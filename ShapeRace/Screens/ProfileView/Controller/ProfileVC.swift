//
//  WorkoutVC.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-24.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    
    let tableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.separatorStyle = .none
        $0.backgroundColor = SRColor.background
        return $0
    }(UITableView(frame: .zero, style: .grouped))
    
    var tableViewHeader = ProfileHeaderView()
    
    var workouts: [WorkoutModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SRColor.background
        configureNavigation()
        configureTableView()
        fetchWorkouts()
        title = DB.currentUser.user?.displayNameAndLastNameIfAvailable
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func configureNavigation() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: ProfileHeaderView.identifier)
        tableView.register(WorkoutTableViewCell.self, forCellReuseIdentifier: WorkoutTableViewCell.identifier)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
    
    func fetchWorkouts() {
        workouts = DB.workout.myWorkouts
    }
    
}
extension ProfileVC: ProfileHeaderViewDelegate {
    func friendRequestAction() {
        let vc = FriendRequestsVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ProfileVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WorkoutTableViewCell.identifier, for: indexPath) as! WorkoutTableViewCell
        cell.workout = workouts[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProfileHeaderView.identifier) as! ProfileHeaderView
        view.delegate = self
        view.user = DB.currentUser.user
        view.workouts = workouts
        return view
    }
        
}

