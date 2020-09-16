//
//  WorkoutVC+Actions.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-30.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

extension WorkoutVC {
    
    func changeSceeneToSaveWorkoutView(_ workout: WorkoutModel, _ nearestGymLocations: [GymPlaceModel]) {
        let vc = SaveWorkoutVC(workout: workout, nearestGymLocations: nearestGymLocations)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
        
    func uploadWorkout() {
        var canCheckout = false
        var nearestGyms: [GymPlaceModel]?
        guard let currentLoc = LocationManagerService.shared.currentLocation, let startLocation = startLocation else { return }
    
        WorkoutService.shared.observeClose(gymLocations: gymCenters, toUserLocation: currentLoc) { (nearestGymLocations) in
            guard startLocation.distance(to: currentLoc) < 200 else {
                AlertService.shared.showError(text: "Go back to where yo checked in", autoHide: true)

                canCheckout = false
                return
            }
            
            guard !nearestGymLocations.isEmpty else {
                AlertService.shared.showError(text: "You have to be close to the gym to save your workout", autoHide: true)

                canCheckout = false
                return
            }
            
            nearestGyms = nearestGymLocations
            canCheckout = true
            
        }
        guard canCheckout else { return }
        
        endLocation = currentLoc
        workout?.checkOutDate = Date()
        if let endLocation = endLocation {
            workout?.coordinate = endLocation
            
        }
        workout?.workoutTime = WorkoutTimerService.shared.seconds
        
        
        guard let workout = workout else {
            endWorkout()
            return
        }
        guard WorkoutTimerService.shared.seconds >= 5 else {
            AlertService.shared.showError(text: "Workout has to be atleast 5 seconds", autoHide: true)
            return
        }
        if let nearestGyms = nearestGyms, !nearestGyms.isEmpty {
            changeSceeneToSaveWorkoutView(workout, nearestGyms)
            endWorkout()
        } else {
            AlertService.shared.showError(text: "You have to be at a gym to finish your workout", autoHide: true)
        }
        
    }
    
    func startWorkoutButtonPressed() {
        Vibration.medium.vibrate()
        if screenState == .normal {
            startWorkout()
        } else if screenState == .workout {
            uploadWorkout()
        }
    }
    
    func cancelWorkoutButtonPressed() {
        Vibration.medium.vibrate()
        if WorkoutTimerService.shared.isRunning {
            WorkoutTimerService.shared.pauseTimer()
            pauseWorkoutButton.setupUI(title: "Resume workout")
        } else {
            WorkoutTimerService.shared.resumeTimer()
            pauseWorkoutButton.setupUI(title: "Pause workout")
        }
        
    }
    
    func askToCancelWorkout() {
        WorkoutTimerService.shared.pauseTimer()
        AlertService.shared.showAlert(title: "You are about to cancel your workout", text: "Are you sure you want to continue?", hideAuto: false,amountOfButtonsMax2: 2, button1Text: "Yes", button2Text: "No", button1Completion: {
            self.endWorkout()
        }) {
            WorkoutTimerService.shared.resumeTimer()
        }
    }
    
    func startWorkout() {
        var canCheckIn = false
        if let currentLoc = LocationManagerService.shared.currentLocation {
            WorkoutService.shared.observeClose(gymLocations: gymCenters, toUserLocation: currentLoc) { (nearestGymLocations) in
                canCheckIn = !nearestGymLocations.isEmpty
            }
            if canCheckIn {
                startLocation = currentLoc
            }
        }
        guard canCheckIn else {
            AlertService.shared.showError(text: "You have to be at a gym to start your workout", autoHide: true)
            return
        }
        startWorkoutAnimate(completion: {})
        workout = WorkoutModel()
        workout?.checkInDate = Date()
        WorkoutTimerService.shared.startTimer()
        screenState = .workout
    }
    
    func endWorkout() {
        endWorkoutAnimate(completion: { [self] in
            self.chooseMusclePartsLeftView.deselectAll()
            self.chooseMusclePartsRightView.deselectAll()
            WorkoutTimerService.shared.stopTimer()
            topTimerView.timerSeconds = 0
        })
        screenState = .normal
        workout = nil
    }
    
    func recieveNearestGymsOnMap() {
        MapBoxService.shared.forwardGeoCodingGymCategory { (gymCenters) in
            for gymCenter in gymCenters {
                self.gymCenters.appendIfNotContains(gymCenter)
                DispatchQueue.main.async {
                    self.mapView.addAnnotation(gymCenter.convertToAnnotation)
                }
            }
        }
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
                recieveNearestGymsOnMap()
            }
            
        } else if LocationManagerService.shared.isUserSharingLocation == .notDetermined {
            LocationManagerService.shared.askUserForLocationRequest()
        } else {
            
        }
    }
    
}
