//
//  ViewController.swift
//  TodoList_App
//
//  Created by Louis Macbook on 11/08/2024.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    
    @IBOutlet private weak var usernameTextField: UITextField!
    
    @IBOutlet private weak var passwordTextField: UITextField!
    private var isSecure = true
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setBackgroundImageWithGradient(imageName: "background", topHexColor: "#7D39CB", bottomHexColor: "#3A87F3")
        setupPasswordField()
    }
    
    
    @IBAction func didTapLogin(_ sender: Any) {
        guard let username = usernameTextField.text, !username.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Lỗi", message: "Vui lòng nhập tên người dùng và mật khẩu.")
            return
        }
        handleLogin(username: username, password: password)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setupPasswordField() {
        // Tạo nút để hiện/ẩn mật khẩu
        let toggleButton = UIButton(type: .custom)
        
        toggleButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        toggleButton.setImage(UIImage(systemName: "eye"), for: .selected)
        toggleButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        toggleButton.frame = CGRect(x: 40, y: 0, width: 30, height: 20)
        
        passwordTextField.rightView = toggleButton
        passwordTextField.rightViewMode = .always
        passwordTextField.isSecureTextEntry = isSecure
    }
    
    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        isSecure.toggle()
        passwordTextField.isSecureTextEntry = isSecure
        sender.isSelected = isSecure
    }
    
    
    
    
    
    func handleLogin(username: String, password: String) {
        let url = "http://localhost:3000/accounts?username=\(username)"
        
        AF.request(url, method: .get).responseDecodable(of: [AccountModel].self) { response in
            switch response.result {
            case .success(let accounts):
                for account in accounts {
                    if account.password == password {
                        let vc = HomeViewController(nibName: "HomeViewController", bundle: nil)
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                }
            case .failure(let error):
                print("Lỗi: \(error)")
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
}

