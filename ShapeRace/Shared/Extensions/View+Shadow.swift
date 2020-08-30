//
//  View+Shadow.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-31.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

enum ShadowSides {
    case top, left, right, bottom, all
}

extension UIView {
    func setShadow(side: ShadowSides = .all) {
        self.clipsToBounds = false
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 1.0
        self.layer.shadowColor = SRColor.shadow.cgColor
        switch side {
            
        case .top:
            self.layer.shadowOffset = CGSize(width: 0, height: -5)
        case .left:
            self.layer.shadowOffset = CGSize(width: -5, height: 0)
        case .right:
            self.layer.shadowOffset = CGSize(width: 5, height: 0)
        case .bottom:
            self.layer.shadowOffset = CGSize(width: 0, height: 5)
        case .all:
            self.layer.shadowOffset = CGSize(width: 0, height: 0)
        }
    }
}
