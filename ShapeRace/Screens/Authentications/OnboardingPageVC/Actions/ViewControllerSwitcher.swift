//
//  ViewControllerSwitcher.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-30.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import Foundation

extension AuthenticationOnBoardingVC {
    
    func configCurrentVC(state: Authstate? = nil) {
        
        //MARK: AuthStartVC
        if currentViewController is AuthStartVC, let _ = currentViewController as? AuthStartVC {
            firstButton.setupUI(title: "Login")
            secondButton.setupUI(title: "Sign up")
            firstButton.addAction { self.navigate(.forward, state: .login) }
            secondButton.addAction { self.navigate(.forward, state: .signUp) }
        }
        if currentViewController is SignInAndUpVC, let vc = currentViewController as? SignInAndUpVC {
            if let state = state {
                vc.state = state
                vc.delegate = self
                switch state {
                case .login:
                    firstButton.setupUI(title: "Login")
                    firstButton.addAction { self.LoginWithFirebase() }
                case .signUp:
                    firstButton.setupUI(title: "Sign Up")
                    firstButton.addAction { self.SignUpWithFirebase() }
                }
                secondButton.setupUI(title: "Cancel")
                secondButton.addAction { self.navigateBack() }
            }
        }
        
        //MARK: PageCreateUserDetailsInfoVC
        if currentViewController is PageCreateUserDetailsInfoVC, let _ = currentViewController as? PageCreateUserDetailsInfoVC {
            stopLocationNotificationHandler()
            stopNotificationPermissionNotificationHandler()
            pageViewController.displayedPageIndex = 1
            firstButton.setupUI(title: "Save")
            secondButton.setupUI(title: "Skip")
            secondButton.addAction { self.navigateForward() }
            backButton.addAction { self.navigateBack(state: .login) }
            firstButton.isHidden = false
        }
        
        if currentViewController is PageEnablePositionVC, let vc = currentViewController as? PageEnablePositionVC {
            pageViewController.displayedPageIndex = 2
            if LocationManagerService.shared.isUserSharingLocation == .authorized {
                stopLocationNotificationHandler()
                firstButton.isHidden = true
                secondButton.setupUI(title: "Location service has been authorized, continue")
                secondButton.addAction {
                    self.finnishWalkthrough()
                }
            } else if LocationManagerService.shared.isUserSharingLocation == .denied {
                stopLocationNotificationHandler()
                firstButton.isHidden = true
                secondButton.setupUI(title: "Location service has been denied, continue")
                secondButton.addAction {
                    self.finnishWalkthrough()
                }
            } else if LocationManagerService.shared.isUserSharingLocation == .notDetermined {
                locationNotificationHandler()
                firstButton.isHidden = false
                self.firstButton.setupUI(title: "Enable location service")
                self.secondButton.setupUI(title: "Skip")
                firstButton.addAction {
                    vc.askForLocation()
                }
                secondButton.addAction { self.finnishWalkthrough() }
            }
            backButton.addAction {  self.navigate(.reverse) }
        }
//
//        //MARK: PageEnableAppleHealthVC
//        if currentViewController is PageEnableAppleHealthVC, let vc = currentViewController as? PageEnableAppleHealthVC {
//            stopLocationNotificationHandler()
//            pageViewController.displayedPageIndex = 3
//            if HealtKitService.shared.isHealthServiceConnected {
//                firstButton.isHidden = true
//            } else {
//                firstButton.setupUI(title: "Connect Apple Health")
//                firstButton.isHidden = false
//                firstButton.addAction {
//                    vc.askForHealthKitPermission { (result) in
//                        switch result {
//                        case .success(_):
//                            Vibration.medium.vibrate()
//                            self.setFirstButtonHidden(to: true)
//                            self.finnishWalkthrough()
//                        case .failure(let error):
//                            self.setFirstButtonHidden(to: true)
//                            print(error.localizedDescription)
//                        }
//                    }
//                }
//            }
//
//            secondButton.setupUI(title: "Finnish walkthrough")
//            secondButton.addAction {
//                Vibration.medium.vibrate()
//                self.finnishWalkthrough()
//            }
//            backButton.addAction { self.navigate(.reverse) }
//        }
    }
    
    
    func setFirstButtonHidden(to hidden: Bool) {
        DispatchQueue.main.async {
            self.firstButton.isHidden = hidden
        }
    }
    
    func setSecondButtonHidden(to hidden: Bool) {
        DispatchQueue.main.async {
            self.secondButton.isHidden = hidden
        }
    }
    
}
