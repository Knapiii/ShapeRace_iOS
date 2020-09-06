//
//  AppDelegate.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-21.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var rootViewController: UIViewController?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
        
        
        configureInitialVC()
        //navigate(to: nil)
        return true
    }
    
    func navigate(to rootView: UIViewController?) {
        if let rootView = rootView {
            self.window?.rootViewController = rootView
        } else {
            self.window?.rootViewController = HomeNavigationViewController()
        }
        self.window?.makeKeyAndVisible()
    }
    
    func configureInitialVC(_ continueToOnboarding: (() -> ())? = nil) {
        if Auth.auth().currentUser == nil {
            rootViewController = HomeNavigationViewController()
            self.navigate(to: self.rootViewController)
        } else if Auth.auth().currentUser != nil {
            DB.currentUser.getCurrentUserData { (result) in
                switch result {
                case .success(let user):
                    switch user.hasFinishedWalkthrough {
                    case true:
                        self.fetchAllSingeltons()
                        self.rootViewController = SRTabBarController()
                        self.navigate(to: self.rootViewController)
                    case false:
                        //navigate to Auth window, onboarding to create User
                        if let completion = continueToOnboarding {
                            completion()
                        } else {
                            self.rootViewController = HomeNavigationViewController()
                            self.navigate(to: self.rootViewController)
                        }
                       
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    FBAuthenticationService.shared.signOut { (_) in
                        self.configureInitialVC()
                    }
                }
            }
        } else {
            self.rootViewController = HomeNavigationViewController()
            self.navigate(to: self.rootViewController)
        }
        
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData!) {
        NotificationCenter.default.post(name: Notis.notificationPermissionUpdated.name, object: true)
        print("Got token data! \(deviceToken)")
    }

    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError!) {
        NotificationCenter.default.post(name: Notis.notificationPermissionUpdated.name, object: false)
        print("Couldn't register: \(error)")
    }
}

