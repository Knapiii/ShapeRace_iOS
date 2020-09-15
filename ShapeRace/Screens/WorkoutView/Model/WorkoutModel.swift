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
    var userName: String?
    var timestamp: Date!
    var checkInDate: Date?
    var checkOutDate: Date?
    private var coord: GeoPoint?
    var workoutTime: Int?
    var bodyParts: [MuscleParts] = []
    var likedBy: [String] = []
    
    var gymAddress: String?
    var gymName: String?
    
    private var gymCoord: GeoPoint?
    
    var isLiked: Bool {
        get {
            guard let user = DB.currentUser.user else { return false }
            return likedBy.contains(user.userId)
        }
    }

    var coordinate: CLLocationCoordinate2D? {
        get {
            return coord?.toCLLocation2D
        }
        set {
            if let coordinate = newValue {
                self.coord = GeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
            }
        }
    }

    var gymCoordinate: CLLocationCoordinate2D? {
        get {
            return gymCoord?.toCLLocation2D
        }
        set {
            if let coordinate = newValue {
                self.gymCoord = GeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
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
    
    func toggleLike() {
        guard let user = DB.currentUser.user else { return }
        DB.workout.toggleLiked(self)
    
        if likedBy.contains(user.userId) {
            likedBy.remove(object: user.userId)
        } else {
            likedBy.append(user.userId)
        }
        
        NotificationCenter.default.post(name: Notis.toggleRouteLikes.name, object: ["workoutId": workoutId, "likedBy": likedBy])
    }
    
}

extension WorkoutModel {
    enum CodingKeys: String, CodingKey {
        case workoutId
        case userId
        case userName
        case timestamp
        case checkInDate
        case checkOutDate
        case coord
        case workoutTime
        case bodyParts
        case gymAddress
        case gymName
        case gymCoord
        case likedBy
    }
}
