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
    let customizedTabBar = TabBarCustomizator()

    var feed: FeedNavigationVC = FeedNavigationVC()
    var workout: WorkoutNavigationVC = WorkoutNavigationVC()
    var profile: ProfileNavigationVC = ProfileNavigationVC()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .clear
        viewControllers = [feed, workout, profile]
        setTabbarImage()
        customizedTabBar.tabBar = tabBar
        customizedTabBar.customize()
        tabBar.backgroundColor = .clear
        selectedIndex = 1
        UITabBar.appearance().tintColor = SRColor.blue
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = UIImage()
    }
    
    func setTabbarImage() {
        setItemIcons(item: 0, selected: "Feed_Selected", unSelected: "Feed_Unselected")
        setItemIcons(item: 1, selected: "Dumbbell_Selected", unSelected: "Dumbbell_Unselected")
        setItemIcons(item: 2, selected: "Profile_Selected", unSelected: "Profile")
    }
    
    fileprivate func setItemIcons(item: Int, selected: String, unSelected: String) {
        self.tabBar.items?[item].selectedImage = UIImage(named: selected)
        self.tabBar.items?[item].image = UIImage(named: unSelected)
        setItemPosition(item: item)
    }
    
    fileprivate func setItemPosition(item: Int) {
        switch item {
        case 0:
            let inset = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
            self.tabBar.items?[item].imageInsets = inset
        case 1:
            let inset = UIEdgeInsets(top: -15, left: 0, bottom: 5, right: 0)
            self.tabBar.items?[item].imageInsets = inset
        case 2:
            let inset = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
            self.tabBar.items?[item].imageInsets = inset
        default:
            let inset = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
            self.tabBar.items?[item].imageInsets = inset
        }

    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let barButtonView = item.value(forKey: "view") as? UIView else { return }
        
        let animationLength: TimeInterval = 0.3
        
        let propertyAnimator = UIViewPropertyAnimator(duration: animationLength, dampingRatio: 0.7) {
            barButtonView.transform = CGAffineTransform.identity.scaledBy(x: 0.7, y: 0.7)
        }
        propertyAnimator.addAnimations({ barButtonView.transform = .identity }, delayFactor: CGFloat(animationLength))
        propertyAnimator.startAnimation()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                if let shapeLayer = customizedTabBar.caShapeLayer {
                    shapeLayer.fillColor = SRColor.background.cgColor
                }
            }
        }
    }

}

extension SRTabBarController: UITabBarControllerDelegate {
    
}
