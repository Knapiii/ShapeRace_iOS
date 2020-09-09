//
//  WorkoutVC+Animations.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-01.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

extension WorkoutVC {
    
    func animateViewsAtStartOfWorkout(completion: @escaping Completion) {
        self.startWorkoutButton.isEnabled = false
        startWorkoutButton.setTitle("End workout", for: .normal)
        topTimerTopConstraint?.constant = -12
        locationButtonTopConstraint?.constant = 16
        startWorkoutBottomConstraint?.constant = 16
        UIView.animate(withDuration: 0.2) {
            self.tabBarController?.tabBar.alpha = 0
        }
        UIView.animate(withDuration: 0.5) {
            self.scrollView.alpha = 1
            self.view.layoutIfNeeded()
        } completion: { (succes) in
            self.startWorkoutButton.isEnabled = true
            completion()
        }
    }
    
    func animateViewsAtEndOfWorkout(completion: @escaping Completion) {
        self.startWorkoutButton.isEnabled = false
        startWorkoutButton.setTitle("Start workout", for: .normal)
        topTimerTopConstraint?.constant = -175
        locationButtonTopConstraint?.constant = 62
        startWorkoutBottomConstraint?.constant = -26
        UIView.animate(withDuration: 0.5) {
            self.scrollView.alpha = 0
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.topTimerView.timerSeconds = 0
            self.startWorkoutButton.isEnabled = true
            UIView.animate(withDuration: 0.5) {
                self.tabBarController?.tabBar.alpha = 1
            } completion: { (succes) in
                completion()
            }
        }
        

    }
}
