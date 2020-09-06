//
//  TopTimerView.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-31.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

class TopTimerView: UIView {

    var timerSeconds = 0 {
        didSet {
            timerLabel.text = timerSeconds.secondsToTimeWithDotsInBetween(includeSeconds: true)
        }
    }
    
    private let timerLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "00:00"
        $0.font = .monospacedDigitSystemFont(ofSize: 66, weight: .bold)
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
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
        
    }
    
}
