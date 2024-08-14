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
        let vc = EntryViewController(nibName: "EntryViewController", bundle: nil)
        vc.title = "New Task"
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerCell(cellType: UITableViewCell.self)
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
        let cell = tableView.dequeueReusableCell(for: indexPath, with: tasks[indexPath.row])
        return cell
        
    }
    
}

extension UITableView{
    func registerCell<T: UITableViewCell>(cellType: T.Type) {
        let identifier = String(describing: cellType)
        self.register(cellType, forCellReuseIdentifier: identifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath,with taskName : String) -> T {
        let identifier = String(describing: T.self)
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Error: could not dequeue cell with identifier: \(identifier)")
        }
        cell.textLabel?.text = taskName
        return cell
    }
    
}


