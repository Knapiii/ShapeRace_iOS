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
    return closestGymLocations.count
  }
    
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
    cell.selectionStyle = .none
    if let gymName = closestGymLocations[indexPath.row].name {
        cell.textLabel?.text = gymName
        cell.textLabel?.textColor = SRColor.label
    }
    
    if let gymAdress = closestGymLocations[indexPath.row].adress {
        cell.detailTextLabel?.text = gymAdress
        cell.detailTextLabel?.textColor = SRColor.label
    }

    return cell
  }
}
