//
//  RegisterViewController.swift
//  TodoList_App
//
//  Created by Louis Macbook on 20/08/2024.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet private var confirmPasswordTexField: PasswordTextView!
    @IBOutlet private var passwordTextField: PasswordTextView!
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
              let password = passwordTextField.getText(), !password.isEmpty,
              let confirmPassword = confirmPasswordTexField.getText(), !confirmPassword.isEmpty
        else {
            showAlert(title: "Alert", message: "Please fill all field")
            return
        }
        if !email.isValidEmail() {
            showAlert(title: "Alert", message: "Please fill email")
        } else if password != confirmPassword {
            showAlert(title: "Alert", message: "Password and confirm password are not the same")
        } else {
            checkUsername(email: email) { isAvailable in
                print(isAvailable)
                if isAvailable {
                    self.showAlert(title: "Alert", message: "your email have register")
                } else {
                    self.registerAccount(email: email, password: password)
                }
            }
        }
    }

    func checkUsername(email: String, completion: @escaping (Bool) -> Void) {
        authService.checkUsername(username: email) { result in
            switch result {
            case let .success(accounts):
                var check = false
                for account in accounts {
                    print(account.username)
                    if account.username == email {
                        check = true
                    }
                }
                completion(check)
            case let .failure(err):
                print("err check account: \(err)")
                completion(false)
            }
        }
    }

    func registerAccount(email: String, password: String) {
        let newAccount = AccountModel(id: "", username: email, password: password, name: "default", image: "")
        authService.register(account: newAccount) { result in
            switch result {
            case let .success(account):
                let mainVC = MainViewController()
                self.emailTextField.text = ""
                self.passwordTextField.setText(text: "")
                self.confirmPasswordTexField.setText(text: "")

                UserDefaults.standard.storeCodable(account, key: .userInfo)

                self.navigationController?.pushViewController(mainVC, animated: true)
            case let .failure(error):
                print("Đăng ký thất bại: \(error)")
                self.showAlert(title: "Alert", message: "something is wrong please try again")
            }
        }
    }

    func setupLayout() {
        navigationItem.hidesBackButton = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.view.setBackgroundImageWithGradient(imageName: "background", topHexColor: "#7D39CB", bottomHexColor: "#3A87F3")
        }

        passwordTextField.setPlaceholder("Enter your password")
        confirmPasswordTexField.setPlaceholder("Re-Enter your password")
    }
}
