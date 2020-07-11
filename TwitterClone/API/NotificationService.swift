//
//  NotificationService.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 05/07/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import Firebase

struct NotificationService {
    static let shared = NotificationService()
    
    func upload(notification type: NotificationType, tweet: Tweet? = nil, user: User? = nil) -> Void {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let timestamp = Date().timeIntervalSince1970
        
        var values: Dictionary<String, Any> = ["timestamp": timestamp, "uid": uid, "type": type.rawValue]
        
        if let tweet = tweet {
            values["tweetId"] = tweet.tweetId
            
            Globals.notifications.child(tweet.authorId).childByAutoId().updateChildValues(values)
        }
        else if let user = user {
            Globals.notifications.child(user.uid).childByAutoId().updateChildValues(values)
        }
        
        return
    }
    
    func fetchNotifications(completion: @escaping ([Notification]) -> Void) {
        var notifications = Array<Notification>()

        guard let user = Auth.auth().currentUser else {
            return
        }

        Globals.notifications.child(user.uid).observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? NotificationDictionary else {
                return
            }
            
            guard let uid = dictionary["uid"] as? String else {
                return
            }
            
            guard let tweetId = dictionary["tweetId"] as? String else {
                return
            }
            
            UserService.shared.fetchUser(identifiedBy: uid) { (user) in
                TweetService.shared.fetchTweet(with: tweetId) { (tweet) in
                    let notification = Notification(user: user, tweet: tweet, dictionary: dictionary)
                    
                    notifications.append(notification)
                    completion(notifications)
                }
            }
        }
    }
}
