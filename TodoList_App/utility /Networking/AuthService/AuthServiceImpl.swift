//
//  AuthServiceImpl.swift
//  TodoList_App
//
//  Created by Louis Macbook on 20/08/2024.
//

import Alamofire
import Foundation

class AuthServiceImpl: AuthService {
    func changePassword(account: AccountModel, completion: @escaping (Result<AccountModel, Alamofire.AFError>) -> Void) {
        let parameters: Parameters = [
            "password": account.password,
        ]
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
        ]
        networkManager.request(endpoint: APIEndpoint.changePassword(id: account.id), method: .patch, parameters: parameters, headers: headers, completion: completion)
    }

    func editProfile(account: AccountModel, completion: @escaping (Result<AccountModel, Alamofire.AFError>) -> Void) {
        let parameters: Parameters = [
            "username": account.username,
            "password": account.password,
            "name": account.name,
            "image": account.image,
        ]
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
        ]
        networkManager.request(endpoint: APIEndpoint.editProfile(id: account.id), method: .put, parameters: parameters, headers: headers, completion: completion)
    }

    func register(account: AccountModel, completion: @escaping (Result<AccountModel, Alamofire.AFError>) -> Void) {
        let parameters: Parameters = [
            "username": account.username,
            "password": account.password,
            "name": "default",
            "image": "",
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
