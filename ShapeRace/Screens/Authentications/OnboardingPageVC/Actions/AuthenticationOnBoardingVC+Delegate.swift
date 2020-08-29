//
//  AuthenticationOnBoardingVC+Delegate.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-23.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

extension AuthenticationOnBoardingVC: SignInAndUpVCDelegate {
    func emailTextfieldEdited(to text: String?) {
        if let text = text, !text.isEmpty {
            email = text
        } else {
            email = nil
        }
    }
    
    func passwordTextfieldEdited(to text: String?) {
        if let text = text, !text.isEmpty {
            password = text
        } else {
            password = nil
        }
    }
    
    func resetPassword() {
        print("hej")
    }
    
    
}
