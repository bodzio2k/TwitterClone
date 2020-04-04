//
//  Globals.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 15/03/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import Foundation
import Firebase

struct Globals {
    static let databaseReference = Database.database().reference()
    static let users = databaseReference.child("users")
    static let tweets = databaseReference.child("tweets")
    
    static let storageReference = Storage.storage().reference()
    static let profileImages = storageReference.child("profile_images")
}
