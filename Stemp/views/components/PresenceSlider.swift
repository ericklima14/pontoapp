//
//  PresenceSlider.swift
//  pontoapp
//
//  Created by Erick Costa on 08/12/25.
//

import SwiftUI

// MARK: - Shimmer Ray
// Usa .task em vez de onAppear + DispatchQueue para que o SwiftUI
// cancele e reinicie o loop automaticamente ao navegar entre telas.

struct ShimmerRay: View {
    let goRight: Bool
    let delay: Double

    @State private var phase: CGFloat  = 0.0
    @State private var opacity: Double = 0.0

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width

            LinearGradient(
                stops: [
                    .init(color: .clear,               location: 0.0),
                    .init(color: .clear,               location: 0.25),
                    .init(color: .white.opacity(0.15), location: 0.5),
                    .init(color: .clear,               location: 0.75),
                    .init(color: .clear,               location: 1.0),
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: w)
            .offset(x: goRight ? phase * w : -phase * w)
            .opacity(opacity)
        }
        .task {
            // Delay inicial para defasagem entre raios
            try? await Task.sleep(for: .seconds(delay))
            // Loop cancelável — para automaticamente quando a view sai da tela
            while !Task.isCancelled {
                await runCycle()
            }
        }
    }

    @MainActor
    private func runCycle() async {
        // Reseta sem animação
        phase   = 0.0
        opacity = 0.0

        withAnimation(.easeIn(duration: 0.4))             { opacity = 1.0 }
        withAnimation(.easeInOut(duration: 2.2))          { phase   = 1.0 }
        withAnimation(.easeOut(duration: 0.8).delay(1.4)) { opacity = 0.0 }

        // Aguarda o ciclo completo antes de reiniciar
        try? await Task.sleep(for: .seconds(3.6))
    }
}

// MARK: - Shimmer Emitter

struct ShimmerEmitter: View {
    let isDragging: Bool
    private let rayCount = 3
    private let spacing  = 1.2

    var body: some View {
        ZStack {
            ForEach(0..<rayCount, id: \.self) { i in
                let d = Double(i) * spacing
                ShimmerRay(goRight: true,  delay: d)
                ShimmerRay(goRight: false, delay: d)
            }
        }
        .opacity(isDragging ? 0 : 1)
        .animation(.easeOut(duration: 0.2), value: isDragging)
        .clipShape(RoundedRectangle(cornerRadius: 50))
        .allowsHitTesting(false)
    }
}

// MARK: - Arrow Ray

struct ArrowRay: View {
    let goRight: Bool
    let delay: Double

    @State private var phase: CGFloat  = 0.0
    @State private var opacity: Double = 0.0

    private let travel: CGFloat = 110

    var body: some View {
        GeometryReader { geo in
            let cx = geo.size.width / 2
            let cy = geo.size.height / 2
            let dx = (goRight ? 1.0 : -1.0) * phase * travel

            Image(systemName: goRight ? "chevron.right" : "chevron.left")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)
                .opacity(opacity)
                .position(x: cx + dx, y: cy)
        }
        .task {
            try? await Task.sleep(for: .seconds(delay))
            while !Task.isCancelled {
                await runCycle()
            }
        }
    }

    @MainActor
    private func runCycle() async {
        phase   = 0.0
        opacity = 0.0

        withAnimation(.easeIn(duration: 0.4))             { opacity = 0.8 }
        withAnimation(.easeInOut(duration: 2.2))          { phase   = 1.0 }
        withAnimation(.easeOut(duration: 0.8).delay(1.4)) { opacity = 0.0 }

        try? await Task.sleep(for: .seconds(3.6))
    }
}

// MARK: - Arrow Emitter

struct ArrowEmitter: View {
    let isDragging: Bool
    private let rayCount = 3
    private let spacing  = 0.5

    var body: some View {
        ZStack {
            ForEach(0..<rayCount, id: \.self) { i in
                let d = Double(i) * spacing
                ArrowRay(goRight: true,  delay: d)
                ArrowRay(goRight: false, delay: d)
            }
        }
        .opacity(isDragging ? 0 : 1)
        .animation(.easeOut(duration: 0.2), value: isDragging)
        .allowsHitTesting(false)
    }
}

// MARK: - Pulse Ring

struct PulseRing: View {
    var offset: CGFloat
    @State private var scale: CGFloat   = 1.0
    @State private var opacity: Double  = 0.65

    var body: some View {
        Circle()
            .stroke(Color.white.opacity(0.55), lineWidth: 2)
            .frame(width: 76, height: 76)
            .scaleEffect(scale)
            .opacity(opacity)
            .offset(x: offset)
            .animation(
                .easeOut(duration: 1.8).repeatForever(autoreverses: false),
                value: scale
            )
            .onAppear {
                scale   = 1.5
                opacity = 0.0
            }
    }
}

// MARK: - Frosted Circle Icon

struct FrostedCircleIcon<Content: View>: View {
    let size: CGFloat
    let iconSize: CGFloat
    let content: () -> Content

