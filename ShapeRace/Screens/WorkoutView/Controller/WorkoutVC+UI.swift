//
//  WorkoutVC+UI.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-30.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit
import Mapbox

extension WorkoutVC {
    
    @objc func updateTimer(_ notification: Notification) {
        if let seconds = notification.object as? Int {
            topTimerView.timerSeconds = seconds
        }
    }
    
    func configureMapView() {
        MapBoxService.shared.setupMapStyle(for: mapView, traitCollection)

        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.compassView.compassVisibility = .hidden
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: -80),
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 80),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
    
    func configureStartWorkoutButton() {
        startWorkoutBottomConstraint = bottomButtonStackView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -24)
        view.addSubview(bottomButtonStackView)
        NSLayoutConstraint.activate([
            bottomButtonStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            startWorkoutBottomConstraint!,
            bottomButtonStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            bottomButtonStackView.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        cancelWorkoutButton.isHidden = true
        bottomButtonStackView.addArrangedSubview(cancelWorkoutButton)
        bottomButtonStackView.addArrangedSubview(startWorkoutButton)
        
        startWorkoutButton.setShadow()
        cancelWorkoutButton.setShadow()
        
        startWorkoutButton.addAction {
            self.startWorkoutButtonPressed()
        }
        
        cancelWorkoutButton.addAction {
            self.cancelWorkoutButtonPressed()
        }
    }
    
    func configTopTimerView() {
        view.addSubview(topTimerView)
        topTimerTopConstraint = topTimerView.topAnchor.constraint(equalTo: view.topAnchor, constant: -175)
        NSLayoutConstraint.activate([
            topTimerTopConstraint!,
            topTimerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            topTimerView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
    
    func configureLocationButton() {
        locationButtonTopConstraint = showCurrentLocationButton.topAnchor.constraint(equalTo: topTimerView.safeAreaLayoutGuide.bottomAnchor, constant: 62)
        view.addSubview(showCurrentLocationButton)
        NSLayoutConstraint.activate([
            locationButtonTopConstraint!,
            showCurrentLocationButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8),
            showCurrentLocationButton.heightAnchor.constraint(equalToConstant: 48 + 8),
            showCurrentLocationButton.widthAnchor.constraint(equalToConstant: 48 + 8)
        ])
        showCurrentLocationButtonPressed()
    }
    
    func configureMusclePartsView() {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomButtonStackView.topAnchor, constant: -16),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
        
        let stackView: UIStackView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .equalSpacing
            $0.spacing = 16
            return $0
        }(UIStackView())
        
        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 16),
            stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 16),

        ])
        chooseMusclePartsLeftView.delegate = self
        chooseMusclePartsRightView.delegate = self
        stackView.addArrangedSubview(chooseMusclePartsLeftView)
        stackView.addArrangedSubview(chooseMusclePartsRightView)
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                MapBoxService.shared.setupMapStyle(for: mapView, traitCollection)
            }
        }
    }
}
