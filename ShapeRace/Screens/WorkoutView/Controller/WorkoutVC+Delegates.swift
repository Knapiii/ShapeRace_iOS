//
//  WorkoutVC+Delegates.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-01.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit
import Mapbox

extension WorkoutVC: MusclePartButtonDelegate {
    func isSelected(_ type: MusclePartButton.MuscleParts) {
        workout?.bodyParts.append(type.rawValue)
    }
    
    func isUnselected(_ type: MusclePartButton.MuscleParts) {
        workout?.bodyParts.removeAll(where: { $0 == type.rawValue })
    }
    
}

extension WorkoutVC: MGLMapViewDelegate {
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        showCurrentLocation()
    }
    
    @objc func reloadResultInMapBounds() {
        MapBoxService.shared.reloadResultInMapBounds(mapView: mapView) { (annotations) in

            self.mapView.addAnnotations(annotations)
        }
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, regionDidChangeWith reason: MGLCameraChangeReason, animated: Bool) {
        guard reason != .programmatic else { return }
        draggingRefreshTimer?.invalidate()
        draggingRefreshTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(reloadResultInMapBounds), userInfo: nil, repeats: false)
    }
}
