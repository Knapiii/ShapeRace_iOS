//
//  WorkoutVC.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-24.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

class WorkoutVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        view.backgroundColor = SRColor.background.withAlphaComponent(0.8)
    }
    
    func configureNavigation() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
}
