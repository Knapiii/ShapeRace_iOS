//
//  SaveWorkout+UI.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-15.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit
import Mapbox

extension SaveWorkoutVC {
    
    func addViewsToMainStackView() {
        mainStackView.addArrangedSubview(timerContainer)
        mainStackView.addArrangedSubview(mapContainer)
        mainStackView.addArrangedSubview(gymInfoContainer)
        if nearestGymLocations.count <= 1 {
            mainStackView.addArrangedSubview(wrongGymContainer)
        }
        mainStackView.addArrangedSubview(bodyPartsContainer)
        mainStackView.addArrangedSubview(descriptionContainer)
    }
    
    func configureUI() {
        configureSaveWorkoutButton()
        setupScrollView()
        configureTimeLabel()
        configureBackButton()
        configureMapView()
        configureGymLocationLabels()
        configureWrongPlaceButton()
        configureMusclePartsView()
        configureDescription()
        addViewsToMainStackView()
    }
    
    func setupScrollView() {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: saveWorkoutButton.topAnchor, constant: -16)
        ])
        
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
        ])
        
        contentView.addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
        ])
    }
    
    func configureBackButton() {
        backButton.contentHorizontalAlignment = .left
        backButton.contentVerticalAlignment = .top
        backButton.titleEdgeInsets.left = 16
        timerContainer.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: timerContainer.safeAreaLayoutGuide.topAnchor, constant: 8),
            backButton.leftAnchor.constraint(equalTo: timerContainer.leftAnchor),
            backButton.bottomAnchor.constraint(equalTo: timerContainer.bottomAnchor, constant: -8),
            backButton.widthAnchor.constraint(equalToConstant: 90)
        ])
        backButton.addAction {
            Vibration.medium.vibrate()
            self.backPressed()
        }
    }
    
    func configureTimeLabel() {
        timerContainer.addSubview(timerLabel)
        NSLayoutConstraint.activate([
            timerLabel.topAnchor.constraint(equalTo: timerContainer.safeAreaLayoutGuide.topAnchor, constant: 16),
            timerLabel.bottomAnchor.constraint(equalTo: timerContainer.bottomAnchor),
            timerLabel.leftAnchor.constraint(equalTo: timerContainer.leftAnchor),
            timerLabel.rightAnchor.constraint(equalTo: timerContainer.rightAnchor),
            timerLabel.heightAnchor.constraint(equalToConstant: 80),
        ])
    }
    
    func configureMapView() {
        let mapBorderContainer: UIView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 12
            return $0
        }(UIView())
        mapBorderContainer.layer.borderWidth = 2
        mapBorderContainer.layer.borderColor = SRColor.adaptiveBlue.cgColor
        mapContainer.addSubview(mapBorderContainer)
        NSLayoutConstraint.activate([
            mapBorderContainer.topAnchor.constraint(equalTo: mapContainer.topAnchor, constant: 8),
            mapBorderContainer.leftAnchor.constraint(equalTo: mapContainer.leftAnchor, constant: 8),
            mapBorderContainer.rightAnchor.constraint(equalTo: mapContainer.rightAnchor, constant: -8),
            mapBorderContainer.bottomAnchor.constraint(equalTo: mapContainer.bottomAnchor),
            mapBorderContainer.heightAnchor.constraint(equalToConstant: 160),
        ])
        mapView = MGLMapView()
        guard let mapView = mapView else { return }
        MapBoxService.shared.setupMapStyle(for: mapView, traitCollection)
        mapView.isUserInteractionEnabled = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.compassView.compassVisibility = .hidden
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        mapBorderContainer.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: mapBorderContainer.topAnchor, constant: -30),
            mapView.leftAnchor.constraint(equalTo: mapBorderContainer.leftAnchor),
            mapView.bottomAnchor.constraint(equalTo: mapBorderContainer.bottomAnchor, constant: 30),
            mapView.rightAnchor.constraint(equalTo: mapBorderContainer.rightAnchor),
        ])
        let annotation = selectedGymPlace.convertToAnnotation
        mapView.addAnnotation(annotation)
        mapView.setCenter(annotation.coordinate, zoomLevel: 14, animated: false)
        
    }
    
    func configureGymLocationLabels() {
        gymNameLabel.text = selectedGymPlace.name
        gymAddressLabel.text = selectedGymPlace.address
        gymInfoContainer.addSubview(gymNameLabel)
        NSLayoutConstraint.activate([
            gymNameLabel.topAnchor.constraint(equalTo: gymInfoContainer.topAnchor, constant: 16),
            gymNameLabel.leftAnchor.constraint(equalTo: gymInfoContainer.leftAnchor, constant: 16),
            gymNameLabel.rightAnchor.constraint(equalTo: gymInfoContainer.rightAnchor, constant: -16),
        ])
        gymInfoContainer.addSubview(gymAddressLabel)
        NSLayoutConstraint.activate([
            gymAddressLabel.topAnchor.constraint(equalTo: gymNameLabel.bottomAnchor),
            gymAddressLabel.leftAnchor.constraint(equalTo: gymInfoContainer.leftAnchor, constant: 16),
            gymAddressLabel.rightAnchor.constraint(equalTo: gymInfoContainer.rightAnchor, constant: -16),
            gymAddressLabel.bottomAnchor.constraint(equalTo: gymInfoContainer.bottomAnchor),
        ])
    }
    
    func configureWrongPlaceButton() {
        
        wrongGymContainer.addSubview(wrongGymButton)
        NSLayoutConstraint.activate([
            wrongGymButton.topAnchor.constraint(equalTo: wrongGymContainer.topAnchor, constant: 8),
            wrongGymButton.leftAnchor.constraint(equalTo: wrongGymContainer.leftAnchor, constant: 16),
            wrongGymButton.bottomAnchor.constraint(equalTo: wrongGymContainer.bottomAnchor),
            wrongGymButton.rightAnchor.constraint(equalTo: wrongGymContainer.rightAnchor, constant: -16),
            wrongGymButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        wrongGymButton.addAction { [self] in
            Vibration.medium.vibrate()
            let vc = ChooseNearestGymLocationVC(workout: workout, selectedGym: selectedGymPlace, nearestGymLocations: nearestGymLocations)
            vc.delegate = self
            present(vc, animated: true, completion: nil)
        }
    }
    
    func configureMusclePartsView() {
        chooseMusclePartsRightView.setActive(workout: workout)
        chooseMusclePartsLeftView.setActive(workout: workout)
        bodyPartsContainer.addSubview(bodyPartsScrollView)
        NSLayoutConstraint.activate([
            bodyPartsScrollView.topAnchor.constraint(equalTo: bodyPartsContainer.topAnchor, constant: 16),
            bodyPartsScrollView.leftAnchor.constraint(equalTo: bodyPartsContainer.leftAnchor),
            bodyPartsScrollView.bottomAnchor.constraint(equalTo: bodyPartsContainer.bottomAnchor),
            bodyPartsScrollView.rightAnchor.constraint(equalTo: bodyPartsContainer.rightAnchor),
        ])
        
        let stackView: UIStackView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .equalSpacing
            $0.spacing = 16
            return $0
        }(UIStackView())
        
        bodyPartsScrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: bodyPartsScrollView.centerYAnchor),
            stackView.topAnchor.constraint(equalTo: bodyPartsScrollView.topAnchor, constant: 16),
            stackView.leftAnchor.constraint(equalTo: bodyPartsScrollView.leftAnchor, constant: 16),
            stackView.rightAnchor.constraint(equalTo: bodyPartsScrollView.rightAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bodyPartsScrollView.bottomAnchor, constant: 16),
            
        ])
        chooseMusclePartsLeftView.delegate = self
        chooseMusclePartsRightView.delegate = self
        stackView.addArrangedSubview(chooseMusclePartsLeftView)
        stackView.addArrangedSubview(chooseMusclePartsRightView)
    }
    
    func configureDescription() {
        descriptionTextField.clipsToBounds = true
        descriptionTextField.delegate = self
        descriptionContainer.addSubview(descriptionPlaceholderText)
        NSLayoutConstraint.activate([
            descriptionPlaceholderText.topAnchor.constraint(equalTo: descriptionContainer.topAnchor, constant: 16),
            descriptionPlaceholderText.leftAnchor.constraint(equalTo: descriptionContainer.leftAnchor, constant: 16),
            descriptionPlaceholderText.rightAnchor.constraint(equalTo: descriptionContainer.rightAnchor, constant: -16),
            descriptionPlaceholderText.heightAnchor.constraint(equalToConstant: 22),
        ])
        
        descriptionContainer.addSubview(descriptionTextField)
        NSLayoutConstraint.activate([
            descriptionTextField.topAnchor.constraint(equalTo: descriptionPlaceholderText.bottomAnchor, constant: 4),
            descriptionTextField.leftAnchor.constraint(equalTo: descriptionContainer.leftAnchor, constant: 16),
            descriptionTextField.rightAnchor.constraint(equalTo: descriptionContainer.rightAnchor, constant: -16),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 90),
            descriptionTextField.bottomAnchor.constraint(equalTo: descriptionContainer.bottomAnchor),
        ])
    }
    
    func configureSaveWorkoutButton() {
        view.addSubview(saveWorkoutButton)
        NSLayoutConstraint.activate([
            saveWorkoutButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            saveWorkoutButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -24),
            saveWorkoutButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            saveWorkoutButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        saveWorkoutButton.addAction {
            Vibration.medium.vibrate()
            self.saveWorkoutToFirebase()
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                guard let mapView = mapView else { return }
                mapContainer.layer.borderColor = SRColor.adaptiveBlue.cgColor
                MapBoxService.shared.setupMapStyle(for: mapView, traitCollection)
            }
        }
    }
}
