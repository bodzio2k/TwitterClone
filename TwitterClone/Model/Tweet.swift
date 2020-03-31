//
//  Tweet.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 29/03/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import Foundation

struct Tweet {
    let uid: String
    let tweetId: String
    let timestamp: Date
    let caption: String
    let likes: Int
    let retweetes: Int
    
    init(tweetId: String, dictionary: TweetDictionary) {
        self.tweetId = tweetId
        
        uid = dictionary["uid"] as? String ?? ""
        timestamp = Date(timeIntervalSince1970: dictionary["timestamp"] as? TimeInterval ?? 0)
        caption = dictionary["caption"] as? String ?? ""
        likes = dictionary["likes"] as? Int ?? 0
        retweetes = dictionary["retweets"] as? Int ?? 0
    }
}

typealias TweetDictionary = [String: Any]
