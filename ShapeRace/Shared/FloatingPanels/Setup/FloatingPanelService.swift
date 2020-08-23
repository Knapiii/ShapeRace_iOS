//
//  FloatingPanelService.swift
//  Shape Race
//
//  Created by Kristoffer Knape on 2020-08-22.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import Foundation
import FloatingPanel

class FloatingPanelService {
    static let shared = FloatingPanelService()
    let typeOfPanel = TypeOfPanel.self
    
    func setType(fpc: FloatingPanelController!, type: TypeOfPanel, vc: UIViewController) {
        type.set(fpc: fpc)
        fpc.delegate = vc as? FloatingPanelControllerDelegate
    }
        
    func setupPanel(with vc: UIViewController, fpc: FloatingPanelController!, type: TypeOfPanel) {
        type.set(fpc: fpc)
        fpc.delegate = vc as? FloatingPanelControllerDelegate

        fpc.view.frame = vc.view.bounds
        vc.view.addSubview(fpc.view)
        vc.addChild(fpc)
        fpc.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
          fpc.view.topAnchor.constraint(equalTo: vc.view.topAnchor),
          fpc.view.leftAnchor.constraint(equalTo: vc.view.leftAnchor),
          fpc.view.rightAnchor.constraint(equalTo: vc.view.rightAnchor),
          fpc.view.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor),
        ])
    }
    
}

