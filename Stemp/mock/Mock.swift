//
//  Mock.swift
//  pontoapp
//
//  Created by Joao Carlos Lima on 26/11/25.
//

import Foundation

extension AttendanceRecord {
    static var mockRecords: [AttendanceRecord] {
        let calendar = Calendar.current
        let today = Date()
        
        return [
            AttendanceRecord(
                date: today,
                status: .onTime,
                checkInTime: "08:45"
            ),
            AttendanceRecord(
                date: calendar.date(byAdding: .day, value: -1, to: today)!,
                status: .late,
                checkInTime: "09:15"
            ),
            AttendanceRecord(
                date: calendar.date(byAdding: .day, value: -2, to: today)!,
                status: .onTime,
                checkInTime: "08:50"
            ),
            AttendanceRecord(
                date: calendar.date(byAdding: .day, value: -3, to: today)!,
                status: .absent,
                checkInTime: nil
            ),
            AttendanceRecord(
                date: calendar.date(byAdding: .day, value: -4, to: today)!,
                status: .onTime,
                checkInTime: "08:40"
            ),
            AttendanceRecord(
                date: calendar.date(byAdding: .day, value: -5, to: today)!,
                status: .late,
                checkInTime: "09:20"
            ),
            AttendanceRecord(
                date: calendar.date(byAdding: .day, value: -6, to: today)!,
                status: .onTime,
                checkInTime: "08:55"
            ),
            AttendanceRecord(
                date: calendar.date(byAdding: .day, value: -7, to: today)!,
                status: .absent,
                checkInTime: nil
            ),
            AttendanceRecord(
                date: calendar.date(byAdding: .day, value: -8, to: today)!,
                status: .onTime,
                checkInTime: "08:30"
            ),
            AttendanceRecord(
                date: calendar.date(byAdding: .day, value: -9, to: today)!,
                status: .late,
                checkInTime: "09:05"
            )
        ]
    }
}
