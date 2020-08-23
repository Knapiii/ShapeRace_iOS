//
//  UserModel.swift
//  Shape Race
//
//  Created by Kristoffer Knape on 2020-08-23.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import Foundation
import Firebase

class UserModel {
    var userId: String!
    var firstName: String!
    var lastName: String!
    var city: String!
    var memberSince: Date!
    var isPrivate: String = FirestoreService.PrivateState.isPrivate.rawValue
    var hasFinishedWalkthrough = false
    
    init() {}
    
    init(_ userId: String!, with dictionary: [String: Any]) {
        self.userId = userId
        if let firstName = dictionary[FirestoreService.DBStrings.User.email] as? String {
            self.firstName = firstName
        }
        if let lastName = dictionary[FirestoreService.DBStrings.User.lastName] as? String {
            self.lastName = lastName
        }
        if let hasFinishedWalkthrough = dictionary[FirestoreService.DBStrings.User.hasFinishedWalkthrough] as? Bool {
            self.hasFinishedWalkthrough = hasFinishedWalkthrough
        }
        if let isPrivate = dictionary[FirestoreService.DBStrings.User.isPrivate] as? String {
            self.isPrivate = isPrivate
        }
    }
    
    func convertToDict() -> [String: Any] {
        var dict: [String: Any] = [:]
        if let firstName = self.firstName {
            dict[FirestoreService.DBStrings.User.firstName] = firstName
        }
        if let lastName = self.lastName{
            dict[FirestoreService.DBStrings.User.lastName] = lastName
        }
        if let city = self.city {
            dict[FirestoreService.DBStrings.User.city] = city
        }
        if let memberSince = self.memberSince {
            dict[FirestoreService.DBStrings.User.memberSince] = memberSince
        }
        dict[FirestoreService.DBStrings.User.isPrivate] = self.isPrivate
        dict[FirestoreService.DBStrings.User.hasFinishedWalkthrough] = self.hasFinishedWalkthrough
        return dict
    }
    
    var displayNameAndLastNameIfAvailable: String {
        guard let firstName = self.firstName else { return "" }
        let lastName = self.lastName
        if let lastName = lastName {
            return "\(firstName) \(lastName)"
        } else {
            return "\(firstName)"
        }
    }
    
}
