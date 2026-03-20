//
//  AttendenceChart.swift
//  pontoapp
//
//  Created by Joao Carlos Lima on 26/11/25.
//

import SwiftUI

struct AttendanceChart: View {
    let records: [AttendanceRecord] = AttendanceRecord.mockRecords
    
    @State private var animateChart = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Últimos 10 dias")
                .font(.headline)
                .foregroundColor(.white)
            
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(Array(records.enumerated()), id: \.element.id) { index, record in
                    VStack(spacing: 4) {
                        // Barra com animação
                        RoundedRectangle(cornerRadius: 4)
                            .fill(record.status.color)
                            .frame(width: 24, height: animateChart ? barHeight(for: record.status) : 0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(Double(index) * 0.05), value: animateChart)
                        
                        // Dia da semana
                        Text(dayLabel(for: record.date))
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            
            // Legenda
            HStack(spacing: 16) {
                LegendItem(color: .green, label: "No horário")
                LegendItem(color: .yellow, label: "Atrasado")
                LegendItem(color: .red, label: "Falta")
            }
            .font(.caption)
        }
        .padding()
        .background(Color.gray.opacity(0.15))
        .cornerRadius(16)
        .onAppear {
            animateChart = true
        }
    }
    
    func barHeight(for status: AttendanceRecord.AttendanceStatus) -> CGFloat {
        switch status {
        case .onTime: return 60
        case .late: return 60
        case .absent: return 60
        }
    }
    
    func dayLabel(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "E"
        return formatter.string(from: date).prefix(1).uppercased()
    }
}


struct LegendItem: View {
    var color: Color
    var label: String
    
    var body: some View {
        HStack(spacing: 6) {
            // Mantemos o quadradinho arredondado para conversar com o grid do calendário!
            RoundedRectangle(cornerRadius: 3)
                .fill(color)
                .frame(width: 8, height: 8)
            
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.85))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.white.opacity(0.05)) // Fundo translúcido estilo "Tag"
        .clipShape(Capsule())
    }
}

#Preview {
    AttendanceChart()
}
