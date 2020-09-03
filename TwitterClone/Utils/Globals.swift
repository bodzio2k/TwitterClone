//
//  Globals.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 15/03/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import Foundation
import Firebase

struct Globals {
    static let databaseReference = Database.database().reference()
    
    static let users = databaseReference.child("users")
    static let tweets = databaseReference.child("tweets")
    static let tweetReplies = databaseReference.child("tweet-replies")
    static let userTweets = databaseReference.child("user-tweets")
    static let userFollowing = databaseReference.child("user-following")
    static let userFollowers = databaseReference.child("user-followers")
    static let tweetLikes = databaseReference.child("tweet-likes")
    static let userLikes = databaseReference.child("user-likes")
    static let userReplies = databaseReference.child("user-replies")
    static let notifications = databaseReference.child("notifications")
    static let usernames = databaseReference.child("user-usernames")
    
    static let storageReference = Storage.storage().reference()
    static let profileImages = storageReference.child("profile_images")
    
    static let placeholderCircle = UIImage(systemName: "person.circle")!
    static let placeholderCropCircleFill = UIImage(systemName: "person.crop.circle.fill")!
    static let placeholderCropCircle = UIImage(systemName: "person.crop.circle")!
    
    static var deviceWidth: CGFloat {
        var width: CGFloat = 0.0
        
        if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            width = keyWindow.screen.bounds.width
        }
        
        return width
    }
}
