//
//  ButtonView+Extension.swift
//  TodoList_App
//
//  Created by Louis Macbook on 28/08/2024.
//

import Foundation
import UIKit

extension UIButton {
    func applyOutletButton(cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        clipsToBounds = true
    }
}
