//
//  TaskUITableView.swift
//  TodoList_App
//
//  Created by Louis Macbook on 15/08/2024.
//

import UIKit


extension UITableView{
    func registerCell<T: UITableViewCell>(cellType: T.Type) {
        let identifier = String(describing: cellType)
        self.register(cellType, forCellReuseIdentifier: identifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath,with taskName : String) -> T {
        let identifier = String(describing: T.self)
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            return UITableViewCell() as! T
        }
        cell.textLabel?.text = taskName
        return cell
    }
}
