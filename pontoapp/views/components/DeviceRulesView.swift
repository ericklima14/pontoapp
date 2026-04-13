//
//  DeviceRulesView.swift
//  pontoapp
//
//  Created by Erick Costa Reimberg de Lima on 10/04/26.
//

import SwiftUI

struct DeviceRulesView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ForEach(deviceSections) { section in
                    RulesSectionView(section: section)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .background(Color.bg950)
        .navigationTitle("Regras sobre os Equipamentos")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
 
    private var deviceSections: [RulesSection] {[
        RulesSection(
            number: "1",
            title: "Software e Licenças",
            items: [
                RulesItem(letter: "a", title: "Software licenciado", body: "É expressamente proibida a instalação, o download ou o compartilhamento de softwares, aplicativos ou quaisquer conteúdos que não possuam licença válida ou autorização legal de uso."),
                RulesItem(letter: "b", title: "Pirataria e torrents", body: "A prática de pirataria, bem como a utilização ou instalação de programas de compartilhamento ilegal de arquivos (como Torrents), é terminantemente proibida e acarretará o desligamento imediato do Programa."),
            ]
        ),
        RulesSection(
            number: "2",
            title: "Personalização dos Equipamentos",
            items: [
                RulesItem(letter: "a", title: "Adesivos e personalizações", body: "É proibida a aplicação de adesivos ou outro tipo de personalização nos equipamentos do laboratório e os disponibilizados aos alunos. Os dispositivos são de propriedade da empresa locadora contratada pelo Senac e devem ser mantidos em perfeito estado de conservação."),
                RulesItem(letter: "b", title: "Películas e capas", body: "É permitida a utilização de películas protetoras e capas, desde que não causem danos, não deixem resíduos e não comprometam a integridade física ou o funcionamento dos equipamentos."),
            ]
        ),
        RulesSection(
            number: "3",
            title: "Boas Práticas de Uso",
            items: [
                RulesItem(letter: "a", title: "Salve seu trabalho", body: "Salve seu trabalho com frequência e mantenha cópias de segurança (backups) atualizadas."),
                RulesItem(letter: "b", title: "Senhas e credenciais", body: "Não compartilhe senhas ou credenciais de acesso pessoais ou institucionais."),
                RulesItem(letter: "c", title: "Encerramento das atividades", body: "Ao final do uso, organize sua estação de trabalho, descartando resíduos e ajustando o espaço. Desligue ou bloqueie os dispositivos conforme orientações da equipe."),
            ]
        ),
        RulesSection(
            number: "4",
            title: "Uso das Redes",
            items: [
                RulesItem(letter: "a", title: "Uso exclusivo acadêmico", body: "A rede da Academy destina-se exclusivamente às atividades acadêmicas e aos objetivos do projeto."),
                RulesItem(letter: "b", title: "Conteúdo proibido", body: "É proibido o acesso, a navegação ou o compartilhamento de conteúdos pornográficos, sexualmente explícitos ou quaisquer materiais inadequados ao ambiente educacional. O descumprimento estará sujeito às medidas administrativas e disciplinares cabíveis."),
            ]
        ),
    ]}
}
 
#Preview {
    DeviceRulesView()
}
