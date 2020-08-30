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
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.activityType = .other
    }
    
    func startTracking() {
        locationManager.startUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    func stopTracking() {
        locationManager.stopUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = false
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        delegate?.locationUpdated(locations[0])
    }
    
    func askUserForLocationRequest() {
        locationManager.requestAlwaysAuthorization()
    }
    
    enum SharingLocation {
        case notDetermined, denied, authorized
    }
    var isUserSharingLocation: SharingLocation {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            return .notDetermined
        case .restricted, .denied:
            return .denied
        case .authorizedWhenInUse, .authorizedAlways:
            return .authorized
        @unknown default:
            return .notDetermined
        }
    }
    
    func askUserToGoToSettingsToUpdateLocationService() {
        if isUserSharingLocation == .denied && !alertIsBeeingViewed, let hasSeen = hasBeenAskedLocation, hasSeen {
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        NotificationCenter.default.post(name: Notis.locationRequestUpdated.name, object: status)
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
