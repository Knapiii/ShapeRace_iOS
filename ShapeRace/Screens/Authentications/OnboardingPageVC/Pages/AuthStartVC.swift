//
//  AuthStartVC.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-22.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

class AuthStartVC: UIViewController {
    
    let logoImageView: UIImageView = {
        $0.image = UIImage(named: "Logo")
        $0.contentMode = .scaleAspectFit
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLogoImage()
    }
    
    
    func configureLogoImage() {
        view.addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 68),
            logoImageView.heightAnchor.constraint(equalToConstant: 68),
        ])
    }

}
