//
//  User.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 16/03/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import Foundation
import UIKit
import Firebase

struct User {
    let uid: String
    let email: String
    var username: String
    var fullname: String
    var profilePhotoURL: URL?
    var isCurrentUser: Bool {
        return Auth.auth().currentUser?.uid == uid
    }
    var isFollowed: Bool = false
    var followingCount: Int?
    var followerCount: Int?
    var bio: String?
    
    init(identifedBy uid: String, from dictionary: UserDictionary) {
        self.uid = uid
        
        email = dictionary["email"] as? String ?? ""
        username = dictionary["username"] as? String ?? ""
        fullname = dictionary["fullname"] as? String ?? ""
        profilePhotoURL = URL(string: dictionary["profilePhotoURL"] as? String ?? "")
        bio = dictionary["bio"] as? String ?? ""
        
        return
    }
}


typealias UserDictionary = Dictionary<String, Any>
