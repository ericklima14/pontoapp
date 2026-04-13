import SwiftUI

// MARK: - Indicador de progresso do onboarding
struct OnboardingStepIndicator: View {

    let totalSteps: Int
    let currentStep: Int  // 0-indexed

    private var progress: CGFloat {
        guard totalSteps > 1 else { return 1 }
        return CGFloat(currentStep + 1) / CGFloat(totalSteps)
    }

    var body: some View {
        VStack(spacing: 6) {

            // Barra de progresso centralizada e compacta
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 10)

                    Capsule()
                        .fill(Color(hex: "#0A4D9A"))
                        .frame(width: geo.size.width * progress, height: 10)
                        .animation(.spring(response: 0.5, dampingFraction: 0.75), value: currentStep)
                }
            }
            .frame(width: 120, height: 10)

            // Texto abaixo
            Text("Etapa \(currentStep + 1) de \(totalSteps)")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white.opacity(0.4))
        }
    }
}
