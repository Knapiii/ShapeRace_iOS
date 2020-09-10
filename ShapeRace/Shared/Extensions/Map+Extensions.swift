//
//  Map+Extensions.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-10.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

extension Locale {
    
    /**
     Given the app's localized language setting, returns a string representing the user's localization.
     */
    public static var preferredLocalLanguageCountryCode: String {
        let firstBundleLocale = Bundle.main.preferredLocalizations.first!
        let bundleLocale = firstBundleLocale.components(separatedBy: "-")
        
        if bundleLocale.count > 1 {
            return firstBundleLocale
        }
        
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            return "\(bundleLocale.first!)-\(countryCode)"
        }
        
        return firstBundleLocale
    }
    
    /**
     Returns a `Locale` from `preferredLocalLanguageCountryCode`.
     */
    public static var nationalizedCurrent = Locale(identifier: preferredLocalLanguageCountryCode)
    
    public static var usesMetric: Bool {
        let locale = self.current as NSLocale
        guard let measurementSystem = locale.object(forKey: .measurementSystem) as? String else {
            return false
        }
        return measurementSystem == "Metric"
    }
    
    public var usesMetric: Bool {
        let locale = self as NSLocale
        guard let measurementSystem = locale.object(forKey: .measurementSystem) as? String else {
            return false
        }
        return measurementSystem == "Metric"
    }
}

extension Bundle {
    static func infoPlistValue(forKey key: String) -> Any? {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) else {
            return nil
        }
        return value
    }
}
