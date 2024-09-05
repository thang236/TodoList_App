//
//  AccountModel.swift
//  TodoList_App
//
//  Created by Louis Macbook on 16/08/2024.
//

import Foundation

struct AccountModel: Codable {
    let id: String
    let username: String
    var password: String
    var name: String
    var image: String
}
