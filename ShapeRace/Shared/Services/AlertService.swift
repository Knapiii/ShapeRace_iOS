//
//  AlertService.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-13.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit
import SCLAlertView

class AlertService {
    static let shared = AlertService()
    
    func showLoader() {
        ProgressHudService.shared.showSpinner()
    }
    
    func dismissLoader() {
        ProgressHudService.shared.dismiss()
    }
    
    func showAlert(title: String,
                     text: String,
                     hideAuto: Bool,
                     hideTimeInterval: TimeInterval = 3,
                     amountOfButtonsMax2: Int = 0,
                     button1Text: String = "",
                     button2Text: String = "",
                     button1Completion: Completion? = nil,
                     button2Completion: Completion? = nil) {
        ProgressHudService.shared.dismiss()
        var appearance: SCLAlertView.SCLAppearance!
        
        if hideAuto {
            appearance = SCLAlertView.SCLAppearance(
                kWindowWidth: UIScreen.main.bounds.width * 0.8,
                kButtonHeight: 48,
                kTitleFont: .systemFont(ofSize: 22, weight: .semibold),
                kTextFont: .systemFont(ofSize: 17, weight: .regular),
                kButtonFont: .systemFont(ofSize: 17, weight: .bold),
                showCloseButton: false,
                shouldAutoDismiss: hideAuto,
                contentViewCornerRadius: 12,
                buttonCornerRadius: 12,
                hideWhenBackgroundViewIsTapped: hideAuto,
                contentViewColor: SRColor.background,
                titleColor: SRColor.label
            )
        } else {
            appearance = SCLAlertView.SCLAppearance(
                kWindowWidth: UIScreen.main.bounds.width * 0.8,
                kButtonHeight: 48,
                kTitleFont: .systemFont(ofSize: 22, weight: .semibold),
                kTextFont: .systemFont(ofSize: 17, weight: .regular),
                kButtonFont: .systemFont(ofSize: 17, weight: .bold),
                showCloseButton: false,
                shouldAutoDismiss: hideAuto,
                contentViewCornerRadius: 12,
                buttonCornerRadius: 12,
                hideWhenBackgroundViewIsTapped: hideAuto,
                contentViewColor: SRColor.background,
                titleColor: SRColor.label,
                buttonsLayout: .horizontal
            )
        }

        let alertView = SCLAlertView(appearance: appearance)
        
        
        if amountOfButtonsMax2 == 1 {
            alertView.addButton(button1Text, backgroundColor: button1Text == "Delete" ? .red : SRColor.adaptiveBlue, textColor: .white) {
                if let completion = button1Completion {
                    Vibration.medium.vibrate()
                    completion()
                    alertView.hideView()
                } else {
                    Vibration.medium.vibrate()
                    alertView.hideView()
                }
            }
        } else if amountOfButtonsMax2 == 2 {
            alertView.addButton(button1Text, backgroundColor: button1Text == "Delete" ? .red : SRColor.adaptiveBlue, textColor: .white) {
                if let completion = button1Completion {
                    Vibration.medium.vibrate()
                    completion()
                    alertView.hideView()
                } else {
                    Vibration.medium.vibrate()
                    alertView.hideView()
                }
            }

            alertView.addButton(button2Text, backgroundColor: button2Text == "Delete" ? .red : SRColor.adaptiveBlue, textColor: .white) {
                if let completion = button2Completion {
                    Vibration.medium.vibrate()
                    completion()
                    alertView.hideView()
                } else {
                    Vibration.medium.vibrate()
                    alertView.hideView()
                }
            }
        }
        
        if !hideAuto {
            alertView.showNotice(title, subTitle: text)
        } else {
            alertView.showNotice(title, subTitle: text, timeout: SCLAlertView.SCLTimeoutConfiguration(timeoutValue: 3, timeoutAction: {
                if hideAuto && amountOfButtonsMax2 == 0  {
                    alertView.hideView()
                }
            }), animationStyle: .bottomToTop)
        }

    }
    
    func showSuccess(title: String = "Success",
                     text: String,
                     hideAuto: Bool,
                     hideTimeInterval: TimeInterval = 3,
                     amountOfButtonsMax2: Int = 0,
                     button1Text: String = "",
                     button2Text: String = "",
                     button1Completion: Completion? = nil,
                     button2Completion: Completion? = nil) {
        
        configDefault(title: title, text: text, hideAuto: hideAuto, hideTimeInterval: hideTimeInterval, amountOfButtonsMax2: amountOfButtonsMax2, button1Text: button1Text, button2Text: button2Text, button1Completion: button1Completion, button2Completion: button2Completion) { (alertView) in
            
            if !hideAuto {
                alertView.showSuccess(title, subTitle: text)
            } else {
                alertView.showSuccess(title, subTitle: text, timeout: SCLAlertView.SCLTimeoutConfiguration(timeoutValue: 3, timeoutAction: {
                    if hideAuto && amountOfButtonsMax2 == 0  {
                        alertView.hideView()
                    }
                }), animationStyle: .bottomToTop)
            }
            
        }

    }
    
