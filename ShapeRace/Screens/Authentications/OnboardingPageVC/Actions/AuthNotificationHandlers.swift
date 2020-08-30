//
//  AuthNotificationHandlers.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-30.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit
import CoreLocation

extension AuthenticationOnBoardingVC {
    
    func locationNotificationHandler() {
        NotificationCenter.default.addObserver(forName: Notis.locationRequestUpdated.name, object: nil, queue: .main) { (notification) in
            if let status = notification.object as? CLAuthorizationStatus {
                switch status {
                case .notDetermined:
                    break
                case  .restricted, .denied:
                    Vibration.medium.vibrate()
                    self.firstButton.isHidden = true
                    self.secondButton.addAction {
                        self.finnishWalkthrough()
                    }
                case .authorizedWhenInUse, .authorizedAlways:
                    Vibration.medium.vibrate()
                @unknown default:
                    break
                }
            }
        }
    }
    
    func stopLocationNotificationHandler() {
        NotificationCenter.default.removeObserver(self, name: Notis.locationRequestUpdated.name, object: nil)
    }
    
    func notificationPermissionNotificationHandler() {
        NotificationCenter.default.addObserver(forName: Notis.notificationPermissionUpdated.name, object: nil, queue: .main) { (notification) in
            if let permission = notification.object as? Bool {
                if permission {
                    
                } else {
                    self.navigateForward()
                }
            }
        }
    }
    
    func stopNotificationPermissionNotificationHandler() {
        NotificationCenter.default.removeObserver(self, name: Notis.notificationPermissionUpdated.name, object: nil)
    }
    
    func appleHealthNotificationHandler() {
        NotificationCenter.default.addObserver(forName: Notis.appleHealthPermissionUpdated.name, object: nil, queue: .main) { (notification) in
            if let permission = notification.object as? Bool {
                if permission {
                    
                } else {
                    self.navigateForward()
                }
            }
        }
    }
    
    func stopAppleHealthNotificationHandler() {
        NotificationCenter.default.removeObserver(self, name: Notis.appleHealthPermissionUpdated.name, object: nil)
    }
    
}
