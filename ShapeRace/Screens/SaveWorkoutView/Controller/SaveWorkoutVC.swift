//
//  SaveWorkoutVC.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-07.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

class SaveWorkoutVC: UIViewController {
    
    let workoutTimeLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())

    var workout: WorkoutModel
    
    init(workout: WorkoutModel) {
        self.workout = workout
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SRColor.adaptiveBlue
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    

}
