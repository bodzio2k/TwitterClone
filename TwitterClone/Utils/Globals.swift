//
//  Globals.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 15/03/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import Foundation
import Firebase

let databaseReference = Database.database().reference()
let users = databaseReference.child("users")
let tweets = databaseReference.child("tweets")

let storageReference = Storage.storage().reference()
let profileImages = storageReference.child("profile_images")
