//
//  SaveWorkoutVC.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-07.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

class SaveWorkoutVC: UIViewController {
    
    let timerLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = SRColor.label
        $0.font = .monospacedDigitSystemFont(ofSize: 66, weight: .bold)
        $0.textAlignment = .center
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
        configTimeLabel()
        setupWorkout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func configTimeLabel() {
        view.addSubview(timerLabel)
        NSLayoutConstraint.activate([
            timerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    private func setupWorkout() {
        self.timerLabel.text = self.workout.workoutTime?.secondsToTimeWithDotsInBetween(includeSeconds: true)
    }
    

}
