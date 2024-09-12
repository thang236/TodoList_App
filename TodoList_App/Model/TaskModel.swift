//
//  TaskModel.swift
//  TodoList_App
//
//  Created by Louis Macbook on 23/08/2024.
//

import Foundation

struct TaskModel: Codable {
    let idAccount: String
    let id: String
    var title: String
    var description: String
    var important: Bool
    var date: String
    var time: String
    var isGroup: Bool
}
