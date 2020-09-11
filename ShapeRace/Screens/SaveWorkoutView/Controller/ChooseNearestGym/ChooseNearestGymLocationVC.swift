//
//  ChooseNearestGymLocationVC.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-11.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit
import Mapbox

class ChooseNearestGymLocationVC: UIViewController {

    var mapView: MGLMapView?

    let tableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UITableView())
    
    var workout: WorkoutModel
    var closestGymLocations: [GymLocationModel]
    
    init(workout: WorkoutModel, closestGymLocations: [GymLocationModel]) {
        self.workout = workout
        self.closestGymLocations = closestGymLocations
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
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
    }
    
    func configureTableView() {
        guard let mapView = mapView else { return }
        //tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -30),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
    
}
