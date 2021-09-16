//
//  AppDelegate.swift
//  RxSwiftPractice
//
//  Created by Masato Takamura on 2021/09/15.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let vc = UIStoryboard(name: "Welcome", bundle: nil).instantiateInitialViewController() as! WelcomeViewController
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UINavigationController(rootViewController: vc)
        window.makeKeyAndVisible()
        self.window = window
        return true
    }


}

