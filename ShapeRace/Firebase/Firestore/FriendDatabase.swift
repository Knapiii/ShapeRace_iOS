//
//  FriendDatabase.swift
//  ShapeRace
//
//  Created by Kristoffer Knape on 2020-09-18.
//  Copyright © 2020 Kristoffer Knape. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class FriendModel: Codable, ReflectedStringConvertible {
    var friendsId: String!
    var userId: String!
    var name: String!
    var lastMessage: String!
    var isRead: Bool!
    var updated: Date!
    
    init(friendsId: String, userId: String, name: String, lastMessage: String, isRead: Bool, updated: Date) {
        self.friendsId = friendsId
        self.userId = userId
        self.name = name
        self.lastMessage = lastMessage
        self.isRead = isRead
        self.updated = updated
    }
    
    enum CodingKeys: String, CodingKey {
        case friendsId
        case userId
        case name
        case lastMessage
        case isRead
        case updated
    }
    
}

class RequestModel: Codable, ReflectedStringConvertible {
    var friendsId: String!
    var userId: String!
    var name: String!
    var updated: Date!
    
    init(friendsId: String, userId: String, name: String, updated: Date) {
        self.friendsId = friendsId
        self.userId = userId
        self.name = name
        self.updated = updated
    }
    
    enum CodingKeys: String, CodingKey {
        case friendsId
        case userId
        case name
        case updated
    }
}


class FriendsDatabase {
    static let shared = FriendsDatabase()
    enum friendState {
        case addFriend, acceptRequest, cancelRequest, removeFriend
    }
    
    var friendsListener: ListenerRegistration?
    var myFriends: [FriendModel] = []
    var sentRequests: [RequestModel] = []
    var receivedRequests: [RequestModel] = []
    var notifications = 0
    var chattingWithUserId: String?
    
    private init() {}
    
