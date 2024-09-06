//
//  UserDefaults+Extension.swift
//  TodoList_App
//
//  Created by Louis Macbook on 06/09/2024.
//

import Foundation

extension UserDefaults {
        func set(_ value: Any?, forKey key: UserDefaultsKey) {
            set(value, forKey: key.rawValue)
        }

        func bool(forKey key: UserDefaultsKey) -> Bool {
            return bool(forKey: key.rawValue)
        }
}
