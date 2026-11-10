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
    private let uploader: AttachmentUploaderProtocol
    
    init(client: AirtableClientProtocol = AirtableClient(), uploader: AttachmentUploaderProtocol = DropboxService()) {
        self.client = client
        self.uploader = uploader
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
        
        if !attachments.isEmpty {
            var uploadedURLs: [[String: String]] = []
            
            for attachment in attachments {
                let link = try await uploader.upload(attachment: attachment)
                uploadedURLs.append(["url": link.absoluteString])
            }
            
            fields["Attach"] = uploadedURLs
        }
        
        try await client.update(.timelog, recordID: recordID, fields: fields)
    }
}
