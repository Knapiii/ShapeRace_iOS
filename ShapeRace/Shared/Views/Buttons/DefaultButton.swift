//
//  SRDefaultButton.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-22.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

class DefaultButton: UIButton {
        
    override open var isHighlighted: Bool {
        didSet {
            if backgroundColor == .clear {
                setTitleColor(isHighlighted ? titleLabel?.textColor.withAlphaComponent(0.4) : titleLabel?.textColor.withAlphaComponent(1), for: .normal)
            } else {
                backgroundColor = isHighlighted ? backgroundColor?.withAlphaComponent(0.8) : backgroundColor?.withAlphaComponent(1)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    convenience init(title: String?, titleColor: UIColor? = .label, bgColor: UIColor? = .darkGray, borderColor: UIColor? = nil) {
        self.init(type: .system)
        setupUI(title: title, titleColor: titleColor, bgColor: bgColor, borderColor: borderColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentHorizontalAlignment = .center
        self.layer.cornerRadius = 12
        self.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
    }
    
    func setupUI(title: String?, titleColor: UIColor? = nil, bgColor: UIColor? = nil, borderColor: UIColor? = nil) {
        if let title = title {
            self.setTitle(title, for: .normal)
        }
        if let titleColor = titleColor {
            self.setTitleColor(titleColor, for: .normal)
        }
        if let tintColor = tintColor {
            self.tintColor = tintColor
        }
        self.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        if let bgColor = bgColor {
            self.backgroundColor = bgColor
        }
        if let borderColor = borderColor {
            self.layer.borderWidth = 2
            self.layer.borderColor = borderColor.cgColor
        }
        self.configure()
    }
    
    func switchButtonStateWithAlpha(fullAlpha: Bool) {
        self.alpha = fullAlpha ? 1 : 0.5
    }
}


class WorkoutButton: UIButton {
      
    override open var isHighlighted: Bool {
        didSet {
            if backgroundColor == .clear {
                setTitleColor(isHighlighted ? titleLabel?.textColor.withAlphaComponent(0.4) : titleLabel?.textColor.withAlphaComponent(1), for: .normal)
            } else {
                backgroundColor = isHighlighted ? backgroundColor?.withAlphaComponent(0.8) : backgroundColor?.withAlphaComponent(1)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    convenience init(title: String?, titleColor: UIColor? = .label, bgColor: UIColor? = .darkGray, borderColor: UIColor? = nil) {
        self.init(type: .system)
        setupUI(title: title, titleColor: titleColor, bgColor: bgColor, borderColor: borderColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentHorizontalAlignment = .center
        self.layer.cornerRadius = 12
        self.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
    }
        
    func setupUI(title: String?, titleColor: UIColor? = nil, bgColor: UIColor? = nil, borderColor: UIColor? = nil) {
        if let title = title {
            self.setTitle(title, for: .normal)
        }
        if let titleColor = titleColor {
            self.setTitleColor(titleColor, for: .normal)
        }
        if let tintColor = tintColor {
            self.tintColor = tintColor
        }
        self.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        if let bgColor = bgColor {
            self.backgroundColor = bgColor
        }
        if let borderColor = borderColor {
            self.layer.borderWidth = 2
            self.layer.borderColor = borderColor.cgColor
        }
        self.configure()
    }
    
    func switchButtonStateWithAlpha(fullAlpha: Bool) {
        self.alpha = fullAlpha ? 1 : 0.5
    }
}
