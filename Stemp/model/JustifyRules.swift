//
//  JustifyRules.swift
//  pontoapp
//
//  Created by Erick Costa Reimberg de Lima on 27/10/26.
//

import Foundation

enum JustificationRules {
    static let minimumCharacters = 10
    static let maxCharacters = 1000
    
    static func verifyJustification(text: String) throws -> String {
        let justify = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard justify.count >= JustificationRules.minimumCharacters else {
            throw JustificationError.minimumCharacters
        }
        
        guard justify.count <= JustificationRules.maxCharacters else {
            throw JustificationError.maxCharacters
        }
        
        return justify
    }
}

enum JustificationError: LocalizedError {
    case minimumCharacters
    case maxCharacters
    
    var errorDescription: String? {
        switch self {
        case .minimumCharacters:
            return "A justificativa deve ter pelo menos \(JustificationRules.minimumCharacters) caracteres!"
        case .maxCharacters:
            return "A justificativa não pode ultrapassar \(JustificationRules.maxCharacters) caracteres!"
        
        }
    }
}
