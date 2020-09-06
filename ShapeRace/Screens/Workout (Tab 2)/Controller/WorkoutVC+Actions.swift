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
        DB.workout.uploadWorkout(workout: workout) { (_) in}
        print(workout.coord)
        workout = WorkoutModel()
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
        workout.checkInDate = Date()
        WorkoutTimerService.shared.startTimer()
        screenState = .workout
    }
    
    func endWorkout() {
        uploadWorkout()
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
