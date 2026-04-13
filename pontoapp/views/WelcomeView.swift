//
//  WelcomeView.swift
//  pontoapp
//
//  Created by Erick Costa Reimberg de Lima on 20/03/26.
//

import SwiftUI

struct WelcomeView: View {

    var onContinue: () -> Void

    var body: some View {
        ZStack {
            Color.bg950.ignoresSafeArea()

            VStack(spacing: 0) {

                Spacer()

                // Logo + título
                VStack(spacing: 16) {
                    ZStack {
                        Image("Logo azul")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)

                        Image("Logo amarelo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                    }
                    .background(Color.white.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                    VStack(spacing: 6) {
                        Text("Bem-vindo ao Ponto App")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)

                        Text("Apple Developer Academy · Senac")
                            .font(.system(size: 13, weight: .regular))
                            .tracking(1)
                            .foregroundColor(.white.opacity(0.4))
                            .textCase(.uppercase)
                    }
                }

                Spacer()

                // Cards de funcionalidades
                VStack(spacing: 12) {
                    FeatureCard(
                        icon: "person.fill.checkmark",
                        iconColor: Color(hex: "#0A4D9A"),
                        title: "Registre sua presença",
                        description: "Bata o ponto direto pelo app com autenticação biométrica"
                    )
                    FeatureCard(
                        icon: "calendar",
                        iconColor: Color(hex: "#F98D1B"),
                        title: "Acompanhe seu histórico",
                        description: "Visualize presenças, atrasos e faltas no calendário"
                    )
                    FeatureCard(
                        icon: "info.circle.fill",
                        iconColor: Color.white.opacity(0.6),
                        title: "Infos da Academy",
                        description: "Dados e novidades da Apple Developer Academy do Senac"
                    )
                }
                .padding(.horizontal, 24)

                Spacer()

                // Botão continuar
                YellowButtonView(disabled: .constant(false), text: "Começar", iconImage: nil){
                    onContinue()
                }
                .padding(.bottom, 40)
            }
        }
    }
}

// MARK: - Feature Card
struct FeatureCard: View {
    let icon: String
    let iconColor: Color
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(iconColor.opacity(0.15))
                    .frame(width: 44, height: 44)

                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(iconColor)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)

                Text(description)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.white.opacity(0.5))
                    .lineLimit(2)
            }

            Spacer()
        }
        .padding(14)
        //.background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}


extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8)  & 0xFF) / 255
        let b = Double(int & 0xFF)          / 255
        self.init(red: r, green: g, blue: b)
    }
}

#Preview{
    WelcomeView(){
        
    }
}
