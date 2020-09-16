//
//  TopTimerView.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-31.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit
protocol TopTimerViewDelegate {
    func cancelWorkout()
}

class TopTimerView: UIView {

    var timerSeconds = 0 {
        didSet {
            timerLabel.text = timerSeconds.secondsToTimeWithDotsInBetween(includeSeconds: true)
        }
    }
    let cancelWorkoutButton: UIButton = {
        $0.backgroundColor = .clear
        $0.setImage(UIImage(named: "X_Mark"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
        $0.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: -32, right: -32)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentVerticalAlignment = .top
        $0.contentHorizontalAlignment = .left
        return $0
    }(UIButton())
    
    private let timerLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "00:00"
        $0.font = .monospacedDigitSystemFont(ofSize: 66, weight: .bold)
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    
    var delegate: TopTimerViewDelegate?
    init() {
        super.init(frame: .zero)
        config()
        layer.cornerRadius = 12
        setShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func config() {
        backgroundColor = SRColor.cell
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(timerLabel)
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 160),
            timerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            timerLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            timerLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            timerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            timerLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
        ])
        
        addSubview(cancelWorkoutButton)
        NSLayoutConstraint.activate([
            cancelWorkoutButton.topAnchor.constraint(equalTo: timerLabel.topAnchor),
            cancelWorkoutButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            cancelWorkoutButton.heightAnchor.constraint(equalToConstant: 48),
            cancelWorkoutButton.widthAnchor.constraint(equalToConstant: 48),
        ])
        
        cancelWorkoutButton.addAction { [self] in
            delegate?.cancelWorkout()
        }
    }
    
}
