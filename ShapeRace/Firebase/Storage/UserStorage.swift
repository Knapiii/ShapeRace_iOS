//
//  UserStorage.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-05.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage

class UserStorage {
    static let shared = UserStorage()
    
    func setProfilePhoto(image: UIImage?, dispatchGroup: DispatchGroup, completion: @escaping VoidCompletion) {
        guard let userId = FirestoreService.Ref.User.shared.currentUserId else {
            completion(.failure(SRError("Something went wrong")))
            return
        }
        guard let imageData = image?.jpegData(compressionQuality: 0.4) else { return }
        CacheService.shared.profileImages[userId] = image
        dispatchGroup.enter()
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        StorageService.Ref.Profile.profile(userId: userId).putData(imageData, metadata: metadata) { storageMetaData, error in
            if let error = error {
                dispatchGroup.leave()
                completion(.failure(error))
                return
            } else {
                dispatchGroup.leave()
                completion(.success(()))
            }
        }
    }
    
}
