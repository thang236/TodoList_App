//
//  AuthServiceImpl.swift
//  TodoList_App
//
//  Created by Louis Macbook on 20/08/2024.
//

import Foundation
import Alamofire

class AuthServiceImpl: AuthService {
    func register(account: AccountModel, completion: @escaping (Result<AccountModel, Alamofire.AFError>) -> Void) {
        let parameters: Parameters = [
            "username": account.username,
            "password": account.password,
            "name": "default"
        ]
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        networkManager.request(endpoint: APIEndpoint.register,method: .post, parameters: parameters,headers: headers, completion: completion)
    }
    
    
    
    
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func login(username: String, completion: @escaping (Result<[AccountModel], Alamofire.AFError>) -> Void) {
        networkManager.request(endpoint: APIEndpoint.login(username: username), completion: completion)
    }
    
    
    
}
