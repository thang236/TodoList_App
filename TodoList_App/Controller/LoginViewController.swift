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
    private let imageIcon = UIImageView()
    
    
    
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
        
        contentView.frame = CGRect(x: 0, y: 0, width: UIImage(systemName: "eye.slash")!.size.width, height: UIImage(systemName: "eye.slash")!.size.height)
        
        imageIcon.frame = CGRect(x: -10, y: 0, width: UIImage(systemName: "eye.slash")!.size.width, height: UIImage(systemName: "eye.slash")!.size.height)
        
        passwordTextField.rightView = contentView
        passwordTextField.rightViewMode = .always
        
        let tapGestureRecongnizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
        imageIcon.isUserInteractionEnabled = true
        imageIcon.addGestureRecognizer(tapGestureRecongnizer)
        
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
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
        let url = "http://localhost:3000/accounts?username=\(username)"
        
        AF.request(url, method: .get).responseDecodable(of: [AccountModel].self) { response in
            switch response.result {
            case .success(let accounts):
                for account in accounts {
                    if account.password == password {
                        let vc = HomeViewController(nibName: "HomeViewController", bundle: nil)
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        self.showAlert(title: "Alert", message: "username or password wrong")
                    }
                    
                }
            case .failure(let error):
                print("Lỗi: \(error)")
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
}

