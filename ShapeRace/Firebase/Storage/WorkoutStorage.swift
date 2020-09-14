//
//  WorkoutStorage.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-13.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage

class WorkoutStorage {
    static let shared = WorkoutStorage()
    
    func setMapPreview(userId: String, workoutId: String, mapStyle: MapBoxService.MapStyle, image: UIImage?, completion: @escaping VoidCompletion) {
        guard let imageData = image?.jpegData(compressionQuality: 0.4) else { return }
        switch mapStyle {
        case .light:
            CacheService.shared.workoutMapLightImages[workoutId] = image
        case .dark:
            CacheService.shared.workoutMapDarkImages[workoutId] = image
        }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        StorageService.Ref.WorkoutMap.shared.mapImageReference(userId: userId, workoutId: workoutId, mapStyle: mapStyle).putData(imageData, metadata: metadata) { (storageMetaData, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            completion(.success((())))
        }
    }
    
}
