//
//  UITableView+Extension.swift
//  TodoList_App
//
//  Created by Louis Macbook on 27/08/2024.
//

import Foundation
import UIKit

extension UITableView {
    func registerCell<T: UITableViewCell>(cellType: T.Type) {
        let identifier = String(describing: cellType)
        let nib = UINib(nibName: identifier, bundle: nil)
        register(nib, forCellReuseIdentifier: identifier)
    }

    func configure<T: UITableViewCell>(cellType: T.Type, at indexPath: IndexPath, with item: Any) -> T {
        let identifier = String(describing: cellType)
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            return UITableViewCell() as! T
        }

        if let taskCell = cell as? TaskTableViewCell, let data = item as? TaskModel {
            taskCell.setupTableView(task: data)
        }

        return cell
    }
}
