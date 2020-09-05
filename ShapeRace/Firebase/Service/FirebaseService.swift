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

struct FirebaseService {
    enum PrivateState: String {
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
