//
//  CurrentUserDatabase.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-23.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import Foundation
import Firebase

class CurrentUserDatabase {
    static let shared = CurrentUserDatabase()
    
    var user: UserModel?
    
    func getCurrentUserData(completion: @escaping UserCompletion) {
        guard let currentUserId =  FirestoreService.Ref.User.shared.currentUserId else { return }
        FirestoreService.Ref.User.shared.specific(user: currentUserId).getDocument { [weak self] snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let self = self,
                let document = snapshot, document.exists,
                let dictionary = document.data() else {
                    completion(.failure(SRError("User doesn't exist")))
                    return
            }
            let currentUser: UserModel = UserModel(document.documentID, with: dictionary)
            self.user = currentUser
            self.user?.email = Auth.auth().currentUser?.email ?? ""
            completion(.success(currentUser))
        }
    }
}
