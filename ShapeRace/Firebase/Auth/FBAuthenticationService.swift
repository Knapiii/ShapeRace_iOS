//
//  FBAuthenticationService.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-23.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class FBAuthenticationService {
    static let shared = FBAuthenticationService()
    
    func switchAuthState(_ continueToOnboarding: (() -> ())? = nil) {
        (UIApplication.shared.delegate as! AppDelegate).configureInitialVC(continueToOnboarding)
    }
    
    func signOut(completion: VoidCompletion) {
        do {
            try Auth.auth().signOut()
            if let providerData = Auth.auth().currentUser?.providerData {
                let userInfo = providerData.first
                switch userInfo?.providerID {
                case "google.com":
                    completion(.success(()))
                default:
                    break
                }
            }
            
            completion(.success(()))
        } catch {
            completion(.failure(SRError("Something went wrong")))
        }
    }
    
    func resetPassword(with email: String?, completion: @escaping VoidCompletion) {
        guard let email = email else { return }
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                completion(.failure(error))
                return
            } else {
                completion(.success(()))
            }
        }
    }
    
    func signIn(with email: String, and password: String, completion: @escaping VoidCompletion) {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        Auth.auth().signIn(with: credential) { authData, error in
            if let error = error {
                completion(.failure(error))
                return
            } else {
                UserDefaults.standard.removeObject(forKey: "thirdPartyLoginDisplayName")
                completion(.success(()))
            }
        }
    }
    
    func createUser(with email: String, and password: String, completion: @escaping VoidCompletion) {
        Auth.auth().createUser(withEmail: email, password: password) { authData, error in
            if let error = error {
                completion(.failure(error))
                return
            } else {
                guard let currentId = Auth.auth().currentUser?.uid else { return }
                UserDefaults.standard.removeObject(forKey: "thirdPartyLoginDisplayName")
                
                let data: [String: Any] = [FirestoreService.DBStrings.User.email: email,
                                           FirestoreService.DBStrings.User.memberSince: Timestamp(date: (authData?.user.metadata.creationDate)!)]
                FirestoreService.Ref.User.shared.specific(user: currentId).setData(data, merge: true) { (error) in
                    if let error = error {
                        completion(.failure(error))
                        return
                    } else {
                        completion(.success(()))
                    }
                }
            }
        }
    }

}
