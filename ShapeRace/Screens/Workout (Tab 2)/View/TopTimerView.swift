//
//  TopTimerView.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-31.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

class TopTimerView: UIView {

    let timerLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "00:00"
        $0.font = .systemFont(ofSize: 66, weight: .bold)
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    init() {
        super.init(frame: .zero)
        config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundedCorners(corners: [.bottomRight, .bottomLeft], radius: 12)
    }
    

    
    private func config() {
        backgroundColor = SRColor.cell
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(timerLabel)
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 160),
            timerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 14),
            timerLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            timerLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
        ])
        
    }
    
    
}
