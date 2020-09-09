//
//  WorkoutModel.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-05.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class WorkoutModel: Identifiable, Codable, ReflectedStringConvertible {
    @DocumentID var workoutId: String!
    var userId: String!
    var timestamp: Date!
    var checkInDate: Date?
    var checkOutDate: Date?
    var coord: GeoPoint?
    var workoutTime: Int?
    var bodyParts: [String] = []
    
    var coordinate: CLLocationCoordinate2D? {
        didSet {
            if let coordinate = coordinate {
                self.getLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            }
        }
    }
    
    init() {}
        
    func changeValuesToFirebaseCodable(ref: DocumentReference) {
        if let checkInDate = checkInDate {
            ref.setData( [WorkoutModel.CodingKeys.checkInDate.rawValue: Timestamp(date: checkInDate)], merge: true )
        }
        if let checkOutDate = checkOutDate {
            ref.setData( [WorkoutModel.CodingKeys.checkOutDate.rawValue: Timestamp(date: checkOutDate)], merge: true )
        }
        if let timestamp = timestamp {
            ref.setData( [WorkoutModel.CodingKeys.timestamp.rawValue: Timestamp(date: timestamp)], merge: true )
        }
    }
    
    func getLocation(latitude: Double, longitude: Double) {
        self.coord = GeoPoint(latitude: latitude, longitude: longitude)
    }
}

extension WorkoutModel {
    enum CodingKeys: String, CodingKey {
        case workoutId
        case userId
        case timestamp
        case checkInDate
        case checkOutDate
        case coord
        case workoutTime
        case bodyParts
    }
}
