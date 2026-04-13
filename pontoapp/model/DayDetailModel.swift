//
//  DayDetailModel.swift
//  pontoapp
//
//  Created by Erick Costa Reimberg de Lima on 25/03/26.
//

import Foundation

struct DayDetail: Identifiable {
    let id = UUID()
    let date: Date
    let checkIn: CheckInDetail?
    let events: [EventDetail]
    let holiday: String? // nil = dia normal
}

struct CheckInDetail {
    let time: String      // "14:05"
    let status: RecordStatus
}

struct EventDetail: Identifiable {
    let id: String        // record id do Airtable
    let name: String
    let time: Date      // "14:00"
    let icon: String      // SF Symbol name
    let colorHex: String?
    let description: String?
    let supportMaterial: [AirtableAttachment]?
    let deliveryLinks: String?
    
    var formattedDateTime: String {
        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "pt_BR")
        fmt.dateFormat = "d 'de' MMM 'às' HH:mm"
        return fmt.string(from: time)
    }
    
    var formattedTime: String {
        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "pt_BR")
        fmt.dateFormat = "HH:mm"
        return fmt.string(from: time)
    }
}
