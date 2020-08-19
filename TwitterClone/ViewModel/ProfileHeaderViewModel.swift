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
    
//    init(user: User) {
//        self.user = user
//    }
    
    var following: NSAttributedString {
        let followingString = NSAttributedString(string: "Following ", attributes: grayedTextAttrs)
        let followingCount = NSAttributedString(string: "\(user.followingCount ?? 0)", attributes: normalTextAttrs)
        let finalTextOutput = NSMutableAttributedString()
        
        finalTextOutput.append(followingString)
        finalTextOutput.append(followingCount)
        
        return finalTextOutput
    }
    
    var followers: NSAttributedString {
        let followersString = NSAttributedString(string: " Followers ", attributes: grayedTextAttrs)
        let followerCount = NSAttributedString(string: "\(user.followerCount ?? 0)", attributes: normalTextAttrs)
        let finalTextOutput = NSMutableAttributedString()
        
        finalTextOutput.append(followersString)
        finalTextOutput.append(followerCount)
        
        return finalTextOutput
    }
    
    var actionButtonTitle: String {
        var title: String = "Loading..."
        
        if user.isCurrentUser {
            title = "Edit Profile"
            
            return title
        }
        
        if user.isFollowed {
            title = "Following"
        } else {
            title = "Follow"
        }
        
        return title
    }
    
    var height: CGFloat {
        let l = UILabel()
        let width = UIScreen.main.bounds.width - 8.0 - 20.0
        
        l.text = user.bio
        l.font = UIFont.systemFont(ofSize: 14.0)
        l.numberOfLines = 0
        l.lineBreakMode = .byWordWrapping
        l.translatesAutoresizingMaskIntoConstraints = false
        l.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        let height = l.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize).height
        
        return 302.0 + (height == 0 ? 16.0 : height)
    }
}
