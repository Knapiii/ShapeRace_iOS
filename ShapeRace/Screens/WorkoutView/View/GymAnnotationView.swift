//
//  GymAnnotationView.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-15.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import Foundation
import Mapbox

class GymAnnotationView: MGLAnnotationView {
    var image = UIImage()
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    var gymPlace: GymPlaceModel?
    
    init(annotation: GymLocationAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        scalesWithViewingDistance = false
        isDraggable = false
        frame = CGRect(x: 0, y: 0, width: 39.6, height: 50)
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leftAnchor.constraint(equalTo: leftAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.rightAnchor.constraint(equalTo: rightAnchor),
        ])
        
        self.gymPlace = annotation?.gymLocation
        if traitCollection.userInterfaceStyle == .dark {
            imageView.image = UIImage(named: "Empty_POI_Dark_Blue")
        } else {
            imageView.image = UIImage(named: "Empty_POI_Light_Blue")
        }
        centerOffset.dy = (-bounds.height / 2) + 5

    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                if traitCollection.userInterfaceStyle == .dark {
                    imageView.image = UIImage(named: "Empty_POI_Dark_Blue")
                } else {
                    imageView.image = UIImage(named: "Empty_POI_Light_Blue")
                }
            }
        }
    }
    
}
