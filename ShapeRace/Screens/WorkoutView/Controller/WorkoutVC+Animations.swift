//
//  WorkoutVC+Animations.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-01.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

extension WorkoutVC {
    
    func animateViewsAtStartOfWorkout() {
        self.startWorkoutButton.isEnabled = false
        startWorkoutButton.setTitle("End workout", for: .normal)
        topTimerTopConstraint?.constant = -12
        locationButtonTopConstraint?.constant = 16
        startWorkoutBottomConstraint?.constant = 16
        UIView.animate(withDuration: 0.2) {
            self.tabBarController?.tabBar.alpha = 0
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        } completion: { (succes) in
            self.startWorkoutButton.isEnabled = true
        }
    }
    
    func animateViewsAtEndOfWorkout() {
        self.startWorkoutButton.isEnabled = false
        startWorkoutButton.setTitle("Start workout", for: .normal)
        topTimerTopConstraint?.constant = -175
        locationButtonTopConstraint?.constant = 62
        startWorkoutBottomConstraint?.constant = -26
        UIView.animate(withDuration: 0.7) {
            self.tabBarController?.tabBar.alpha = 1
        } completion: { (succes) in
            self.topTimerView.timerSeconds = 0
            self.startWorkoutButton.isEnabled = true
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}
