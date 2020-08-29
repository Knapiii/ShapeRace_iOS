//
//  AuthenticationVC.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-21.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit
import FloatingPanel

class AuthenticationOnBoardingVC: UIViewController {
    let backgroundImageView: UIImageView = {
        $0.image = UIImage(named: "Full_Background_Image")
        $0.contentMode = .scaleAspectFill
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    let buttonStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 16
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())
    
    var firstButton = SRDefaultButton(title: "Login", titleColor: .black, bgColor: .white)
    var secondButton = SRDefaultButton(title: "Sign up", titleColor: .black, bgColor: .white)
    var backButton = SRDefaultButton(title: "Back", titleColor: .white, bgColor: .clear)
    
    var backButtonAlpha: CGFloat = 0.0 {
        didSet {
            backButton.isEnabled = backButtonAlpha != 0
            UIView.animate(withDuration: 0.4) {
                self.backButton.alpha = self.backButtonAlpha
                self.pageControl.alpha = self.backButtonAlpha
            }
        }
    }
    
    let pageControl = UIPageControl()
    let pageViewController = AuthPageVC()
    
    var currentViewController: UIViewController?
    var email: String?
    var password: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        currentViewController = self.pageViewController.viewControllerList[self.pageViewController.currentPageIndex]
        configureBackgroundImage()
        configurePageDots()
        configureBottomContainer()
        setupPageVC()
        configureBackButton()
        checkCurrentViewController()
        
        backButtonAlpha = 0
    }
    
}

///Onboarding
extension AuthenticationOnBoardingVC {
    
    
    func navigate(to page: AuthPageVC.ViewControllers, direction: UIPageViewController.NavigationDirection, animated: Bool = true) {
        if (direction == .forward && self.pageViewController.currentPageIndex == self.pageViewController.viewControllerList.count - 1) { return }
        removeTargetActions()
        Vibration.medium.vibrate()
        pageViewController.navigate(to: page, direction: direction, animated: animated)
        pageControl.currentPage = pageViewController.displayedPageIndex
        currentViewController = self.pageViewController.viewControllerList[self.pageViewController.currentPageIndex]
        
        checkCurrentViewController()
    }
    
    func navigate(_ direction: UIPageViewController.NavigationDirection, state: Authstate? = nil) {
        if (direction == .forward && self.pageViewController.currentPageIndex == self.pageViewController.viewControllerList.count - 1) { return }
        
        Vibration.medium.vibrate()
        pageViewController.navigate(direction)
        pageControl.currentPage = pageViewController.displayedPageIndex
        currentViewController = self.pageViewController.viewControllerList[self.pageViewController.currentPageIndex]
        
        checkCurrentViewController(state: state)
    }
    
    func checkCurrentViewController(state: Authstate? = nil) {
        removeTargetActions()
        backButtonAlpha = pageViewController.currentPageIndex >= 2 ? 1 : 0
        
        if currentViewController is AuthStartVC, let _ = currentViewController as? AuthStartVC {
            firstButton.setupUI(title: "Login")
            secondButton.setupUI(title: "Sign up")
            firstButton.addAction { self.navigate(.forward, state: .login) }
            secondButton.addAction { self.navigate(.forward, state: .signUp) }
        } else if currentViewController is SignInAndUpVC, let vc = currentViewController as? SignInAndUpVC {
            if let state = state {
                vc.state = state
                vc.delegate = self
                switch state {
                case .login:
                    firstButton.setupUI(title: "Login")
                    firstButton.addAction { self.LoginWithFirebase() }
                case .signUp:
                    firstButton.setupUI(title: "Sign Up")
                    firstButton.addAction { self.SignUpWithFirebase() }
                }
                secondButton.setupUI(title: "Cancel")
                secondButton.addAction { self.navigateBack() }
            }
        } else if currentViewController is PageCreateUserDetailsInfoVC, let _ = currentViewController as? PageCreateUserDetailsInfoVC {
            pageViewController.displayedPageIndex = 1
            firstButton.setupUI(title: "Save")
            secondButton.setupUI(title: "Skip")
            secondButton.addAction { self.navigateForward() }
            backButton.addAction { self.navigateBack(state: .login) }
        } else if currentViewController is PageEnablePositionVC, let _ = currentViewController as? PageEnablePositionVC {
            pageViewController.displayedPageIndex = 2
            firstButton.setupUI(title: "Enable location service")
            secondButton.setupUI(title: "Skip")
            secondButton.addAction { self.navigateForward() }
            backButton.addAction {  self.navigate(.reverse) }
        } else if currentViewController is PageEnableNotificationsVC, let _ = currentViewController as? PageEnableNotificationsVC {
            pageViewController.displayedPageIndex = 3
            firstButton.setupUI(title: "Enable notifications")
            secondButton.setupUI(title: "Skip")
            
            secondButton.addAction { self.navigateForward() }
            backButton.addAction { self.navigate(.reverse) }
        }
    }
    
