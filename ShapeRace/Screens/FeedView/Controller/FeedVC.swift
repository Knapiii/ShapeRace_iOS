//
//  FeedVC.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-08-24.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

class FeedVC: UIViewController {
    let refreshController: UIRefreshControl = {
        $0.tintColor = .blue
        return $0
    }(UIRefreshControl())
    
    let tableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.separatorStyle = .none
        $0.backgroundColor = SRColor.background
        return $0
    }(UITableView())
    
    var workouts: [WorkoutModel]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        fetchAllWorkouts()
    }
    
    func fetchAllWorkouts() {
        refreshController.beginRefreshing()
        DB.workout.fetchAllWorkouts { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let workouts):
                self.workouts = workouts
                self.refreshController.endRefreshing()
            case .failure(let error):
                print(error.localizedDescription)
                self.refreshController.endRefreshing()
            }
        }
    }
    
    func configureTableView() {
        refreshController.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        tableView.refreshControl = refreshController
        tableView.dataSource = self
        tableView.delegate = self
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
    @objc func refreshTableView() {
        fetchAllWorkouts()
    }
    
}

extension FeedVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WorkoutTableViewCell.identifier, for: indexPath) as! WorkoutTableViewCell
        guard let workouts = workouts else {
            return cell
        }
        cell.delegate = self
        cell.workout = workouts[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
                     
}

extension FeedVC: WorkoutTVCDelegate {
    func goToUser(id: String) {
        guard id != DB.currentUser.userId else { return }
        Vibration.medium.vibrate()
        AlertService.shared.showLoader()
        DB.user.getUser(with: id) { (result) in
            switch result {
            case .success(let user):
                let vc = UserVC(user: user)
                self.navigationController?.pushViewController(vc, animated: true)
                AlertService.shared.dismissLoader()
            case .failure(let error):
                print(error.localizedDescription)
                AlertService.shared.dismissLoader()
            }
        }
    }
    
    func goToWorkout(id: String) {
        Vibration.medium.vibrate()
        print(id)
    }
}
