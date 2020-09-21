//
//  FriendRequestsVC.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-21.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import UIKit

class FriendRequestsVC: UIViewController {
    
    let tableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.separatorStyle = .none
        $0.backgroundColor = SRColor.background
        return $0
    }(UITableView())
    
    var requests: [RequestModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SRColor.background
        configureTableView()
        fetchRequests()
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
    
    func fetchRequests() {
        requests = DB.friends.receivedRequests
    }
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FriendTableViewCell.self, forCellReuseIdentifier: FriendTableViewCell.reuseId)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }

}

extension FriendRequestsVC: FriendCellProtocol {
    
    func accept(request: RequestModel) {
        Vibration.medium.vibrate()
        DB.friends.acceptFriendRequest(withFriendsId: request.friendsId, fromUserId: request.userId, completion: { _ in
            self.fetchRequests()
        })
    }
    
    func decline(request: RequestModel) {
        Vibration.medium.vibrate()
        DB.friends.deleteFriendCollection(withFriendsId: request.friendsId, completion: { _ in
            self.fetchRequests()
        })
    }
    
    func profileImageTapped(userId: String) {
        print(userId)
    }
    
}

extension FriendRequestsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendTableViewCell.reuseId, for: indexPath) as! FriendTableViewCell
        cell.clearCell()
        let request: RequestModel = requests[indexPath.row]
        cell.delegate = self
        cell.request = request
        return cell
    }
    
}
