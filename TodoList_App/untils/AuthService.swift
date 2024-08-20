//
//  AuthService.swift
//  TodoList_App
//
//  Created by Louis Macbook on 20/08/2024.
//

import Foundation
import Alamofire

class AuthService {
    
    func login(username: String, completion: @escaping (Result<[AccountModel], AFError>) -> Void) {
        NetworkManager.shared.request(endpoint: .login(username: username), completion: completion)
    }

}
