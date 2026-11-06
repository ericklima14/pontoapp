//
//  MockAbsenceService.swift
//  pontoapp
//
//  Created by Erick Costa Reimberg de Lima on 27/10/26.
//
import Foundation

class MockAbsenceService: AbsenceServiceProtocol {
    var pendingAbsences: [PendingAbsence] = [
        PendingAbsence(id: "1", date: Calendar.current.date(byAdding: .day, value: -5, to: Date.now)!),
        PendingAbsence(id: "2", date: Calendar.current.date(byAdding: .day, value: -6, to: Date.now)!),
        PendingAbsence(id: "3", date: Calendar.current.date(byAdding: .day, value: -7, to: Date.now)!),
        PendingAbsence(id: "4", date: Calendar.current.date(byAdding: .day, value: -8, to: Date.now)!)
    ]
    
    func fetchPendingAbsences(studentID: String) async throws -> [PendingAbsence] {
        return pendingAbsences
    }
    
    func justifyAbsence(recordID: String, text: String, attachments: [AttachmentModel]) async throws {
        let _ = try JustificationRules.verifyJustification(text: text)
        
        self.pendingAbsences.removeAll(where: {$0.id == recordID})
    }
}
