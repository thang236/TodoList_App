//
//  TaskViewController.swift
//  TodoList_App
//
//  Created by Louis Macbook on 11/08/2024.
//

import UIKit

class TaskViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    private var tasks = ["thanwg", "hoang"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "List"
        
        setupTableView()
    }
    
    
    @IBAction private func didTapAddButton(_ sender: Any) {
        let vc = EntryViewController(nibName: "EntryViewController", bundle: nil)
        vc.title = "New Task"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupTableView(){
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




