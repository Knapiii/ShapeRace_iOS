//
//  WorkoutVC+Actions.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-30.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

extension WorkoutVC {
    
    func changeSceenOnUploadWorkoutSuccess() {
        guard let workout = workout else { return }
        let vc = SaveWorkoutVC(workout: workout)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func uploadWorkout() {
        ProgressHudService.shared.showSpinner()
        workout?.checkOutDate = Date()
        if let currentLoc = LocationManagerService.shared.currentLocation {
            workout?.getLocation(latitude: currentLoc.latitude, longitude: currentLoc.longitude)
        }
        workout?.workoutTime = WorkoutTimerService.shared.seconds
        guard let workout = workout else { return }
        if WorkoutTimerService.shared.seconds > 5 {
            DB.workout.uploadWorkout(workout: workout) { [weak self] (result) in
                guard let self = self else { return }
                switch result {
                case .success():
                    ProgressHudService.shared.success()
                    self.endWorkout()
                    self.changeSceenOnUploadWorkoutSuccess()
                case .failure(let error):
                    ProgressHudService.shared.error(error.localizedDescription)
                }
                self.workout = nil
            }
        } else {
            ProgressHudService.shared.error("Workout has to be atleast 5 seconds")
            endWorkout()
            self.workout = nil
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
