//
//  TaskViewController.swift
//  TodoList_App
//
//  Created by Louis Macbook on 11/08/2024.
//

import UIKit

class TaskViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    private var tasks = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "List"
        
        setupUserDefault()
        
        setupTableView()
        
    }
    

    
    private func setupUserDefault(){
        if !UserDefaults().bool(forKey: "setup") {
            UserDefaults().set(true, forKey: "setup")
            UserDefaults().set(0, forKey: "count")
        }
    }
    
    private func fetchData () {
        tasks.removeAll()
        guard let count = UserDefaults().value(forKey: "count") as? Int else{
            return
        }
        for index in 0..<count {
            if let task = UserDefaults().value(forKey: "task_\( index + 1 )") as? String {
                tasks.append(task)
            }
        }
        tableView.reloadData()
    }
    
    
    @IBAction private func didTapAddButton(_ sender: Any) {
        let vc = EntryViewController(nibName: "EntryViewController", bundle: nil)
        vc.title = "New Task"
        vc.fetchData = {
            DispatchQueue.main.async {
                self.fetchData()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupTableView(){
        fetchData()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(cellType: UITableViewCell.self)
    }
    
    
}

extension TaskViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension TaskViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, with: tasks[indexPath.row])
        return cell
    }
    
}




