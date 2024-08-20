//
//  APIConstants.swift
//  TodoList_App
//
//  Created by Louis Macbook on 19/08/2024.
//

import Foundation

enum APIEndpoint {
    case login(username: String)
    
    var path: String {
        switch self {
        case .login(let username):
            return "/accounts/?username=\(username)"
            
        }
    }
    
    var url: String {
        return APIConfig.baseURL + path
    }
}

