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

class MapBoxService {
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
    
    static let shared = MapBoxService()

    
}


class GeocodingService {
    static let shared = GeocodingService()

    private let startUrl = "https://api.mapbox.com/geocoding/v5/mapbox.places/"
    private let proximity = "proximity="
    private let language = "&language=\(Locale.preferredLocalLanguageCountryCode)"
    private let token = "&access_token=pk.eyJ1IjoiZGV0ZWNodCIsImEiOiJjazAzd2l6MHUwaTFjM2hvMndnazJ2ZWRpIn0.iir3VRG6Co_GaJQ2TbVHUA"
    
    private let geocoder = Geocoder(accessToken: "pk.eyJ1IjoiZGV0ZWNodCIsImEiOiJjazAzd2l6MHUwaTFjM2hvMndnazJ2ZWRpIn0.iir3VRG6Co_GaJQ2TbVHUA")

    private func buildUrl(currentLocation: CLLocationCoordinate2D, search: String) -> String? {
        let proximityString = proximity + "\(currentLocation.longitude),\(currentLocation.latitude)"
        let urlString = startUrl + search + ".json?" + proximityString + language + token
        return urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
    
    
    func searchForLocation(currentLocation: CLLocationCoordinate2D, searchText: String) {
        guard let urlString = buildUrl(currentLocation: currentLocation, search: searchText) else { return }
        URLSession.shared.dataTask(with: URL(string: urlString)!) { (data, response, error) in
            if let data = data {
                do {
                    let dict = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                    if let results = dict?["features"] as? [[String:Any]] {
                        results.forEach({
                            if let center = $0["center"] as? [Double] {
//                                if let waypoint = DTWaypoint(lon: center.first, lat: center.last, displayText: $0["place_name"] as? String) {
//                                    waypoints.append(waypoint)
//                                }
                            }
                        })
                    }
                } catch {
                    print("Error serializing json")
                }
            }
        }.resume()
        
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
