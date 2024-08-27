//
//  AppDelegate.swift
//  TodoList_App
//
//  Created by Louis Macbook on 11/08/2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // DI
//        let loginVC = LoginViewController.create()
        let loginVC = HomeViewController.create()
        window = UIWindow(frame: UIScreen.main.bounds)
        let nav = UINavigationController(rootViewController: loginVC)

        window?.rootViewController = nav
        window?.makeKeyAndVisible()

        return true
    }
}
