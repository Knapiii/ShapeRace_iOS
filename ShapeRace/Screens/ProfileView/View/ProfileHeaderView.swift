//
//  ProfileHeaderView.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-13.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

protocol ProfileHeaderViewDelegate {
    func friendRequestAction()
}

class ProfileHeaderView: UITableViewHeaderFooterView {
    static let identifier = "ProfileHeaderView"
    var delegate: ProfileHeaderViewDelegate?
    var profileImageView = UserProfileImageView()
    let nameLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.textColor = SRColor.label
        return $0
    }(UILabel())
    
    let friendRequestButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(named: "Friend_Request"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
        return $0
    }(UIButton())
    
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
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentView.backgroundColor = SRColor.background
        backgroundColor = SRColor.background

        addSubview(profileImageView)
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            profileImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        profileImageView.ratioOneToOne()
        if let uid = DB.currentUser.userId {
            profileImageView.setImage(with: uid)
        }

        addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leftAnchor.constraint(equalTo: profileImageView.leftAnchor),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            nameLabel.rightAnchor.constraint(equalTo: rightAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
        
        addSubview(friendRequestButton)
        NSLayoutConstraint.activate([
            friendRequestButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            friendRequestButton.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            friendRequestButton.heightAnchor.constraint(equalToConstant: 24),
            friendRequestButton.widthAnchor.constraint(equalToConstant: 24),
        ])
        
        friendRequestButton.addAction {
            self.delegate?.friendRequestAction()
        }

        addSubview(statsView)
        NSLayoutConstraint.activate([
            statsView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 16),
            statsView.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            statsView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
        ])
    }
    
}
