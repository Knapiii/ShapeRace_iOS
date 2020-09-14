//
//  Int+Time.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-01.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

extension Int {
    func secondsToTimeWithDotsInBetween(includeSeconds: Bool = true) -> String {
        let hours = self / 3600
        let minutes = self / 60 % 60
        let seconds = self % 60
        
        if hours == 0 {
            return String(format:"%02i:%02i", minutes, seconds)
        }
        if includeSeconds {
            return String(format:"%2i:%02i:%02i", hours, minutes, seconds)
        }

        return String(format:"%2i:%02i", hours, minutes)
    }
    
    func returnSinutesSecondsThenHours(showSecondsWithHours: Bool = false) -> String {
        let seconds = self % 60
        let minutes = (self / 60) % 60
        let hours = self / 3600
        
        if hours != 0 {
            if showSecondsWithHours {
                return String(format: "%dh %02dm %02ds", hours, minutes, seconds)
            } else {
                return String(format: "%dh %02dm", hours, minutes)
            }
        } else {
            return String(format: "%dm %02ds", minutes, seconds)
        }
    }
    
}

extension Date {
    
    func timestampToDate() -> String {
        
        let day = DateFormatter(format: "d").string(from: self)
        let month = DateFormatter(format: "MMMM").string(from: self)
        let year = DateFormatter(format: "yyyy").string(from: self)
        
        return "\(day) \(month) \(year)"
    }
}

extension DateFormatter {
    /// Sweeter: Create a new formatter with format string.
    public convenience init(format: String, timeZone: TimeZone = .current, locale: String? = nil) {
        self.init()
        dateFormat = format
        self.timeZone = timeZone
        if let locale = locale {
            self.locale = Locale(identifier: locale)
        }
    }
}
