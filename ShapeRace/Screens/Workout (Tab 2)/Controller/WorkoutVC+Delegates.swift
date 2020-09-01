//
//  WorkoutVC+Delegates.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-01.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

extension WorkoutVC: MusclePartButtonDelegate {
    func isSelected(_ type: MusclePartButton.MuscleParts) {
        print("selected: ", type.rawValue)
    }
    
    func isUnselected(_ type: MusclePartButton.MuscleParts) {
        print("unselected: ", type.rawValue)
    }
    
}
