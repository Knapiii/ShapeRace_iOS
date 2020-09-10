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

class GymCenterModel: Equatable, ReflectedStringConvertible {
    static func == (lhs: GymCenterModel, rhs: GymCenterModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: String?
    var name: String?
    var adress: String?
    var city: String?
    var coordinates: CLLocationCoordinate2D?
    var categories: [String]?
    
    init(id: String?, name: String? = nil, adress: String? = nil, city: String? = nil, coordinates: CLLocationCoordinate2D? = nil, categories: [String]? = nil) {
        self.id = id
        if let name = name {
            self.name = name
        }
        if let adress = adress {
            self.adress = adress
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

extension GymCenterModel {
    
    var convertToAnnotation: MGLAnnotation {
        let pointAnnotation = MGLPointAnnotation()
        pointAnnotation.title = self.name
        pointAnnotation.subtitle = self.adress
        if let coordinates = self.coordinates {
            pointAnnotation.coordinate = coordinates
        }
        return pointAnnotation
    }
    
}

extension Array where Element == GymCenterModel {
    var convertToAnnotations: [MGLAnnotation] {
        let annotations = self.map({ result -> MGLAnnotation in
            let pointAnnotation = MGLPointAnnotation()
            pointAnnotation.title = result.name
            pointAnnotation.subtitle = result.adress
            if let coordinates = result.coordinates {
                pointAnnotation.coordinate = coordinates
            }
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
