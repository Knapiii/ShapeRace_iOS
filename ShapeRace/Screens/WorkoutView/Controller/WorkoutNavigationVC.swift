//
//  WorkoutNavigationVC.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-24.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import Foundation

class WorkoutNavigationVC: SRNavigationController {
    let workoutVC: WorkoutVC
    
    init() {
        self.workoutVC = WorkoutVC()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workoutVC.navigationController?.navigationBar.isTranslucent = true
        workoutVC.navigationController?.setNavigationBarHidden(true, animated: false)
        navigationBar.tintColor = SRColor.label
        pushViewController(workoutVC, animated: false)
    }
    
    
    
}
