//
//  PageCreateUserDetailsInfoVC.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-23.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

class PageCreateUserDetailsInfoVC: UIViewController {
    
    private let profileImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .black
        return $0
    }(UIImageView())
    
    private let nameTextField = AuthTextFieldWithFloat(placeholder: "First name", iconName: "Email_Symbol")
    private let lastNameTextField = AuthTextFieldWithFloat(placeholder: "last name", iconName: "Email_Symbol")
    
    private let textFieldStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 16
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())
    
    private var imagePicker: ImagePicker!
    var profileImage: UIImage? {
        didSet {
            profileImageView.image = profileImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFields()
        configureImageView()
        DispatchQueue.main.async { [self] in
            getUserInfo()
        }
        imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    func getUserInfo() {
        nameTextField.text = DB.currentUser.user?.firstName
        lastNameTextField.text = DB.currentUser.user?.lastName
        guard let uid = FirestoreService.Ref.User.shared.currentUserId else { return }
        profileImageView.setProfileImage(userId: uid)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
    }
        
    private func configureTextFields() {
        nameTextField.addTarget(self, action: #selector(nameTextFieldChanged(_:)), for: .editingChanged)
        lastNameTextField.addTarget(self, action: #selector(lastNameTextFieldChanged(_:)), for: .editingChanged)

        textFieldStackView.addArrangedSubview(nameTextField)
        textFieldStackView.addArrangedSubview(lastNameTextField)
        
        view.addSubview(textFieldStackView)
        NSLayoutConstraint.activate([
            nameTextField.heightAnchor.constraint(equalToConstant: 48),
            lastNameTextField.heightAnchor.constraint(equalToConstant: 48),
            
            textFieldStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            textFieldStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            textFieldStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
    }
    
    private func configureImageView() {
        view.addSubview(profileImageView)
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: textFieldStackView.topAnchor, constant: -16)
        ])
        profileImageView.ratioOneToOne()
        profileImageView.clipsToBounds = true
        
        profileImageView.addTapGestureRecognizer(action: {
            self.imagePicker.present(from: self.view)
        })
    }
    
    func uploadUserInfo(completion: @escaping VoidCompletion) {
        guard let user = DB.currentUser.user else { return }

        if let firstname = nameTextField.text, !firstname.isEmpty {
            user.firstName = firstname
        }
        if let lastname = lastNameTextField.text, !lastname.isEmpty {
            user.lastName = lastname
        }
        DB.currentUser.uploadUserInfo(user: user, image: profileImage, completion: completion)
    }
    
    @objc private func nameTextFieldChanged(_ textField: UITextField) {
    }
    
    @objc private func lastNameTextFieldChanged(_ textField: UITextField) {
    }
    

}


extension PageCreateUserDetailsInfoVC: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        if let image = image {
            self.profileImage = image
        }
        
    }
    
}
