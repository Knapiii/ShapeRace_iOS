//
//  AuthenticationNavigationVC.swift
//  Shape Race
//
//  Created by Kristoffer Knape on 2020-08-22.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//


import UIKit

class HomeNavigationViewController: SRNavigationController {
    let authenticationOnBoardingVC: AuthenticationOnBoardingVC
        
    
    init() {
        self.authenticationOnBoardingVC = AuthenticationOnBoardingVC()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = true
        pushViewController(authenticationOnBoardingVC, animated: false)
    }
    
}
