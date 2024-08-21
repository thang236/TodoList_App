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

    var path: String {
        switch self {
        case let .login(username):
            return "/accounts/?username=\(username)"
        case .register:
            return "/accounts"
        }
    }

    var url: String {
        return APIConfig.baseURL + path
    }
}
