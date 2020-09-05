//
//  WorkoutVC+Actions.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-30.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

extension WorkoutVC {
    
    func uploadWorkout() {
        let workout = WorkoutModel()
        workout.bodyParts = WorkoutService.shared.currentlySelectedMuscleGroups
        workout.checkInDate = Date()
        workout.checkOutDate = Date()
        workout.workoutTime = WorkoutTimerService.shared.seconds
        DB.workout.uploadWorkout(workout: workout) { (_) in}
    }
    
    func workoutButtonPressed() {
        Vibration.medium.vibrate()
        if screenState == .normal {
            animateViewsAtStartOfWorkout()
            startWorkout()
            screenState = .workout
        } else if screenState == .workout {
            animateViewsAtEndOfWorkout()
            endWorkout()
            screenState = .normal
        }
    }
    
    func startWorkout() {
        WorkoutTimerService.shared.startTimer()
        screenState = .workout

    }
    
    func endWorkout() {
        uploadWorkout()
        WorkoutService.shared.currentlySelectedMuscleGroups.removeAll()
        WorkoutTimerService.shared.stopTimer()
        screenState = .normal
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
