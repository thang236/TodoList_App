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
    case editProfile(id: String)
    case changePassword(id: String)
    case fetchTask(dateSearch: String)
    case deleteTask(id: String)
    case addTask
    case fetchAllTask
    case updateTask(id: String)

    var path: String {
        switch self {
        case let .login(username):
            return "/accounts/?username=\(username)"
        case .register:
            return "/accounts"
        case let .editProfile(id):
            return "/accounts/\(id)"
        case let .changePassword(id):
            return "/accounts/\(id)"
        case let .fetchTask(dateSearch):
            return"/task?date=\(dateSearch)"
        case let .deleteTask(id):
            return "/task/\(id)"
        case .addTask:
            return "/task"
        case let .updateTask(id):
            return "/task/\(id)"
        case .fetchAllTask:
            return "/task"
        }
    }

    var url: String {
        return APIConfig.baseURL + path
    }
}
