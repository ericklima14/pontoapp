//
//  PillarsListView.swift
//  pontoapp
//
//  Created by Erick Costa on 27/04/26.
//

import SwiftUI

struct AcademyPillar: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
}

struct AcademyPillarRow: View {
    let pillar: AcademyPillar
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(hex: "#1D9E75").opacity(0.12))
                    .frame(width: 32, height: 32)
                Image(systemName: pillar.icon)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Color(hex: "#1D9E75"))
            }
            .frame(width: 32, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(pillar.title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white.opacity(0.9))
                
                Text(pillar.description)
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.55))
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct PillarsListView: View {
    private let pillars: [AcademyPillar] = [
        AcademyPillar(
            icon: "chevron.left.forwardslash.chevron.right",
            title: "Tecnologia",
            description: "Desenvolvimento de apps com Swift, SwiftUI, frameworks da Apple, arquitetura de software, versionamento e boas práticas de engenharia."
        ),
        AcademyPillar(
            icon: "paintbrush.pointed.fill",
            title: "Design",
            description: "UX, UI, prototipação, design thinking, acessibilidade e pesquisa com usuários — sempre com foco em criar experiências que realmente importam para as pessoas."
        ),
        AcademyPillar(
            icon: "chart.line.uptrend.xyaxis",
            title: "Negócios",
            description: "Empreendedorismo, modelos de negócio, validação de ideias, estratégia de produto e como transformar um projeto em algo viável no mercado."
        ),
        AcademyPillar(
            icon: "bubble.left.and.text.bubble.right.fill",
            title: "Storytelling & Marketing",
            description: "Como apresentar suas ideias, comunicar valor, construir narrativas envolventes e posicionar um produto. Pitch, demos e App Reviews fazem parte da rotina."
        ),
        AcademyPillar(
            icon: "person.2.fill",
            title: "Habilidades profissionais",
            description: "Colaboração em equipe, comunicação, escuta ativa, gestão de conflitos e postura profissional — competências essenciais em qualquer ambiente de trabalho."
        )
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(pillars) { pillar in
                AcademyPillarRow(pillar: pillar)
            }
        }
        .padding(.top, 4)
    }
}

