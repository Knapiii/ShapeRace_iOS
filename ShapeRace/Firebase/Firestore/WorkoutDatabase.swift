//
//  WorkoutDatabase.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-05.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Firebase

class WorkoutDatabase {
    static let shared = WorkoutDatabase()
    var myWorkouts: [WorkoutModel] = []
    
    func uploadWorkout(workout: WorkoutModel, completion: @escaping VoidCompletion) {
        workout.timestamp = Date()
        if let uid = Auth.auth().currentUser?.uid {
            workout.userId = uid
        }
        
        do {
            let ref = try FirestoreService.Ref.Workout.shared.workouts.addDocument(from: workout, encoder: Firestore.Encoder(), completion: { (error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
            })
            workout.changeValuesToFirebaseCodable(ref: ref)
            completion(.success(()))
        }
        catch {
            completion(.failure(error))
        }
    }
    
    func fetchMyWorkouts(completion: @escaping WorkoutsCompletion) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        fetchWorkoutsFrom(userId: uid) { (result) in
            switch result {
            case .success(let workouts):
                self.myWorkouts = workouts
                completion(.success(workouts))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchWorkoutsFrom(userId: String, completion: @escaping WorkoutsCompletion) {
        FirestoreService.Ref.Workout.shared.specific(userId: userId).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let documents = snapshot?.documents else {
                completion(.failure(SRError("")))
                return
            }
            
            let workouts: [WorkoutModel] = documents.compactMap { (doc) -> WorkoutModel? in
                return try? doc.data(as: WorkoutModel.self)
            }
            completion(.success(workouts))
        }
    }

}
