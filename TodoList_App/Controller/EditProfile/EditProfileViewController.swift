//
//  EditProfileViewController.swift
//  TodoList_App
//
//  Created by Louis Macbook on 04/09/2024.
//

import FirebaseStorage
import Kingfisher
import ProgressHUD
import UIKit

protocol EditProfileViewControllerDelegate {
    func onClickSubmit(accountNew: AccountModel)
}

class EditProfileViewController: UIViewController {
    private var account: AccountModel
    var editProfileDelegate: EditProfileViewControllerDelegate?
    private var avatarNew: UIImage?

    @IBOutlet var avatarImageView: UIImageView!
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
    private lazy var imagePicker: UIImagePickerController = {
           let picker = UIImagePickerController()
           picker.sourceType = .photoLibrary
           picker.allowsEditing = true
           picker.delegate = self
           return picker
       }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupDataToTextField()
        setupImage()
        // Do any additional setup after loading the view.
    }

    private func setupImage() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapGesture)
    }

    @objc func imageTapped() {
        present(imagePicker, animated: true, completion: nil)
    }

    private func setupDataToTextField() {
        emailTextField.text = account.username
        nameTextField.text = account.name
        if account.image != "" {
            let url = URL(string: account.image)
            avatarImageView.kf.setImage(with: url)
        }
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
        guard let name = nameTextField.text, !name.isEmpty
        else {
            showAlert(title: "Alert", message: "Please fill all field")
            return
        }
        account.name = name
        guard let delegate = editProfileDelegate else { return }
        ProgressHUD.animate("Please wait...", interaction: false)
        if let avatarNew = avatarNew {
            uploadImageToFirebase(image: avatarNew)
        } else {
            handleEditProfile(account: account, delegate: delegate)
        }
    }

    func handleEditProfile(account: AccountModel, delegate: EditProfileViewControllerDelegate) {
        authService.editProfile(account: account) { result in
            switch result {
            case let .success(accountResponse):
                ProgressHUD.succeed("Upload complete")
//                self.showAlert(title: "Alert", message: "update account complete")

                delegate.onClickSubmit(accountNew: accountResponse)
            case let .failure(err):
                print(err)
                ProgressHUD.failed("Upload fail...")

                self.showAlert(title: "Warning", message: "update account fail: \(err)")
            }
        }
    }

    func uploadImageToFirebase(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("convert to jpeg fail")
            return
        }

        let storageRef = Storage.storage().reference()

        let imageRef = storageRef.child("avartars/\(UUID().uuidString).jpeg")

        let uploadTask = imageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("Fail to upload image: \(error.localizedDescription)")
                return
            }
            imageRef.downloadURL { url, error in
                if let error = error {
                    print("Fail to get image url: \(error)")
                }
                if let downloadURL = url {
                    self.avatarNew = nil
                    print("URL is update: \(downloadURL)")
                    guard let delegate = self.editProfileDelegate else { return }
                    self.account.image = downloadURL.absoluteString
                    self.handleEditProfile(account: self.account, delegate: delegate)
                }
            }
        }
        uploadTask.observe(.progress) { snapshot in
            let percentComplete = Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount) * 100
            print("Loading \(percentComplete)")
        }
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage else {
            return
        }
        avatarNew = image
        avatarImageView.image = image
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
