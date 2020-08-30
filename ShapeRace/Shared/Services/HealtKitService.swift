//
//  HealtKitService.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-30.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import Foundation
import HealthKit

class HealtKitService {
    static let shared = HealtKitService()
    
    var healthStore: HKHealthStore?
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }
    
    var isHealthServiceConnected: Bool {
        let workoutType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime)
        guard let healthStore = healthStore, let type = workoutType else {
            return false }
        if healthStore.authorizationStatus(for: type) == .sharingAuthorized {
            return true
        } else if healthStore.authorizationStatus(for: type) == .sharingDenied {
            return false
        } else if healthStore.authorizationStatus(for: type) == .notDetermined {
            return false
        } else {
            return false
        }
        
    }
    
    func requestAuthorization(completion: @escaping BoolCompletion) {
        let workoutType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime)

        guard let healthStore = healthStore, let type = workoutType else { return }
        healthStore.requestAuthorization(toShare: [], read: [type]) { (success, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(success))
        }
        
    }
    
}
