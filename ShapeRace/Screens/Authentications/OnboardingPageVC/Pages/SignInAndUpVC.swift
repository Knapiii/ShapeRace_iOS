//
//  SignInAndUpVC.swift
//  Shape Race
//
//  Created by Kristoffer Knape on 2020-08-22.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit
enum Authstate { case login, signUp }

protocol SignInAndUpVCDelegate {
    func emailTextfieldEdited(to text: String?)
    func passwordTextfieldEdited(to text: String?)
    func resetPassword()
}

class SignInAndUpVC: UIViewController {
    
    var state: Authstate = .login {
        didSet {
            forgotPasswordButton.isHidden = state == .login
        }
    }
    var delegate: SignInAndUpVCDelegate?

    let emailTextField = AuthTextFieldWithFloat(placeholder: "Email")
    let passwordTextField = AuthTextFieldWithFloat(placeholder: "Password")
    
    let forgotPasswordButton: UIButton = {
        $0.contentHorizontalAlignment = .right
        $0.isHidden = true
        return $0
    }(SRDefaultButton(title: "Forgot password", titleColor: .white, bgColor: .clear))
    
    let textFieldStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 16
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFields()
        configureForotPassword()
    }
    
    private func configureTextFields() {
        emailTextField.setEmailIcon()
        passwordTextField.setPasswordIcon()
        passwordTextField.setPasswordEyeButton(placement: .right)
        emailTextField.addTarget(self, action: #selector(emailTextFieldChanged(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldChanged(_:)), for: .editingChanged)
        forgotPasswordButton.addTarget(self, action: #selector(resetPassword), for: .touchUpInside)

        textFieldStackView.addArrangedSubview(emailTextField)
        textFieldStackView.addArrangedSubview(passwordTextField)
        
        view.addSubview(textFieldStackView)
        NSLayoutConstraint.activate([
            emailTextField.heightAnchor.constraint(equalToConstant: 48),
            passwordTextField.heightAnchor.constraint(equalToConstant: 48),
            
            textFieldStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            textFieldStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            textFieldStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)

        ])
    }
    
    private func configureForotPassword() {
        view.addSubview(forgotPasswordButton)
        NSLayoutConstraint.activate([
            forgotPasswordButton.heightAnchor.constraint(equalToConstant: 48),
            
            forgotPasswordButton.topAnchor.constraint(equalTo: textFieldStackView.bottomAnchor, constant: 16),
            forgotPasswordButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            forgotPasswordButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),

        ])
    }
    
    @objc private func emailTextFieldChanged(_ textField: UITextField) {
        delegate?.emailTextfieldEdited(to: textField.text)
    }
    
    @objc private func passwordTextFieldChanged(_ textField: UITextField) {
        delegate?.passwordTextfieldEdited(to: textField.text)
    }
    
    @objc private func resetPassword() {
        delegate?.resetPassword()
    }

}
