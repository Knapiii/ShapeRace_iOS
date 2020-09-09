//
//  DB.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-23.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import Foundation
import CodableFirebase
import Firebase
import FirebaseFirestore

extension DocumentReference: DocumentReferenceType {}
extension GeoPoint: GeoPointType {}
extension FieldValue: FieldValueType {}
extension Timestamp: TimestampType {}

struct DB {
    static let auth = FBAuthenticationService.shared
    static let currentUser = CurrentUserDatabase.shared
    static let workout = WorkoutDatabase.shared

}