    func startObservingFriends() {
        guard let currentUser = Auth.auth().currentUser else { return }
        friendsListener = FirestoreService.Ref.Friends.shared
            .friends
            .whereField("users", arrayContains: currentUser.uid)
                .addSnapshotListener {[weak self] (querySnapshot, error) in
                    guard let self = self else { return }
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }

                    guard let documents = querySnapshot?.documents else { return }
                    var updatedFriends: [FriendModel] = []
                    var updatedSentRequests: [RequestModel] = []
                    var updatedReceivedRequests: [RequestModel] = []
                    var updatedNotifications = 0
                    
                    documents.forEach({ document in
                        let dictionary = document.data() as [String : Any]
                        guard let isFriends = dictionary["isFriends"] as? Bool else { return }
                        
                        if isFriends {
                            if let friend = self.createFriendModel(dict: dictionary, currentUser: currentUser, friendsId: document.documentID) {
                                updatedFriends.append(friend)
                                if !friend.isRead {
                                    if self.chattingWithUserId == friend.userId {
                                        self.markAsRead(friendsId: friend.friendsId)
                                    } else {
                                        updatedNotifications += 1
                                    }
                                }
                            }
                        } else {
                            let requestTuple = self.createRequestModel(dict: dictionary, currentUser: currentUser, friendsId: document.documentID)
                            
                            if let sent = requestTuple.sentRequest {
                                updatedSentRequests.append(sent)
                            }
                            if let received = requestTuple.receivedRequest {
                                updatedReceivedRequests.append(received)
                                updatedNotifications += 1
                            }
                        }
                    })
                    updatedFriends.sort { $0.updated.compare($1.updated) == .orderedDescending }
                    updatedReceivedRequests.sort { $0.updated.compare($1.updated) == .orderedDescending }
                    self.myFriends = updatedFriends
                    self.sentRequests = updatedSentRequests
                    self.receivedRequests = updatedReceivedRequests
                    
                    NotificationCenter.default.post(name: Notis.friends.name, object: nil)
                    if self.notifications != updatedNotifications {
                        self.notifications = updatedNotifications
                        NotificationCenter.default.post(name: Notis.friendsBadge.name, object: self.notifications)
                    }
        }
    }
    
    func stopObservingFriends() {
        if let listener = friendsListener {
            listener.remove()
            friendsListener = nil
        }
    }
    
    func sendFriendRequest(toUser friendUser: UserModel) {
        guard let user = DB.currentUser.user else { return }
        
        let userName = (user.firstName ?? "") + " " + (user.lastName ?? "")
        let friendName = (friendUser.firstName ?? "") + " " + (friendUser.lastName ?? "")
                
        let friendData: [String: Any] = [
            "isFriends": false,
            "names": [user.userId: userName, friendUser.userId: friendName],
            "updated": Timestamp(date: Date()),
            "users": [user.userId, friendUser.userId],
            "version": 1
        ]
        FirestoreService.Ref.Friends.shared.friends.addDocument(data: friendData) { (error) in
            if let error = error {
                //Try again here?
                print(error.localizedDescription)
            }
            //Event.setEventFor.friends.friendRequestSent()
            //NotificationHandlerService.shared.sendRequestAs(.sendFriendRequest, notificationId: user.userId, to: friendUser.userId, badgeAmount: 1)
        }
        
    }
    
    func acceptFriendRequest(withFriendsId friendsId: String, fromUserId: String? = nil) {
        let lastMes: [String: Any] = [
            "text" : "\("Start chatting")!",
            "read" : false,
            "sender" : "Shape Race"
        ]
        
        FirestoreService.Ref.Friends.shared.specific(friendsId: friendsId).updateData(["isFriends": true, "lastMessage.read": lastMes]) { (error) in
            if let error = error {
                //Try again here?
                print(error.localizedDescription)
            }
            if let fromUserId = fromUserId {
                //Event.setEventFor.friends.friendRequestSent()
                //NotificationHandlerService.shared.sendRequestAs(.acceptFriendRequest, notificationId: fromUserId, to: fromUserId, badgeAmount: 1)
            }
        }
    }
    
    func deleteFriendCollection(withFriendsId friendsId: String) {
        FirestoreService.Ref.Friends.shared.specific(friendsId: friendsId).delete { (error) in
            if let error = error {
                //Try again here?
                print(error.localizedDescription)
            }
        }
    }
    
    func acceptFriendRequest(fromUser friend: UserModel) {
        let specificFriendArray = receivedRequests.filter{ $0.userId == friend.userId }
        guard let specificFriend = specificFriendArray.first else { return }
        acceptFriendRequest(withFriendsId: specificFriend.friendsId, fromUserId: friend.userId)
    }
    
    func cancelFriendRequest(toUser friend: UserModel) {
        let specificRequestArray = sentRequests.filter{ $0.userId == friend.userId }
        guard let specificRequest = specificRequestArray.first else { return }
        //Event.setEventFor.friends.friendRequestCanceled()
        deleteFriendCollection(withFriendsId: specificRequest.friendsId)
    }
    
    func declineFriendRequest(fromUser friend: UserModel) {
        let specificRequestArray = receivedRequests.filter{ $0.userId == friend.userId }
        guard let specificRequest = specificRequestArray.first else { return }
        //Event.setEventFor.friends.friendRequestDecline()
        deleteFriendCollection(withFriendsId: specificRequest.friendsId)
    }
    
    func deleteFriendCollection(withUser friend: UserModel) {
        let specificFriendArray = myFriends.filter{ $0.userId == friend.userId }
        guard let specificFriend = specificFriendArray.first else { return }
        //Event.setEventFor.friends.friendRemoved()
        deleteFriendCollection(withFriendsId: specificFriend.friendsId)
    }
    
    func checkFriendState(forUserId userId: String) -> friendState {
        if myFriends.contains(where: { $0.userId == userId }) {
            //Friends
            return .removeFriend
        } else if receivedRequests.contains(where: { $0.userId == userId }) {
            //Received friend request
            return .acceptRequest
        } else if sentRequests.contains(where: { $0.userId == userId }) {
            //Sent friend request
            return .cancelRequest
        } else {
            //Not friends and no request pending
            return .addFriend
        }
    }
    
    func markAsRead(friendsId: String) {
        FirestoreService.Ref.Friends.shared.specific(friendsId: friendsId).updateData(["lastMessage.read" : true])
    }
    
    private func createFriendModel(dict: [String : Any], currentUser: User, friendsId: String) -> FriendModel? {
        guard let users = dict["users"] as? [String],
            let names = dict["names"] as? [String : String],
            let lastMes = dict["lastMessage"] as? [String : Any],
            let updated = dict["updated"] as? Timestamp else { return nil }
        
        // Get the other persons userId
        let friendUserId = users.filter { !$0.contains(currentUser.uid) }[0]
        
        // Get the correct name from names for the friendId
        guard let friendName = names[friendUserId] else { return nil }

        // Get last message
        guard let senderId = lastMes["sender"] as? String,
            let lastText = lastMes["text"] as? String,
            let lastRead = lastMes["read"] as? Bool
            else { return nil }
        
        var senderName = ""
        var read = lastRead
        
        // Get only the first name from the name field
        if senderId == friendUserId {
            senderName = friendName.components(separatedBy: " ")[0] + ": "
            read = lastRead
        } else if senderId == currentUser.uid {
            senderName = "You" + ": "
            read = true
        }
        
        return FriendModel(friendsId: friendsId, userId: friendUserId, name: friendName, lastMessage: senderName + lastText, isRead: read, updated: updated.dateValue())
    }
    
    private func createRequestModel(dict: [String : Any], currentUser: User, friendsId: String) -> (sentRequest: RequestModel?, receivedRequest: RequestModel?) {
        guard let users = dict["users"] as? [String],
            let names = dict["names"] as? [String : String],
            let updated = dict["updated"] as? Timestamp
        else { return (nil, nil) }
                        
        if users[0] == currentUser.uid {
            // Sent request
            guard let name = names[users[1]] else { return (nil, nil) }
            return (RequestModel(friendsId: friendsId, userId: users[1], name: name, updated: updated.dateValue()), nil)
        } else if users[1] == currentUser.uid {
            // Received request
            guard let name = names[users[0]] else { return (nil, nil) }
            return (nil, RequestModel(friendsId: friendsId, userId: users[0], name: name, updated: updated.dateValue()))
        }
        
        return (nil, nil)
    }
    
}



