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
    
    let scrollView : UIScrollView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.bounces = true
        return $0
    }(UIScrollView())
    
    let contentView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    let mainStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        return $0
    }(UIStackView())
    
    let timerContainer: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    let timerLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = SRColor.label
        $0.font = .monospacedDigitSystemFont(ofSize: 66, weight: .bold)
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    var mapView: MGLMapView?
    
    let mapContainer: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    let gymInfoContainer: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
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
    
    let bodyPartsContainer: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    let bodyPartsScrollView: UIScrollView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isPagingEnabled = true
        $0.bounces = true
        $0.showsHorizontalScrollIndicator = false
        return $0
    }(UIScrollView())
    let wrongGymContainer: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    let descriptionContainer: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    let descriptionPlaceholderText: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = SRColor.label
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.text = "Description"
        return $0
    }(UILabel())
    let descriptionTextField: UITextView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 12
        $0.font = .systemFont(ofSize: 17, weight: .regular)
        $0.backgroundColor = SRColor.tertiaryLabel.withAlphaComponent(0.1)
        $0.setShadow()
        return $0
    }(UITextView())
    
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
        configureUI()
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
    
    func saveWorkoutToFirebase() {
        guard let mapView = mapView else { return }
        let name = DB.currentUser.user?.displayNameAndLastNameIfAvailable
        let gymAdress = selectedGymPlace.address
        let gymName = selectedGymPlace.name
        let gymCoordinate = selectedGymPlace.coordinates
        
        workout.userName = name
        workout.gymAddress = gymAdress
        workout.gymName = gymName
        workout.gymCoordinate = gymCoordinate
        workout.descriptionText = descriptionTextField.text
        
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
    
    @objc func backPressed() {
        AlertService.shared.showAlert(title: "You are about to delete your workout", text: "Are you sure you want to continue?", hideAuto: false, amountOfButtonsMax2: 2, button1Text: "Delete", button2Text: "Cancel", button1Completion: {
            self.navigationController?.popToRootViewController(animated: true)
        })
        
    }
    
    
}

extension SaveWorkoutVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.contentInset = UIEdgeInsets.zero
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
