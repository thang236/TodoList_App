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
    



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
        window = UIWindow(frame: UIScreen.main.bounds)
        var nav = UINavigationController(rootViewController:loginVC)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        return true
    }

   
}

