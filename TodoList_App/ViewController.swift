//
//  ViewController.swift
//  TodoList_App
//
//  Created by Louis Macbook on 11/08/2024.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var tasks = ["thanwg", "hoang"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "List"
        
        setupTableView()
        
    }
    
    
    @IBAction func didTapAddButton(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(identifier: "entry") as? EntryViewController else{
            fatalError()
        }
        vc.title = "New Task"
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = tasks[indexPath.row]
        return cell
        
    }
    
}


