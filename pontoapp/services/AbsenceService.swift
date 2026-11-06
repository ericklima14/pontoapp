//
//  AbsenceService.swift
//  pontoapp
//
//  Created by Erick Costa Reimberg de Lima on 06/10/26.
//

import Foundation

private struct AbsenceFields: Decodable {
    let datetime: String
}

class AbsenceService: AbsenceServiceProtocol {
    
    private let client: AirtableClientProtocol
    
    init(client: AirtableClientProtocol = AirtableClient()) {
        self.client = client
    }
    
    func fetchPendingAbsences(studentID: String) async throws -> [PendingAbsence] {
        let formula = "AND({Status} = 'Absent', {Justify} = '', FIND('\(studentID)', ARRAYJOIN({Record ID (from student)})))"
        let fields = ["datetime"]
        
        let absenceRecords: [AirtableRecord<AbsenceFields>] = try await client.list(.timelog, formula: formula, fields: fields)
        
        let pendingAbsences: [PendingAbsence] = absenceRecords.compactMap{ value in
            guard let date = value.fields.datetime.toDate() else {
                return nil
            }
            
            let absenceID = value.id
            let newPendingAbsence = PendingAbsence(id: absenceID, date: date)
            
            return newPendingAbsence
        }
        
        return pendingAbsences
    }
    
    func justifyAbsence(recordID: String, text: String, attachments: [AttachmentModel]) async throws {
        let justify = try JustificationRules.verifyJustification(text: text)
        
        var fields: [String: Any] = [
            "Justify": justify
        ]
//        
//        if !files.isEmpty {
//            let attachments = files.map { url in
//                return ["url": url.]
//            }
//            
//            fields["Attach"] = attachments
//        }
        
        try await client.update(.timelog, recordID: recordID, fields: fields)
    }
}
