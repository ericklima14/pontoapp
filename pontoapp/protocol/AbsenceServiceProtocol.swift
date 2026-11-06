//
//  AbsenceServicing.swift
//  pontoapp
//
//  Created by Erick Costa Reimberg de Lima on 06/10/26.
//
import Foundation

protocol AbsenceServiceProtocol {
    func fetchPendingAbsences(studentID: String) async throws -> [PendingAbsence]
    
    func justifyAbsence(recordID: String, text: String, attachments: [AttachmentModel]) async throws
}

extension AbsenceServiceProtocol {
    func justifyAbsence(recordID: String, text: String) async throws {
        try await justifyAbsence(recordID: recordID, text: text, attachments: [])
    }
}
