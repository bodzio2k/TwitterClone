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
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        Globals.notifications.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if !snapshot.exists() {
                completion(notifications)
            }
            else {
                Globals.notifications.child(uid).observe(.childAdded) { (snapshot) in
                    guard let dictionary = snapshot.value as? NotificationDictionary else {
                        return
                    }
                    
                    guard let uid = dictionary["uid"] as? String else {
                        return
                    }
                    
                    if let tweetId = dictionary["tweetId"] as? String {
                        print("fetching tweet \(tweetId)...")
                        TweetService.shared.fetchTweet(with: tweetId) { (tweet) in
                            UserService.shared.fetchUser(identifiedBy: uid) { (user) in
                                let notification = Notification(user: user, tweet: tweet, dictionary: dictionary)
                                
                                notifications.append(notification)
                                completion(notifications.sorted { $0.timestamp > $1.timestamp })
                            }
                        }
                    }
                    else {
                        UserService.shared.fetchUser(identifiedBy: uid) { (user) in
                            let notification = Notification(user: user, tweet: nil,  dictionary: dictionary)
                            
                            notifications.append(notification)
                            completion(notifications)
                        }
                    }
                }
            }
        }
    }
}
