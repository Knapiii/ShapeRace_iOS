//
//  LocationManagerService.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-25.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

protocol LocationServiceDelegate {
    func locationUpdated(_ location: CLLocation)
}


class LocationManagerService: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManagerService()
    var locationManager = CLLocationManager()
    var delegate: LocationServiceDelegate?
    private var alertIsBeeingViewed = false
    private var hasBeenAskedLocation: Bool? = nil
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.activityType = .automotiveNavigation
    }
    
    func startTracking() {
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    func stopTracking() {
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
        locationManager.allowsBackgroundLocationUpdates = false
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        delegate?.locationUpdated(locations[0])
    }
    
    var isUserSharingLocation: Bool {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined, .restricted, .denied:
            return false
        case .authorizedWhenInUse, .authorizedAlways:
            return true
        @unknown default:
            return false
        }
    }
    
    func askUserToGoToSettingsToUpdateLocationService() {
        if !isUserSharingLocation && !alertIsBeeingViewed, let hasSeen = hasBeenAskedLocation, hasSeen {
            alertIsBeeingViewed = true
            
        }
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            hasBeenAskedLocation = false
        case .denied, .restricted:
            hasBeenAskedLocation = true
            break
        case .authorizedAlways:
            hasBeenAskedLocation = true
            break
        case .authorizedWhenInUse:
            hasBeenAskedLocation = true
            break
        @unknown default:
            fatalError()
        }
    }
}