    func removeTargetActions (){
        firstButton.removeTarget(nil, action: nil, for: .allEvents)
        secondButton.removeTarget(nil, action: nil, for: .allEvents)
        backButton.removeTarget(nil, action: nil, for: .allEvents)
    }
    
    @objc func navigateForward() {
        navigate(.forward)
    }
    
    func navigateBack(state: Authstate? = nil) {
        if self.pageViewController.currentPageIndex > 0 {
            navigate(.reverse, state: state)
        }
    }
    
}

///Actions
extension AuthenticationOnBoardingVC {
    
    private func LoginWithFirebase() {
        ProgressHudService.shared.showSpinner()
        Vibration.medium.vibrate()
        if let email = email, let password = password {
            FBAuthenticationService.shared.signIn(with: email, and: password) { (result) in
                switch result {
                case .success():
                    DB.auth.switchAuthState {
                        self.navigate(to: .pageCreateUserDetailsInfoVC, direction: .forward, animated: true)
                    }
                    ProgressHudService.shared.dismiss()
                case .failure(let error):
                    ProgressHudService.shared.error(error.localizedDescription)
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func SignUpWithFirebase() {
        ProgressHudService.shared.showSpinner()
        Vibration.medium.vibrate()
        if let email = email, let password = password {
            DB.auth.createUser(with: email, and: password) { (result) in
                switch result {
                case .success():
                    DB.auth.switchAuthState {
                        self.navigate(to: .pageCreateUserDetailsInfoVC, direction: .forward, animated: true)
                    }
                    ProgressHudService.shared.dismiss()
                case .failure(let error):
                    ProgressHudService.shared.error(error.localizedDescription)
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    private func AllowLocationService() {
        
    }
    
    private func allowNotificationService() {
        
    }
    
    
}

///UI
extension AuthenticationOnBoardingVC {
    
    func configureBackgroundImage() {
        view.addSubview(backgroundImageView)
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
    
    
    func configurePageDots() {
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.numberOfPages = pageViewController.viewControllerList.count - 2
        pageControl.isUserInteractionEnabled = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.heightAnchor.constraint(equalToConstant: 20),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func configureBottomContainer() {
        buttonStackView.addArrangedSubview(firstButton)
        buttonStackView.addArrangedSubview(secondButton)
        view.addSubview(buttonStackView)
        NSLayoutConstraint.activate([
            firstButton.heightAnchor.constraint(equalToConstant: 48),
            secondButton.heightAnchor.constraint(equalToConstant: 48),
            
            buttonStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            buttonStackView.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -16),
            buttonStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
        ])
    }
    
    func setupPageVC() {
        addChild(pageViewController)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageViewController.view)
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            pageViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor, constant: -16),
            pageViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
        pageViewController.didMove(toParent: self)
    }
    
    func configureBackButton() {
        view.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 60),
            backButton.heightAnchor.constraint(equalToConstant: 48),
        ])
    }
    
}



