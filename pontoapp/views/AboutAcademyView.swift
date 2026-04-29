//
//  AboutAcademyView.swift
//  pontoapp
//
//  Created by Erick Costa Reimberg de Lima on 25/04/26.
//

import SwiftUI

struct AboutAcademyView: View {
    
    private var aboutSections: [AboutSection] {[
        AboutSection(
            number: "1",
            title: "O que é a Academy",
            items: [
                AboutItem(
                    letter: "a",
                    title: "Um programa multidisciplinar",
                    body: "A Apple Developer Academy é um programa gratuito, criado pela Apple em parceria com universidades e instituições locais, que forma profissionais completos para o ecossistema da Apple — não apenas desenvolvedores."
                ),
                AboutItem(
                    letter: "b",
                    title: "Challenge Based Learning (CBL)",
                    body: "Diferente de cursos tradicionais, a Academy adota o **Challenge Based Learning**, uma metodologia em que os learners passam pelo ciclo completo de criação de um app diversas vezes ao longo do programa — partindo de um problema real da comunidade, pesquisando, prototipando, desenvolvendo, validando e apresentando soluções."
                ),
                AboutItem(
                    letter: "c",
                    title: "Os 5 pilares de aprendizado",
                    body: "O processo exige um aprendizado multidisciplinar profundo, dividido em cinco grandes pilares que formam um profissional com visão 360° do produto.",
                    view: AnyView(PillarsListView())
                )
            ]
        ),
        AboutSection(
            number: "2",
            title: "Academies pelo mundo",
            items: [
                AboutItem(
                    letter: "a",
                    title: "Uma rede global",
                    body: "A primeira Academy abriu em 2013, no Brasil. Hoje, são mais de uma dúzia de unidades espalhadas pelo mundo, presentes em 6 países.",
                    view: AnyView(WorldStatsView())
                ),
                AboutItem(
                    letter: "b",
                    title: "Países com Academies",
                    body: "Cada Academy é resultado de uma parceria local entre a Apple e instituições de ensino, com currículo adaptado à realidade da região, mas mantendo os mesmos pilares e metodologia.",
                    view: AnyView(CountriesListView())
                )
            ]
        ),
        AboutSection(
            number: "3",
            title: "Swift Student Challenge",
            items: [
                AboutItem(
                    letter: "a",
                    title: "O que é",
                    body: "O Swift Student Challenge é um desafio anual da Apple para estudantes desenvolvedores, onde você cria um app playground criativo que pode ser experimentado em até 3 minutos. As submissões são avaliadas por inovação, criatividade, impacto social e inclusão."
                ),
                AboutItem(
                    letter: "b",
                    title: "Distinguished Winners",
                    body: "Os 50 melhores dentre 350 vencedores são selecionados como Distinguished Winners e recebem uma viagem de 3 dias ao Apple Park, em Cupertino. Todos os 350 vencedores ganham uma assinatura anual gratuita do Apple Developer Program.",
                    view: AnyView(DistinguishedWinnersHighlight())
                ),
                AboutItem(
                    letter: "c",
                    title: "Como participar",
                    body: "É preciso atender alguns requisitos básicos e submeter seu app playground dentro do prazo de inscrições, que geralmente acontece em fevereiro de cada ano.",
                    view: AnyView(RequirementsListView())
                )
            ]
        ),
        AboutSection(
            number: "4",
            title: "Espaços de aprendizagem",
            items: [
                AboutItem(
                    letter: "a",
                    title: "Cave",
                    body: "Espaço para trabalho isolado. É o momento de realizar uma tarefa sozinho, ter um insight ou tomar uma decisão. É onde o conhecimento é internalizado.",
                    view: AnyView(LearningSpaceImageView(asset: "space_cave", color: Color(hex: "#A4C639")))
                ),
                AboutItem(
                    letter: "b",
                    title: "Watering Hole",
                    body: "Espaço de colaboração entre pares, sem um líder definido. É onde acontece o compartilhamento de informação e o aprendizado menos formal — cada participante é aluno e professor ao mesmo tempo.",
                    view: AnyView(LearningSpaceImageView(asset: "space_wateringhole", color: Color(hex: "#3CC5D9")))
                ),
                AboutItem(
                    letter: "c",
                    title: "Campfire",
                    body: "Espaço de storytelling, com líder alternável. É onde se compartilham experiências e aprendizados através de narrativas — qualquer participante pode assumir o papel de quem conta a história.",
                    view: AnyView(LearningSpaceImageView(asset: "space_campfire", color: Color(hex: "#F08C2F")))
                ),
                AboutItem(
                    letter: "d",
                    title: "Mountaintop",
                    body: "Espaço de palestra, no modelo um para muitos. É o momento de ensino formal e compartilhamento de conquistas e objetivos atingidos com toda a turma.",
                    view: AnyView(LearningSpaceImageView(asset: "space_mountaintop", color: Color(hex: "#2C7E9C")))
                )
            ]
        )
    ]}
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                HeroHeaderView()
                
