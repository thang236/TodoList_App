//
//  TextField+Extension.swift
//  TodoList_App
//
//  Created by Louis Macbook on 28/08/2024.
//

import Foundation
import UIKit

extension UITextField {
    func addIconToLeft(image: UIImage, padding: CGFloat) {
        let iconView = UIImageView(frame: CGRect(x: 0, y: 0, width: image.size.width + padding, height: image.size.height))
        iconView.image = image
        iconView.contentMode = .center

        let iconContainerView = UIView(frame: CGRect(x: 0, y: 0, width: image.size.width + padding, height: image.size.height))
        iconContainerView.addSubview(iconView)

        leftView = iconContainerView
        leftViewMode = .always
    }
}
