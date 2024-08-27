//
//  UICollectionView+Extension.swift
//  TodoList_App
//
//  Created by Louis Macbook on 22/08/2024.
//

import UIKit

extension UICollectionView {
    func registerCell<T: UICollectionViewCell>(cellType _: T.Type, nibName: String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        register(nib, forCellWithReuseIdentifier: nibName)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(withType type: T.Type, for indexPath: IndexPath) -> T {
        let identifier = String(describing: type)
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
            print("Unable to dequeue \(identifier)")
            return UICollectionViewCell() as! T
        }
        return cell
    }
}
