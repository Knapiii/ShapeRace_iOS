//
//  MapBoxService.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-01.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import Foundation

class MapBoxService {
    enum MapStyle {
        case light, dark
        
        var url: URL? {
            switch self {
            case .light:
                return URL(string: "mapbox://styles/knapiii/ckejtdwea51s61apv30gmwvry")
            case .dark:
                return URL(string: "mapbox://styles/knapiii/ckejtfum10ckr19qvmpg6wepx")
            }
        }
    }
    
    static let shared = MapBoxService()

    
}
