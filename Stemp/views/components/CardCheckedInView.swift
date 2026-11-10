//
//  CardCheckedInView.swift
//  pontoapp
//
//  Created by Erick Costa on 28/01/26.
//

import SwiftUI

struct CardCheckedInView: View {
    let text: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            Image(systemName: "checkmark.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.green)

            VStack(spacing: 5) {
                Text("Seu ponto foi registrado com sucesso!")
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
        .padding(.vertical, 15)
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
    CardCheckedInView(text: "Volte às 13:40 para bater seu ponto novamente.")
}
