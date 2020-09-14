//
//  ChooseNearestTVC.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-11.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

protocol ChooseNearestTVCDelegate {
    func selected(gym: GymPlaceModel)
}
class ChooseNearestTVC: UITableViewCell {
    static let identifier = "ChooseNearestTVC"
    var delegate: ChooseNearestTVCDelegate?
    var gymLocation: GymPlaceModel?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        config()
    }
    
    func config() {
        self.addTapGestureRecognizer { [self] in
            Vibration.medium.vibrate()
            if let gym = gymLocation {
                delegate?.selected(gym: gym)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
