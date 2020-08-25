//
//  FirestoreService.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-23.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import Foundation
import Firebase


struct FirestoreService {
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
