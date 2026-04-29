import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                Text("Esta Política de Privacidade explica como o Stemp coleta, utiliza e protege os dados pessoais de alunos(as) e administradores, em total conformidade com a Lei Geral de Proteção de Dados (LGPD).")
                    .font(.system(size: 14))
                    .foregroundStyle(.white.opacity(0.6))
                    .lineSpacing(4)

                PolicySection(number: "1", title: "Agentes de Tratamento") {
                    PolicyParagraph(bold: "Controlador:", bodyText: "Apple Developer Academy | Senac, doravante denominada Academy.")
                    PolicyParagraph(bold: "Operador:", bodyText: "Academy.")
                }

                PolicySection(number: "2", title: "Dados Coletados e Finalidades") {
                    Text("Coletamos apenas os dados estritamente necessários para a prestação do serviço educacional e administrativo:")
                        .font(.system(size: 13))
                        .foregroundStyle(.white.opacity(0.55))
                        .lineSpacing(4)
                        .padding(.bottom, 4)

                    PolicyParagraph(bold: "Identificação (Apple ID, Nome e E-mail):", bodyText: "utilizados para autenticação segura e criação do perfil digital único do(a) aluno(a).")
                    PolicyParagraph(bold: "Localização (Geolocalização):", bodyText: "coletada apenas no momento do registro de presença para validar a permanência do(a) aluno(a) no recinto da Academy. Não rastreamos o usuário fora do horário ou do local de atividades.")
                    PolicyParagraph(bold: "Registros de Presença/Falta:", bodyText: "dados gerados pelo próprio uso do app para fins de histórico acadêmico e cumprimento de carga horária.")
                }

                PolicySection(number: "3", title: "Direitos do Titular (Art. 18 da LGPD)") {
                    Text("Você, como usuário, possui os seguintes direitos sobre seus dados:")
                        .font(.system(size: 13))
                        .foregroundStyle(.white.opacity(0.55))
                        .lineSpacing(4)
                        .padding(.bottom, 4)

                    PolicyParagraph(bold: "Confirmação e Acesso:", bodyText: "saber se tratamos seus dados e acessá-los.")
                    PolicyParagraph(bold: "Correção:", bodyText: "solicitar o ajuste de dados incompletos ou inexatos.")
                    PolicyParagraph(bold: "Eliminação:", bodyText: "requerer a exclusão de dados desnecessários ou tratados em desconformidade (ressalvada a guarda obrigatória por legislação educacional).")
                    PolicyParagraph(bold: "Revogação de Consentimento:", bodyText: "desautorizar o acesso à localização ou contatos a qualquer momento nas configurações do seu dispositivo.")
                }

                PolicySection(number: "4", title: "Compartilhamento de Dados") {
                    PolicyParagraph(bodyText: "Não comercializamos seus dados pessoais. O compartilhamento ocorre apenas entre Alunos(as) e Administradores (ex: frequência).")
                }

                PolicySection(number: "5", title: "Segurança da Informação") {
                    PolicyParagraph(bodyText: "Adotamos medidas técnicas e administrativas (criptografia, controle de acesso restrito) para proteger seus dados contra acessos não autorizados e situações acidentais de destruição ou perda.")
                }

                PolicySection(number: "6", title: "Retenção de Dados") {
                    PolicyParagraph(bodyText: "Os dados de presença e faltas serão mantidos pelo período exigido pela legislação educacional brasileira. Dados de autenticação (Apple ID) permanecem ativos enquanto a conta do usuário não for excluída.")
                }

                PolicySection(number: "7", title: "Contato do Encarregado (DPO)") {
                    PolicyParagraph(bodyText: "Para exercer seus direitos ou tirar dúvidas, entre em contato com nosso Encarregado de Proteção de Dados pelo e-mail: developeracademy@sp.senac.br.")
                }

                Text("Esta Política de Privacidade tem vigência a partir de: 14/04/2026.")
                    .font(.system(size: 12))
                    .foregroundStyle(.white.opacity(0.3))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 8)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .background(Color.bg950)
        .navigationTitle("Política de Privacidade")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

// MARK: - Componentes auxiliares

struct PolicySection<Content: View>: View {
    let number: String
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Text(number)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(Color(hex: "#1D9E75"))
                    .frame(width: 22, height: 22)
                    .background(Color(hex: "#1D9E75").opacity(0.12))
                    .clipShape(Circle())

                Text(title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white.opacity(0.5))
                    .kerning(0.3)
                    .textCase(.uppercase)
            }

            VStack(alignment: .leading, spacing: 0) {
                content()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.white.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.08), lineWidth: 0.5)
            )
        }
    }
}

struct PolicyParagraph: View {
    var bold: String? = nil
    let bodyText: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Circle()
                .fill(Color(hex: "#1D9E75").opacity(0.5))
                .frame(width: 5, height: 5)
                .padding(.top, 6)

            Group {
                if let boldText = bold {
                    Text(boldText).fontWeight(.semibold)
                    + Text(" \(bodyText)")
                } else {
                    Text(bodyText)
                }
            }
            .font(.system(size: 13))
            .foregroundStyle(.white.opacity(0.55))
            .lineSpacing(4)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    NavigationStack {
        PrivacyPolicyView()
    }
}
