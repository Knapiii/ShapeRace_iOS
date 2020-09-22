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
    var authListener: AuthStateDidChangeListenerHandle?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
        
        //navigate(to: nil)
        if authListener != nil {
            return true
        }
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        authListener = Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                DB.friends.startObservingFriends()
                //DB.workout.fetchMyWorkouts { (_) in }
                dispatchGroup.leave()
            } else {
                DB.friends.stopObservingFriends()
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            self.configureInitialVC()
        }
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        if WorkoutTimerService.shared.timer != nil && WorkoutTimerService.shared.isRunning {
            WorkoutTimerService.shared.isPausedByInactivity = true
            WorkoutTimerService.shared.didBecomeInActiveDate = Date()
            WorkoutTimerService.shared.pauseTimer()
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if WorkoutTimerService.shared.timer != nil && WorkoutTimerService.shared.isPausedByInactivity {
            guard let inactiveDate = WorkoutTimerService.shared.didBecomeInActiveDate  else { return }
            let secondsSinceResignedActive = Int(Date().timeIntervalSince(inactiveDate))
            WorkoutTimerService.shared.seconds += secondsSinceResignedActive
            WorkoutTimerService.shared.resumeTimer()
            WorkoutTimerService.shared.didBecomeInActiveDate = nil
        }
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
                    print(user.description)
                    print(user.description)
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
                            let root = HomeNavigationViewController()
                            self.rootViewController = root
                            self.navigate(to: root)
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

