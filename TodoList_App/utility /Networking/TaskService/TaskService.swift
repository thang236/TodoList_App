//
//  TaskService.swift
//  TodoList_App
//
//  Created by Louis Macbook on 27/08/2024.
//

import Alamofire
import Foundation

protocol TaskService {
    func fetchTask(isImportant: String, dateSearch: String, completion: @escaping (Result<[TaskModel], AFError>) -> Void)
    func deleteTask(id: String, completion: @escaping (Result<TaskModel, AFError>) -> Void)
    func addTask(task: TaskModel, completion: @escaping (Result<TaskModel, AFError>) -> Void)
    func updateTask(task: TaskModel, completion: @escaping (Result<TaskModel, AFError>) -> Void)
}