                ForEach(aboutSections) { section in
                    AboutSectionView(section: section)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .background(Color.bg950)
        .navigationTitle("Sobre a Academy")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

// MARK: - Hero Header

struct HeroHeaderView: View {
    var body: some View {
        VStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(hex: "#1D9E75").opacity(0.25),
                                Color(hex: "#1D9E75").opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 72, height: 72)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(hex: "#1D9E75").opacity(0.3), lineWidth: 0.5)
                    )
                
                Image(systemName: "graduationcap.fill")
                    .font(.system(size: 30, weight: .medium))
                    .foregroundColor(Color(hex: "#1D9E75"))
            }
            
            VStack(spacing: 6) {
                Text("Apple Developer Academy")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Empoderando a próxima geração de desenvolvedores, designers e empreendedores")
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.5))
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                    .padding(.horizontal, 20)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .padding(.horizontal, 16)
        .background(Color.white.opacity(0.04))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.08), lineWidth: 0.5)
        )
    }
}

// MARK: - World stats

struct WorldStatsView: View {
    var body: some View {
        HStack(spacing: 10) {
            StatBox(value: "19", label: "Academies")
            StatBox(value: "6", label: "Países")
            StatBox(value: "2013", label: "1ª unidade")
        }
        .padding(.top, 4)
    }
}

struct StatBox: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color(hex: "#1D9E75"))
            Text(label.uppercased())
                .font(.system(size: 9, weight: .semibold))
                .foregroundColor(.white.opacity(0.4))
                .kerning(0.5)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.04))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white.opacity(0.06), lineWidth: 0.5)
        )
    }
}

// MARK: - Countries

struct CountriesListView: View {
    private let countries: [(flag: String, name: String, count: String)] = [
        ("🇧🇷", "Brasil", "10 unidades"),
        ("🇮🇩", "Indonésia", "5 unidades"),
        ("🇮🇹", "Itália", "Nápoles"),
        ("🇰🇷", "Coreia do Sul", "Pohang"),
        ("🇸🇦", "Arábia Saudita", "Riade"),
        ("🇺🇸", "Estados Unidos", "Detroit, MI")
    ]
    
    var body: some View {
        VStack(spacing: 6) {
            ForEach(countries, id: \.name) { country in
                HStack(spacing: 12) {
                    Text(country.flag)
                        .font(.system(size: 20))
                    
                    Text(country.name)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                    
                    Spacer()
                    
                    Text(country.count)
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.4))
                }
                .padding(.vertical, 4)
            }
        }
        .padding(.top, 4)
    }
}

// MARK: - Distinguished Winners

struct DistinguishedWinnersHighlight: View {
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.yellow.opacity(0.15))
                    .frame(width: 40, height: 40)
                Image(systemName: "trophy.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.yellow)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("3 dias no Apple Park")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white.opacity(0.9))
                Text("Cupertino, California")
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.5))
            }
            
            Spacer()
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.yellow.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.yellow.opacity(0.15), lineWidth: 0.5)
        )
        .padding(.top, 4)
    }
}

// MARK: - Requirements

struct RequirementsListView: View {
    private let requirements: [(icon: String, text: String)] = [
        ("graduationcap.fill", "Estar matriculado em uma instituição de ensino reconhecida ou na Apple Developer Academy"),
        ("person.fill", "Ter a idade mínima exigida no seu país (16+ no Brasil)"),
        ("xmark.circle.fill", "Não estar empregado em tempo integral como desenvolvedor"),
        ("calendar", "Submeter o app playground (.swiftpm) dentro do prazo (geralmente em fevereiro)"),
        ("hammer.fill", "Criar um app playground no Xcode 26 ou Swift Playground 4.6+")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(requirements.indices, id: \.self) { index in
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: requirements[index].icon)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(Color(hex: "#1D9E75"))
                        .frame(width: 18, height: 18)
                        .padding(.top, 1)
                    
                    Text(requirements[index].text)
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.7))
                        .lineSpacing(3)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(.top, 4)
    }
}

// MARK: - Learning space image

struct LearningSpaceImageView: View {
    let asset: String
    let color: Color
    
    var body: some View {
        Image(asset)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(color.opacity(0.3), lineWidth: 0.5)
            )
            .padding(.top, 4)
    }
}

#Preview {
    NavigationStack {
        AboutAcademyView()
    }
}
