//
//  NetworkManager.swift
//  TodoList_App
//
//  Created by Louis Macbook on 19/08/2024.
//

import Alamofire

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func request<T: Decodable>(
        endpoint: APIEndpoint,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        completion: @escaping (Result<T, AFError>) -> Void
    ) {
        AF.request(endpoint.url, method: method, parameters: parameters, headers: headers)
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let decodedData):
                    completion(.success(decodedData))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func login(username: String, completion: @escaping (Result<[AccountModel], AFError>) -> Void) {
        request(endpoint: .login(username: username), completion: completion)
        
    }
    
}

