//
//  LoginViewController.swift
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
    private let imageIcon = UIImageView()
    
    private let authService = AuthService()
    
    
    
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
        imageIcon.image = UIImage(systemName: "eye.slash")
        let contentView = UIView()
        contentView.addSubview(imageIcon)
        
        guard let icon = UIImage(systemName: "eye.slash") else {
            return
        }
        
        contentView.frame = CGRect(x: 0, y: 0, width: icon.size.width, height: icon.size.height)
        imageIcon.frame = CGRect(x: -10, y: 0, width: icon.size.width, height: icon.size.height)
        
        passwordTextField.rightView = contentView
        passwordTextField.rightViewMode = .always
        
        let tapGestureRecongnizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
        imageIcon.isUserInteractionEnabled = true
        imageIcon.addGestureRecognizer(tapGestureRecongnizer)
        
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        guard let tappedImage = tapGestureRecognizer.view as? UIImageView else{
            return
        }
        if isSecure {
            isSecure = false
            tappedImage.image = UIImage(systemName: "eye")
            passwordTextField.isSecureTextEntry = isSecure
        } else{
            isSecure = true
            tappedImage.image = UIImage(systemName: "eye.slash")
            passwordTextField.isSecureTextEntry = isSecure
        }
    }
    
    func handleLogin(username: String, password: String) {
        authService.login(username: username) { result in
            switch result {
            case .success(let accounts):
                if accounts.first(where: {$0.password == password}) != nil {
                    let vc = HomeViewController(nibName: "HomeViewController", bundle: nil)
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    self.showAlert(title: "Alert", message: "Username or password wrong")
                }
            case .failure(let error):
                print("Request Error: \(error.localizedDescription)")
                
            }
            
        }
    }
    
    
    
    
    
    
    
    
    
    
}

