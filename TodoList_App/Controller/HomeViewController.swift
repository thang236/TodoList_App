//
//  HomeViewController.swift
//  TodoList_App
//
//  Created by Louis Macbook on 16/08/2024.
//

import UIKit

class HomeViewController: UIViewController {
    private let authService: AuthService

    init(authService: AuthService) {
        self.authService = authService
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init\(coder) has not been implemented")
    }

    static func create() -> HomeViewController {
        let authService = AuthServiceImpl()
        let homeVC = HomeViewController(authService: authService)

        return homeVC
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
