//
//  MainViewController.swift
//  TodoList_App
//
//  Created by Louis Macbook on 04/09/2024.
//

import UIKit

class MainViewController: UIViewController {
    private var sideMenuViewController: SideMenuViewController!
    private var sideMenuRevealWidth: CGFloat = 270
    private let paddingForRotation: CGFloat = 150
    private var isExpanded: Bool = false

    private var sideMenuTrailingConstraint: NSLayoutConstraint!

    private var revealSideMenuOnTop: Bool = true

    private var sideMenuShadowView: UIView!
    private var account: AccountModel

    init(account: AccountModel) {
        self.account = account
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init\(coder) has not been implemented")
    }

    @IBAction open func revealSideMenu() {
        toggleSideMenu(expanded: isExpanded ? false : true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupSideMenuShadowView()
        setupSideMenu()
        setupInitialViewController()
    }

    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    private func setupSideMenuShadowView() {
        sideMenuShadowView = UIView(frame: view.bounds)
        sideMenuShadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        sideMenuShadowView.backgroundColor = .black
        sideMenuShadowView.alpha = 0.0
        if revealSideMenuOnTop {
            view.insertSubview(sideMenuShadowView, at: 1)
        }
    }

    private func setupSideMenu() {
        sideMenuViewController = SideMenuViewController(account: account)
        sideMenuViewController.delegate = self
        view.insertSubview(sideMenuViewController!.view, at: revealSideMenuOnTop ? 2 : 0)
        addChild(sideMenuViewController!)
        sideMenuViewController!.didMove(toParent: self)

        setupSideMenuConstraints()
    }

    private func setupSideMenuConstraints() {
        sideMenuViewController.view.translatesAutoresizingMaskIntoConstraints = false

        if revealSideMenuOnTop {
            sideMenuTrailingConstraint = sideMenuViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -sideMenuRevealWidth - paddingForRotation)
            sideMenuTrailingConstraint.isActive = true
        }
        NSLayoutConstraint.activate([
            sideMenuViewController.view.widthAnchor.constraint(equalToConstant: sideMenuRevealWidth),
            sideMenuViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sideMenuViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
        ])
    }

    private func setupInitialViewController() {
        let homeVC = HomeViewController.create()
        let nav = UINavigationController(rootViewController: homeVC)
        showViewController(viewController: nav)
    }

    func showViewController(viewController: UIViewController) {
        for subview in view.subviews {
            if subview.tag == 99 {
                subview.removeFromSuperview()
            }
        }
        viewController.view.tag = 99
        view.insertSubview(viewController.view, at: revealSideMenuOnTop ? 0 : 1)
        addChild(viewController)
        if !revealSideMenuOnTop {
            if isExpanded {
                viewController.view.frame.origin.x = sideMenuRevealWidth
            }
            if sideMenuShadowView != nil {
                viewController.view.addSubview(sideMenuShadowView)
            }
        }
        viewController.didMove(toParent: self)
    }

    func toggleSideMenu(expanded: Bool) {
        if expanded {
            animateSideMenu(targetPosition: revealSideMenuOnTop ? 0 : sideMenuRevealWidth) { _ in
                self.isExpanded = true
            }
            UIView.animate(withDuration: 0.5) { self.sideMenuShadowView.alpha = 0.6 }
        } else {
            animateSideMenu(targetPosition: revealSideMenuOnTop ? (-sideMenuRevealWidth - paddingForRotation) : 0) { _ in
                self.isExpanded = false
            }
            UIView.animate(withDuration: 0.5) { self.sideMenuShadowView.alpha = 0.0 }
        }
    }
}

extension MainViewController: SideMenuViewControllerDelegate {
    func selectedEditProfile() {
        let edit = EditProfileViewController()
        let nav = UINavigationController(rootViewController: edit)
        showViewController(viewController: nav)

        DispatchQueue.main.async { self.toggleSideMenu(expanded: false) }
    }

    func closeSideMenu() {
        DispatchQueue.main.async { self.toggleSideMenu(expanded: false) }
    }

    func selectedCell(_ row: Int) {
        guard let option = MenuOption(rawValue: row) else { return }
        switch option {
        case .home:
            // Home
            let home = HomeViewController.create()
            let nav = UINavigationController(rootViewController: home)
            showViewController(viewController: nav)

        case .setting:
            // Setting
            let setting = SettingViewController()
            let nav = UINavigationController(rootViewController: setting)
            showViewController(viewController: nav)
        }
        DispatchQueue.main.async { self.toggleSideMenu(expanded: false) }
    }

    func animateSideMenu(targetPosition: CGFloat, completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .layoutSubviews, animations: {
            if self.revealSideMenuOnTop {
                self.sideMenuTrailingConstraint.constant = targetPosition
                self.view.layoutIfNeeded()
            } else {
                self.view.subviews[1].frame.origin.x = targetPosition
            }
        }, completion: completion)
    }
}
