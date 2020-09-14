//
//  ChooseNearestGym+Tableview.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-11.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

extension ChooseNearestGymLocationVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return nearestGymLocations.count
  }
    
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ChooseNearestTVC.identifier, for: indexPath) as! ChooseNearestTVC
    cell.gymLocation = nearestGymLocations[indexPath.row]
    cell.delegate = self
    if let gymName = nearestGymLocations[indexPath.row].name {
        cell.textLabel?.text = gymName
        cell.textLabel?.textColor = SRColor.label
    }
    if nearestGymLocations[indexPath.row] == selectedGym {
        cell.accessoryType = .checkmark
    } else {
        cell.accessoryType = .none
    }
    
    if let gymAdress = nearestGymLocations[indexPath.row].address {
        cell.detailTextLabel?.text = gymAdress
        cell.detailTextLabel?.textColor = SRColor.label
    }

    return cell
  }
}

extension ChooseNearestGymLocationVC: ChooseNearestTVCDelegate {
    func selected(gym: GymPlaceModel) {
        guard let mapView = mapView else { return }
        delegate?.selected(gym: gym)
        
        mapView.removeAnnotations(mapView.annotations ?? [])
        let annotation = gym.convertToAnnotation
        mapView.addAnnotation(annotation)
        mapView.setCenter(annotation.coordinate, zoomLevel: 14, animated: false)
        
        dismiss(animated: true, completion: {
            self.mapView?.removeFromSuperview()
            self.mapView = nil
        })
    }
}
