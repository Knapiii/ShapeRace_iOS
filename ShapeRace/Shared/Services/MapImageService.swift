//
//  MapImageService.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-13.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import Foundation
import Mapbox

class MapImageService {
    static let shared = MapImageService()
    private let WIDTH = 512
    private let HEIGHT = 256
    
    private let mapStyles: [MapBoxService.MapStyle : URL] = [
        MapBoxService.MapStyle.light: MapBoxService.MapStyle.light.url!,
        MapBoxService.MapStyle.dark: MapBoxService.MapStyle.dark.url!
    ]
    
    func generateMapPreviews(mapView: MGLMapView, workout: WorkoutModel, dispatchGroup: DispatchGroup) {
        guard let location = workout.gymCoordinate else { return }
        mapView.setCenter(location, animated: false)
        
        let camera = mapView.camera
        let zoomLevel = mapView.zoomLevel
        dispatchGroup.enter()
        mapStyles.forEach { key, style in
            
            let options = MGLMapSnapshotOptions(styleURL: style, camera: camera, size: CGSize(width: WIDTH, height: HEIGHT))
            options.zoomLevel = zoomLevel
            
            var snapshotter: MGLMapSnapshotter? = MGLMapSnapshotter(options: options)
            
            snapshotter?.start { [self] snapshot, error in
                if error != nil {
                    print("Unable to create a map snapshot.")
                } else if let snapshot = snapshot {
                    let renderer = UIGraphicsImageRenderer(size: CGSize(width: self.WIDTH, height: self.HEIGHT))
                    let ciContext = CIContext(options: nil)
                    guard var ciImage = CIImage(image: snapshot.image) else { return }
                    ciImage = ciImage.oriented(.downMirrored)
                    let cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent)
                    
                    let upperLeft = snapshot.coordinate(for: CGPoint(x: 0, y: 0))
                    let bottomRight = snapshot.coordinate(for: CGPoint(x: WIDTH, y: HEIGHT))
                    
                    let center = CGPoint(x: WIDTH/2, y: HEIGHT/2)
                    
                    let image = renderer.image { context in
                        let cxt = context.cgContext
                        cxt.draw(cgImage!, in: CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT))
                        
                        let markerIconSize = 48
                        let startMarkerX = center.x
                        let startMarkerY = center.y
                        var startMarkerciImage = CIImage(image: UIImage(named: "Dumbbell_Selected")!)!
                        startMarkerciImage = startMarkerciImage.oriented(.downMirrored)
                        let startMarkerciContext = CIContext(options: nil)
                        let startMarkercgImage = startMarkerciContext.createCGImage(startMarkerciImage, from: startMarkerciImage.extent)
                        cxt.draw(startMarkercgImage!, in: CGRect(x: Int(startMarkerX) - Int(markerIconSize/2), y: Int(startMarkerY) - Int(markerIconSize), width: markerIconSize, height: markerIconSize))
                        
                    }
                    
                    StorageAPI.workout.setMapPreview(userId: workout.userId, workoutId: workout.workoutId, mapStyle: key, image: image) { (_) in
                        if dispatchGroup.debugDescription.components(separatedBy: ",").filter({$0.contains("count")}).first!.components(separatedBy: CharacterSet.decimalDigits.inverted).filter({Int($0) != nil}).first! != "0" {
                            
                            dispatchGroup.leave()
                        }
                    }
                    snapshotter = nil
                    
                }
            }
        }
        
    }
    
    
}
