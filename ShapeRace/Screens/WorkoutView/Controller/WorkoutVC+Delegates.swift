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
            
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        guard annotation.title != nil, annotation.title != "" else { return nil }
        let identifier = "Annotation"
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        annotationView?.annotation = annotation

        return annotationView
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        showCurrentLocation()
    }
    
    @objc func reloadResultInMapBounds() {
        MapBoxService.shared.reloadResultInMapBounds(mapView: mapView) { (gymCenters) in
            for gymCenter in gymCenters {
                if !self.gymCenters.contains(gymCenter) {
                    DispatchQueue.main.async {
                        self.mapView.addAnnotation(gymCenter.convertToAnnotation)
                        self.gymCenters.appendIfNotContains(gymCenter)
                    }
                }
                
            }
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
