//
//  DefaultFloatingPanelLayout.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-22.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import Foundation
import FloatingPanel

class DefaultFloatingPanelLayout: FloatingPanelLayout {
        
    public var initialPosition: FloatingPanelPosition {
        return .tip
    }
    
    public var supportedPositions: Set<FloatingPanelPosition> {
        return [.tip, .hidden]
    }
    
    public func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .tip:
            return 376
        case .hidden:
            return 0
        default:
            return nil
        }
    }
    
    var positionReference: FloatingPanelLayoutReference {
        return .fromSuperview
    }
}
