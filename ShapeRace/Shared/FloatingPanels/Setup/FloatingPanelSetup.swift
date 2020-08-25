//
//  FloatingPanelSetup.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-22.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import Foundation
import FloatingPanel

enum TypeOfPanel {
    case isDefault
    
    func set(fpc: FloatingPanelController) {

    }
    
    func setFloatingPanelLayout() -> FloatingPanelLayout {
        switch self {
        case .isDefault:
            return DefaultFloatingPanelLayout()
        }
    }
}

extension FloatingPanelController {
    
    func remove() {
        self.willMove(toParent: nil)
        self.hide(animated: false) {
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
    
}

