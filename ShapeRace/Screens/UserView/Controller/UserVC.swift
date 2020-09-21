//
//  UserVC.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-24.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

class UserVC: UIViewController {
    
    let tableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.separatorStyle = .none
        $0.backgroundColor = SRColor.background
        return $0
    }(UITableView(frame: .zero, style: .grouped))
    
    var tableViewHeader = ProfileHeaderView()
    
    var user: UserModel
    var workouts: [WorkoutModel] = []
    init(user: UserModel) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SRColor.background
        configureNavigation()
        configureTableView()
        fetchWorkoutsFrom(user: user)
        title = user.displayNameAndLastNameIfAvailable
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func configureNavigation() {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func fetchWorkoutsFrom(user: UserModel) {
        DB.workout.fetchWorkoutsFrom(userId: user.userId) { (result) in
            switch result {
            case .success(let workouts):
                self.workouts = workouts
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UserHeaderView.self, forHeaderFooterViewReuseIdentifier: UserHeaderView.identifier)
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

extension UserVC: UserHeaderDelegate {
    func setFriendState(user: UserModel, state: FriendState) {
        switch state {
        case .addFriend:
            DB.friends.sendFriendRequest(toUser: user)
        case .acceptRequest:
            DB.friends.acceptFriendRequest(fromUser: user, completion: {_ in })
        case .cancelRequest:
            DB.friends.cancelFriendRequest(toUser: user, completion: {_ in })
        case .removeFriend:
            DB.friends.deleteFriendCollection(withUser: user, completion: {_ in })
        }
    }
}

extension UserVC: UITableViewDataSource, UITableViewDelegate {
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
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: UserHeaderView.identifier) as! UserHeaderView
        view.user = user
        view.delegate = self
        view.workouts = workouts
        return view
    }
        
}

