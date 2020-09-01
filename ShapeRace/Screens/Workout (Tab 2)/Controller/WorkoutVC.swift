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
    let chooseWorkouteTypeContainer: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    var topTimerView = TopTimerView()
    let chooseMusclePartsView = ChooseMusclePartsView()

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
        configureChooseWorkouteTypeContainer()
        configTopTimerView()
        configureLocationButton()
        showCurrentLocation()
        notificationHandler()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBarController?.tabBar.isTranslucent = true
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
