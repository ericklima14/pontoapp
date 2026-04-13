//
//  RuleSectionView.swift
//  pontoapp
//
//  Created by Erick Costa Reimberg de Lima on 10/04/26.
//

import SwiftUI

struct RulesSection: Identifiable {
    let id = UUID()
    let number: String
    let title: String
    let items: [RulesItem]
}
 
struct RulesItem: Identifiable {
    let id = UUID()
    let letter: String
    let title: String
    let body: String
    var view: (any View)? = nil
}

struct RuleCardItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let color: Color
    let text: String
    let textExample: [String]
}
 
struct RulesSectionView: View {
    let section: RulesSection
 
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
                    RulesItemView(item: item)
                }
            }
            .background(Color.white.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.08), lineWidth: 0.5))
        }
    }
}
 
struct RulesItemView: View {
    let item: RulesItem
    @State private var isExpanded = false
 
    var body: some View {
        VStack(spacing: 0) {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(spacing: 12) {
                    Text(item.letter.uppercased())
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.white.opacity(0.3))
                        .frame(width: 18)
 
                    Text(item.title)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
 
                    Spacer()
 
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.white.opacity(0.2))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 13)
            }
 
            if isExpanded {
                VStack(spacing: 10){
                    if let content = item.view{
                        AnyView(content)
                    }
                    
                    Text(item.body)
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.55))
                        .lineSpacing(4)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 14)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .overlay(alignment: .bottom) {
            Rectangle().fill(Color.white.opacity(0.06)).frame(height: 0.5)
        }
    }
}

#Preview {
    ZStack{
        Color.bg950.ignoresSafeArea()
        
        RulesSectionView(section: RulesSection(
                number: "1",
                title: "Software e Licenças",
                items: [
                    RulesItem(letter: "a", title: "Software licenciado", body: "É expressamente proibida a instalação, o download ou o compartilhamento de softwares, aplicativos ou quaisquer conteúdos que não possuam licença válida ou autorização legal de uso."),
                    RulesItem(letter: "b", title: "Pirataria e torrents", body: "A prática de pirataria, bem como a utilização ou instalação de programas de compartilhamento ilegal de arquivos (como Torrents), é terminantemente proibida e acarretará o desligamento imediato do Programa."),
                ]
            ),
        )
    }
}
