//
//  UserDatabase.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-19.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

class UserDatatabase {
    static let shared = UserDatatabase()
    
    func getUser(with userId: String, completion: @escaping UserCompletion) {
        FirestoreService.Ref.User.shared.specific(user: userId).getDocument { snapshot, error in
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
                    completion(.success(user))
                } else {
                    completion(.failure(SRError("")))
                }
            }
        }
    }
    
}
