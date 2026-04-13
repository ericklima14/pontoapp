//
//  CardCheckInWindowOpenView.swift
//  pontoapp
//
//  Created by Erick Costa on 20/01/26.
//

import SwiftUI

struct CardCheckInWindowClosedView: View {
    let text: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Image(systemName: "clock.arrow.circlepath")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.gradientEnd)

            VStack(spacing: 5) {
                Text("O ponto não pode ser batido agora")
                    .fontWeight(.semibold)
                    .font(.headline)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(text)
                    .font(.subheadline)
                    .opacity(0.8)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .multilineTextAlignment(.center)
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.bg900)
        )
        .padding(.horizontal, 20)
        .foregroundColor(.white)
    }
}

#Preview {
    CardCheckInWindowClosedView(text: "Volte às 13:40 para bater seu ponto!")
}
