//
//  ChangePasswordViewController.swift
//  TodoList_App
//
//  Created by Louis Macbook on 04/09/2024.
//

import UIKit

protocol ChangePasswordViewControllerDelegate {
    func onChangePasswordDone()
}

class ChangePasswordViewController: UIViewController {
    @IBOutlet private var emailtextField: UITextField!
    @IBOutlet private var currentPasswordTextField: PasswordTextView!
    @IBOutlet private var newPasswordTextField: PasswordTextView!
    @IBOutlet private var confirmPasswordTextField: PasswordTextView!

    var delegate: ChangePasswordViewControllerDelegate?
    private var account: AccountModel
    private let authService: AuthService
    init(account: AccountModel, authService: AuthService) {
        self.account = account
        self.authService = authService
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init\(coder) has not been implemented")
    }

    static func create(account: AccountModel) -> ChangePasswordViewController {
        let authService = AuthServiceImpl()
        return ChangePasswordViewController(account: account, authService: authService)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
        setupData()
        // Do any additional setup after loading the view.
    }

    private func setupData() {
        emailtextField.text = account.username
        currentPasswordTextField.setPlaceholder("Enter your password")
        newPasswordTextField.setPlaceholder("Enter your new password")
        confirmPasswordTextField.setPlaceholder("Enter your confirm password")
    }

    private func setupNavigation() {
        navigationItem.hidesBackButton = true
        let checkdoneButton = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .plain, target: self, action: #selector(didTapSave))
        checkdoneButton.tintColor = .white
        navigationItem.rightBarButtonItem = checkdoneButton

        let leftButton = UIBarButtonItem(image: UIImage(named: "dashboard"), style: .plain, target: self, action: #selector(searchButtonTapped))
        leftButton.tintColor = .white
        navigationItem.leftBarButtonItem = leftButton
        let image = UIImage(named: "checked")
        let imageView = UIImageView(image: image)
        let titleLabel = UILabel()
        titleLabel.text = "To-do"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = UIColor(hex: "#B3B3AC")
        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        navigationItem.titleView = stackView

        leftButton.target = revealViewController()
        leftButton.action = #selector(revealViewController()?.revealSideMenu)
    }

    @objc func didTapSave() {
        guard let currentPass = currentPasswordTextField.getText(), !currentPass.isEmpty,
              let newPass = newPasswordTextField.getText(), !newPass.isEmpty,
              let confirmPass = confirmPasswordTextField.getText(), !confirmPass.isEmpty
        else {
            showAlert(title: "Warning", message: "Please fill all field")
            return
        }
        if currentPass != account.password {
            showAlert(title: "Warning", message: "wrong password")
            return
        }
        if newPass != confirmPass {
            showAlert(title: "Warning", message: "confirm password is not like new password")
            return
        }
        account.password = newPass
        changePassword(account: account)
    }

    @objc func searchButtonTapped() {}

    func changePassword(account: AccountModel) {
        guard let delegate = delegate else {
            return
        }
        authService.changePassword(account: account) { result in
            switch result {
            case .success:
                print("succes")
                delegate.onChangePasswordDone()
            case let .failure(error):
                self.showAlert(title: "Waring", message: "change password error: \(error)")
                print("change password error: \(error)")
            }
        }
    }
}
