//
//  NetworkManager.swift
//  TodoList_App
//
//  Created by Louis Macbook on 19/08/2024.
//

import Alamofire

class NetworkManager {
    init() {}

    func request<T: Decodable>(
        endpoint: APIEndpoint,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        completion: @escaping (Result<T, AFError>) -> Void
    ) {
        AF.request(endpoint.url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case let .success(decodedData):
                    completion(.success(decodedData))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
    }
}
