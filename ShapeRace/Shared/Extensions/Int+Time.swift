//
//  Int+Time.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-01.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

extension Int {
    func secondsToTimeWithDotsInBetween(includeSeconds: Bool = true) -> String {
        let hours = self / 3600
        let minutes = self / 60 % 60
        let seconds = self % 60
        
        if hours == 0 {
            return String(format:"%02i:%02i", minutes, seconds)
        }
        if includeSeconds {
            return String(format:"%2i:%02i:%02i", hours, minutes, seconds)
        }

        return String(format:"%2i:%02i", hours, minutes)
    }
}
