//
//  CalendarDTO.swift
//  pontoapp
//
//  Created by Erick Costa on 28/01/26.
//

import Foundation
import SwiftUI

struct AirtableCalendarResponse: Codable {
    let records: [Record]
}

struct Record: Codable{
    let id: String
    let fields: RecordFields
}

struct RecordFields: Codable{
    let status: String
    let datetime: String
    
    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case datetime = "datetime"
    }
}

struct CalendarEvent {
    let day: Int
    let status: RecordStatus
}

extension RecordStatus {
    
    var color: Color {
        switch self {
        case .present:
            return .green
        case .absent:
            return .red
        case .lated:
            return .yellow // ou .orange
        case .holiday:
            return .gray
        }
    }
}
