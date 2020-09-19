//
//  FirestoreService.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-23.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import CoreLocation

struct FirestoreService {
    enum PrivateState: String, Codable {
        case isPublic, isPublicForFriends, isPrivate
    }
    
    struct Ref {
        struct User {
            static let shared = User()
            let REF_USER = "users"
            
            var currentUserId: String? {
                return Auth.auth().currentUser?.uid
            }
            
            var users: CollectionReference {
                return Firestore.firestore().collection(REF_USER)
            }
            
            func specific(user uid: String) -> DocumentReference {
                return users.document(uid)
            }
            
        }
        
        struct Workout {
            static let shared = Workout()
            let REF_WORKUTS = "workouts"
            
            var workouts: CollectionReference {
                return Firestore.firestore().collection(REF_WORKUTS)
            }
            
            func specific(workoutId: String) -> DocumentReference {
                return workouts.document(workoutId)
            }
            
            func specific(userId: String) -> Query {
                return workouts.whereField("userId", isEqualTo: userId)
            }
        }
        
        struct Friends {
            static let shared = Friends()
            private let REF_FRIENDS = "firends"
            var friends: CollectionReference{
                return Firestore.firestore().collection(REF_FRIENDS)
            }
            
            func specific(friendsId id: String) -> DocumentReference {
                return friends.document(id)
            }
            
        }
        
        //TODO: Can be removed. use the coding key rawvalue instead
        
        
    }
    struct DBStrings {
        struct User {
            static let userId = "userId"
            static let email = "email"
            static let memberSince = "memberSince"
            static let firstName = "firstName"
            static let lastName = "lastName"
            static let city = "city"
            static let isPrivate = "isPrivate"
            static let hasFinishedWalkthrough = "hasFinishedWalkthrough"
        }
    }
}

extension GeoPoint {
    var toCLLocation2D: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}

extension CLLocationCoordinate2D {
    var toGeoPoint: GeoPoint {
        return GeoPoint(latitude: self.latitude, longitude: self.longitude)
    }
}
