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

extension Array where Element: Equatable {
    
    mutating func remove(object: Element) {
        guard let index = firstIndex(of: object) else { return }
        remove(at: index)
    }
    
    mutating func replace(with object: Element) {
        guard let index = firstIndex(of: object) else { return }
        self[index] = object
    }

    mutating func removeDuplicates() {
        var result = [Element]()
        for value in self {
            if !result.contains(value) {
                result.append(value)
            }
        }
        self = result
    }
    
    func subtracting(_ array: Array<Element>) -> Array<Element> {
        self.filter { !array.contains($0) }
    }
    
}

extension Dictionary {
    subscript(i:Int) -> (key:Key,value:Value) {
        get {
            return self[index(startIndex, offsetBy: i)];
        }
    }
}

extension Array where Element == Double {
    var median: Double? {
        guard count > 0  else { return nil }
        let sortedArray = sorted()
        if count % 2 != 0 {
            return Double(sortedArray[count / 2])
        } else {
            return Double(sortedArray[count / 2] + sortedArray[count / 2 - 1]) / 2.0
        }
    }
}

extension BidirectionalCollection where Iterator.Element: Equatable {
    typealias Element = Self.Iterator.Element

    func after(_ item: Element, loop: Bool = false) -> Element? {
        if let itemIndex = self.firstIndex(of: item) {
            let lastItem: Bool = (index(after:itemIndex) == endIndex)
            if loop && lastItem {
                return self.first
            } else if lastItem {
                return nil
            } else {
                return self[index(after:itemIndex)]
            }
        }
        return nil
    }

    func before(_ item: Element, loop: Bool = false) -> Element? {
        if let itemIndex = self.firstIndex(of: item) {
            let firstItem: Bool = (itemIndex == startIndex)
            if loop && firstItem {
                return self.last
            } else if firstItem {
                return nil
            } else {
                return self[index(before:itemIndex)]
            }
        }
        return nil
    }
}
