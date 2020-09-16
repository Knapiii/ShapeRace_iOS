//
//  WorkoutTimerService.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-01.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

class WorkoutTimerService: ObservableObject {
    static let shared = WorkoutTimerService()
    var isRunning = false
    var isPausedByInactivity = false
    var didBecomeInActiveDate: Date?
    
    var timer: Timer?
    var seconds: Int = 0

    func startTimer() {
        WorkoutTimerService.shared.isPausedByInactivity = false
        isRunning = true
        seconds = 0
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
        seconds = 0
        timer = nil
        isRunning = false
        WorkoutTimerService.shared.isPausedByInactivity = false
    }
    
    func pauseTimer() {
        isRunning = false
        timer?.invalidate()
    }
    
    func resumeTimer() {
        WorkoutTimerService.shared.isPausedByInactivity = false
        isRunning = true
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimer() {
        seconds += 1
        NotificationCenter.default.post(name: Notis.workoutTimeUpdate.name, object: seconds)
    }
}

