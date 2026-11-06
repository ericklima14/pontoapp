//
//  StringExtension.swift
//  pontoapp
//
//  Created by Erick Costa Reimberg de Lima on 17/03/26.
//

import Foundation

extension String {
    private static let dateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    
    func trimingWhitespaces() -> String {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        let realString = trimmed.split(separator: " ").joined(separator: "-")
        let realStringWithOutSpecialCharacter = realString.folding(options: .diacriticInsensitive, locale: .current)
        return realStringWithOutSpecialCharacter
    }
    
    func toDate() -> Date? {
        let date = String.dateFormatter.date(from: self)
        return date
    }
}
