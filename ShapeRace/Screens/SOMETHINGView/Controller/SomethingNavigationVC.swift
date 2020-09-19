//
//  SomethingNavigationVC.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-18.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import Foundation

class SomethingNavigationVC: SRNavigationController {
    let somethingVC: SomethingVC
    
    init() {
        self.somethingVC = SomethingVC()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        somethingVC.navigationController?.navigationBar.isTranslucent = true
        navigationBar.tintColor = SRColor.label
        pushViewController(somethingVC, animated: false)
    }
    
    
    
}
