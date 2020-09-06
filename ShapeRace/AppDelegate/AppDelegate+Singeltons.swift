//
//  AppDelegate+Singeltons.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-05.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import Foundation

extension AppDelegate {
    func fetchAllSingeltons() {
        fetchMyWorkouts()
    }
    
    private func fetchMyWorkouts() {
        print("Fetching my workouts...")
        DB.workout.fetchMyWorkouts { (result) in
            switch result {
            case .success(let workouts):
                print("Amount of workouts: ", workouts.count)
            case .failure(let error):
                print("fetchMyWorkouts: ", error)
            }
        }
        
    }
}
