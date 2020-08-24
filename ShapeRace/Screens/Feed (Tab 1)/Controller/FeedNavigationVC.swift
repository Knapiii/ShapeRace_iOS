//
//  FeedNavigationVC.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-24.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import Foundation

class FeedNavigationVC: SRNavigationController {
    let feedVC: FeedVC
        
    init() {
        self.feedVC = FeedVC()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = true
        pushViewController(feedVC, animated: false)
    }
    
}

