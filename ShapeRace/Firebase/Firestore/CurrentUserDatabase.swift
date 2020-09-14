//
//  CurrentUserDatabase.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-23.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

class CurrentUserDatabase {
    static let shared = CurrentUserDatabase()
    
    var user: UserModel?
    var userId: String? {
        return FirestoreService.Ref.User.shared.currentUserId
    }
    
    func getCurrentUserData(completion: @escaping UserCompletion) {
        guard let currentUserId =  FirestoreService.Ref.User.shared.currentUserId else { return }
        FirestoreService.Ref.User.shared.specific(user: currentUserId).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = snapshot, document.exists else {
                completion(.failure(SRError("")))
                return
            }
            
            do {
                if let user = try? document.data(as: UserModel.self) {
                    self.user = user
                    self.user?.email = Auth.auth().currentUser?.email ?? ""
                    completion(.success(user))
                } else {
                    completion(.failure(SRError("")))
                }
            }

        }
    }
    
    func uploadUserInfo(user: UserModel, image: UIImage?, completion: @escaping VoidCompletion) {
        guard let currentUserId =  FirestoreService.Ref.User.shared.currentUserId else { return }
        do {
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            let _ = try FirestoreService.Ref.User.shared.specific(user: currentUserId).setData(from: user, encoder: Firestore.Encoder(), completion: { (error) in
                if let error = error {
                    dispatchGroup.leave()
                    completion(.failure(error))
                    return
                }
                dispatchGroup.leave()
                if let image = image {
                    StorageAPI.user.setProfilePhoto(image: image, dispatchGroup: dispatchGroup, completion: completion)
                }
                dispatchGroup.notify(queue: .main) {
                    completion(.success(()))
                }
            })
        }
        catch {
            completion(.failure(error))
        }
    }
    
    func setWalkthroughFinished(completion: @escaping VoidCompletion) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        FirestoreService.Ref.User.shared
            .specific(user: currentUserId)
            .setData([FirestoreService.DBStrings.User.hasFinishedWalkthrough: true], merge: true) { (error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    self.user?.hasFinishedWalkthrough = true
                    UserDefaults.standard.removeObject(forKey: "thirdPartyLoginDisplayName")
                    completion(.success(()))
                }
        }
    }
}
