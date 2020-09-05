//
//  DB.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-23.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import Foundation

struct DB {
    static let auth = FBAuthenticationService.shared
    static let currentUser = CurrentUserDatabase.shared
    static let workout = WorkoutDatabase.shared

}
