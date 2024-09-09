//
//  String+Extension.swift
//  TodoList_App
//
//  Created by Louis Macbook on 27/08/2024.
//

import Foundation

extension String {
    func dateComponentsSeparated() -> (year: String?, month: String?, day: String?, weekDay: String?) {
        let components = self.components(separatedBy: "-")
        if components.count == 4 {
            return (year: components[2], month: components[1], day: components[0], weekDay: components[3])
        } else {
            return (year: nil, month: nil, day: nil, weekDay: nil)
        }
    }

    func formattedDate() -> String? {
        let components = self.components(separatedBy: "-")
        if components.count >= 3 {
            return "\(components[0])-\(components[1])-\(components[2])"
        }
        return nil
    }

    func toDate(format: String = "dd-MM-yyyy") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)
    }

    func toTime(format: String = "HH:mm") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)
    }

    func isValidEmail() -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
}
