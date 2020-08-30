//
//  WorkoutVC.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-24.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
    }
    
    func configureNavigation() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
}
