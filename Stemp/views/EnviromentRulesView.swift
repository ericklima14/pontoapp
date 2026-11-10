//
//  EnviromentRulesView.swift
//  pontoapp
//
//  Created by Erick Costa Reimberg de Lima on 10/04/26.
//

import SwiftUI

struct EnviromentRulesView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ForEach(enviromentSections) { section in
                    RulesSectionView(section: section)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .background(Color.bg950)
        .navigationTitle("Regras da Academy")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
    
    private var enviromentSections: [RulesSection] {[
        RulesSection(
            number: "1",
            title: "Uso do espaço",
            items: [
                RulesItem(letter: "a", title: "Ambiente inclusivo", body: "Contribua ativamente para um ambiente acolhedor, inclusivo e seguro para todos os participantes. Zero tolerância ao preconceito — não será admitida qualquer forma de discriminação, bullying, importunação ou assédio."),
                RulesItem(letter: "b", title: "Uso adequado do espaço", body: "O espaço é destinado exclusivamente às atividades acadêmicas. Não é permitido utilizá-lo para descanso prolongado ou dormir; pausas devem ser realizadas em áreas apropriadas fora do ambiente."),
            ]
        ),
        RulesSection(
            number: "2",
            title: "Uso do Espaço em Equipe",
            items: [
                RulesItem(letter: "a", title: "Espaços compartilhados", body: "Respeite os espaços compartilhados e o trabalho das equipes."),
                RulesItem(letter: "b", title: "Evite interrupções", body: "Evite interrupções desnecessárias durante momentos de concentração ou desenvolvimento."),
            ]
        ),
        RulesSection(
            number: "3",
            title: "Organização e Cuidado com o Espaço",
            items: [
                RulesItem(letter: "a", title: "Laboratório limpo e organizado", body: "Mantenha o espaço da Academy sempre limpo e descarte o lixo corretamente."),
                RulesItem(letter: "b", title: "Preserve os equipamentos", body: "Use os recursos com cuidado e responsabilidade, evitando danos e mau uso. Não risque, cole adesivos ou outro tipo de material nos móveis ou equipamentos do laboratório. Evite acionar os controles de abaixar ou levantas as mesas desnecessariamente, assim como os braços das cadeiras."),
                RulesItem(letter: "c", title: "Alimentos e bebidas", body: "Evite consumir alimentos e bebidas próximos aos equipamentos eletrônicos, especialmente em computadores, estações de desenvolvimento e nas dependências da Academy, incluindo o laboratório I441, a fim de preservar o bom funcionamento dos dispositivos. É proibido o consumo de alimentos com odores fortes nesses ambientes."),
                RulesItem(letter: "d", title: "Itens pessoais", body: "Evite deixar no laboratório itens pessoais importantes. Caso necessário, utilize os armários com senha."),
            ]
        ),
    ]}
}

#Preview {
    EnviromentRulesView()
}
