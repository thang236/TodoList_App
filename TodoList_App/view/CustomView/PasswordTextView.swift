//
//  PasswordTextView.swift
//  TodoList_App
//
//  Created by Louis Macbook on 09/09/2024.
//

import UIKit

@IBDesignable
final class PasswordTextView: UIView {
    @IBOutlet private var passwordTextField: UITextField!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        guard let view = loadViewFormNib(nibName: "PasswordTextView") else {
            return
        }
        view.frame = bounds
        addSubview(view)
        let toggleButton = UIButton(type: .custom)
        toggleButton.setImage(UIImage(systemName: "eye.fill"), for: .selected)
        toggleButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        toggleButton.tintColor = .iconPassword
        toggleButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        toggleButton.addTarget(self, action: #selector(togglePasswordView), for: .touchUpInside)
        let rightViewPadding = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        rightViewPadding.addSubview(toggleButton)

        toggleButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        passwordTextField.rightView = rightViewPadding
        passwordTextField.rightViewMode = .always
    }

    func getText() -> String? {
        return passwordTextField.text
    }

    func setText(text: String) {
        passwordTextField.text = text
    }

    func setPlaceholder(_ placeholder: String) {
        passwordTextField.placeholder = placeholder
    }

    @objc private func togglePasswordView(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        sender.isSelected.toggle()
    }
}
