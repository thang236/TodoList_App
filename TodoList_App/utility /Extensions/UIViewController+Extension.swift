//
//  UIViewController+Extension.swift
//  TodoList_App
//
//  Created by Louis Macbook on 04/09/2024.
//

import Foundation
import UIKit

extension UIViewController {
    // With this extension you can access the MainViewController from the child view controllers.
    func revealViewController() -> MainViewController? {
        var viewController: UIViewController? = self

        if viewController != nil, viewController is MainViewController {
            return viewController! as? MainViewController
        }
        while !(viewController is MainViewController), viewController?.parent != nil {
            viewController = viewController?.parent
        }
        if viewController is MainViewController {
            return viewController as? MainViewController
        }
        return nil
    }

    // Call this Button Action from the View Controller you want to Expand/Collapse when you tap a button
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
}
