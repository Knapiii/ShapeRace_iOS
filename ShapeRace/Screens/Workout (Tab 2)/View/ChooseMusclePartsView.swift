//
//  ChooseMusclePartsView.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-30.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

class ChooseMusclePartsView: UIView {
    let backButton = MusclePartButton(.back)
    let bicepsButton = MusclePartButton(.biceps)
    let legsButton = MusclePartButton(.legs)
    let chestButton = MusclePartButton(.chest)
    let tricepsButton = MusclePartButton(.triceps)
    let coreButton = MusclePartButton(.core)
    let shouldersButton = MusclePartButton(.shoulders)
    let buttButton = MusclePartButton(.butt)


    init() {
        super.init(frame: .zero)
        config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let mainStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fillEqually
        return $0
    }(UIStackView())
    
    let leftStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.spacing = 8
        $0.distribution = .fillEqually
        return $0
    }(UIStackView())
    
    let rightStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.spacing = 8
        $0.distribution = .fillEqually
        return $0
    }(UIStackView())
    
    
    func config() {
        translatesAutoresizingMaskIntoConstraints = false
        leftStackView.addArrangedSubview(backButton)
        leftStackView.addArrangedSubview(bicepsButton)
//        leftStackView.addArrangedSubview(legsButton)
//        leftStackView.addArrangedSubview(shouldersButton)
        
        rightStackView.addArrangedSubview(chestButton)
        rightStackView.addArrangedSubview(tricepsButton)
//        rightStackView.addArrangedSubview(buttButton)
//        rightStackView.addArrangedSubview(coreButton)
        
        mainStackView.addArrangedSubview(leftStackView)
        mainStackView.addArrangedSubview(rightStackView)
        
        addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.leftAnchor.constraint(equalTo: leftAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainStackView.rightAnchor.constraint(equalTo: rightAnchor),
        ])
    }

}

class MusclePartButton: UIButton {
    enum MuscleParts: String {
        case back, biceps, legs, chest, triceps, butt, core, shoulders
    }
    
    var musclePart: MuscleParts
    
    var isActive = false {
        didSet {
            backgroundColor = isActive ? SRColor.adaptiveBlue : UIColor.white.withAlphaComponent(0.8)
            setTitleColor(isActive ? .white: SRColor.adaptiveBlue, for: .normal)
            if traitCollection.userInterfaceStyle == .dark {
                layer.borderWidth = 0
            } else {
                layer.borderColor = SRColor.darkBlue.cgColor
                layer.borderWidth = isActive ? 0 : 2
            }
        }
    }
    init(_ musclePart: MuscleParts) {
        self.musclePart = musclePart
        super.init(frame: .zero)
        config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config() {
        translatesAutoresizingMaskIntoConstraints = false
        setTitle(musclePart.rawValue.capitalizingFirstLetter, for: .normal)
        layer.cornerRadius = 12
        if traitCollection.userInterfaceStyle == .dark {
            layer.borderWidth = 0
        } else {
            layer.borderColor = SRColor.darkBlue.cgColor
            layer.borderWidth = 2
        }
        backgroundColor = UIColor.white.withAlphaComponent(0.8)
        setTitleColor(SRColor.reversedLabel, for: .normal)
        contentHorizontalAlignment = .center
        setTitleColor(isActive ? .white : SRColor.adaptiveBlue, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        addAction {
            Vibration.medium.vibrate()
            self.isActive.toggle()
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
                backgroundColor = isHighlighted ? backgroundColor?.withAlphaComponent(0.8) : isActive ? backgroundColor?.withAlphaComponent(1) : backgroundColor?.withAlphaComponent(0.8)
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                if traitCollection.userInterfaceStyle == .dark {
                    layer.borderWidth = 0
                } else {
                    layer.borderColor = SRColor.darkBlue.cgColor
                    layer.borderWidth = 2
                }
            }
        }
    }

}
