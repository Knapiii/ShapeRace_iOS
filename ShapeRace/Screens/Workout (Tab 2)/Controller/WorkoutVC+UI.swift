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
            mapView.styleURL = MapBoxService.MapStyle.dark.url
        } else {
            mapView.styleURL = MapBoxService.MapStyle.light.url
        }
    }
    
    func configureStartWorkoutButton() {
        startWorkoutButton.setShadow()
        startWorkoutBottomConstraint = startWorkoutButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -26)
        view.addSubview(startWorkoutButton)
        NSLayoutConstraint.activate([
            startWorkoutButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            startWorkoutBottomConstraint!,
            startWorkoutButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            startWorkoutButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        startWorkoutButton.addAction {
            Vibration.medium.vibrate()
            self.startWorkout()
        }
    }
    
    func configTopTimerView() {
        view.addSubview(topTimerView)
        topTimerTopConstraint = topTimerView.topAnchor.constraint(equalTo: view.topAnchor, constant: -160)
        NSLayoutConstraint.activate([
            topTimerTopConstraint!,
            topTimerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            topTimerView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
    
    func configureLocationButton() {
        locationButtonTopConstraint = showCurrentLocationButton.topAnchor.constraint(equalTo: topTimerView.bottomAnchor, constant: 42)
        view.addSubview(showCurrentLocationButton)
        NSLayoutConstraint.activate([
            locationButtonTopConstraint!,
            showCurrentLocationButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8),
            showCurrentLocationButton.heightAnchor.constraint(equalToConstant: 48 + 8),
            showCurrentLocationButton.widthAnchor.constraint(equalToConstant: 48 + 8)
        ])
        showCurrentLocationButton.addAction {
            Vibration.medium.vibrate()
            self.showCurrentLocation()
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
