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
        guard let annotation = annotation as? GymLocationAnnotation else { return nil }
        let identifier = "Annotation"
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        annotationView?.annotation = annotation
        return annotationView
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        mapView.addAnnotations(nearestGymLocations.convertToAnnotations)
    }
    
}
