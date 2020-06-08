//
//  NewTweetViewModel.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 31/05/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import UIKit

struct NewTweetViewModel {
    var actionButtonTitle: String
    var placeholderText: String
    var shouldShowReplyLabel: Bool
    var replyLabelText: String?
    
    init(config: NewTweetConfiguration) {
        switch config {
        case .newTweet:
            actionButtonTitle = "Tweet"
            placeholderText = "What is happening?"
            shouldShowReplyLabel = false
        case .reply(let tweet):
            actionButtonTitle = "Reply"
            placeholderText = "Tweet Your reply"
            shouldShowReplyLabel = true
            replyLabelText = "Replying to @\(tweet.author.username)"
        }
    }
}
