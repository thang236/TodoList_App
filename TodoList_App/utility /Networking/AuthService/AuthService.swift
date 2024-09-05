//
//  AuthService.swift
//  TodoList_App
//
//  Created by Louis Macbook on 20/08/2024.
//

import Alamofire
import Foundation

protocol AuthService {
    func login(username: String, completion: @escaping (Result<[AccountModel], AFError>) -> Void)
    func register(account: AccountModel, completion: @escaping (Result<AccountModel, AFError>) -> Void)
    func editProfile(account: AccountModel, completion: @escaping (Result<AccountModel, AFError>) -> Void)
}
