//
//  PendingAbsencesViewModel.swift
//  pontoapp
//
//  Created by Erick Costa Reimberg de Lima on 28/10/26.
//
import Foundation

enum UserVariables {
//    static var appleID: String?
//    static var email: String?
//    static var name: String?
//    static var hasSelectedMemoji: Bool = false
//    static var hasCompletedFirstCheckIn: Bool = false
//    static var hasCompletedTutorial: Bool = false
//    static var hasSeenWelcome: Bool = false
//    static var memoji: String = ""
    static var studentID: String {
        get { UserDefaults.standard.string(forKey: "studentId") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "studentId") }
    }
    //static var userID: String?
}

@Observable
@MainActor
class PendingAbsencesViewModel {
    let studentID: String
    var absences: [PendingAbsence]
    var errorMessage: String?
    var isLoading: Bool
    private let absenceService: AbsenceServiceProtocol
    
    init(studentID: String = UserVariables.studentID, absenceService: AbsenceServiceProtocol = AbsenceService()) {
        self.studentID = studentID
        self.absences = []
        self.errorMessage = nil
        self.isLoading = false
        self.absenceService = absenceService
    }
    
    func loadAbsences() async {
        defer {
            isLoading = false
        }
        
        do{
            isLoading = true
            errorMessage = nil
            
            self.absences = try await self.absenceService.fetchPendingAbsences(studentID: studentID)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    ///Função para justificar uma falta no airtable
    /// - Parameter pendingAbsence: Objeto PendingAbsence para saber qual registro do airtable foi alterado
    /// - Parameter text: texto de justificativa
    /// - Parameter files: arquivos enviados como justificativa
    func justifyAbsence(pendingAbsence: PendingAbsence, text: String, files: [AttachmentModel]) async throws {
            
            try await absenceService.justifyAbsence(recordID: pendingAbsence.id, text: text, attachments: files)
            
            await loadAbsences()
    }
}
