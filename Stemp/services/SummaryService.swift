//
//  SummaryService.swift
//  pontoapp
//
//  Created by Erick Costa Reimberg de Lima on 31/03/26.
//

struct AirtableSummaryDetailResponse: Decodable{
    let records: [SummaryDetailRecord]
}

struct SummaryDetailRecord: Decodable{
    let id: String
    let fields: SummaryDetailFields
}

struct SummaryDetailFields: Decodable {
    let id: Int
    let studentId: [String]
    let recordId: [String]
    let presences: Int
    let absences: Int
    let delays: Int
    
    var summaryRecordId: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case studentId = "student"
        case recordId = "Record ID (from student)"
        case presences = "presences"
        case absences = "absences"
        case delays = "delays"
    }
}

struct SummaryRecord: Codable {
    let summaryId: String
    let presences: Int
    let absences: Int
    let delays: Int
}
