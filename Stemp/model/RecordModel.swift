//
//  Record.swift
//  pontoapp
//
//  Created by Joao Carlos Lima on 11/11/24.
//

import Foundation

enum RecordStatus: String, Codable {
    case lated = "Lated"
    case present = "Present"
    case absent = "Absent"
    case holiday
}

enum RecordLocation: String, Codable {
    case isAtAcademy = "Yes"
    case isntAtAcademy = "No"
}

struct RecordModel: Codable{
    var studentId: String
    var latitude: Double
    var longitude: Double
    var status: RecordStatus
    var isAtAcademy: RecordLocation
    var filesURL: [String]?
    var justifyText: String?
    
    init(studentId: String, latitude: Double, longitude: Double, status: RecordStatus, filesURL: [String]? = nil, justifyText: String? = nil, isAtAcademy: RecordLocation) {
        self.studentId = studentId
        self.latitude = latitude
        self.longitude = longitude
        self.status = status
        self.isAtAcademy = isAtAcademy
        self.filesURL = filesURL
        self.justifyText = justifyText
    }
}
