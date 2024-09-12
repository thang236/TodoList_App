//
//  TaskServiceImpl.swift
//  TodoList_App
//
//  Created by Louis Macbook on 27/08/2024.
//

import Alamofire
import Foundation

class TaskServiceImpl: TaskService {
    func fetchTask(isImportant _: String, dateSearch _: String, completion: @escaping (Result<[TaskModel], Alamofire.AFError>) -> Void) {
        guard let idUser = UserDefaults.standard.string(forKey: .idUser) else {
            return
        }
        networkManager.request(endpoint: APIEndpoint.fetchTask(idAccount: idUser), completion: completion)
    }

    private let networkManager: NetworkManager
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }

    func deleteTask(id: String, completion: @escaping (Result<TaskModel, Alamofire.AFError>) -> Void) {
        networkManager.request(endpoint: APIEndpoint.deleteTask(id: id), method: .delete, completion: completion)
    }

    func updateTask(task: TaskModel, completion: @escaping (Result<TaskModel, Alamofire.AFError>) -> Void) {
        let parameters: Parameters = [
            "idAccount": task.idAccount,
            "title": task.title,
            "description": task.description,
            "important": task.important,
            "date": task.date,
            "time": task.time,
            "isGroup": task.isGroup,
        ]
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
        ]
        networkManager.request(endpoint: APIEndpoint.updateTask(id: task.id), method: .put, parameters: parameters, headers: headers, completion: completion)
    }

    func addTask(task: TaskModel, completion: @escaping (Result<TaskModel, Alamofire.AFError>) -> Void) {
        let parameters: Parameters = [
            "idAccount": task.idAccount,
            "title": task.title,
            "description": task.description,
            "important": task.important,
            "date": task.date,
            "time": task.time,
            "isGroup": task.isGroup,
        ]
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
        ]
        networkManager.request(endpoint: APIEndpoint.addTask, method: .post, parameters: parameters, headers: headers, completion: completion)
    }
}
