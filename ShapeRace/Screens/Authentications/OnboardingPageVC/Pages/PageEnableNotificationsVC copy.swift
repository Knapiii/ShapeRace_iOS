//
//  PageEnableNotificationsVC.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-25.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

class PageEnableNotificationsVC: UIViewController {

    private let topTitle: UILabel = {
        $0.text = "Allow notifications"
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 24, weight: .semibold)
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    private let topDescription: UILabel = {
        $0.text = "Send and recieve notifications with your friends"
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .white
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 20, weight: .regular)
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTopText()
    }
        
    private func configureTopText() {
        view.addSubview(topTitle)
        NSLayoutConstraint.activate([
            topTitle.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 70),
            topTitle.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor, constant: 16),
            topTitle.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor, constant: -16),
        ])
        view.addSubview(topDescription)
        NSLayoutConstraint.activate([
            topDescription.topAnchor.constraint(equalTo: topTitle.bottomAnchor, constant: 16),
            topDescription.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor, constant: 16),
            topDescription.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor, constant: -16),
        ])
    }
    
    func askForNotificationPermission() {
        UIApplication.shared.registerForRemoteNotifications()
    }
    
}
