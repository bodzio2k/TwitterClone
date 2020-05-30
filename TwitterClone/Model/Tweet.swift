//
//  Tweet.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 29/03/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import Foundation

struct Tweet {
    let authorId: String
    let tweetId: String
    let timestamp: Date
    let caption: String
    let likes: Int
    let retweets: Int
    let author: User
    
    init(createdBy user: User, tweetId: String, dictionary: TweetDictionary) {
        self.tweetId = tweetId
        
        author = user
        
        authorId = dictionary["authorId"] as? String ?? ""
        timestamp = Date(timeIntervalSince1970: dictionary["timestamp"] as? TimeInterval ?? 0)
        caption = dictionary["caption"] as? String ?? ""
        likes = dictionary["likes"] as? Int ?? 0
        retweets = dictionary["retweets"] as? Int ?? 0
    }
}

typealias TweetDictionary = [String: Any]
