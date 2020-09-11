//
//  WorkoutVC+Actions.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-30.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

extension WorkoutVC {
    
    func changeSceenToNearestGymListView(_ workout: WorkoutModel, _ closestGymLocations: [GymLocationModel]) {
        let vc = ChooseNearestGymLocationVC(workout: workout, closestGymLocations: closestGymLocations)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func uploadWorkout() {
        var canCheckout = false
        var closestGyms: [GymLocationModel]?
        guard let currentLoc = LocationManagerService.shared.currentLocation, let startLocation = startLocation else { return }
        
        
        WorkoutService.shared.observeClose(gymLocations: gymCenters, toUserLocation: currentLoc) { (nearestGymLocations) in
            guard startLocation.distance(to: currentLoc) < 200 else {
                ProgressHudService.shared.error("Go back to where yo checked in")
                canCheckout = false
                return
            }
            
            guard !nearestGymLocations.isEmpty else {
                ProgressHudService.shared.error("You have to be close to the gym to save your workout")
                canCheckout = false
                return
            }
            
            closestGyms = nearestGymLocations
            canCheckout = true
            
        }
        guard canCheckout else { return }
        
        endLocation = currentLoc
        workout?.checkOutDate = Date()
        if let endLocation = endLocation {
            workout?.getLocation(latitude: endLocation.latitude, longitude: endLocation.longitude)
        }
        workout?.workoutTime = WorkoutTimerService.shared.seconds
        
        
        guard let workout = workout else {
            endWorkout()
            return
        }
        guard WorkoutTimerService.shared.seconds >= 5 else {
            ProgressHudService.shared.error("Workout has to be atleast 5 seconds")
            return
        }
        if let closestGyms = closestGyms, !closestGyms.isEmpty {
            changeSceenToNearestGymListView(workout, closestGyms)
            endWorkout()
        } else {
            ProgressHudService.shared.error("You have to be at a gym to finish your workout")
        }
        
    }
    
    func workoutButtonPressed() {
        Vibration.medium.vibrate()
        if screenState == .normal {
            startWorkout()
        } else if screenState == .workout {
            uploadWorkout()
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
            ProgressHudService.shared.error("You have to be at a gym to start your workout")
            return
        }
        animateViewsAtStartOfWorkout(completion: {})
        workout = WorkoutModel()
        workout?.checkInDate = Date()
        WorkoutTimerService.shared.startTimer()
        screenState = .workout
    }
    
    func endWorkout() {
        animateViewsAtEndOfWorkout(completion: { [self] in
            self.chooseMusclePartsLeftView.deselectAll()
            self.chooseMusclePartsRightView.deselectAll()
            WorkoutTimerService.shared.stopTimer()
        })
        screenState = .normal
        workout = nil
        topTimerView.timerSeconds = 0
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
