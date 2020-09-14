//
//  SaveWorkoutVC.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-07.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit
import Mapbox

class SaveWorkoutVC: UIViewController {
    
    let timerLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = SRColor.label
        $0.font = .monospacedDigitSystemFont(ofSize: 66, weight: .bold)
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    let mapContainer: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        return $0
    }(UIView())
    var mapView: MGLMapView?
    
    let gymNameLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = SRColor.label
        $0.font = .systemFont(ofSize: 34, weight: .semibold)
        $0.minimumScaleFactor = 0.1
        $0.adjustsFontSizeToFitWidth = true
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    let gymAddressLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = SRColor.label
        $0.font = .systemFont(ofSize: 22, weight: .regular)
        $0.minimumScaleFactor = 0.4
        $0.textAlignment = .center
        return $0
    }(UILabel())
    let scrollView: UIScrollView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isPagingEnabled = true
        $0.bounces = true
        $0.showsHorizontalScrollIndicator = false
        return $0
    }(UIScrollView())
    
    var chooseMusclePartsLeftView = ChooseMusclePartsView(side: .left)
    var chooseMusclePartsRightView = ChooseMusclePartsView(side: .right)
    let backButton = WorkoutButton(title: "Back", titleColor: SRColor.label, bgColor: .clear)
    let saveWorkoutButton = WorkoutButton(title: "Save workout", titleColor: .white, bgColor: SRColor.adaptiveBlue)
    let wrongGymButton = WorkoutButton(title: "Is this the correct place?", titleColor: SRColor.label, bgColor: .clear, borderColor: SRColor.adaptiveBlue)
    
    var workout: WorkoutModel
    var nearestGymLocations: [GymPlaceModel]
    var selectedGymPlace: GymPlaceModel
    
    init(workout: WorkoutModel, nearestGymLocations: [GymPlaceModel]) {
        self.workout = workout
        self.nearestGymLocations = nearestGymLocations
        self.selectedGymPlace = nearestGymLocations.first!
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SRColor.background
        configureTimeLabel()
        configureMapView()
        configureGymLocationLabels()
        configureSaveWorkoutButton()
        configureWrongPlaceButton()
        configureMusclePartsView()
        configureBackButton()
        configureWorkout()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        mapView?.removeFromSuperview()
        mapView = nil
    }
    
    private func configureWorkout() {
        self.timerLabel.text = self.workout.workoutTime?.secondsToTimeWithDotsInBetween(includeSeconds: true)
    }
    
    private func saveWorkoutToFirebase() {
        guard let mapView = mapView else { return }
        let name = DB.currentUser.user?.displayNameAndLastNameIfAvailable
        let gymAdress = selectedGymPlace.address
        let gymName = selectedGymPlace.name
        let gymCoordinate = selectedGymPlace.coordinates
        
        workout.userName = name
        workout.gymAddress = gymAdress
        workout.gymName = gymName
        workout.gymCoordinate = gymCoordinate
        
        ProgressHudService.shared.showSpinner()
        DB.workout.uploadWorkout(mapView: mapView, workout: workout) { (result) in
            switch result {
            case .success():
                self.navigationController?.popToRootViewController(animated: true)
                ProgressHudService.shared.dismiss()
            case .failure(let error):
                ProgressHudService.shared.dismiss()
                print(error.localizedDescription)
            }
        }
    }
    
    private func configureBackButton() {
        backButton.contentHorizontalAlignment = .left
        backButton.contentVerticalAlignment = .top
        backButton.titleEdgeInsets.left = 16
        view.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: timerLabel.topAnchor),
            backButton.leftAnchor.constraint(equalTo: view.leftAnchor),
            backButton.bottomAnchor.constraint(equalTo: timerLabel.bottomAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 90)
        ])
        backButton.addAction {
            Vibration.medium.vibrate()
            self.backPressed()
        }
    }
    
    @objc func backPressed() {
        AlertService.shared.showAlert(title: "You are about to delete your workout", text: "Are you sure you want to continue?",
                                     hideAuto: false, amountOfButtonsMax2: 2,
                                     button1Text: "Delete", button2Text: "Cancel", button1Completion: {
            self.navigationController?.popToRootViewController(animated: true)
        })
        
    }
    
    private func configureTimeLabel() {
        view.addSubview(timerLabel)
        NSLayoutConstraint.activate([
            timerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    private func configureMapView() {
        mapContainer.layer.borderWidth = 2
        mapContainer.layer.borderColor = SRColor.adaptiveBlue.cgColor
        view.addSubview(mapContainer)
        NSLayoutConstraint.activate([
            mapContainer.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 8),
            mapContainer.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            mapContainer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8),
            mapContainer.heightAnchor.constraint(equalToConstant: 160)
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
        mapContainer.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: mapContainer.topAnchor, constant: -30),
            mapView.leftAnchor.constraint(equalTo: mapContainer.leftAnchor),
            mapView.bottomAnchor.constraint(equalTo: mapContainer.bottomAnchor, constant: 30),
            mapView.rightAnchor.constraint(equalTo: mapContainer.rightAnchor),
        ])
        let annotation = selectedGymPlace.convertToAnnotation
        mapView.addAnnotation(annotation)
        mapView.setCenter(annotation.coordinate, zoomLevel: 14, animated: false)
    }
    
    func configureGymLocationLabels() {
        gymNameLabel.text = selectedGymPlace.name
        gymAddressLabel.text = selectedGymPlace.address
        view.addSubview(gymNameLabel)
        NSLayoutConstraint.activate([
            gymNameLabel.topAnchor.constraint(equalTo: mapView!.bottomAnchor, constant: -16),
            gymNameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            gymNameLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            
        ])
        view.addSubview(gymAddressLabel)
        NSLayoutConstraint.activate([
            gymAddressLabel.topAnchor.constraint(equalTo: gymNameLabel.bottomAnchor, constant: 8),
            gymAddressLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            gymAddressLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            
        ])
    }
    
    func configureMusclePartsView() {
        chooseMusclePartsRightView.setActive(workout: workout)
        chooseMusclePartsLeftView.setActive(workout: workout)
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.bottomAnchor.constraint(equalTo: wrongGymButton.topAnchor, constant: -16),
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
    
    private func configureWrongPlaceButton() {
        wrongGymButton.isHidden = nearestGymLocations.count <= 1
        view.addSubview(wrongGymButton)
        NSLayoutConstraint.activate([
            wrongGymButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            wrongGymButton.bottomAnchor.constraint(equalTo: saveWorkoutButton.topAnchor, constant: -8),
            wrongGymButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            wrongGymButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        wrongGymButton.addAction { [self] in
            Vibration.medium.vibrate()
            let vc = ChooseNearestGymLocationVC(workout: workout, selectedGym: selectedGymPlace, nearestGymLocations: nearestGymLocations)
            vc.delegate = self
            present(vc, animated: true, completion: nil)
        }
    }
    
    private func configureSaveWorkoutButton() {
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

extension SaveWorkoutVC: ChooseNearestGymLocationDelegate {
    func selected(gym: GymPlaceModel) {
        guard let mapView = mapView else { return }
       
        selectedGymPlace = gym
        mapView.removeAnnotations(mapView.annotations ?? [])
        let annotation = selectedGymPlace.convertToAnnotation
        gymNameLabel.text = gym.name
        gymAddressLabel.text = gym.address
        mapView.addAnnotation(annotation)
        mapView.setCenter(annotation.coordinate, zoomLevel: 14, animated: false)
    }

}

extension SaveWorkoutVC: MGLMapViewDelegate {
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        guard let annotation = annotation as? GymLocationAnnotation else { return nil }
        let identifier = "Annotation"
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        annotationView?.annotation = annotation
        return annotationView
    }

}

extension SaveWorkoutVC: MusclePartButtonDelegate {
    func isSelected(_ type: MuscleParts) {
        workout.bodyParts.append(type)
    }
    
    func isUnselected(_ type: MuscleParts) {
        workout.bodyParts.removeAll(where: { $0 == type })
    }
    
}
