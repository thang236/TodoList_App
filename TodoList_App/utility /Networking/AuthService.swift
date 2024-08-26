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
    func fetchTask(isImportance: String, dateSearch: String, completion: @escaping (Result<[TaskModel], AFError>) -> Void)
    func deleteTask(id: String, completion: @escaping (Result<TaskModel, AFError>) -> Void)
}
