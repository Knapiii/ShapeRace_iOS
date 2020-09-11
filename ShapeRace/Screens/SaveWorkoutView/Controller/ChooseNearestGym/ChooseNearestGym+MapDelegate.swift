//
//  ChooseNearestGym+MapDelegate.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-11.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//


import UIKit
import Mapbox

extension ChooseNearestGymLocationVC: MGLMapViewDelegate {
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        guard annotation.title != nil, annotation.title != "" else { return nil }
        let identifier = "Annotation"
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        annotationView?.annotation = annotation

        return annotationView
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        showCurrentLocation()
        mapView.addAnnotations(closestGymLocations.convertToAnnotations)
    }

    func showCurrentLocation() {
        if LocationManagerService.shared.isUserSharingLocation == .authorized {
            if let location = LocationManagerService.shared.currentLocation {
                mapView?.setCenter(location, zoomLevel: 14, animated: true)
            }
            
        } else if LocationManagerService.shared.isUserSharingLocation == .notDetermined {
            LocationManagerService.shared.askUserForLocationRequest()
        } 
    }
    
}
