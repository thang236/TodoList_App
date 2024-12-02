//
//  LoginViewController.swift
//  TodoList_App
//
//  Created by Louis Macbook on 11/08/2024.
//

import Alamofire
import ProgressHUD
import UIKit

class LoginViewController: UIViewController {
    @IBOutlet private var usernameTextField: UITextField!

    @IBOutlet private var passwordTextField: PasswordTextView!
    private var isSecure = true
    private let imageIcon = UIImageView()

    private let authService: AuthService

    init(authService: AuthService) {
        self.authService = authService
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init\(coder) has not been implemented")
    }

    static func create() -> LoginViewController {
        let authService = AuthServiceImpl()
        let loginVc = LoginViewController(authService: authService)

        return loginVc
    }

    @IBAction func didTapRegister(_: Any) {
        let vc = RegisterViewController.create()
        navigationController?.pushViewController(vc, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.view.setBackgroundImageWithGradient(imageName: "background", topHexColor: "#7D39CB", bottomHexColor: "#3A87F3")
        }
        setupPasswordField()
    }

    @IBAction func didTapLogin(_: Any) {
        ProgressHUD.animate("Please wait...", .ballVerticalBounce)
        guard let username = usernameTextField.text, !username.isEmpty,
              let password = passwordTextField.getText(), !password.isEmpty
        else {
            showAlert(title: "Alert", message: "Please fill username and password.")
            return
        }
        handleLogin(username: username, password: password)
    }

    private func setupPasswordField() {
        passwordTextField.setPlaceholder("Enter your password")
    }

    func handleLogin(username: String, password: String) {
        authService.login(username: username) { result in
            switch result {
            case let .success(accounts):
                if accounts.first(where: { $0.password == password }) != nil {
                    ProgressHUD.succeed()
                    let mainVC = MainViewController()
                    self.usernameTextField.text = ""
                    self.passwordTextField.setText(text: "")

                    UserDefaults.standard.storeCodable(accounts.first, key: .userInfo)

                    self.navigationController?.pushViewController(mainVC, animated: true)
                } else {
                    self.showAlert(title: "Alert", message: "Username or password wrong")
                }
            case let .failure(error):
                print("Request Error: \(error.localizedDescription)")
            }
        }
    }
}
