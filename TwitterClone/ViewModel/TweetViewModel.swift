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
    
    var profilePhotoURL: URL? {
        return user.profilePhotoURL
    }
    
    var headerLine: NSAttributedString {
        let headerLine = NSMutableAttributedString()
        let username: NSAttributedString
        let fullname: NSAttributedString
        
        fullname = NSAttributedString(string: user.fullname, attributes: [.font: UIFont.boldSystemFont(ofSize: 12.0)])
        username = NSAttributedString(string: " @\(user.username.lowercased())", attributes: [.font: UIFont.systemFont(ofSize: 12.0), .foregroundColor: UIColor.lightGray])
        
        headerLine.append(fullname)
        headerLine.append(username)
        
        return headerLine
    }
    
    init(tweet: Tweet) {
        self.tweet = tweet
        self.user = tweet.author
    }
}
