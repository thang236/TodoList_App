//
//  AuthServiceImpl.swift
//  TodoList_App
//
//  Created by Louis Macbook on 20/08/2024.
//

import Alamofire
import Foundation

class AuthServiceImpl: AuthService {
    func deleteTask(id: String, completion: @escaping (Result<TaskModel, Alamofire.AFError>) -> Void) {
        networkManager.request(endpoint: APIEndpoint.deleteTask(id: id), method: .delete, completion: completion)
    }

    func fetchTask(isImportance: String, dateSearch: String, completion: @escaping (Result<[TaskModel], Alamofire.AFError>) -> Void) {
        networkManager.request(endpoint: APIEndpoint.fetchTask(isImportance: isImportance, dateSearch: dateSearch), completion: completion)
    }

    func register(account: AccountModel, completion: @escaping (Result<AccountModel, Alamofire.AFError>) -> Void) {
        let parameters: Parameters = [
            "username": account.username,
            "password": account.password,
            "name": "default",
        ]
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
        ]
        networkManager.request(endpoint: APIEndpoint.register, method: .post, parameters: parameters, headers: headers, completion: completion)
    }

    private let networkManager: NetworkManager

    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }

    func login(username: String, completion: @escaping (Result<[AccountModel], Alamofire.AFError>) -> Void) {
        networkManager.request(endpoint: APIEndpoint.login(username: username), completion: completion)
    }
}
