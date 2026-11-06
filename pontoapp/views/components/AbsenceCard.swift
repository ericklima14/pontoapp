//
//  AbsenceCard.swift
//  Stemp
//
//  Created by Erick Costa Reimberg de Lima on 30/10/26.
//

import SwiftUI

struct AbsenceCard: View {
    var pendingAbsence: Date
    
    var body: some View {
        VStack{
            HStack(spacing: 8){
                Text("\(pendingAbsence.formatted(.dateTime.day().month(.wide).year()))")
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.white)
                
                Spacer()
                
                Text("Justificar")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.5))
                
                Image(systemName: "chevron.right")
                    .font(.title3)
                    .foregroundStyle(Color.white.opacity(0.5))
                    
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 30)
        }
        .background(
            RoundedRectangle(cornerRadius: 15).foregroundStyle(Color.bg900)
        )
        .padding(.horizontal, 10)
    }
}

#Preview {
    AbsenceCard(pendingAbsence: Date.now)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.bg950)
    
}
