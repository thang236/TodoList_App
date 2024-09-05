//
//  EditProfileViewController.swift
//  TodoList_App
//
//  Created by Louis Macbook on 04/09/2024.
//

import UIKit

protocol EditProfileViewControllerDelegate {
    func onClickSubmit(accountNew: AccountModel)
}

class EditProfileViewController: UIViewController {
    private var account: AccountModel
    var editProfileDelegate: EditProfileViewControllerDelegate?
    @IBOutlet private var urlTextField: UITextField!
    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var emailTextField: UITextField!

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

    static func create(account: AccountModel) -> EditProfileViewController {
        let authService = AuthServiceImpl()
        let editProfileVC = EditProfileViewController(account: account, authService: authService)
        return editProfileVC
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
        setupDataToTextField()
        // Do any additional setup after loading the view.
    }

    private func setupDataToTextField() {
        emailTextField.text = account.username
        nameTextField.text = account.name
        urlTextField.text = account.image
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

    @objc func searchButtonTapped() {}
    @objc func didTapSave() {
        guard let name = nameTextField.text, !name.isEmpty,
              let url = urlTextField.text, !url.isEmpty
        else {
            showAlert(title: "Alert", message: "Please fill all field")
            return
        }
        account.name = name
        account.image = url
        guard let delegate = editProfileDelegate else { return }
        handleEditProfile(account: account, delegate: delegate)
    }

    func handleEditProfile(account: AccountModel, delegate: EditProfileViewControllerDelegate) {
        authService.editProfile(account: account) { result in
            switch result {
            case let .success(accountResponse):
                self.showAlert(title: "Alert", message: "update account complete")
                delegate.onClickSubmit(accountNew: accountResponse)
            case let .failure(err):
                print(err)
                self.showAlert(title: "Warning", message: "update account fail: \(err)")
            }
        }
    }
}
