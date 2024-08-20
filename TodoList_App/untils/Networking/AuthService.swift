//
//  AuthService.swift
//  TodoList_App
//
//  Created by Louis Macbook on 20/08/2024.
//

import Foundation
import Alamofire

protocol AuthService {
    func login(username: String, completion: @escaping (Result<[AccountModel], AFError>) -> Void) 
}
