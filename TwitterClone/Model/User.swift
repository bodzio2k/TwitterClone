//
//  User.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 16/03/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import Foundation
import UIKit

struct User {
    let uid: String
    let email: String
    let username: String
    let fullname: String
    var profilePhotoURL: URL?
    
    init(identifedBy uid: String, from dictionary: Dictionary<String, Any>) {
        self.uid = uid
        
        email = dictionary["email"] as? String ?? ""
        username = dictionary["username"] as? String ?? ""
        fullname = dictionary["fullname"] as? String ?? ""
        profilePhotoURL = URL(string: dictionary["profilePhotoURL"] as? String ?? "")
        
        return
    }
}
