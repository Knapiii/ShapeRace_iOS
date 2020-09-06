//
//  UIView+Anchor.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-05.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

extension UIView {
    
    func ratioOneToOne(to: UIView? = nil) {
        if let to = to {
            self.addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: to, attribute: .width, multiplier: 1, constant: 0))
        } else {
            self.addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0))
        }
        
    }
    
    func anchorAllSides(to view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.topAnchor),
            self.leftAnchor.constraint(equalTo: view.leftAnchor),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
        
        
    }
    
}
