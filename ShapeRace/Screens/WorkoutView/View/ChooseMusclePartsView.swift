//
//  ChooseMusclePartsView.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-30.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

enum MuscleParts: String, Codable {
    case back, biceps, legs, chest, triceps, butt, core, shoulders
}

class ChooseMusclePartsView: UIView, MusclePartButtonDelegate {
    private let backButton = MusclePartButton(.back)
    private let bicepsButton = MusclePartButton(.biceps)
    private let legsButton = MusclePartButton(.legs)
    private let chestButton = MusclePartButton(.chest)
    private let tricepsButton = MusclePartButton(.triceps)
    private let coreButton = MusclePartButton(.core)
    private let shouldersButton = MusclePartButton(.shoulders)
    private let buttButton = MusclePartButton(.butt)
    var delegate: MusclePartButtonDelegate?
        
    enum Side {
        case left, right
    }
    
    var side: Side?
    
    init(side: Side) {
        self.side = side
        super.init(frame: .zero)
        config(side: side)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let mainStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fillEqually
        return $0
    }(UIStackView())
    
    private let leftStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.spacing = 8
        $0.distribution = .fillEqually
        return $0
    }(UIStackView())
    
    private let rightStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.spacing = 8
        $0.distribution = .fillEqually
        return $0
    }(UIStackView())
    
    func deselectAll() {
        for view in leftStackView.arrangedSubviews {
            if let view = view as? MusclePartButton {
                view.isActive = false
            }
        }
        for view in rightStackView.arrangedSubviews {
            if let view = view as? MusclePartButton {
                view.isActive = false
            }
        }
    }
    
    func setActive(workout: WorkoutModel) {
        guard let side = side else { return }
        let bodyparts = workout.bodyParts
        for bodypart in bodyparts {
            if side == .left {
                switch bodypart {
                case .back:
                    backButton.isActive = true
                case .biceps:
                    bicepsButton.isActive = true
                case .chest:
                    chestButton.isActive = true
                case .triceps:
                    tricepsButton.isActive = true
                case .butt, .legs, .core, .shoulders:
                    break
                }
            } else {
                switch bodypart {
                case .butt:
                    buttButton.isActive = true
                case .legs:
                    legsButton.isActive = true
                case .core:
                    coreButton.isActive = true
                case .shoulders:
                    shouldersButton.isActive = true
                case .back, .biceps, .chest, .triceps:
                    break
                }
            }
        }
    }
    
    private func config(side: Side) {
        translatesAutoresizingMaskIntoConstraints = false
        switch side {
        case .left:
            leftStackView.addArrangedSubview(backButton)
            leftStackView.addArrangedSubview(bicepsButton)
            rightStackView.addArrangedSubview(chestButton)
            rightStackView.addArrangedSubview(tricepsButton)
        case .right:
            leftStackView.addArrangedSubview(legsButton)
            leftStackView.addArrangedSubview(shouldersButton)
            rightStackView.addArrangedSubview(buttButton)
            rightStackView.addArrangedSubview(coreButton)
        }
        
        mainStackView.addArrangedSubview(leftStackView)
        mainStackView.addArrangedSubview(rightStackView)
        
        addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.leftAnchor.constraint(equalTo: leftAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainStackView.rightAnchor.constraint(equalTo: rightAnchor),
            widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 16 - 16),
        ])
        for view in leftStackView.arrangedSubviews {
            if let view = view as? MusclePartButton {
                view.delegate = self
            }
        }
        for view in rightStackView.arrangedSubviews {
            if let view = view as? MusclePartButton {
                view.delegate = self
            }
        }
    }

    func isSelected(_ type: MuscleParts) {
        delegate?.isSelected(type)
    }
    
    func isUnselected(_ type: MuscleParts) {
        delegate?.isUnselected(type)
    }
    
}

protocol MusclePartButtonDelegate {
    func isSelected(_ type: MuscleParts)
    func isUnselected(_ type: MuscleParts)
}

class MusclePartButton: UIButton {

    
    private var musclePart: MuscleParts
    var delegate: MusclePartButtonDelegate?
    var isActive = false {
        didSet {
            backgroundColor = isActive ? SRColor.adaptiveBlue : UIColor.white.withAlphaComponent(1)
            setTitleColor(isActive ? .white: SRColor.adaptiveBlue, for: .normal)
        }
    }
    init(_ musclePart: MuscleParts) {
        self.musclePart = musclePart
        super.init(frame: .zero)
        config()
        setShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config() {
        translatesAutoresizingMaskIntoConstraints = false
        setTitle(musclePart.rawValue.capitalizingFirstLetter, for: .normal)
        layer.cornerRadius = 12
        backgroundColor = UIColor.white.withAlphaComponent(1)
        setTitleColor(SRColor.reversedLabel, for: .normal)
        contentHorizontalAlignment = .center
        setTitleColor(isActive ? .white : SRColor.adaptiveBlue, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        addAction { [self] in
            Vibration.medium.vibrate()
            self.isActive.toggle()
            isActive ? delegate?.isSelected(musclePart) : delegate?.isUnselected(musclePart)
        }
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    override open var isHighlighted: Bool {
        didSet {
            if backgroundColor == .clear {
                setTitleColor(isHighlighted ? titleLabel?.textColor.withAlphaComponent(0.4) : titleLabel?.textColor.withAlphaComponent(1), for: .normal)
            } else {
                backgroundColor = isHighlighted ? backgroundColor?.withAlphaComponent(0.8) : isActive ? backgroundColor?.withAlphaComponent(1) : backgroundColor?.withAlphaComponent(1)
            }
        }
    }

}
