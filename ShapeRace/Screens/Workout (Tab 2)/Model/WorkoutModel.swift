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
        if let coord = withDoc.get(CodingKeys.coord.rawValue) {
            self.coord = coord as? Coordinate
        }
    }
    
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
        if let coord = coord?.locationCoordinate {
            ref.setData( [WorkoutModel.CodingKeys.coord.rawValue: GeoPoint(latitude: coord.latitude, longitude: coord.longitude)], merge: true )
        }
    }
}

internal struct Coordinate: Codable {
    var latitude: Double?
    var longitude: Double?
    
    var locationCoordinate: CLLocationCoordinate2D? {
        guard let latitude = latitude, let longitude = longitude else { return nil }
        return CLLocationCoordinate2D(latitude: latitude,
                                      longitude: longitude)
    }
    
}