    init(size: CGFloat = 62, iconSize: CGFloat = 30, @ViewBuilder content: @escaping () -> Content) {
        self.size     = size
        self.iconSize = iconSize
        self.content  = content
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(.white.opacity(0.07))
                .frame(width: size, height: size)
            content()
                .frame(width: iconSize, height: iconSize)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Presence Slider

struct PresenceSlider: View {
    var profileImage: Image?

    var onSwipeRight: () -> Void
    var onSwipeLeft: () -> Void

    @State private var userOffset: CGSize   = .zero
    @State private var isDragging: Bool     = false
    @State private var flashOpacity: Double = 0.0

    private let colorSuccess: Color = Color.gradientSuccessStart.opacity(0.5)
    private let colorJustify: Color = Color.gradientJustifyStart.opacity(0.5)
    @State private var trackColor: Color = Color.gradientSuccessStart.opacity(0.5)

    private let maxDragOffset: CGFloat = 150

    private var textOpacity: Double {
        let deadzone: CGFloat = 25
        let fadeRange: CGFloat = 90
        let abs = Swift.abs(userOffset.width)
        guard abs > deadzone else { return 0 }
        return Double(min(1, (abs - deadzone) / fadeRange))
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let translation = value.translation.width
                guard translation >= -maxDragOffset && translation <= maxDragOffset else { return }

                withAnimation(.interactiveSpring()) {
                    userOffset = value.translation
                    isDragging = true
                }
                withAnimation(.easeInOut(duration: 0.25)) {
                    trackColor = translation < -30 ? colorJustify : colorSuccess
                }
            }
            .onEnded { value in
                let finalOffset = value.translation.width

                if finalOffset >= maxDragOffset - 20 {
                    finishDrag(isSuccess: true)
                } else if finalOffset <= -(maxDragOffset - 20) {
                    finishDrag(isSuccess: false)
                } else {
                    withAnimation(.spring()) {
                        userOffset = .zero
                        isDragging = false
                        trackColor = colorSuccess
                    }
                }
            }
    }

    var body: some View {
        ZStack {

            // MARK: Track
            RoundedRectangle(cornerRadius: 50)
                .fill(trackColor)
                .frame(width: 370, height: 80)
                .animation(.easeInOut(duration: 0.25), value: trackColor)

            // MARK: Shimmer
            ShimmerEmitter(isDragging: isDragging)
                .frame(width: 370, height: 80)

            // MARK: Chevrons
            ArrowEmitter(isDragging: isDragging)
                .frame(width: 370, height: 80)

            // Flash de conclusão
            RoundedRectangle(cornerRadius: 50)
                .fill(Color.white.opacity(flashOpacity))
                .frame(width: 370, height: 80)
                .allowsHitTesting(false)

            // MARK: Ícone direita
            HStack {
                Spacer()
                FrostedCircleIcon(size: 62, iconSize: 34) {
                    Image(systemName: "person.fill.checkmark")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white.opacity(0.75))
                }
            }
            .frame(width: 360, height: 70)

            // MARK: Ícone esquerda
            HStack {
                FrostedCircleIcon(size: 62, iconSize: 30) {
                    Image(systemName: "doc.text.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white.opacity(0.75))
                }
                Spacer()
            }
            .frame(width: 360, height: 70)

            // MARK: Label central
            Text(userOffset.width < 0 ? "Justificar" : "Presença")
                .fontWeight(.semibold)
                .foregroundColor(.white.opacity(textOpacity * 0.9))
                .opacity(isDragging ? 1 : 0)
                .animation(.easeInOut(duration: 0.15), value: textOpacity)

            // MARK: Pulse ring
            PulseRing(offset: userOffset.width)
                .opacity(isDragging ? 0 : 1)
                .animation(.easeOut(duration: 0.2), value: isDragging)
                .allowsHitTesting(false)

            // MARK: ProfileImage
            Group {
                if let image = profileImage {
                    FrostedCircleIcon(size: 70, iconSize: 70) {
                        image
                            .resizable()
                            .scaledToFill()
                    }
                } else {
                    FrostedCircleIcon(size: 70, iconSize: 38) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white.opacity(0.85))
                    }
                }
            }
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 3.5))
            .offset(x: userOffset.width)
            .zIndex(10)
            .gesture(dragGesture)
        }
    }

    func finishDrag(isSuccess: Bool) {
        withAnimation(.easeIn(duration: 0.1))             { flashOpacity = 0.18 }
        withAnimation(.easeOut(duration: 0.4).delay(0.1)) { flashOpacity = 0.0  }

        if isSuccess {
            withAnimation(.spring(duration: 0.5)) {
                userOffset = CGSize(width: maxDragOffset, height: 0)
            }
            onSwipeRight()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(.spring()) {
                    userOffset = .zero
                    isDragging = false
                    trackColor = colorSuccess
                }
            }
        } else {
            onSwipeLeft()
            withAnimation(.spring()) {
                userOffset = .zero
                isDragging = false
                trackColor = colorSuccess
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.bg950.ignoresSafeArea()
        PresenceSlider(
            profileImage: Image(systemName: "person.circle.fill"),
            onSwipeRight: {},
            onSwipeLeft: {}
        )
    }
}
