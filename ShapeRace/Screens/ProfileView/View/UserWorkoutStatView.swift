//
//  UserWorkoutStatView.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-13.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

class UserWorkoutStatView: UIView {
    
    enum UnitState {
        case amountOfWorkouts, totalWorkoutTime
    }
    
    var unitState: UnitState
    
    var unit: Int {
        didSet {
            setTexts()
        }
    }
    
    let unitTitleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = SRColor.label
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    let unitLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.textColor = SRColor.label
        $0.textAlignment = .center
        return $0
    }(UILabel())

    init(unitState: UnitState, unit: Int) {
        self.unitState = unitState
        self.unit = unit
        super.init(frame: .zero)
        config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config() {
        setTexts()
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(unitLabel)
        NSLayoutConstraint.activate([
            unitLabel.topAnchor.constraint(equalTo: topAnchor),
            unitLabel.leftAnchor.constraint(equalTo: leftAnchor),
            unitLabel.rightAnchor.constraint(equalTo: rightAnchor),
        ])
        addSubview(unitTitleLabel)
        NSLayoutConstraint.activate([
            unitTitleLabel.topAnchor.constraint(equalTo: unitLabel.bottomAnchor),
            unitTitleLabel.leftAnchor.constraint(equalTo: leftAnchor),
            unitTitleLabel.rightAnchor.constraint(equalTo: rightAnchor),
        ])
    }
    
    func setTexts() {
        switch unitState {
        case .amountOfWorkouts:
            unitTitleLabel.text = "Workouts"
            unitLabel.text = "\(unit)"
        case .totalWorkoutTime:
            unitTitleLabel.text = "Workout time"
            unitLabel.text = unit.returnSinutesSecondsThenHours(showSecondsWithHours: true)
        }
    }

}
