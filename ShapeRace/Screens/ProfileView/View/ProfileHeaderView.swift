//
//  ProfileHeaderView.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-13.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

class ProfileHeaderView: UITableViewHeaderFooterView {
    static let identifier = "ProfileHeaderView"
    
    var profileImageView = UserProfileImageView()
    let nameLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 24, weight: .bold)
        $0.textColor = SRColor.label
        return $0
    }(UILabel())
    let statsView = UserWorkoutStatsView()
    
    var user: UserModel? {
        didSet {
            nameLabel.text = user?.displayNameAndLastNameIfAvailable
        }
    }
    var workouts: [WorkoutModel] = [] {
        didSet {
            statsView.amountOfWorkouts = workouts.count
            statsView.totalWorkoutTime = workouts.map({ ($0.workoutTime ?? 0) }).reduce(0, +)
        }
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        contentView.backgroundColor = SRColor.background
        backgroundColor = SRColor.background

        addSubview(profileImageView)
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        profileImageView.ratioOneToOne()
        if let uid = DB.currentUser.userId {
            profileImageView.setImage(with: uid)
        }

//        addSubview(nameLabel)
//        NSLayoutConstraint.activate([
//            nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 16),
//            nameLabel.bottomAnchor.constraint(equalTo: profileImageView.centerYAnchor),
//            nameLabel.rightAnchor.constraint(equalTo: rightAnchor),
//        ])

        addSubview(statsView)
        NSLayoutConstraint.activate([
            statsView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16),
            statsView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            statsView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            statsView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
        ])
    }
    
}
