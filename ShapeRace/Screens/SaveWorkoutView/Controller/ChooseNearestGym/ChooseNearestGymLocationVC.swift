//
//  ChooseNearestGymLocationVC.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-11.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit
import Mapbox

protocol ChooseNearestGymLocationDelegate{
    func selected(gym: GymPlaceModel)
}

class ChooseNearestGymLocationVC: UIViewController {

    var mapView: MGLMapView?
    let tableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UITableView())
    
    var workout: WorkoutModel
    var nearestGymLocations: [GymPlaceModel]
    var selectedGym: GymPlaceModel
    var delegate: ChooseNearestGymLocationDelegate?
    
    init(workout: WorkoutModel, selectedGym: GymPlaceModel, nearestGymLocations: [GymPlaceModel]) {
        self.workout = workout
        self.nearestGymLocations = nearestGymLocations
        self.selectedGym = selectedGym
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SRColor.adaptiveBlue
        configureMapView()
        configureTableView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        mapView?.removeFromSuperview()
        mapView = nil
    }
    
    func setupMapStyle() {
        MapBoxService.shared.setupMapStyle(for: mapView!, traitCollection)
    }
    
    func configureMapView() {
        mapView = MGLMapView()
        guard let mapView = mapView else { return }
        setupMapStyle()
        mapView.isUserInteractionEnabled = false
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
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mapView.heightAnchor.constraint(equalToConstant: 230)
        ])
        
        if let selectedGymLocation = selectedGym.coordinates {
            mapView.setCenter(selectedGymLocation, zoomLevel: 14, animated: false)
        }
        
        
    }
    
    func configureTableView() {
        guard let mapView = mapView else { return }
        tableView.dataSource = self
        tableView.register(ChooseNearestTVC.self, forCellReuseIdentifier: ChooseNearestTVC.identifier)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -30),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
    
}
