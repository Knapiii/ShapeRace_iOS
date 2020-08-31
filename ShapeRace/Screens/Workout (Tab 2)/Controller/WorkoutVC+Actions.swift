//
//  WorkoutVC+Actions.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-30.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

extension WorkoutVC {
    
    func startWorkout() {
        Vibration.medium.vibrate()
        if startWorkoutButton.buttonState == .start {
            animateViewsAtStartOfWorkout()
        } else if startWorkoutButton.buttonState == .end {
            animateViewsAtEndOfWorkout()
        }
    }
    
    func animateViewsAtStartOfWorkout() {
        startWorkoutButton.setTitle("End workout", for: .normal)
        topTimerTopConstraint?.constant = 0
        locationButtonTopConstraint?.constant = 16
        startWorkoutBottomConstraint?.constant = 16
        UIView.animate(withDuration: 0.2) {
            self.tabBarController?.tabBar.alpha = 0
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        startWorkoutButton.buttonState = .end
    }
    
    func animateViewsAtEndOfWorkout() {
        startWorkoutButton.setTitle("Start workout", for: .normal)
        topTimerTopConstraint?.constant = -160
        locationButtonTopConstraint?.constant = 42
        startWorkoutBottomConstraint?.constant = -26
        UIView.animate(withDuration: 0.7) {
            self.tabBarController?.tabBar.alpha = 1
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        startWorkoutButton.buttonState = .start
    }
    
    func showCurrentLocation() {
        if LocationManagerService.shared.isUserSharingLocation == .authorized {
            if let location = LocationManagerService.shared.locationManager.location?.coordinate {
                mapView.setCenter(location, zoomLevel: 14, animated: true)
            }
            
        } else if LocationManagerService.shared.isUserSharingLocation == .notDetermined {
            LocationManagerService.shared.askUserForLocationRequest()
        } else {
            
        }
        
    }
    
}
