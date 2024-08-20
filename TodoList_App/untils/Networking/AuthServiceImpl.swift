//
//  AuthServiceImpl.swift
//  TodoList_App
//
//  Created by Louis Macbook on 20/08/2024.
//

import Foundation
import Alamofire

class AuthServiceImpl: AuthService {
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func login(username: String, completion: @escaping (Result<[AccountModel], Alamofire.AFError>) -> Void) {
        networkManager.request(endpoint: APIEndpoint.login(username: username), completion: completion)
    }
    
}
