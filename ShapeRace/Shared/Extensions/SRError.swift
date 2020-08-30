//
//  SRError.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-23.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import Foundation

class SRError: Error {
    let error: String
    
    init(_ error: String) {
        self.error = error
    }
}
