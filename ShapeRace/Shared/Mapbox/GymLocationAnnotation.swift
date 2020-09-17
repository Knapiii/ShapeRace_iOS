//
//  GymLocationAnnotation.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-12.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import Foundation
import Mapbox
import MapKit

class GymLocationAnnotation: MGLPointAnnotation {
    var gymLocation: GymPlaceModel
    
    init(gymlocation: GymPlaceModel) {
        self.gymLocation = gymlocation
        super.init()
        if let coordinate = gymlocation.coordinates {
            self.coordinate = coordinate
        }
        self.title = gymlocation.name
        self.subtitle = gymlocation.address
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
