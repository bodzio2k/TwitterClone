//
//  ProfileFilterOption.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 03/05/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import Foundation

enum ProfileFilterOption: Int, CaseIterable {
    case tweets
    case replies
    case likes
    
    var description: String {
        switch self {
        case .tweets:
            return "Tweets"
        case .replies:
            return "Tweet & Replies"
        case .likes:
            return "Likes"
        }
    }
}
