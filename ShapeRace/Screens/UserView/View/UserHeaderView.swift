//
//  UserHeaderView.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-13.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

protocol UserHeaderDelegate {
    func setFriendState(user: UserModel, state: FriendState)
}

class UserHeaderView: UITableViewHeaderFooterView {
    static let identifier = "UserHeaderView"
    
    var profileImageView = UserProfileImageView()
    let nameLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.textColor = SRColor.label
        return $0
    }(UILabel())
    let friendStateButton = DefaultButton(title: "Add friend", titleColor: .white, bgColor: SRColor.blue)
    let statsView = UserWorkoutStatsView()
    var currentFriendState: FriendState = .addFriend
    var user: UserModel? {
        didSet {
            configureUser()
            NotificationCenter.default.addObserver(self, selector: #selector(setFriendsStateTitle), name: Notis.friends.name, object: nil)
        }
    }
    var workouts: [WorkoutModel] = [] {
        didSet {
            statsView.amountOfWorkouts = workouts.count
            statsView.totalWorkoutTime = workouts.map({ ($0.workoutTime ?? 0) }).reduce(0, +)
        }
    }
    var delegate: UserHeaderDelegate?
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUser() {
        nameLabel.text = user?.displayNameAndLastNameIfAvailable
        if let uid = user?.userId {
            profileImageView.setImage(with: uid)
        }
        self.setFriendsStateTitle()

    }
    
    @objc private func setFriendsStateTitle() {
        guard let id = user?.userId else { return }
        friendStateButton.removeTarget(self, action: nil, for: .allEvents)
        friendStateButton.isEnabled = true
        switch DB.friends.checkFriendState(forUserId: id) {
        case .addFriend:
            currentFriendState = .addFriend
            friendStateButton.setupUI(title: "Add friend", titleColor: .white, bgColor: SRColor.blue)
            //friendStateButton.setImage(UIImage(named: "Add_Friend"), for: .normal)
            friendStateButton.addTarget(self, action: #selector(friendsButtonTapped(_:)), for: .touchUpInside)
        case .acceptRequest:
            currentFriendState = .acceptRequest
            friendStateButton.setupUI(title: "Accept request", titleColor: SRColor.adaptiveBlue, bgColor: .white, borderColor: SRColor.adaptiveBlue)
            friendStateButton.backgroundColor = .orange
            //friendStateButton.setImage(UIImage(named: "Add_Friend"), for: .normal)
            friendStateButton.addTarget(self, action: #selector(friendsButtonTapped(_:)), for: .touchUpInside)
        case .cancelRequest:
            currentFriendState = .cancelRequest
            friendStateButton.setupUI(title: "Cancel request", titleColor: SRColor.adaptiveBlue, bgColor: .white, borderColor: SRColor.adaptiveBlue)
            //friendStateButton.setImage(UIImage(named: "Remove_Friend"), for: .normal)
            friendStateButton.addTarget(self, action: #selector(friendsButtonTapped(_:)), for: .touchUpInside)
        case .removeFriend:
            currentFriendState = .removeFriend
            friendStateButton.setupUI(title: "Remove friend", titleColor: SRColor.adaptiveBlue, bgColor: .white, borderColor: SRColor.adaptiveBlue)
            //friendStateButton.setImage(UIImage(named: "Remove_Friend"), for: .normal)
            friendStateButton.addTarget(self, action: #selector(friendsButtonTapped(_:)), for: .touchUpInside)
        }
        //friendStateButton.imageView?.contentMode = .scaleAspectFit
        //friendStateButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 16)
    }
    
    @objc private func friendsButtonTapped(_ sender: UIButton) {
        sender.isEnabled = false
        guard let user = user else { return }
        Vibration.medium.vibrate()
        delegate?.setFriendState(user: user, state: currentFriendState)
    }
    
    @objc private func addFriendButtonTapped(_ sender: UIButton){
        sender.isEnabled = false
        DB.friends.sendFriendRequest(toUser: self.user!)
    }
    
    @objc private func acceptFriendButtonTapped(_ sender: UIButton){
        sender.isEnabled = false
        DB.friends.acceptFriendRequest(fromUser: self.user!, completion: {_ in })
    }
    
    @objc private func cancelRequestButtonTapped(_ sender: UIButton){
        sender.isEnabled = false
        DB.friends.cancelFriendRequest(toUser: self.user!, completion: {_ in })
    }
    
    @objc private func removeFriendButtonTapped(_ sender: UIButton){
        sender.isEnabled = false
        DB.friends.deleteFriendCollection(withUser: self.user!, completion: {_ in })
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

        
        addSubview(statsView)
        NSLayoutConstraint.activate([
            statsView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 16),
            statsView.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            statsView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
        ])
        
        addSubview(friendStateButton)
        friendStateButton.layer.cornerRadius = 6
        NSLayoutConstraint.activate([
            friendStateButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            friendStateButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            friendStateButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            friendStateButton.heightAnchor.constraint(equalToConstant: 48/1.3),
            friendStateButton.widthAnchor.constraint(equalToConstant: 150),
        ])
        
        addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leftAnchor.constraint(equalTo: profileImageView.leftAnchor),
            nameLabel.rightAnchor.constraint(equalTo: friendStateButton.leftAnchor, constant: -8),
            nameLabel.centerYAnchor.constraint(equalTo: friendStateButton.centerYAnchor)
        ])

    }
    
}
