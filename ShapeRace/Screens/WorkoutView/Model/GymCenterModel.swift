//
//  GymCenterModel.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-09.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import Foundation
import CoreLocation
import Mapbox

class GymPlaceModel: Equatable, ReflectedStringConvertible {
    static func == (lhs: GymPlaceModel, rhs: GymPlaceModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: String?
    var name: String?
    var address: String?
    var city: String?
    var coordinates: CLLocationCoordinate2D?
    var categories: [String]?
    
    init(id: String?, name: String? = nil, adress: String? = nil, city: String? = nil, coordinates: CLLocationCoordinate2D? = nil, categories: [String]? = nil) {
        self.id = id
        if let name = name {
            self.name = name
        }
        if let adress = adress {
            self.address = adress
        }
        if let city = city {
            self.city = city
        }
        if let coordinates = coordinates {
            self.coordinates = coordinates
        }
        if let categories = categories {
            self.categories = categories
        }
        
    }
    
    init(){}
    
}

extension GymPlaceModel {
    
    var convertToAnnotation: GymLocationAnnotation {
        let pointAnnotation = GymLocationAnnotation(gymlocation: self)
        return pointAnnotation
    }
    
}

extension Array where Element == GymPlaceModel {
    var convertToAnnotations: [GymLocationAnnotation] {
        let annotations = self.map({ result -> GymLocationAnnotation in
            let pointAnnotation = GymLocationAnnotation(gymlocation: result)
            return pointAnnotation
        })
        return annotations
    }
    
}


extension RangeReplaceableCollection where Element: Equatable {
    @discardableResult
    mutating func appendIfNotContains(_ element: Element) -> (appended: Bool, memberAfterAppend: Element) {
        if let index = firstIndex(of: element) {
            return (false, self[index])
        } else {
            append(element)
            return (true, element)
        }
    }
}
