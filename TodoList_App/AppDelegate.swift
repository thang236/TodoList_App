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
        //DI
        let networkManager = NetworkManager()
        let authService = AuthServiceImpl(networkManager: networkManager)

        let loginVC = LoginViewController(authService: authService)
        window = UIWindow(frame: UIScreen.main.bounds)
        let nav = UINavigationController(rootViewController:loginVC)
        
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        return true
    }

   
}

