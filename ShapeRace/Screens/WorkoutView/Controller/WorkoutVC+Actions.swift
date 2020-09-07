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
        workout.checkOutDate = Date()
        workout.coord = Coordinate(latitude: LocationManagerService.shared.currentLocation?.latitude, longitude: LocationManagerService.shared.currentLocation?.longitude)
        workout.workoutTime = WorkoutTimerService.shared.seconds
        if WorkoutTimerService.shared.seconds > 5 {
            DB.workout.uploadWorkout(workout: workout) { (_) in}
        } else {
            ProgressHudService.shared.error("Workout has to be atleast 5 seconds")
            endWorkout()
        }
        workout = WorkoutModel()
    }
    
    func workoutButtonPressed() {
        Vibration.medium.vibrate()
        if screenState == .normal {
            startWorkout()
        } else if screenState == .workout {
            uploadWorkout()
            endWorkout()
        }
    }
    
    func startWorkout() {
        animateViewsAtStartOfWorkout()
        workout.checkInDate = Date()
        WorkoutTimerService.shared.startTimer()
        screenState = .workout
    }
    
    func endWorkout() {
        animateViewsAtEndOfWorkout()
        chooseMusclePartsLeftView.deselectAll()
        chooseMusclePartsRightView.deselectAll()
        WorkoutTimerService.shared.stopTimer()
        screenState = .normal
    }
    
    func showCurrentLocationButtonPressed() {
        showCurrentLocationButton.addAction {
            Vibration.medium.vibrate()
            self.showCurrentLocation()
        }
    }

    func showCurrentLocation() {
        if LocationManagerService.shared.isUserSharingLocation == .authorized {
            if let location = LocationManagerService.shared.currentLocation {
                mapView.setCenter(location, zoomLevel: 14, animated: true)
            }
            
        } else if LocationManagerService.shared.isUserSharingLocation == .notDetermined {
            LocationManagerService.shared.askUserForLocationRequest()
        } else {
            
        }
        
    }
    
}
