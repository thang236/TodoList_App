//
//  RegisterViewController.swift
//  TodoList_App
//
//  Created by Louis Macbook on 20/08/2024.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet private var confirmPasswordTexField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var emailTextField: UITextField!

    private var isSecure = true
    private let imageIcon = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }

    private let authService: AuthService

    init(authService: AuthService) {
        self.authService = authService
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init\(coder) has not been implemented")
    }

    static func create() -> RegisterViewController {
        let authService = AuthServiceImpl()
        let registerVC = RegisterViewController(authService: authService)
        return registerVC
    }

    @IBAction func didTapLoginButton(_: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func didTapSubmit(_: Any) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTexField.text, !confirmPassword.isEmpty
        else {
            showAlert(title: "Alert", message: "Please fill all field")
            return
        }
        if password == confirmPassword {
            registerAccount(email: email, password: password)
        } else {
            showAlert(title: "Alert", message: "Password and confirm password are not the same")
        }
    }

    func registerAccount(email: String, password: String) {
        let newAccount = AccountModel(id: "", username: email, password: password, name: "default")
        authService.register(account: newAccount) { result in
            switch result {
            case let .success(account):
                print("account: \(account)")
                let homeVC = HomeViewController.create()
                self.navigationController?.pushViewController(homeVC, animated: true)
            case let .failure(error):
                print("Đăng ký thất bại: \(error)")
                self.showAlert(title: "Alert", message: "something is wrong please try again")
            }
        }
    }

    func setupLayout() {
        navigationItem.hidesBackButton = true

        view.setBackgroundImageWithGradient(imageName: "background", topHexColor: "#7D39CB", bottomHexColor: "#3A87F3")
        passwordTextField.tag = 1
        confirmPasswordTexField.tag = 2

        setupPasswordField(for: passwordTextField)
        setupPasswordField(for: confirmPasswordTexField)
    }

    private func setupPasswordField(for textField: UITextField) {
        let imageIcon = UIImageView()
        imageIcon.image = UIImage(systemName: "eye.slash")
        let contentView = UIView()
        contentView.addSubview(imageIcon)

        guard let icon = UIImage(systemName: "eye.slash") else {
            return
        }
        contentView.frame = CGRect(x: 0, y: 0, width: icon.size.width, height: icon.size.height)
        imageIcon.frame = CGRect(x: -10, y: 0, width: icon.size.width, height: icon.size.height)

        textField.rightView = contentView
        textField.rightViewMode = .always

        let tapGestureRecongnizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))

        imageIcon.isUserInteractionEnabled = true
        imageIcon.addGestureRecognizer(tapGestureRecongnizer)

        imageIcon.tag = textField.tag
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        guard let tappedImage = tapGestureRecognizer.view as? UIImageView,
              let textField = view.viewWithTag(tappedImage.tag) as? UITextField
        else {
            return
        }
        if isSecure {
            isSecure = false
            tappedImage.image = UIImage(systemName: "eye")
            textField.isSecureTextEntry = isSecure
        } else {
            isSecure = true
            tappedImage.image = UIImage(systemName: "eye.slash")
            textField.isSecureTextEntry = isSecure
        }
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
}
