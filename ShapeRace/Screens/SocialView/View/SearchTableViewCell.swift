//
//  SearchTVC.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-20.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    static let reuseId = "SearchTableViewCell"
    var friend : FriendModel? {
        didSet {
            nameLabel.text = friend!.name
            requestButton.isHidden = true
            profileImageView.setImage(with: friend!.userId!)
        }
    }
    
    var user : UserModel? {
        didSet {
            nameLabel.text = (user?.firstName ?? "") + " " + (user?.lastName ?? "")
            requestButton.isHidden = false
            profileImageView.setImage(with: user!.userId!)
        }
    }
    
    private let nameLabel : UILabel = {
        let label = UILabel()
        label.textColor = SRColor.label
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    private let profileImageView = UserProfileImageView()
    
    let requestButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.layer.cornerRadius = 6
        button.isHidden = true
        return button
    }()
    
    private let contentContainer : UIView = {
        let view = UIView()
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = SRColor.background
        
        addSubview(profileImageView)
        addSubview(contentContainer)
        contentContainer.addSubview(nameLabel)
        contentContainer.addSubview(requestButton)
        
        NSLayoutConstraint.activate([
            profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            profileImageView.heightAnchor.constraint(equalToConstant: 44),
            profileImageView.widthAnchor.constraint(equalToConstant: 44),
            profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            contentContainer.topAnchor.constraint(equalTo: topAnchor),
            contentContainer.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 10),
            contentContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentContainer.rightAnchor.constraint(equalTo: rightAnchor),
        ])
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentContainer.topAnchor),
            nameLabel.leftAnchor.constraint(equalTo: contentContainer.leftAnchor, constant: 10),
            nameLabel.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            requestButton.leftAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 10),
            requestButton.rightAnchor.constraint(equalTo: contentContainer.rightAnchor, constant: -16),
            requestButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            requestButton.heightAnchor.constraint(equalToConstant: 64),
            requestButton.widthAnchor.constraint(equalToConstant: 28),
        ])
    }
    
    func clearCell() {
        requestButton.removeTarget(nil, action: nil, for: .allEvents)
        profileImageView.clearImage()
    }
    
    enum ButtonType {
        case add, accept, sent, hidden
    }
    
    func setButton(buttonType: ButtonType) {
        switch buttonType {
        case .add:
            requestButton.setTitle("Add", for: .normal)
            requestButton.setTitleColor(.systemOrange, for: .highlighted)
            requestButton.backgroundColor = .orange
            requestButton.isEnabled = true
            requestButton.isHidden = false
        case .accept:
            requestButton.setTitle("Accept", for: .normal)
            requestButton.setTitleColor(.green, for: .highlighted)
            requestButton.backgroundColor = .orange
            requestButton.isEnabled = true
            requestButton.isHidden = false
        case .sent:
            requestButton.setTitle("Sent", for: .normal)
            requestButton.setTitleColor(.systemGray, for: .highlighted)
            requestButton.backgroundColor = .gray
            requestButton.isEnabled = false
            requestButton.isHidden = false
        case .hidden:
            requestButton.isHidden = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
