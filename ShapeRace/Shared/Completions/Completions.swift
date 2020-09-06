//
//  Completions.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-23.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

typealias VoidCompletion = (Result<Void, Error>) -> ()
typealias UserCompletion = (Result<UserModel, Error>) -> ()
typealias WorkoutCompletion = (Result<WorkoutModel, Error>) -> ()
typealias WorkoutsCompletion = (Result<[WorkoutModel], Error>) -> ()

typealias BoolCompletion = (Result<Bool, Error>) -> ()
typealias Completion = (() -> ())
