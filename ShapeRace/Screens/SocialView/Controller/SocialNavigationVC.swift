//
//  SocialNavigationVC.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-18.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import Foundation


class SocialNavigationVC: SRNavigationController {
    let socialVC: SocialVC
    
    init() {
        self.socialVC = SocialVC()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        socialVC.navigationController?.navigationBar.isTranslucent = true
        navigationBar.tintColor = SRColor.label
        pushViewController(socialVC, animated: false)
    }
    
    
    
}
