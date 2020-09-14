//
//  Completions.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-23.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit
import Mapbox

typealias VoidCompletion = (Result<Void, Error>) -> ()
typealias UserCompletion = (Result<UserModel, Error>) -> ()
typealias WorkoutCompletion = (Result<WorkoutModel, Error>) -> ()
typealias WorkoutsCompletion = (Result<[WorkoutModel], Error>) -> ()

typealias StringCompletion = (Result<String, Error>) -> ()
typealias BoolCompletion = (Result<Bool, Error>) -> ()
typealias Completion = (() -> ())
typealias MGLAnnotationsCompletion = (([MGLAnnotation]) -> ())
typealias GymLocationsCompletion = (([GymPlaceModel]) -> ())
typealias GymLocationCompletion = ((GymPlaceModel) -> ())

