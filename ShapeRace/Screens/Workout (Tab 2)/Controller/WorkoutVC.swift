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
    let startWorkoutButton = SRDefaultButton(title: "Start workout", titleColor: .white, bgColor: SRColor.adaptiveBlue)
    let chooseWorkouteTypeContainer: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    let chooseMusclePartsView = ChooseMusclePartsView()

    let showCurrentLocationButton: UIButton = {
        $0.backgroundColor = .clear
        $0.setImage(UIImage(named: "Follow_Active"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
        $0.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIButton())

    override func viewDidLoad() {
        super.viewDidLoad()
        configureMapView()
        configureStartWorkoutButton()
        configureChooseWorkouteTypeContainer()
        configureLocationButton()
        showCurrentLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBarController?.tabBar.isTranslucent = true
    }
    
    
}

extension WorkoutVC: MGLMapViewDelegate {
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        showCurrentLocation()
    }
}
