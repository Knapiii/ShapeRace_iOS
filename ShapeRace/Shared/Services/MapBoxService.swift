//
//  MapBoxService.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-01.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import Foundation
import Mapbox
import MapboxGeocoder
import MapboxSearch

class MapBoxService {
    static let shared = MapBoxService()
    let accessTooken = Bundle.infoPlistValue(forKey: "MGLMapboxAccessToken")
    private let token = "pk.eyJ1Ijoia25hcGlpaSIsImEiOiJja2VnNGNqd2kxaHc3MnNydm0wNXRhZmg1In0.GoLBxzSXHOpodB2HCaLc2Q"
    let searchEngine = CategorySearchEngine()
    
    private let geocoder = Geocoder.shared
    
    enum MapStyle {
        case light, dark
        
        var url: URL? {
            switch self {
            case .light:
                return URL(string: "mapbox://styles/knapiii/ckejtdwea51s61apv30gmwvry")
            case .dark:
                return URL(string: "mapbox://styles/knapiii/ckejtfum10ckr19qvmpg6wepx")
            }
        }
    }
    
    
    func forwardGeoCoding(completion: @escaping MGLAnnotationsCompletion) {
        guard let currentLocation = LocationManagerService.shared.currentLocation else { return }
        let mapboxSFOfficeCoordinate = CLLocationCoordinate2D(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        let requestOptions = CategorySearchEngine.RequestOptions(proximity: mapboxSFOfficeCoordinate)
        requestOptions.boundingBox
        searchEngine.search(categoryName: "gym", options: requestOptions) { response in
            do {
                let results = try response.get()
                self.displaySearchResults(results, completion: completion)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func reloadResultInMapBounds(mapView: MGLMapView, completion: @escaping MGLAnnotationsCompletion) {
        guard let currentLocation = LocationManagerService.shared.currentLocation else { return }
        let mapboxSFOfficeCoordinate = CLLocationCoordinate2D(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        
        let boundingBox = BoundingBox(mapView.visibleCoordinateBounds.sw, mapView.visibleCoordinateBounds.ne)
        let requestOptions = CategorySearchEngine.RequestOptions(proximity: mapboxSFOfficeCoordinate, boundingBox: boundingBox)
        
        searchEngine.search(categoryName: "gym", options: requestOptions) { response in
            do {
                let results = try response.get()
                self.displaySearchResults(results, completion: completion)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func displaySearchResults(_ results: [SearchResult], completion: MGLAnnotationsCompletion) {
        let annotations = results.map({ result -> MGLAnnotation in
            let pointAnnotation = MGLPointAnnotation()
            pointAnnotation.title = result.name
            pointAnnotation.subtitle = result.address?.formattedAddress(style: .medium)
            pointAnnotation.coordinate = result.coordinate
            pointAnnotation.title = result.name
            if let adress = result.address?.street {
                pointAnnotation.subtitle = adress
            }
            return pointAnnotation
        })
        completion(annotations)
    }
    
    func reverseGeoCoding(from coordinate: CLLocationCoordinate2D, dispatchGroup: DispatchGroup? = nil, completion: @escaping StringCompletion) {
        let options = ReverseGeocodeOptions(coordinate: coordinate)
        dispatchGroup?.enter()
        geocoder.geocode(options) { (placemarks, attribution, error) in
            guard let placemark = placemarks?.first else {
                dispatchGroup?.leave()
                return
            }
            if let adress = placemark.qualifiedName {
                completion(.success(adress))
                dispatchGroup?.leave()
            } else {
                dispatchGroup?.leave()
            }
        }
    }
    
}


extension Locale {
    
    /**
     Given the app's localized language setting, returns a string representing the user's localization.
     */
    public static var preferredLocalLanguageCountryCode: String {
        let firstBundleLocale = Bundle.main.preferredLocalizations.first!
        let bundleLocale = firstBundleLocale.components(separatedBy: "-")
        
        if bundleLocale.count > 1 {
            return firstBundleLocale
        }
        
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            return "\(bundleLocale.first!)-\(countryCode)"
        }
        
        return firstBundleLocale
    }
    
    /**
     Returns a `Locale` from `preferredLocalLanguageCountryCode`.
     */
    public static var nationalizedCurrent = Locale(identifier: preferredLocalLanguageCountryCode)
    
    public static var usesMetric: Bool {
        let locale = self.current as NSLocale
        guard let measurementSystem = locale.object(forKey: .measurementSystem) as? String else {
            return false
        }
        return measurementSystem == "Metric"
    }
    
    public var usesMetric: Bool {
        let locale = self as NSLocale
        guard let measurementSystem = locale.object(forKey: .measurementSystem) as? String else {
            return false
        }
        return measurementSystem == "Metric"
    }
}

extension Bundle {
    static func infoPlistValue(forKey key: String) -> Any? {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) else {
            return nil
        }
        return value
    }
}
