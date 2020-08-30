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
    
    func configureMapView() {
        setupMapStyle()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.compassView.compassVisibility = .hidden
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
    
    
    func setupMapStyle() {
        if traitCollection.userInterfaceStyle == .dark {
            mapView.styleURL = MGLStyle.darkStyleURL
        } else {
            mapView.styleURL = MGLStyle.lightStyleURL
        }
    }
    
    func configureStartWorkoutButton() {
        startWorkoutButton.setShadow()
        view.addSubview(startWorkoutButton)
        NSLayoutConstraint.activate([
            startWorkoutButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            startWorkoutButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -26),
            startWorkoutButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            startWorkoutButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    func configureLocationButton() {
        view.addSubview(showCurrentLocationButton)
        NSLayoutConstraint.activate([
            showCurrentLocationButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 24),
            showCurrentLocationButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8),
            showCurrentLocationButton.heightAnchor.constraint(equalToConstant: 48 + 8),
            showCurrentLocationButton.widthAnchor.constraint(equalToConstant: 48 + 8)
        ])
        showCurrentLocationButton.addAction {
            Vibration.medium.vibrate()
            self.showCurrentLocation()
        }
    }
    
    
    func configureChooseWorkouteTypeContainer() {
        view.addSubview(chooseWorkouteTypeContainer)
        NSLayoutConstraint.activate([
            chooseWorkouteTypeContainer.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            chooseWorkouteTypeContainer.bottomAnchor.constraint(equalTo: startWorkoutButton.topAnchor, constant: -16),
            chooseWorkouteTypeContainer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
        ])
        
        chooseWorkouteTypeContainer.addSubview(chooseMusclePartsView)
        NSLayoutConstraint.activate([
            chooseMusclePartsView.topAnchor.constraint(equalTo: chooseWorkouteTypeContainer.topAnchor),
            chooseMusclePartsView.leftAnchor.constraint(equalTo: chooseWorkouteTypeContainer.leftAnchor),
            chooseMusclePartsView.bottomAnchor.constraint(equalTo: chooseWorkouteTypeContainer.bottomAnchor),
            chooseMusclePartsView.rightAnchor.constraint(equalTo: chooseWorkouteTypeContainer.rightAnchor),
        ])
        for view in chooseMusclePartsView.leftStackView.arrangedSubviews {
            view.setShadow()
        }
        for view in chooseMusclePartsView.rightStackView.arrangedSubviews {
            view.setShadow()
        }
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                setupMapStyle()
            }
        }
    }
}
