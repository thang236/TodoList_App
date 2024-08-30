//
//  APIEndpoint.swift
//  TodoList_App
//
//  Created by Louis Macbook on 19/08/2024.
//

import Foundation

enum APIEndpoint {
    case login(username: String)
    case register
    case fetchTask(isImportant: String, dateSearch: String)
    case deleteTask(id: String)
    case addTask
    case updateTask(id: String)

    var path: String {
        switch self {
        case let .login(username):
            return "/accounts/?username=\(username)"
        case .register:
            return "/accounts"
        case let .fetchTask(isImportant, dateSearch):
            return"/task?important=\(isImportant)&date=\(dateSearch)"
        case let .deleteTask(id):
            return "/task/\(id)"
        case .addTask:
            return "/task"
        case let .updateTask(id):
            return "/task/\(id)"
        }
    }

    var url: String {
        return APIConfig.baseURL + path
    }
}
