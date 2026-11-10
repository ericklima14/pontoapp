//
//  AttendanceRecord.swift
//  pontoapp
//
//  Created by Joao Carlos Lima on 26/11/25.
//

import SwiftUI

struct AttendanceRecord: Identifiable {
    let id = UUID()
    let date: Date
    let status: AttendanceStatus
    let checkInTime: String?
    
    enum AttendanceStatus {
        case onTime      // Verde - no horário
        case late        // Amarelo - atrasado
        case absent      // Vermelho - falta
        
        var color: Color {
            switch self {
            case .onTime: return .green
            case .late: return .yellow
            case .absent: return .red
            }
        }
        
        var icon: String {
            switch self {
            case .onTime: return "checkmark.circle.fill"
            case .late: return "clock.fill"
            case .absent: return "xmark.circle.fill"
            }
        }
        
        var title: String {
            switch self {
            case .onTime: return "No horário"
            case .late: return "Atrasado"
            case .absent: return "Falta"
            }
        }
    }
}
