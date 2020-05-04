//
//  ProfileHeaderViewModel.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 03/05/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import UIKit

struct ProfileHeaderViewModel {
    let user: User
    
    private let grayedTextAttrs = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
    private let normalTextAttrs = [NSAttributedString.Key.foregroundColor: UIColor.black]
    
    init(user: User) {
        self.user = user
    }
    
    var following: NSAttributedString {
        let followingString = NSAttributedString(string: " Following ", attributes: grayedTextAttrs)
        let followingCount = NSAttributedString(string: "\(-999)", attributes: normalTextAttrs)
        let finalTextOutput = NSMutableAttributedString()
        
        finalTextOutput.append(followingString)
        finalTextOutput.append(followingCount)
        
        return finalTextOutput
    }
    
    var followers: NSAttributedString {
        let followersString = NSAttributedString(string: " Followers ", attributes: grayedTextAttrs)
        let followersCount = NSAttributedString(string: "\(-998)", attributes: normalTextAttrs)
        let finalTextOutput = NSMutableAttributedString()
        
        finalTextOutput.append(followersString)
        finalTextOutput.append(followersCount)
        
        return finalTextOutput
    }
    
    var actionButtonTitle: String {
        if user.isCurrentUser {
            return "Edit Profile"
        }
        else {
            return "Follow"
        }
    }
}
