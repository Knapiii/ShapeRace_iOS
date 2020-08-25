//
//  SRTextFieldWithFloat.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-22.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class SRTextFieldWithFloat: SkyFloatingLabelTextField, Jiggerable {
    private let textFieldplaceholderColor = SRColor.systemGray2

    convenience init(placeholder: String) {
        self.init(frame: .zero)
        self.placeholder = placeholder
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        defaultUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func jiggerWithLight() {
        self.jigger()
    }
    
    func makeUIWhite() {
        self.tintColor = .white
        self.textColor = .white
        self.selectedLineColor = .white
    }

    func makeOriginal() {
        self.tintColor = SRColor.label
        self.textColor = SRColor.label
        self.selectedLineColor = SRColor.label
    }

    private func defaultUI() {
        //Placeholder
        self.placeholderColor = textFieldplaceholderColor
        self.placeholderFont = .systemFont(ofSize: 18)
        //Upper text
        self.selectedTitleColor = textFieldplaceholderColor
        self.titleColor = textFieldplaceholderColor
        
        self.textColor = SRColor.label
        
        self.lineColor = textFieldplaceholderColor
        self.selectedLineColor = SRColor.label
        
        self.lineHeight = 1.0
        self.selectedLineHeight = 2.0
        
        self.font = UIFont.systemFont(ofSize: 16)
        self.layer.masksToBounds = false
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setPlaceholder(_ placeholder: String) {
        self.placeholder = placeholder
    }
    
}


class AuthTextFieldWithFloat: SkyFloatingLabelTextFieldWithIcon, Jiggerable {
    private let textFieldplaceholderColor = SRColor.systemGray2

    convenience init(placeholder: String) {
        self.init(frame: .zero)
        self.placeholder = placeholder
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        defaultUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func jiggerWithLight() {
        self.jigger()
    }
    
    private func defaultUI() {
        self.placeholderColor = UIColor.white.withAlphaComponent(0.6)
        self.placeholderFont = .systemFont(ofSize: 18)

        
        self.titleColor = UIColor.white.withAlphaComponent(0.6)
        self.titleFont = .systemFont(ofSize: 14)
        self.selectedTitleColor = UIColor.white

        self.textColor = .white
        
        self.lineColor = UIColor.white.withAlphaComponent(0.6)
        self.selectedLineColor = UIColor.white

        self.lineHeight = 1.0
        self.selectedLineHeight = 2.0
        
        self.font = UIFont.systemFont(ofSize: 16)
        self.layer.masksToBounds = false
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setPlaceholder(_ placeholder: String) {
        self.placeholder = placeholder
    }
    
    enum ButtonPlacement {
        case left, right
    }
    
    func setEmailIcon() {
        iconType = .image
        iconImage = UIImage(named: "Email_Symbol")
        iconMarginBottom = 4.0
        iconMarginLeft = 2.0
        iconImageView.contentMode = .scaleAspectFit
        iconWidth = 35
        self.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    
    func setPasswordIcon() {
        iconType = .image
        iconImage = UIImage(named: "Password_Symbol")
        iconMarginBottom = 4.0
        iconMarginLeft = 2.0
        iconImageView.contentMode = .scaleAspectFit
        iconWidth = 35
        isSecureTextEntry = true
    }
    
    func setPasswordEyeButton(placement: ButtonPlacement) {
        let button  = UIButton(type: .custom)
        button.frame = CGRect(x:0, y:0, width:24, height:24)
        button.setImage(UIImage(named: "Eye_Crossed"), for: .normal)
        
        button.addAction {
            self.isSecureTextEntry.toggle()
            switch self.isSecureTextEntry {
            case true:
                button.setImage(UIImage(named: "Eye_Crossed"), for: .normal)
            case false:
                button.setImage(UIImage(named: "Eye"), for: .normal)
            }
        }
        switch placement {
        case .left:
            self.leftViewMode = .always
            self.leftView = button
        case .right:
            self.rightViewMode = .always
            self.rightView = button
        }
    }
    
    @objc func textFieldDidChange(_ textfield: UITextField) {
        if let text = textfield.text {
            if(text.count < 3 || !text.contains("@")) {
                self.errorColor = errorColor.withAlphaComponent(0.8)
                self.errorMessage = "Invalid email"
            } else {
                // The error message will only disappear when we reset it to nil or empty string
                self.errorMessage = ""
            }
        }
    }
    
}

