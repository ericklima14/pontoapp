//
//  DashboardViewModel.swift
//  pontoapp
//
//  Created by Erick Costa Reimberg de Lima on 01/04/26.
//

import Foundation
import SwiftUI

class DashboardViewModel: ObservableObject {
    @AppStorage("summaryRecordId") var summaryRecordId: String = ""
    @AppStorage("studentId") var studentId: String = ""
    @AppStorage("presences") var presences: Int = 0
    @AppStorage("absences") var absences: Int = 0
    @AppStorage("delays") var delays: Int = 0
    @AppStorage("summaryAlreadyFetched") var summaryAlredyFetched: Bool = false
    
    @Published var nextEvent: EventDetail? = nil
    @Published var isLoading: Bool = false
    
    private let webService = WebService()
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleCheckIn), name: NSNotification.Name("CheckInRealizado"), object: nil)
    }
    
    var attendanceStatus: (label: String, color: Color) {
        switch absences {
        case 0:        return ("Ótimo", Color(hex: "#1D9E75"))
        case 1...3:    return ("Atenção", Color(hex: "#EF9F27"))
        default:       return ("Crítico", Color(hex: "#D85A30"))
        }
    }
    
    @objc func handleCheckIn(notification: Notification) {
        let status = notification.object as? RecordStatus
        
        switch status {
        case .present:
            self.presences += 1
        case .absent:
            self.absences += 1
        case .lated:
            self.delays += 1
        default:
            return
        }
        
        self.updateSummaryOnAirtable()
    }
    
    func loadSummary() {
        if !self.summaryAlredyFetched {
            getSummaryFromAirtable()
        }
        
        fetchNextEvent()
    }
    
    func fetchNextEvent() {
        webService.fetchEvents { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let events):
                    self.nextEvent = events.first
                case .failure(let error):
                    print("Erro ao buscar eventos: \(error)")
                }
            }
        }
    }
    
    func getSummaryFromAirtable() {
        self.isLoading = true
        
        self.webService.fetchSummary(studentId: self.studentId) { result in
            print("O ESTUDANTE ID É (GET SUMMARY): \(self.studentId)")
            self.isLoading = false
            
            switch result {
            case .success(let summary):
                if let recordId = summary.summaryRecordId {
                    self.summaryRecordId = recordId
                }
                
                self.presences = summary.presences
                self.absences = summary.absences
                self.delays = summary.delays
                self.summaryAlredyFetched = true
                print("Summary recebido do Airtable")
            case .failure(let error):
                print("Erro ao buscar summary: \(error.localizedDescription)")
            }
        }
    }
    
    func updateSummaryOnAirtable() {
        guard !summaryRecordId.isEmpty else {
            print("summaryRecordId ainda não carregado")
            return
        }
        
        print("O ESTUDANTE ID É (UPDATE SUMMARY): \(self.studentId)")
        
        self.isLoading = true
        let newSummaryRecord = SummaryRecord(summaryId: self.summaryRecordId, presences: self.presences, absences: self.absences, delays: self.delays)
        
        
        self.webService.updateSummaryStudent(summaryRecord: newSummaryRecord) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success:
                    print("Summary atualizado no Airtable")
                case .failure(let error):
                    print("Erro ao atualizar summary: \(error)")
                }
            }
        }
    }
}
