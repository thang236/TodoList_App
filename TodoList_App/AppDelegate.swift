//
//  AppDelegate.swift
//  TodoList_App
//
//  Created by Louis Macbook on 11/08/2024.
//

import IQKeyboardManagerSwift
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // DI
        let loginVC = LoginViewController.create()
        window = UIWindow(frame: UIScreen.main.bounds)
        let nav = UINavigationController(rootViewController: loginVC)

        window?.rootViewController = nav
        window?.makeKeyAndVisible()

        // LibraryIQKeyboardManager
        IQKeyboardManager.shared.enable = true

        applySavedAppearance()
        return true
    }

    func applySavedAppearance() {
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        if isDarkMode {
            window?.overrideUserInterfaceStyle = .dark
        } else {
            window?.overrideUserInterfaceStyle = .light
        }
    }
}
