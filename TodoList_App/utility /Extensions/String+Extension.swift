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
}
