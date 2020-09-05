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
            let ref = try FirebaseService.Ref.Workout.shared.workouts.addDocument(from: workout, encoder: Firestore.Encoder(), completion: { (error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
            })
            if let checkInDate = workout.checkInDate {
                ref.setData( [WorkoutModel.CodingKeys.checkInDate.rawValue: Timestamp(date: checkInDate)], merge: true )
            }
            if let checkOutDate = workout.checkOutDate {
                ref.setData( [WorkoutModel.CodingKeys.checkOutDate.rawValue: Timestamp(date: checkOutDate)], merge: true )
            }
            if let timestamp = workout.timestamp {
                ref.setData( [WorkoutModel.CodingKeys.timestamp.rawValue: Timestamp(date: timestamp)], merge: true )
            }
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
        FirebaseService.Ref.Workout.shared.specific(userId: userId).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let documents = snapshot?.documents else { return }
            
            let workouts: [WorkoutModel] = documents.compactMap { (doc) -> WorkoutModel? in
                return try? doc.data(as: WorkoutModel.self)
            }
            completion(.success(workouts))
        }
    }

}
