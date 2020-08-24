//
//  FeedVC.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-24.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        view.backgroundColor = SRColor.background.withAlphaComponent(0.6)
    }
    
    func configureNavigation() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
}
