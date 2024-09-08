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
        if !email.isValidEmail() {
            showAlert(title: "Alert", message: "Please fill email")
        } else if password == confirmPassword {
            registerAccount(email: email, password: password)
        } else {
            showAlert(title: "Alert", message: "Password and confirm password are not the same")
        }
    }

    func registerAccount(email: String, password: String) {
        let newAccount = AccountModel(id: "", username: email, password: password, name: "default", image: "")
        authService.register(account: newAccount) { result in
            switch result {
            case let .success(account):
                let mainVC = MainViewController(account: account)
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                self.confirmPasswordTexField.text = ""
                self.navigationController?.pushViewController(mainVC, animated: true)
            case let .failure(error):
                print("Đăng ký thất bại: \(error)")
                self.showAlert(title: "Alert", message: "something is wrong please try again")
            }
        }
    }

    func setupLayout() {
        navigationItem.hidesBackButton = true
        view.setBackgroundImageWithGradient(imageName: "background", topHexColor: "#7D39CB", bottomHexColor: "#3A87F3")

        passwordTextField.enablePasswordToggle()
        confirmPasswordTexField.enablePasswordToggle()
    }
}
