//
//  Print.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-05.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import Foundation

public protocol ReflectedStringConvertible : CustomStringConvertible { }

extension ReflectedStringConvertible {
  public var description: String {
    let mirror = Mirror(reflecting: self)
    
    var str = "\(mirror.subjectType)("
    var first = true
    for (label, value) in mirror.children {
      if let label = label {
        if first {
          first = false
        } else {
          str += ", "
        }
        str += label
        str += ": "
        str += "\(value)"
      }
    }
    str += ")"
    
    return str
  }
}
