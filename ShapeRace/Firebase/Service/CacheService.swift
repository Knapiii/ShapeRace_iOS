//
//  CacheService.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-05.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit
import FirebaseUI

class CacheService: NSObject {
    static let shared = CacheService()
    private override init() {
        super.init()
    }

    var profileImages: [String: UIImage] = [:]
    
}

extension UIImageView {
    func setProfileImage(userId: String, asThumbnail: Bool = false, completion: Completion? = nil) {
        if let image = CacheService.shared.profileImages[userId] {
            self.image = image
            if let completion = completion {
                completion()
            }
        } else {
            sd_setImage(with: StorageService.Ref.Profile.specific(id: userId, asThumbnail: asThumbnail), placeholderImage: UIImage(named: "User_Placeholder")) { [weak self] image, error, _, ref in
                guard let self = self else { return }
                if error != nil {
                    self.image = UIImage(named: "User_Placeholder")
                } else {
                    ref.getMetadata { metadata, _ in
                        if let url = NSURL.sd_URL(with: ref)?.absoluteString,
                           let cachePath = SDImageCache.shared.cachePath(forKey: url),
                           let attributes = try? FileManager.default.attributesOfItem(atPath: cachePath),
                           let cacheDate = attributes[.creationDate] as? Date,
                           let serverDate = metadata?.timeCreated,
                           serverDate > cacheDate {
                            SDImageCache.shared.removeImage(forKey: url) {
                                self.sd_setImage(with: ref, placeholderImage: UIImage(named: "User_Placeholder"))
                                if let completion = completion {
                                    completion()
                                }
                            }
                        } else {
                            if let completion = completion {
                                completion()
                            }
                        }
                    }
                }
            }
        }
    }
}

extension UIButton {
    func setProfileImage(userId: String, asThumbnail: Bool = false) {
        if let image = CacheService.shared.profileImages[userId] {
            self.setImage(image, for: .normal)
        } else {
            self.imageView?.sd_setImage(with: StorageService.Ref.Profile.specific(id: userId, asThumbnail: asThumbnail), placeholderImage: UIImage(named: "User_Placeholder"), completion: {[weak self] (image, error, cacheType, ref) in
                guard let self = self else { return }
                if let image = image {
                    self.setImage(image, for: .normal)
                } else {
                    self.setImage(UIImage(named: "User_Placeholder"), for: .normal)
                }
                ref.getMetadata { metadata, _ in
                    if let url = NSURL.sd_URL(with: ref)?.absoluteString,
                        let cachePath = SDImageCache.shared.cachePath(forKey: url),
                        let attributes = try? FileManager.default.attributesOfItem(atPath: cachePath),
                        let cacheDate = attributes[.creationDate] as? Date,
                        let serverDate = metadata?.timeCreated,
                        serverDate > cacheDate {
                        SDImageCache.shared.removeImage(forKey: url) {
                            self.setProfileImage(userId: userId)
                        }
                    }
                }
            })
        }
    }
}
