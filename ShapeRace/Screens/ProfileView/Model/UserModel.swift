//
//  UserModel.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-23.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class UserModel: Identifiable, Codable, ReflectedStringConvertible  {
    @DocumentID var userId: String!
    var email: String?
    var firstName: String!
    var lastName: String?
    var city: String?
    var memberSince: Date!
    var isPrivate: FirestoreService.PrivateState?
    var hasFinishedWalkthrough = false
    
    init() {}
    
    enum CodingKeys: String, CodingKey {
        case userId
        case email
        case firstName
        case lastName
        case city
        case memberSince
        case isPrivate
        case hasFinishedWalkthrough
    }
    
    convenience init(withDoc: QueryDocumentSnapshot){
        self.init()
        if let memberSince = withDoc.get(CodingKeys.memberSince.rawValue) {
            self.memberSince = memberSince as? Date
        }
    }
    
//    init(_ userId: String!, with dictionary: [String: Any]) {
//        self.userId = userId
//        if let firstName = dictionary[FirebaseService.DBStrings.User.email] as? String {
//            self.firstName = firstName
//        }
//        if let lastName = dictionary[FirebaseService.DBStrings.User.lastName] as? String {
//            self.lastName = lastName
//        }
//        if let hasFinishedWalkthrough = dictionary[FirebaseService.DBStrings.User.hasFinishedWalkthrough] as? Bool {
//            self.hasFinishedWalkthrough = hasFinishedWalkthrough
//        }
//        if let isPrivate = dictionary[FirebaseService.DBStrings.User.isPrivate] as? String {
//            self.isPrivate = isPrivate
//        }
//    }
    
//    func convertToDict() -> [String: Any] {
//        var dict: [String: Any] = [:]
//        if let firstName = self.firstName {
//            dict[FirebaseService.DBStrings.User.firstName] = firstName
//        }
//        if let lastName = self.lastName{
//            dict[FirebaseService.DBStrings.User.lastName] = lastName
//        }
//        if let city = self.city {
//            dict[FirebaseService.DBStrings.User.city] = city
//        }
//        if let memberSince = self.memberSince {
//            dict[FirebaseService.DBStrings.User.memberSince] = memberSince
//        }
//        dict[FirebaseService.DBStrings.User.isPrivate] = self.isPrivate
//        dict[FirebaseService.DBStrings.User.hasFinishedWalkthrough] = self.hasFinishedWalkthrough
//        return dict
//    }
    
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
