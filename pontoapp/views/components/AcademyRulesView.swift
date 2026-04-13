//
//  AademyRulesView.swift
//  pontoapp
//
//  Created by Erick Costa Reimberg de Lima on 10/04/26.
//

import SwiftUI

struct AcademyRulesView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("A academy é um espaço de trabalho, e como qualquer outro devem ter regras de convivência e de conduta.")
                    .foregroundStyle(.white.opacity(0.5))
                                
                ForEach(academySections) { section in
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
 
    private var academyRulesExamples: [RuleCardItem] {
        [RuleCardItem(
            title: "Warnings",
            icon: "exclamationmark.triangle.fill",
            color: .warning,
            text: "Uma warning corresponde a uma infração leve que pode ser representada por alguns exemplos:",
            textExample: [
                   "Atrasar mais de 20 minutos sem justificativa",
                   "1 falta sem justificativa",
                   "Não fazer entregas no tempo estipulado (Documentos, Challenges, Requisições...)",
                   "Bagunçar o laboratório",
                   "Baixa performance nas atividades do projeto",
                   "Falha no cumprimento de responsabilidades como estudantes"
            ]),
         RuleCardItem(
             title: "Notifications",
             icon: "xmark",
             color: .notification,
             text: "Uma notification corresponde a uma infração grave que pode ser representada por alguns exemplos:",
             textExample: [
                    "Violação da confidencialidade do programa/laboratório",
                    "Faltas em app review, workshops, apresentações (interno ou externos)",
                    "Violações graves das regras da Academy",
                    "Ausência de compromissos assumidos pelo laboratório/ instituição",
                    "2 warnings recorrentes",
                    "Mais de 2 faltas sem justificativas"
             ]),
         RuleCardItem(
             title: "Shutdown",
             icon: "person.fill.xmark",
             color: .shutdown,
             text: "Um shutdown corresponde ao desligamento imediato do programa, perdendo o benefício da bolsa auxílio e dos equipamentos previstos no edital. Pode ser gerado por:",
             textExample: [
                "Situações críticas",
                "2 notifications = Shutdown"
             ]
         ),
        ]
    }
    
    private var academySections: [RulesSection] {[
        RulesSection(
            number: "1",
            title: "Conduta e Convivência",
            items: [
                RulesItem(letter: "a", title: "Comunicação respeitosa", body: "Mantenha uma comunicação clara, objetiva e respeitosa, tanto presencialmente, quanto em canais digitais (e-mail, chats, plataforma de colaboração). Trate colegas, mentores, professores e colaboradores em geral com cordialidade, empatia e educação."),
                RulesItem(letter: "b", title: "Postura profissional", body: "Adote uma postura ética e profissional dentro e fora da Academy, especialmente em eventos, apresentações e interações com parceiros."),
                RulesItem(letter: "c", title: "Colaboração em equipe", body: "Respeite as opiniões divergentes e contribua de forma construtiva para o desenvolvimento coletivo."),
                RulesItem(letter: "d", title: "Responsabilidade individual", body: "Assuma responsabilidade por suas entregas, prazos e compromissos com a equipe e o Programa."),
                RulesItem(letter: "e", title: "Ambiente colaborativo", body: "Compartilhe conhecimentos, ajude sempre que possível e pratique a escuta ativa."),
                RulesItem(letter: "f", title: "Resolução de conflito", body: "Em caso de conflitos, busque o diálogo respeitoso e, se necessário, envolva os mentores para mediação.")
            ]
        ),
        RulesSection(
            number: "2",
            title: "Pontualidade e Comprometimento",
            items: [
                RulesItem(letter: "a", title: "Seja pontual", body: "Respeite os horários das atividades e compromissos agendados. O horário das atividades da Academy são das 14h até as 18h."),
                RulesItem(letter: "b", title: "Frequência ativa", body: "Compareça às atividades e esteja presente de forma participativa e engajada."),
                RulesItem(letter: "c", title: "Avise em caso de imprevistos", body: "Em caso de ausência ou atraso, comunique previamente os mentores e sua própria equipe."),
            ]
        ),
        RulesSection(
            number: "3",
            title: "Uso de Imagem e Confidencialidade",
            items: [
                RulesItem(letter: "a", title: "Registro na Academy", body: "É proibido registrar (foto, vídeo ou áudio) dentro da Academy sem autorização prévia."),
                RulesItem(letter: "b", title: "Confidencialidade dos projetos", body: "Projetos desenvolvidos podem conter informações confidenciais e não devem ser compartilhados externamente sem autorização."),
            ]
        ),
        RulesSection(
            number: "4",
            title: "Segurança e Acesso",
            items: [
                RulesItem(letter: "a", title: "Acesso restrito", body: "É proibida a entrada e permanência de pessoas não autorizadas nas dependências da Academy."),
                RulesItem(letter: "b", title: "Reporte de incidentes", body: "Caso identifique qualquer comportamento inadequado, situação de risco ou incidente, comunique imediatamente a equipe de mentores."),
                RulesItem(letter: "c", title: "Monitoramento", body: "O laboratório é equipado com sistema de monitoramento por câmeras, operando 24 horas por dia, nas áreas internas e externas. As imagens são utilizadas exclusivamente para fins de segurança patrimonial e institucional."),
            ]
        ),
        RulesSection(
            number: "5",
            title: "Limpeza e Encerramento das Atividades",
            items: [
                RulesItem(letter: "a", title: "Ambiente de trabalho", body: "Ao final do uso, organize sua        estação de trabalho, descartando resíduos e ajustando o espaço."),
                RulesItem(letter: "b", title: "Equipamentos", body: "Desligue ou bloqueie os dispositivos conforme orientações da equipe.")
            ]
        ),
        RulesSection(
            number: "6",
            title: "Penalidades",
            items: [
                RulesItem(letter: "a", title: "Advertência", body: "O descumprimento das normas poderá resultar em advertência verbal ou escrita."),
                RulesItem(
                    letter: "c",
                    title: "Warnings",
                    body: "Infrações graves podem resultar em desligamento do Programa. A aplicação das medidas será realizada conforme a gravidade da infração.",
                    view: RulesCardView(ruleItem:
                            RuleCardItem(
                                title: "Warnings",
                                icon: "exclamationmark.triangle.fill",
                                color: .warning,
                                text: "Uma warning corresponde a uma infração leve que pode ser representada por alguns exemplos:",
                                textExample: [
                                       "Atrasar mais de 20 minutos sem justificativa",
                                       "1 falta sem justificativa",
                                       "Não fazer entregas no tempo estipulado (Documentos, Challenges, Requisições...)",
                                       "Bagunçar o laboratório",
                                       "Baixa performance nas atividades do projeto",
                                       "Falha no cumprimento de responsabilidades como estudantes"
                                ]
                            )
                    )
                ),
                RulesItem(
                    letter: "c",
                    title: "Notifications",
                    body: "Infrações graves podem resultar em desligamento do Programa. A aplicação das medidas será realizada conforme a gravidade da infração.",
                    view: RulesCardView(
                        ruleItem:
                            RuleCardItem(
                                title: "Notifications",
                                icon: "xmark",
                                color: .notification,
                                text: "Uma notification corresponde a uma infração grave que pode ser representada por alguns exemplos:",
                                textExample: [
                                       "Violação da confidencialidade do programa/laboratório",
                                       "Faltas em app review, workshops, apresentações (interno ou externos)",
                                       "Violações graves das regras da Academy",
                                       "Ausência de compromissos assumidos pelo laboratório/ instituição",
                                       "2 warnings recorrentes",
                                       "Mais de 2 faltas sem justificativas"
                                ])
                       )
                ),
                RulesItem(
                    letter: "d",
                    title: "Shutdown",
                    body: "Infrações graves podem resultar em desligamento do Programa. A aplicação das medidas será realizada conforme a gravidade da infração.",
                    view: RulesCardView(
                        ruleItem:
                            RuleCardItem(
                                title: "Shutdown",
                                icon: "person.fill.xmark",
                                color: .shutdown,
                                text: "Um shutdown corresponde ao desligamento imediato do programa, perdendo o benefício da bolsa auxílio e dos equipamentos previstos no edital. Pode ser gerado por:",
                                textExample: [
                                   "Situações críticas",
                                   "2 notifications = Shutdown"
                                ]
                            )
                       )
                )

            ]
        ),
    ]}
}
#Preview {
    AcademyRulesView()
}
