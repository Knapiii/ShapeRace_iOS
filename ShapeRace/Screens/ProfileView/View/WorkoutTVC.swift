//
//  WorkoutTVC.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-13.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

class WorkoutTVC: UITableViewCell {
    static let identifier = "WorkoutTVC"
    
    let cellContentView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 6
        $0.backgroundColor = SRColor.cell
        return $0
    }(UIView())
    
    let userImageView = UserProfileImageView()
    let nameLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
        $0.textColor = SRColor.label
        return $0
    }(UILabel())
    let timestampLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 10, weight: .regular)
        $0.textColor = SRColor.label
        return $0
    }(UILabel())
    let gymNameLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 14, weight: .bold)
        $0.textColor = SRColor.label
        $0.textAlignment = .center
        return $0
    }(UILabel())
    let gymAddressLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 10, weight: .semibold)
        $0.textColor = SRColor.label
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    let gymLabelsContainer: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 6
        $0.backgroundColor = SRColor.cell
        $0.setShadow()
        
        return $0
    }(UIView())
    
    let workoutTimeLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 26, weight: .bold)
        $0.textColor = SRColor.label
        $0.text = "00:00:00"
        return $0
    }(UILabel())
    
    let amountOfBoosts: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
        $0.textColor = SRColor.label
        $0.textAlignment = .right
        $0.text = "124 boosts"
        return $0
    }(UILabel())
    
    let mapContainer: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.3)
        $0.clipsToBounds = true
        return $0
    }(UIView())
    
    let mapImage: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView())
    
    let likeButton: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "Muscle_White")
        return $0
    }(UIImageView())
    
    var workout: WorkoutModel? {
        didSet {
            DispatchQueue.main.async { [self] in
                self.setLabels()
                self.updateCell(false)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cellContentView.setShadow()
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLabels() {
        //= workout?.workoutTime?.secondsToTimeWithDotsInBetween(includeSeconds: true)
        guard let workout = workout else { return }
        userImageView.setImage(with: workout.userId)
        nameLabel.text = workout.userName
        timestampLabel.text = workout.timestamp.timestampToDate()
        gymNameLabel.text = workout.gymName
        gymAddressLabel.text = workout.gymAddress
        workoutTimeLabel.text = workout.workoutTime?.secondsToTimeWithDotsInBetween(includeSeconds: true)
        if traitCollection.userInterfaceStyle == .dark {
            mapImage.setWorkoutMapImage(userId: workout.userId, workoutId: workout.workoutId, style: .dark)
        } else if traitCollection.userInterfaceStyle == .light {
            mapImage.setWorkoutMapImage(userId: workout.userId, workoutId: workout.workoutId, style: .light)
        }
        
        likeButton.addTapGestureRecognizer {
            self.likeButtonTapped()
        }
    
    }
    
    @objc func toggleRouteLikes(_ notification: Notification) {
        guard let object = notification.object as? [String : Any],
              let workoutId = object["workoutId"] as? String,
              let likedBy = object["likedBy"] as? [String],
              workoutId == workout?.workoutId else { return }
        
        self.workout?.likedBy = likedBy
        updateCell(false)
    }
    
    func updateCell(_ newWorkout: Bool) {
        guard let workout = workout else { return }
        if workout.isLiked {
            likeButton.image = UIImage(named: "Muscle_Filled_White")
        } else {
            likeButton.image = UIImage(named: "Muscle_White")
        }
        amountOfBoosts.text = workout.likedBy.count == 1 ? "\(workout.likedBy.count) Boost" : "\(workout.likedBy.count) Boosts"
    }
    
    func likeButtonTapped() {
        guard let workout = workout else { return }
        Vibration.selection.vibrate()
        
        UIView.animate(withDuration: 0.1,
                       animations: {
                        self.likeButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                       },
                       completion: { _ in
                        UIView.animate(withDuration: 0.1) {
                            self.likeButton.transform = CGAffineTransform.identity
                        }
                       })
        
        workout.toggleLike()
    }
    
    private func config() {
        NotificationCenter.default.addObserver(self, selector: #selector(toggleRouteLikes), name: Notis.toggleRouteLikes.name, object: nil)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.addSubview(cellContentView)
        NSLayoutConstraint.activate([
            cellContentView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cellContentView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            cellContentView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
            cellContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        cellContentView.addSubview(userImageView)
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: cellContentView.topAnchor, constant: 16
            ),
            userImageView.leftAnchor.constraint(equalTo: cellContentView.leftAnchor, constant: 8),
            userImageView.heightAnchor.constraint(equalToConstant: 34),
        ])
        userImageView.ratioOneToOne()
        
        cellContentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: 8),
            nameLabel.bottomAnchor.constraint(equalTo: userImageView.centerYAnchor),
        ])
        cellContentView.addSubview(timestampLabel)
        NSLayoutConstraint.activate([
            timestampLabel.topAnchor.constraint(equalTo: userImageView.centerYAnchor),
            timestampLabel.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: 8),
        ])
        
        cellContentView.addSubview(workoutTimeLabel)
        NSLayoutConstraint.activate([
            workoutTimeLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 8),
            workoutTimeLabel.leftAnchor.constraint(equalTo: cellContentView.leftAnchor, constant: 8),
        ])
        
        cellContentView.addSubview(mapContainer)
        NSLayoutConstraint.activate([
            mapContainer.topAnchor.constraint(equalTo: workoutTimeLabel.bottomAnchor, constant: 16),
            mapContainer.leftAnchor.constraint(equalTo: cellContentView.leftAnchor),
            mapContainer.rightAnchor.constraint(equalTo: cellContentView.rightAnchor),
            mapContainer.heightAnchor.constraint(equalToConstant: 160)
        ])
        
        mapContainer.addSubview(mapImage)
        NSLayoutConstraint.activate([
            mapImage.topAnchor.constraint(equalTo: mapContainer.topAnchor),
            mapImage.leftAnchor.constraint(equalTo: mapContainer.leftAnchor),
            mapImage.rightAnchor.constraint(equalTo: mapContainer.rightAnchor),
            mapImage.bottomAnchor.constraint(equalTo: mapContainer.bottomAnchor)
        ])
        
        mapContainer.addSubview(gymLabelsContainer)
        NSLayoutConstraint.activate([
            gymLabelsContainer.centerXAnchor.constraint(equalTo: mapContainer.centerXAnchor),
            gymLabelsContainer.topAnchor.constraint(equalTo: mapContainer.centerYAnchor, constant: 16),
            gymLabelsContainer.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        gymLabelsContainer.addSubview(gymNameLabel)
        NSLayoutConstraint.activate([
            gymNameLabel.topAnchor.constraint(equalTo: gymLabelsContainer.topAnchor, constant: 8),
            gymNameLabel.leftAnchor.constraint(equalTo: gymLabelsContainer.leftAnchor, constant: 8),
            gymNameLabel.rightAnchor.constraint(equalTo: gymLabelsContainer.rightAnchor, constant: -8),
        ])
        
        gymLabelsContainer.addSubview(gymAddressLabel)
        NSLayoutConstraint.activate([
            gymAddressLabel.topAnchor.constraint(equalTo: gymNameLabel.bottomAnchor),
            gymAddressLabel.leftAnchor.constraint(equalTo: gymLabelsContainer.leftAnchor, constant: 8),
            gymAddressLabel.bottomAnchor.constraint(equalTo: gymLabelsContainer.bottomAnchor, constant: -8),
            gymAddressLabel.rightAnchor.constraint(equalTo: gymLabelsContainer.rightAnchor, constant: -8),
        ])
        
        cellContentView.addSubview(likeButton)
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: mapContainer.bottomAnchor, constant: 16),
            likeButton.heightAnchor.constraint(equalToConstant: 28),
            likeButton.widthAnchor.constraint(equalToConstant: 28),
            likeButton.leftAnchor.constraint(equalTo: cellContentView.leftAnchor, constant: 8),
            likeButton.bottomAnchor.constraint(equalTo: cellContentView.bottomAnchor, constant: -16)
        ])
        
        cellContentView.addSubview(amountOfBoosts)
        NSLayoutConstraint.activate([
            amountOfBoosts.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            amountOfBoosts.rightAnchor.constraint(equalTo: cellContentView.rightAnchor, constant: -8),
        ])
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if #available(iOS 13.0, *) {
            guard let workout = workout else { return }
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                if traitCollection.userInterfaceStyle == .dark {
                    mapImage.setWorkoutMapImage(userId: workout.userId, workoutId: workout.workoutId, style: .dark)
                } else if traitCollection.userInterfaceStyle == .light {
                    mapImage.setWorkoutMapImage(userId: workout.userId, workoutId: workout.workoutId, style: .light)
                }
            }
        }
    }
}
