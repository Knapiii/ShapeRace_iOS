//
//  String+Capitalize.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-30.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

extension String {
    var capitalizingFirstLetter: String {
        return prefix(1).capitalized + dropFirst()
    }

}
