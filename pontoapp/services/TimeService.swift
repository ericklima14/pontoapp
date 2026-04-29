//
//  TimeService.swift
//  pontoapp
//
//  Created by Erick Costa on 27/04/26.
//

import Foundation

struct TimeAPIResponse: Codable {
    let hour: Int
    let minute: Int
    let year: Int
    let month: Int
    let day: Int
    let dayOfWeek: String
    let dateTime: String

    enum CodingKeys: String, CodingKey {
        case hour, minute, year, month, day
        case dayOfWeek  = "dayOfWeek"
        case dateTime   = "dateTime"
    }
}

class TimeService {
    static let shared = TimeService()
    private init() {}
    private var apiUrl = EnviromentVariables.timeZoneApi

    func fetchServerTime() async throws -> TimeAPIResponse {
        let url = URL(string: apiUrl)!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(TimeAPIResponse.self, from: data)
    }
    
    func formatTime(_ response: TimeAPIResponse) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "America/Sao_Paulo")

        if let date = formatter.date(from: response.dateTime) {
            let iso = ISO8601DateFormatter()
            iso.formatOptions = [.withInternetDateTime]
            return iso.string(from: date)
        }

        return response.dateTime
    }
}
