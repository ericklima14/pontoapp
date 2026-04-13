//
//  RulesCardView.swift
//  pontoapp
//
//  Created by Erick Costa Reimberg de Lima on 10/04/26.
//

import SwiftUI

struct RulesCardView: View {
    @State var ruleItem: RuleCardItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            HStack{
                Text(ruleItem.title.uppercased())
                    .bold()
                    .foregroundStyle(ruleItem.color.opacity(0.7))
                Image(systemName: ruleItem.icon)
                    .foregroundStyle(ruleItem.color)
                Spacer()
            }
            
            Text(ruleItem.text)
                .font(.system(size: 14))
                .foregroundStyle(ruleItem.color.opacity(0.7))
            
            VStack(alignment: .leading, spacing: 6) {
                ForEach(ruleItem.textExample, id: \.self) { example in
                    HStack(alignment: .top, spacing: 8) {
                        Text("•")
                        Text(example)
                    }
                    .font(.system(size: 14))
                    .foregroundStyle(.white.opacity(0.5))

                }
            }
            
//            Text("**Obs.:** estes são apenas alguns exemplos. Cada caso será avaliado individualmente e a devida providência será tomada conforme a gravidade da situação.")
//                .font(.system(size: 14))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
        .background(ruleItem.color.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .overlay{
            RoundedRectangle(cornerRadius: 15)
                .stroke(ruleItem.color, lineWidth: 0.7)
        }
        .padding(.horizontal, 10)
    }
}

#Preview {
    ZStack{
        Color.bg950.ignoresSafeArea(edges: .all)
        
        var preview = RuleCardItem(
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
            ])
        
        RulesCardView(ruleItem: preview)
    }
    
}
