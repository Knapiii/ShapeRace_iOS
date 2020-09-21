//
//  UserProfileImageView.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-13.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

class UserProfileImageView: UIImageView {

    init() {
        super.init(frame: .zero)
        config()
    }
    
    convenience init(id: String) {
        self.init()
        setImage(with: id)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config() {
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFill
        backgroundColor = SRColor.systemGray6
    }
    
    func clearImage() {
        image = nil
    }
    
    func setImage(with userId: String) {
        setProfileImage(userId: userId)
    }

}
