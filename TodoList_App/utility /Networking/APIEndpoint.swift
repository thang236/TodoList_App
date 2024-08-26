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
    case fetchTask(isImportance: String, dateSearch: String)
    case deleteTask(id: String)

    var path: String {
        switch self {
        case let .login(username):
            return "/accounts/?username=\(username)"
        case .register:
            return "/accounts"
        case let .fetchTask(isImportance, dateSearch):
            return"/task?importance=\(isImportance)&date=\(dateSearch)"
        case let .deleteTask(id):
            return "/task/\(id)"
        }
    }

    var url: String {
        return APIConfig.baseURL + path
    }
}
