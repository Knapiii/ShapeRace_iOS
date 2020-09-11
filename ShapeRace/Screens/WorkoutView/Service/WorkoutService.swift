//
//  WorkoutService.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-01.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit
import CoreLocation
import Mapbox
import Turf

class WorkoutService {
    
    static let shared = WorkoutService()
    
    func observeClose(gymLocations: [GymLocationModel], toUserLocation: CLLocationCoordinate2D, completion: GymLocationsCompletion) {
        let distanceLimit: CLLocationDistance = 700
        
        let gymLocationsWithinDistanceLimit: [GymLocationModel] = gymLocations.compactMap { (gymlocation) -> GymLocationModel? in
            if let locationCoordinate = gymlocation.coordinates {
                let distanceToLocation = toUserLocation.distance(to: locationCoordinate)
                if distanceToLocation < distanceLimit {
                    return gymlocation
                }
            }
            return nil
        }
        let locationsWithCoordinates = gymLocationsWithinDistanceLimit.filter({ $0.coordinates != nil })

        let sortedGymLocations = locationsWithCoordinates.sorted { toUserLocation.distance(to: $0.coordinates!) < toUserLocation.distance(to: $1.coordinates!) }
        completion(sortedGymLocations)

    }
    
}
