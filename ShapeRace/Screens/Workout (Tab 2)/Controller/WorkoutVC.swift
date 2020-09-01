//
//  WorkoutVC.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-24.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit
import Mapbox

class WorkoutVC: UIViewController {
    let mapView = MGLMapView()
    let startWorkoutButton = StartWorkoutButton(title: "Start workout", titleColor: .white, bgColor: SRColor.adaptiveBlue)
    var topTimerView = TopTimerView()
    let chooseMusclePartsLeftView = ChooseMusclePartsView(viewNumber: 1)
    let chooseMusclePartsRightView = ChooseMusclePartsView(viewNumber: 2)

    let showCurrentLocationButton: UIButton = {
        $0.backgroundColor = .clear
        $0.setImage(UIImage(named: "Follow_Active"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
        $0.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIButton())

    var topTimerTopConstraint: NSLayoutConstraint?
    var startWorkoutBottomConstraint: NSLayoutConstraint?
    var locationButtonTopConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureMapView()
        configureStartWorkoutButton()
        configTopTimerView()
        configureLocationButton()
        showCurrentLocation()
        notificationHandler()
        configureMusclePartsView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBarController?.tabBar.isTranslucent = true
    }
    
    func configureMusclePartsView() {
        let scrollView: UIScrollView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.isPagingEnabled = true
            $0.bounces = true
            $0.showsHorizontalScrollIndicator = false
            return $0
        }(UIScrollView())
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.bottomAnchor.constraint(equalTo: startWorkoutButton.topAnchor, constant: -16),
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
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 16),
            stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -16)
        ])
        NSLayoutConstraint.activate([
            scrollView.heightAnchor.constraint(equalTo: stackView.heightAnchor)
        ])
        chooseMusclePartsLeftView.delegate = self
        chooseMusclePartsRightView.delegate = self
        stackView.addArrangedSubview(chooseMusclePartsLeftView)
        stackView.addArrangedSubview(chooseMusclePartsRightView)
    }
    
    func notificationHandler() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateTimer(_:)), name: Notis.workoutTimeUpdate.name, object: nil)
    }
    
    @objc func updateTimer(_ notification: Notification) {
        if let seconds = notification.object as? Int {
            topTimerView.timerSeconds = seconds
        }
    }
    
}

extension WorkoutVC: MGLMapViewDelegate {
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        showCurrentLocation()
    }
}
