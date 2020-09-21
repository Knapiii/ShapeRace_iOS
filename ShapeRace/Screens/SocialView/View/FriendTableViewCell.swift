//
//  FriendTVC.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-20.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//


import UIKit

protocol FriendCellProtocol {
    func profileImageTapped(userId: String)
    func accept(request: RequestModel)
    func decline(request: RequestModel)
}

class FriendTableViewCell : UITableViewCell {
    static let reuseId = "FriendTableViewCell"
        
    var delegate: FriendCellProtocol?
    
    var friend : FriendModel? {
        didSet {
            nameLabel.text = friend!.name
            lastMessageLabel.text = friend!.lastMessage
            lastMessageLabel.font = friend!.isRead ? UIFont.systemFont(ofSize: 14) : .systemFont(ofSize: 14, weight: .bold)
            lastMessageLabel.textColor = friend!.isRead ? SRColor.secondaryLabel : SRColor.label
            dot.isHidden = friend!.isRead
            declineButton.isHidden = true
            acceptButton.isHidden = true
            lastMessageLabel.isHidden = false
            profileImage.setProfileImage(userId: friend!.userId, asThumbnail: true)
            profileImage.removeTarget(self, action: nil, for: .allEvents)
            profileImage.addTarget(self, action: #selector(friendProfileImageTapped), for: .touchUpInside)
        }
    }
    
    var request : RequestModel? {
        didSet {
            nameLabel.text = request!.name
            dot.isHidden = true
            declineButton.isHidden = false
            acceptButton.isHidden = false
            lastMessageLabel.isHidden = true
            profileImage.setProfileImage(userId: request!.userId, asThumbnail: true)
            acceptButton.addTarget(self, action: #selector(acceptRequestTapped), for: .touchUpInside)
            declineButton.addTarget(self, action: #selector(declineRequestTapped), for: .touchUpInside)
            profileImage.removeTarget(self, action: nil, for: .allEvents)
            profileImage.addTarget(self, action: #selector(requestProfileImageTapped), for: .touchUpInside)
        }
    }
    
    private let nameLabel : UILabel = {
        let label = UILabel()
        label.textColor = SRColor.label
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lastMessageLabel : UILabel = {
        let label = UILabel()
        label.textColor = SRColor.secondaryLabel
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let profileImage : UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = false
        button.clipsToBounds = true
        button.layer.borderWidth = 1.0
        button.layer.borderColor = SRColor.secondaryLabel.cgColor
        button.setImage(UIImage(named: "User_Placeholder"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 64/2
        return button
    }()
    
    private let dot : UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 12))
        view.backgroundColor = SRColor.adaptiveBlue
        view.layer.cornerRadius = 6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let acceptButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Accept", for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.5) , for: .highlighted)
        button.backgroundColor = SRColor.adaptiveBlue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.layer.cornerRadius = 6
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let declineButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Decline", for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .highlighted)
        button.backgroundColor = SRColor.systemGray3
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.layer.cornerRadius = 6
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private let contentContainer : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let infoContainer : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        config()
    }
        
    func config() {
        selectionStyle = .none
        backgroundColor = SRColor.background
        
        contentView.addSubview(contentContainer)
        NSLayoutConstraint.activate([
            contentContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            contentContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            contentContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            contentContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
        ])

        
        contentContainer.addSubview(profileImage)
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: contentContainer.topAnchor),
            profileImage.leftAnchor.constraint(equalTo: contentContainer.leftAnchor, constant: 16),
            profileImage.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor),
            profileImage.heightAnchor.constraint(equalToConstant: 64)
        ])
        profileImage.ratioOneToOne()
        
        contentContainer.addSubview(infoContainer)
        NSLayoutConstraint.activate([
            infoContainer.topAnchor.constraint(equalTo: contentContainer.topAnchor),
            infoContainer.leftAnchor.constraint(equalTo: profileImage.rightAnchor),
            infoContainer.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor),
            infoContainer.rightAnchor.constraint(equalTo: contentContainer.rightAnchor),
        ])
        
        contentContainer.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 16),
            nameLabel.rightAnchor.constraint(equalTo: contentContainer.rightAnchor, constant: -16),
            nameLabel.bottomAnchor.constraint(equalTo: contentContainer.centerYAnchor, constant: -2),
        ])
        
        contentContainer.addSubview(lastMessageLabel)
        NSLayoutConstraint.activate([
            lastMessageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6),
            lastMessageLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 10),
            lastMessageLabel.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor),
            lastMessageLabel.rightAnchor.constraint(equalTo: contentContainer.rightAnchor),
        ])

        addSubview(declineButton)
        NSLayoutConstraint.activate([
            declineButton.topAnchor.constraint(equalTo: contentContainer.centerYAnchor, constant: 2),
            declineButton.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 16),
            declineButton.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor),
            declineButton.rightAnchor.constraint(equalTo: infoContainer.centerXAnchor, constant: -8)
        ])
        
        addSubview(acceptButton)
        NSLayoutConstraint.activate([
            acceptButton.topAnchor.constraint(equalTo: contentContainer.centerYAnchor, constant: 2),
            acceptButton.leftAnchor.constraint(equalTo: infoContainer.centerXAnchor, constant: 8),
            acceptButton.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor),
            acceptButton.rightAnchor.constraint(equalTo: contentContainer.rightAnchor, constant: -16)
        ])
        
        contentView.addSubview(dot)
        dot.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        NSLayoutConstraint.activate([
            dot.leftAnchor.constraint(equalTo: contentContainer.rightAnchor),
            dot.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            dot.heightAnchor.constraint(equalToConstant: 12),
            dot.widthAnchor.constraint(equalToConstant: 12),
        ])
    }
        
    func clearCell() {
        acceptButton.removeTarget(nil, action: nil, for: .allEvents)
        declineButton.removeTarget(nil, action: nil, for: .allEvents)
    }
    
    func setButtonTags(tag: Int) {
        acceptButton.isEnabled = true
        declineButton.isEnabled = true
        acceptButton.tag = tag
        declineButton.tag = tag
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func acceptRequestTapped(sender: UIButton) {
        sender.isEnabled = false
        delegate?.accept(request: request!)
        //DB.friends.acceptFriendRequest(withFriendsId: request!.friendsId, fromUserId: request?.userId)
    }
    
    @objc func declineRequestTapped(sender: UIButton) {
        sender.isEnabled = false
        delegate?.decline(request: request!)
        //DB.friends.deleteFriendCollection(withFriendsId: request!.friendsId)
    }
    
    @objc func friendProfileImageTapped() {
        self.delegate?.profileImageTapped(userId: friend!.userId)
    }
    
    @objc func requestProfileImageTapped() {
        self.delegate?.profileImageTapped(userId: request!.userId)
    }

    
}

