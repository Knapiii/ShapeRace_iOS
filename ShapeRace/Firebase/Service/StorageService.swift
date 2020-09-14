//
//  StorageService.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-05.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

enum ImageRef: String {
    case profileImage = "profile_images"
    case workoutMapImages = "workout_map_images"
    case workoutImages = "workout_images"
    
}

struct StorageService {
    
    static let storageRoot = Storage.storage().reference()
    
    struct Ref {
        //MARK: - Profile Image
        struct Profile {
            static func profile(userId: String) -> StorageReference {
                return storageRoot.child(ImageRef.profileImage.rawValue).child(userId + ".jpg")
            }
            static func specific(id: String, asThumbnail: Bool = false) -> StorageReference {
                let size = asThumbnail ? 128 : 512
                return storageRoot.child(ImageRef.profileImage.rawValue).child("\(id).jpg")
                //return storageRoot.child(ImageRef.profileImage.rawValue).child("\(id)-thumb@\(size).jpg")
            }
        }
        //MARK: - Workout Map Image
        struct WorkoutMap {
            static let shared = WorkoutMap()
            func mapImageFolder(userId: String, workoutId: String) -> StorageReference {
                return storageRoot.child(ImageRef.workoutMapImages.rawValue).child(userId).child(workoutId)
            }
            
            func mapImageReference(userId: String, workoutId: String, mapStyle: MapBoxService.MapStyle) -> StorageReference {
                mapImageFolder(userId: userId, workoutId: workoutId).child("\(workoutId)_\(mapStyle.rawValue).jpg")
            }
        }
                
        //MARK: - Workout Photos
        struct WorkoutPhotos {
            static var photo: StorageReference {
                return storageRoot.child(ImageRef.workoutImages.rawValue)
            }
            
            static func workoutPhotos(userId: String, workoutId: String, name: String) -> StorageReference {
                return photo.child(userId).child(workoutId).child(name)
            }
        }
    }
    
}
