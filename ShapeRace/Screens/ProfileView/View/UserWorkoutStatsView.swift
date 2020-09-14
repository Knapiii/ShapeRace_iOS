//
//  UserWorkoutStatsView.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-13.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

class UserWorkoutStatsView: UIView {

    var amountOfWorkouts: Int = 0 {
        didSet {
            amountOfWorkoutsView?.unit = amountOfWorkouts
        }
    }
    var totalWorkoutTime: Int = 0 {
        didSet {
            totalWorkoutsView?.unit = totalWorkoutTime
        }
    }
    
    var amountOfWorkoutsView: UserWorkoutStatView?
    var totalWorkoutsView: UserWorkoutStatView?
    
    let stackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.distribution = .fillEqually
        $0.spacing = 16
        $0.axis = .horizontal
        return $0
    }(UIStackView())
    
    init() {
        super.init(frame: .zero)
        config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config() {
        translatesAutoresizingMaskIntoConstraints = false
        amountOfWorkoutsView = UserWorkoutStatView(unitState: .amountOfWorkouts, unit: amountOfWorkouts)
        totalWorkoutsView = UserWorkoutStatView(unitState: .totalWorkoutTime, unit: totalWorkoutTime)
        
        stackView.addArrangedSubview(amountOfWorkoutsView!)
        stackView.addArrangedSubview(totalWorkoutsView!)
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 48)
        ])
        
    }

}
