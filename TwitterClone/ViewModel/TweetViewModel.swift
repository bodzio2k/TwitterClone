//
//  TweetViewModel.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 05/04/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import UIKit

struct TweetViewModel {
    private let tweet: Tweet
    private let user: User
    private let formatter = DateComponentsFormatter()
    private let now = Date()
    
    var profilePhotoURL: URL? {
        return user.profilePhotoURL
    }
    
    var headerLine: NSAttributedString {
        let headerLine = NSMutableAttributedString()
        let username: NSAttributedString
        let fullname: NSAttributedString
        let timestamp: NSAttributedString
        
        fullname = NSAttributedString(string: user.fullname, attributes: [.font: UIFont.boldSystemFont(ofSize: 12.0)])
        username = NSAttributedString(string: " @\(user.username)", attributes: [.font: UIFont.systemFont(ofSize: 12.0), .foregroundColor: UIColor.lightGray])
        timestamp = NSAttributedString(string: " • \(formatter.string(from: tweet.timestamp, to: now)!)", attributes: [.font: UIFont.systemFont(ofSize: 12.0), .foregroundColor: UIColor.lightGray])
        
        headerLine.append(fullname)
        headerLine.append(username)
        headerLine.append(timestamp)
        
        return headerLine
    }
    
    init(tweet: Tweet) {
        self.tweet = tweet
        self.user = tweet.author
        
        formatter.allowedUnits = [.second, .minute, .weekday]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
    }
}
