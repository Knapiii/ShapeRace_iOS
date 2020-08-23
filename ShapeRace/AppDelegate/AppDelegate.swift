//
//  AppDelegate.swift
//  Shape Race
//
//  Created by Kristoffer Knape on 2020-08-21.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var rootViewController: UIViewController?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()

        rootViewController = HomeNavigationViewController()
        navigate(to: rootViewController!)
        return true
    }
    
    func navigate(to rootView: UIViewController) {
        self.window?.rootViewController = rootView
        self.window?.makeKeyAndVisible()
    }
}

