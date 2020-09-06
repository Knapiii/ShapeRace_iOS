//
//  AuthPageVC.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-22.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

class AuthPageVC: UIPageViewController {
    enum ViewControllers: Int {
        case authStartVC = 0
        case signInAndUpVC = 1
        case pageCreateUserDetailsInfoVC = 2
        case pageEnablePositionVC = 3
        //case pageEnableNotificationsVC = 4
        //case pageEnableAppleHealthVC = 4

    }
    let viewControllerList: [UIViewController] = [
        AuthStartVC(),
        SignInAndUpVC(),
        PageCreateUserDetailsInfoVC(),
        PageEnablePositionVC(),
       // PageEnableNotificationsVC(),
        //PageEnableAppleHealthVC(),
        
    ]
    var currentPageIndex: Int = 0
    var displayedPageIndex: Int = 0
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        
        for view in view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = false
            }
        }
        
        if let firstVC = viewControllerList.first {
            self.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func navigate(_ direction: NavigationDirection, animated: Bool = true) {
        currentPageIndex = direction == .forward ? currentPageIndex + 1 : currentPageIndex - 1
        setViewControllers([viewControllerList[currentPageIndex]], direction: direction, animated: animated, completion: nil)
    }
    
    func navigate(to page: ViewControllers, direction: NavigationDirection, animated: Bool = true) {
        currentPageIndex = page.rawValue
        setViewControllers([viewControllerList[page.rawValue]], direction: .forward, animated: animated, completion: nil)

    }
}

extension AuthPageVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return viewControllerList[currentPageIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return viewControllerList[currentPageIndex]
    }
}
