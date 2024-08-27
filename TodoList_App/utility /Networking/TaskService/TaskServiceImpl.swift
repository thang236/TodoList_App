//
//  TaskServiceImpl.swift
//  TodoList_App
//
//  Created by Louis Macbook on 27/08/2024.
//

import Alamofire
import Foundation

class TaskServiceImpl: TaskService {
    private let networkManager: NetworkManager
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }

    func deleteTask(id: String, completion: @escaping (Result<TaskModel, Alamofire.AFError>) -> Void) {
        networkManager.request(endpoint: APIEndpoint.deleteTask(id: id), method: .delete, completion: completion)
    }

    func fetchTask(isImportant: String, dateSearch: String, completion: @escaping (Result<[TaskModel], Alamofire.AFError>) -> Void) {
        networkManager.request(endpoint: APIEndpoint.fetchTask(isImportant: isImportant, dateSearch: dateSearch), completion: completion)
    }
}
