//
//  Notification.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 04/07/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import Foundation

enum NotificationType: Int {
    case follow
    case like
    case reply
    case retweet
    case mention
}

struct Notification {
    var user: User
    let tweet: Tweet!
    let timestamp: Date
    let type: NotificationType!
    
    init(user: User, tweet: Tweet?, dictionary: [String:Any]) {
        self.user = user
        self.tweet = tweet
        
        let timestamp = dictionary["timestamp"] as? TimeInterval
        self.timestamp = Date(timeIntervalSince1970: timestamp ?? 0)
        
        self.type = NotificationType(rawValue: (dictionary["type"] as? Int) ?? -1)
        
    }
}

typealias NotificationDictionary = Dictionary<String, AnyObject>
