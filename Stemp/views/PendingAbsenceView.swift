//
//  PendingAbsenceView.swift
//  Stemp
//
//  Created by Erick Costa Reimberg de Lima on 30/10/26.
//

import SwiftUI

struct PendingAbsenceView: View {
    @State var viewModel: PendingAbsencesViewModel
    
    var body: some View {
        ScrollView{
            ForEach(viewModel.absences){ pendingAbsence in
                NavigationLink(destination:
                JustifyView(titleText: "Justificar Ausência", subtitleText: "Motivo da sua ausência:")
                { text, files in
                    try await viewModel.justifyAbsence(pendingAbsence: pendingAbsence, text: text, files: files)
                })
                {
                    AbsenceCard(pendingAbsence: pendingAbsence.date)
                }
            }
        }
        .navigationTitle("Faltas a Justificar")
        .task {
            await viewModel.loadAbsences()
        }
    }
}

#Preview {
    let pendingAbsence = PendingAbsencesViewModel(absenceService: MockAbsenceService())
    
    NavigationStack{
        PendingAbsenceView(viewModel: pendingAbsence)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.bg950)
}
