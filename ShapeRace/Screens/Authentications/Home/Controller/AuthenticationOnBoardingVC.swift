//
//  AuthenticationVC.swift
//  Shape Race
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
        manageFirstView()
    }
    
}


///Onboarding
extension AuthenticationOnBoardingVC {
    
    func manageFirstView() {
        if let currentVC = currentViewController as? AuthStartVC {
            firstButton.setupUI(title: "Login")
            secondButton.setupUI(title: "Sign up")
            firstButton.addAction {
                self.navigate(.forward, state: .login)
            }
            secondButton.addAction {
                self.navigate(.forward, state: .signUp)
            }
        }
    }
    
    func navigate(_ direction: UIPageViewController.NavigationDirection, state: Authstate? = nil) {
        if (direction == .forward && self.pageViewController.currentPageIndex == self.pageViewController.viewControllerList.count - 1) {
            return;
        }
        
        removeTargetActions()
        Vibration.medium.vibrate()
        pageViewController.navigate(direction)
        pageControl.currentPage = pageViewController.currentPageIndex
        currentViewController = self.pageViewController.viewControllerList[self.pageViewController.currentPageIndex]
        
        if currentViewController is AuthStartVC, let _ = currentViewController as? AuthStartVC {
            firstButton.setupUI(title: "Login")
            secondButton.setupUI(title: "Sign up")
            firstButton.addTarget(self, action: #selector(navigateForward), for: .touchUpInside)
            firstButton.addTarget(self, action: #selector(navigateForward), for: .touchUpInside)
        } else if currentViewController is SignInAndUpVC, let vc = currentViewController as? SignInAndUpVC {
            if let state = state {
                vc.state = state
                vc.delegate = self
                switch state {
                case .login:
                    firstButton.setupUI(title: "Login")
                    firstButton.addTarget(self, action: #selector(LoginWithFirebase), for: .touchUpInside)
                case .signUp:
                    firstButton.setupUI(title: "Sign Up")
                    firstButton.addTarget(self, action: #selector(SignUpWithFirebase), for: .touchUpInside)
                }
                secondButton.setupUI(title: "Cancel")
                secondButton.addTarget(self, action: #selector(navigateBack), for: .touchUpInside)
            }
        }
    }
    
    func removeTargetActions (){
        firstButton.removeTarget(self, action: nil, for: .allEvents)
        secondButton.removeTarget(self, action: nil, for: .allEvents)
    }
    
    @objc func navigateForward() {
        navigate(.forward)
    }
    
    @objc func navigateBack() {
        if self.pageViewController.currentPageIndex > 0 {
            navigate(.reverse)
        }
    }
    
}

///Actions
extension AuthenticationOnBoardingVC {
    
    @objc private func LoginWithFirebase() {
        Vibration.medium.vibrate()
        print("LoginWithFirebase")
        if let email = email, let password = password {
            FBAuthenticationService.shared.signIn(with: email, and: password) { (result) in
                switch result {
                case .success():
                    print("User signed in")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    @objc private func SignUpWithFirebase() {
        Vibration.medium.vibrate()
        print("SignUpWithFirebase")
        if let email = email, let password = password {
            FBAuthenticationService.shared.createUser(with: email, and: password) { (result) in
                switch result {
                case .success():
                    print("User created")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
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
        pageControl.numberOfPages = pageViewController.viewControllerList.count - 1
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
    
}




