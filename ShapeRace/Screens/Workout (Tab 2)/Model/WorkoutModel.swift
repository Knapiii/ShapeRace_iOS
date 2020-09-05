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
    var coord: Coordinate?
    var workoutTime: Int?
    var bodyParts: [String] = []
    
    init() {}
    
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
    
    convenience init(withDoc: QueryDocumentSnapshot){
        self.init()
        if let timestamp = withDoc.get(CodingKeys.timestamp.rawValue) {
            self.timestamp = timestamp as? Date
        }
        if let checkOutDate = withDoc.get(CodingKeys.checkOutDate.rawValue) {
            self.checkOutDate = checkOutDate as? Date
        }
        if let checkInDate = withDoc.get(CodingKeys.checkInDate.rawValue) {
            self.checkInDate = checkInDate as? Date
        }
    }
}

internal struct Coordinate: Codable {
    let latitude: Double
    let longitude: Double
    
    func locationCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude,
                                      longitude: self.longitude)
    }
    
}
