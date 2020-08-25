//
//  SignUpFloatingPanelVC.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-22.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import Foundation
import UIKit

class SignUpFloatingPanelVC: UIViewController {
    
    let emailTextField = SRTextFieldWithFloat(placeholder: "Email")
    let passwordTextField = SRTextFieldWithFloat(placeholder: "Password")
    
    let signUpButton = SRDefaultButton(title: "Sign up", titleColor: .blue)
    let cancelButton = SRDefaultButton(title: "Cancel", titleColor: .blue, bgColor: .clear)

    let textFieldStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 16
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())
    
    let buttonsStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 16
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())
    
    override func viewDidLoad() {
        view.backgroundColor = SRColor.tertiarySystemBackground
        configureTextFields()
        configureButtons()
    }
    
    private func configureTextFields() {
        textFieldStackView.addArrangedSubview(emailTextField)
        textFieldStackView.addArrangedSubview(passwordTextField)
        view.addSubview(textFieldStackView)
        NSLayoutConstraint.activate([
            emailTextField.heightAnchor.constraint(equalToConstant: 48),
            passwordTextField.heightAnchor.constraint(equalToConstant: 48),
            
            textFieldStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
            textFieldStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            textFieldStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),

        ])
    }
    
    private func configureButtons() {
        buttonsStackView.addArrangedSubview(signUpButton)
        buttonsStackView.addArrangedSubview(cancelButton)
        view.addSubview(buttonsStackView)
        NSLayoutConstraint.activate([
            signUpButton.heightAnchor.constraint(equalToConstant: 48),
            cancelButton.heightAnchor.constraint(equalToConstant: 48),
            
            buttonsStackView.topAnchor.constraint(equalTo: textFieldStackView.bottomAnchor, constant: 32),
            buttonsStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            buttonsStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),

        ])
    }
    
    
    
}
