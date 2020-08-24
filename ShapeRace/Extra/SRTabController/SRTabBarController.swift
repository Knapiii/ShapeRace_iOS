//
//  SRTabBarController.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-24.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

enum ViewTag: Int {
    case feedTabBarItem = 400
    case workoutTabBarItem = 401
    case profileTabBarItem = 402

}

class SRTabBarController: UITabBarController {
    static let shared = SRTabBarController()

    var feed: FeedNavigationVC = FeedNavigationVC()
    var workout: WorkoutNavigationVC = WorkoutNavigationVC()
    var profile: ProfileNavigationVC = ProfileNavigationVC()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        feed.tabBarItem.title = "Workout"
        feed.tabBarItem.tag = ViewTag.feedTabBarItem.rawValue
        
        workout.tabBarItem.title = "Workout"
        workout.tabBarItem.tag = ViewTag.workoutTabBarItem.rawValue
        
        profile.tabBarItem.title = "Profile"
        profile.tabBarItem.tag = ViewTag.profileTabBarItem.rawValue
        
        tabBar.tintColor = SRColor.label
        tabBar.unselectedItemTintColor = SRColor.secondaryLabel
        tabBar.backgroundColor = SRColor.systemBackground
        tabBar.barTintColor = SRColor.systemBackground
        tabBar.isTranslucent = false
        tabBar.backgroundImage = UIImage()
        viewControllers = [feed, workout, profile]

        
        selectedIndex = 1
    }
    

}

extension SRTabBarController: UITabBarControllerDelegate {
    
}
