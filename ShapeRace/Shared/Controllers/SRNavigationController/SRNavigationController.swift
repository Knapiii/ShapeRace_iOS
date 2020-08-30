//
//  SRNavigationController.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-22.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

class SRNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barTintColor = .systemGray6
        navigationBar.backgroundColor = .systemGray6
        navigationBar.isTranslucent = false
    }


}
