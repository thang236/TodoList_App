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

    func enablePasswordToggle() {
        let toggleButton = UIButton(type: .custom)
        toggleButton.setImage(UIImage(systemName: "eye.fill"), for: .selected)
        toggleButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        toggleButton.tintColor = .iconPassword
        toggleButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        toggleButton.addTarget(self, action: #selector(togglePasswordView), for: .touchUpInside)

        let rightViewPadding = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        rightViewPadding.addSubview(toggleButton)

        toggleButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)

        rightView = rightViewPadding
        rightViewMode = .always
    }

    @objc private func togglePasswordView(_ sender: UIButton) {
        isSecureTextEntry.toggle()
        sender.isSelected.toggle()
    }
}
