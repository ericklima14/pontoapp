//
//  RecordRequest.swift
//  pontoapp
//
//  Created by Joao Carlos Lima on 11/11/24.
//

import Foundation

struct RecordRequest: Encodable {
    var userId: String
    var latitude: Double
    var longitude: Double
}

