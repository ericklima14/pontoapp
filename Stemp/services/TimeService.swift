//
//  TimeService.swift
//  pontoapp
//
//  Created by Erick Costa on 27/04/26.
//

import Foundation

struct TimeAPIResponse: Codable {
   let year: Int
   let month: Int
   let day: Int
   let hour: Int
   let minute: Int
   let seconds: Int
   let timeZone: String
}

class TimeService {
    static let shared = TimeService()
    private init() {}
    private var apiUrl = EnviromentVariables.timeZoneApi

    func fetchServerTime() async throws -> Date {
        guard let url = URL(string: apiUrl) else { throw URLError(.badURL) }
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(TimeAPIResponse.self, from: data)
        
        let calendar = Calendar.academy
        
        let components = DateComponents(
           year: response.year, month: response.month, day: response.day,
           hour: response.hour, minute: response.minute, second: response.seconds
        )
        
        guard let date = calendar.date(from: components) else {
            throw URLError(.cannotParseResponse)
        }
        
        return date
    }
}
