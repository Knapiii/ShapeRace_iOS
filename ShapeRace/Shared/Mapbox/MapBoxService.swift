//
//  MapBoxService.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-01.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import Foundation
import UIKit
import Mapbox
import MapboxGeocoder
import MapboxSearch

class MapBoxService {
    static let shared = MapBoxService()
    let accessTooken = Bundle.infoPlistValue(forKey: "MGLMapboxAccessToken")
    private let token = "pk.eyJ1Ijoia25hcGlpaSIsImEiOiJja2VnNGNqd2kxaHc3MnNydm0wNXRhZmg1In0.GoLBxzSXHOpodB2HCaLc2Q"
    let searchEngine = CategorySearchEngine()
    
    private let geocoder = Geocoder.shared
    
    enum MapStyle: String {
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
    
    func setupMapStyle(for mapView: MGLMapView, _ traitCollection: UITraitCollection) {
        if traitCollection.userInterfaceStyle == .dark {
            mapView.styleURL = MapBoxService.MapStyle.dark.url
        } else {
            mapView.styleURL = MapBoxService.MapStyle.light.url
        }
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
    
    private func getResultFromCategory(_ results: [SearchResult], completion: GymLocationsCompletion) {
        let gymCenters = results.map({ result -> GymPlaceModel in
            let gymCenter = GymPlaceModel(id: result.id, name: result.name, adress: result.address?.street, city: result.address?.place, coordinates: result.coordinate, categories: result.categories)
            return gymCenter
        })
        completion(gymCenters)
        
    }
    
    func forwardGeoCodingGymCategory(completion: @escaping GymLocationsCompletion) {
        guard let currentLocation = LocationManagerService.shared.currentLocation else { return }
        let mapboxSFOfficeCoordinate = CLLocationCoordinate2D(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        let requestOptions = CategorySearchEngine.RequestOptions(proximity: mapboxSFOfficeCoordinate)
        searchEngine.search(categoryName: "gym", options: requestOptions) { response in
            do {
                let results = try response.get()
                self.getResultFromCategory(results, completion: completion)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func reloadResultInMapBounds(mapView: MGLMapView, completion: @escaping GymLocationsCompletion) {
        guard let currentLocation = LocationManagerService.shared.currentLocation else { return }
        let mapboxSFOfficeCoordinate = CLLocationCoordinate2D(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        
        let boundingBox = BoundingBox(mapView.visibleCoordinateBounds.sw, mapView.visibleCoordinateBounds.ne)
        let requestOptions = CategorySearchEngine.RequestOptions(proximity: mapboxSFOfficeCoordinate, boundingBox: boundingBox)
        
        searchEngine.search(categoryName: "gym", options: requestOptions) { response in
            do {
                let results = try response.get()
                self.getResultFromCategory(results, completion: completion)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

}

