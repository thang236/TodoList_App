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

    func string(forKey key: UserDefaultsKey) -> String? {
        return string(forKey: key.rawValue)
    }

    func storeCodable<T: Codable>(_ object: T, key: UserDefaultsKey) {
        do {
            let data = try JSONEncoder().encode(object)
            UserDefaults.standard.set(data, forKey: key.rawValue)
        } catch {
            print("Error encoding: \(error)")
        }
    }

    func retrieveCodable<T: Codable>(for key: UserDefaultsKey) -> T? {
        do {
            guard let data = UserDefaults.standard.data(forKey: key.rawValue) else {
                return nil
            }
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Error decoding: \(error)")
            return nil
        }
    }
}
