//
//  AboutSectionView.swift
//  pontoapp
//
//  Created by Erick Costa on 27/04/26.
//

import SwiftUI

struct AboutSection: Identifiable {
    let id = UUID()
    let number: String
    let title: String
    let items: [AboutItem]
}

struct AboutItem: Identifiable {
    let id = UUID()
    let letter: String
    let title: String
    let body: String
    var view: AnyView? = nil
}

struct AboutSectionView: View {
    let section: AboutSection
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                Text(section.number)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(Color(hex: "#1D9E75"))
                    .frame(width: 22, height: 22)
                    .background(Color(hex: "#1D9E75").opacity(0.12))
                    .clipShape(Circle())
                
                Text(section.title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white.opacity(0.5))
                    .kerning(0.3)
                    .textCase(.uppercase)
            }
            .padding(.leading, 4)
            
            VStack(spacing: 0) {
                ForEach(section.items) { item in
                    AboutItemView(item: item)
                }
            }
            .background(Color.white.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.08), lineWidth: 0.5)
            )
        }
    }
}
