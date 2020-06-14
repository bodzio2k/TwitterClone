//
//  ActionSheetViewModel.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 13/06/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import Foundation

struct ActionSheetViewModel {
    private let user: User
    lazy var options: Array<ActionSheetOptions> = {
        var results = Array<ActionSheetOptions>()
        
        if user.isCurrentUser {
            results.append(.delete)
        }
        else {
            let followOption: ActionSheetOptions = user.isFollowed ? .unfollow(user) : .follow(user)
            results.append(followOption)
        }
        
        results.append(.report)
        
        return results
    }()
    
    init(user: User) {
        self.user = user
    }
    
    
}

enum ActionSheetOptions {
    case follow(User)
    case unfollow(User)
    case delete
    case report
    
    var description: String {
        switch self {
        case .follow(let user):
            return "Follow @\(user.username)"
        case .unfollow(let user):
            return "Unfollow @\(user.username)"
        case .delete:
            return "Delete"
        case .report:
            return "Report"
        }
    }
}
