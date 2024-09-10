//
//  Date+Extension.swift
//  TodoList_App
//
//  Created by Louis Macbook on 27/08/2024.
//

import Foundation

extension Date {
    static func generateDatesForCurrentMonth(currentMonth: Int) -> [String] {
        let calendar = Calendar.current
        let currentDate = Date()
        let currentYear = calendar.component(.year, from: currentDate)

        let dateComponents = DateComponents(year: currentYear, month: currentMonth, day: 1)
        guard let startOfMonth = calendar.date(from: dateComponents) else {
            return []
        }
        guard let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth) else {
            return []
        }

        var dates: [String] = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy-EEE"

        var dateIterator = startOfMonth
        while dateIterator < endOfMonth {
            dates.append(dateFormatter.string(from: dateIterator))
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: dateIterator) else {
                break
            }
            dateIterator = nextDate
        }
        return dates
    }

    func formatDateToString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: self)
    }

    func formatTimeToString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
}
