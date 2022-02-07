//
//  Notification.swift
//  MySNS
//
//  Created by SANGMIN YEOM on 2022/01/27.
//

import Firebase

enum NotificationType: Int {
    case like
    case follow
    case comment
    
    var notificationMessage: String {
        switch self {
        case .like : return " liked your post."
        case .follow : return " started following you."
        case .comment : return " commented on your post"
        }
    }
}

struct Notification {
    let uid: String
    var postImageUrl: String?
    var postId: String?
    let timestamp: Timestamp
    let type: NotificationType
    let id: String
    let userProfileImageUrl: String
    let username: String
    var userIsFollowed = false
    
    init(dic: [String:Any]) {
        self.timestamp = dic["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.id = dic["id"] as? String ?? ""
        self.uid = dic["uid"] as? String ?? ""
        self.postId = dic["postId"] as? String ?? ""
        self.postImageUrl = dic["postImageUrl"] as? String ?? ""
        self.type = NotificationType(rawValue: dic["type"] as? Int ?? 0) ?? .like
        self.userProfileImageUrl = dic["userProfileImageUrl"] as? String ?? ""
        self.username = dic["username"] as? String ?? ""
        
    }
}