    func showInfo(title: String = "Info",
                  text: String,
                  hideAuto: Bool,
                  hideTimeInterval: TimeInterval = 3,
                  amountOfButtonsMax2: Int = 0,
                  button1Text: String = "",
                  button2Text: String = "",
                  button1Completion: Completion? = nil,
                  button2Completion: Completion? = nil) {
    
        configDefault(title: title, text: text, hideAuto: hideAuto, hideTimeInterval: hideTimeInterval, amountOfButtonsMax2: amountOfButtonsMax2, button1Text: button1Text, button2Text: button2Text, button1Completion: button1Completion, button2Completion: button2Completion) { (alertView) in
            
            if !hideAuto {
                alertView.showInfo(title, subTitle: text)
            } else {
                alertView.showInfo(title, subTitle: text, timeout: SCLAlertView.SCLTimeoutConfiguration(timeoutValue: 3, timeoutAction: {
                    if hideAuto && amountOfButtonsMax2 == 0  {
                        alertView.hideView()
                    }
                }), animationStyle: .bottomToTop)
            }
        }
    }
    
    func showError(title: String = "Error",
                   text: String,
                   autoHide: Bool,
                   hideTimeInterval: TimeInterval = 3,
                   amountOfButtonsMax2: Int = 0,
                   button1Text: String = "",
                   button2Text: String = "",
                   button1Completion: Completion? = nil,
                   button2Completion: Completion? = nil) {

        configDefault(title: title, text: text, hideAuto: autoHide, hideTimeInterval: hideTimeInterval, amountOfButtonsMax2: amountOfButtonsMax2, button1Text: button1Text, button2Text: button2Text, button1Completion: button1Completion, button2Completion: button2Completion) { (alertView) in
            
            if !autoHide {
                alertView.showError(title, subTitle: text)
            } else {
                alertView.showError(title, subTitle: text, timeout: SCLAlertView.SCLTimeoutConfiguration(timeoutValue: hideTimeInterval, timeoutAction: {
                    if autoHide && amountOfButtonsMax2 == 0  {
                        alertView.hideView()
                    }
                }), animationStyle: .bottomToTop)
            }
        }
        

    
    }
    
    private func configDefault(title: String,
                               text: String,
                               hideAuto: Bool,
                               hideTimeInterval: TimeInterval = 3,
                               amountOfButtonsMax2: Int = 0,
                               button1Text: String = "",
                               button2Text: String = "",
                               button1Completion: Completion? = nil,
                               button2Completion: Completion? = nil,
                               alertViewCompletion: (SCLAlertView) -> ()) {
        ProgressHudService.shared.dismiss()
        var appearance: SCLAlertView.SCLAppearance!
        
        if hideAuto {
            appearance = SCLAlertView.SCLAppearance(
                kWindowWidth: UIScreen.main.bounds.width * 0.8,
                kButtonHeight: 48,
                kTitleFont: .systemFont(ofSize: 22, weight: .semibold),
                kTextFont: .systemFont(ofSize: 17, weight: .regular),
                kButtonFont: .systemFont(ofSize: 17, weight: .bold),
                showCloseButton: false,
                shouldAutoDismiss: hideAuto,
                contentViewCornerRadius: 12,
                buttonCornerRadius: 12,
                hideWhenBackgroundViewIsTapped: hideAuto,
                contentViewColor: SRColor.background,
                titleColor: SRColor.label
            )
        } else {
            appearance = SCLAlertView.SCLAppearance(
                kWindowWidth: UIScreen.main.bounds.width * 0.8,
                kButtonHeight: 48,
                kTitleFont: .systemFont(ofSize: 22, weight: .semibold),
                kTextFont: .systemFont(ofSize: 17, weight: .regular),
                kButtonFont: .systemFont(ofSize: 17, weight: .bold),
                showCloseButton: false,
                shouldAutoDismiss: hideAuto,
                contentViewCornerRadius: 12,
                buttonCornerRadius: 12,
                hideWhenBackgroundViewIsTapped: hideAuto,
                contentViewColor: SRColor.background,
                titleColor: SRColor.label,
                buttonsLayout: .horizontal
            )
        }

        let alertView = SCLAlertView(appearance: appearance)
    
        if amountOfButtonsMax2 == 1 {
            alertView.addButton(button1Text) {
                if let completion = button1Completion {
                    Vibration.medium.vibrate()
                    completion()
                    alertView.hideView()
                } else {
                    Vibration.medium.vibrate()
                    alertView.hideView()
                }
            }
        } else if amountOfButtonsMax2 == 2 {
            alertView.addButton(button1Text) {
                if let completion = button1Completion {
                    Vibration.medium.vibrate()
                    completion()
                    alertView.hideView()
                } else {
                    Vibration.medium.vibrate()
                    alertView.hideView()
                }
            }
            alertView.addButton(button2Text) {
                if let completion = button2Completion {
                    Vibration.medium.vibrate()
                    completion()
                    alertView.hideView()
                } else {
                    Vibration.medium.vibrate()
                    alertView.hideView()
                }
            }
        }
        
        alertViewCompletion(alertView)
    }
    
}

