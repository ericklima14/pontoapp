//
//  UserTermsView.swift
//  pontoapp
//
//  Created by Erick Costa Reimberg de Lima on 10/04/26.
//

import SwiftUI

struct UserTermsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                // Cabeçalho Introdutório
                Text("Bem-vindo(a) ao Stemp. O objetivo deste aplicativo é possibilitar o registro de presença e consulta de atividades da Apple Developer Academy | Senac.")
                    .font(.system(size: 14))
                    .foregroundStyle(.white.opacity(0.6))
                    .lineSpacing(4)

                // 1. Definições de Usuários
                PolicySection(number: "1", title: "Definições de Usuários") {
                    PolicyParagraph(bold: "Alunos(as):", bodyText: "autorizados a registrar presença/faltas, consultar calendário, regras da Academy, uso de equipamentos e manifesto de valores.")
                    PolicyParagraph(bold: "Administradores:", bodyText: "responsáveis pela gestão, publicação de regras e informações sobre eventos.")
                }

                // 2. Identificação e Autenticação
                PolicySection(number: "2", title: "Identificação e Autenticação") {
                    PolicyParagraph(bodyText: "O acesso é realizado via Apple ID para garantir segurança.")
                    PolicyParagraph(bodyText: "Coletamos seu Nome, E-mail e ID Apple exclusivamente para fins de autenticação no sistema.")
                }

                // 3. Permissões de Acesso
                PolicySection(number: "3", title: "Permissões de Acesso") {
                    PolicyParagraph(bold: "Localização:", bodyText: "Utilizada exclusivamente para validar se o aluno está nas dependências da Academy no momento do registro.")
                    PolicyParagraph(bold: "Lista de Contatos:", bodyText: "Utilizada para coletar o seu memoji.")
                }

                // 4. Responsabilidades do Aluno(a)
                PolicySection(number: "4", title: "Responsabilidades do Aluno(a)") {
                    PolicyParagraph(bodyText: "Registrar presença e falta de forma honesta e fidedigna.")
                    PolicyParagraph(bodyText: "Consultar regularmente comunicados e eventos.")
                    PolicyParagraph(bodyText: "Não compartilhar credenciais de acesso com terceiros.")
                }

                // 5. Responsabilidades do Administrador
                PolicySection(number: "5", title: "Responsabilidades do Administrador") {
                    PolicyParagraph(bodyText: "Garantir que as regras publicadas sejam verídicas e atualizadas.")
                    PolicyParagraph(bodyText: "Respeitar a finalidade educacional e administrativa no uso dos dados.")
                }

                // 6. Equipamentos e Conduta
                PolicySection(number: "6", title: "Equipamentos e Conduta") {
                    PolicyParagraph(bodyText: "O uso de recursos do Senac está sujeito às normas publicadas pelos administradores no app.")
                    PolicyParagraph(bodyText: "O descumprimento pode gerar sanções administrativas previstas.")
                }

                // 7. Proteção de Dados (LGPD) e Exclusão
                PolicySection(number: "7", title: "Proteção de Dados (LGPD)") {
                    PolicyParagraph(bodyText: "Dados processados apenas para viabilizar as funções do app. Não comercializamos dados com terceiros.")
                    PolicyParagraph(bodyText: "A exclusão da conta pode ser solicitada formalmente, ciente de que isso pode acarretar a perda de vínculo com a Academy.")
                }

                // Rodapé de Vigência
                VStack(spacing: 4) {
                    Text("Reservamo-nos o direito de atualizar estes termos através de avisos no aplicativo.")
                        .font(.system(size: 11))
                        .foregroundStyle(.white.opacity(0.4))
                        .multilineTextAlignment(.center)
                    
                    Text("Vigência a partir de: 14/04/2026.")
                        .font(.system(size: 12))
                        .foregroundStyle(.white.opacity(0.3))
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 8)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .background(Color.bg950) // Certifique-se que Color.bg950 está definido no seu projeto
        .navigationTitle("Termos de Uso")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        UserTermsView()
    }
}
