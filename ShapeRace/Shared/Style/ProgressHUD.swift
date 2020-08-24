//
//  ProgressHUD.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-24.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import Foundation
import ProgressHUD

class ProgressHudService {
    static let shared = ProgressHudService()
    
    func dismiss() {
        ProgressHUD.dismiss()
    }
    
    func success(_ text: String? = nil) {
        ProgressHUD.showSuccess(text)
    }
    
    func error(_ text: String? = nil) {
        ProgressHUD.showError(text)
    }
    
    func showSpinner(_ text: String? = nil) {
        ProgressHUD.show(text)
    }
}
