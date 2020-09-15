//
//  WorkoutDatabase.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-05.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import Foundation
import CoreLocation
import FirebaseAuth
import FirebaseFirestore
import Firebase
import Mapbox

class WorkoutDatabase {
    static let shared = WorkoutDatabase()
    var myWorkouts: [WorkoutModel] = []
    
    func uploadWorkout(mapView: MGLMapView, workout: WorkoutModel, completion: @escaping VoidCompletion) {
        workout.timestamp = Date()
        if let uid = Auth.auth().currentUser?.uid {
            workout.userId = uid
        }
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        do {
            let ref = try FirestoreService.Ref.Workout.shared.workouts.addDocument(from: workout, encoder: Firestore.Encoder(), completion: { (error) in
                if let error = error {
                    dispatchGroup.leave()
                    completion(.failure(error))
                    return
                }
            })
            
            workout.workoutId = ref.documentID
            MapImageService.shared.generateMapPreviews(mapView: mapView, workout: workout, dispatchGroup: dispatchGroup)
            
            workout.changeValuesToFirebaseCodable(ref: ref)
            dispatchGroup.leave()
            completion(.success(()))
        }
        catch {
            dispatchGroup.leave()
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
        FirestoreService.Ref.Workout.shared.specific(userId: userId).order(by: "timestamp", descending: true).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let documents = snapshot?.documents else {
                completion(.failure(SRError("Something went wrong")))
                return
            }
        
            let workouts: [WorkoutModel] = documents.compactMap { (doc) -> WorkoutModel? in
                return try? doc.data(as: WorkoutModel.self)
            }
            completion(.success(workouts))
        }
    }
    
    func toggleLiked(_ workout: WorkoutModel) {
        guard let userId = DB.currentUser.user?.userId else { return }
        let likedByUser = workout.likedBy.contains(userId)
        
        FirestoreService.Ref.Workout.shared.specific(workoutId: workout.workoutId).updateData([
            WorkoutModel.CodingKeys.likedBy.rawValue: likedByUser ? FieldValue.arrayRemove([userId]) : FieldValue.arrayUnion([userId])
        ])
    }

}
