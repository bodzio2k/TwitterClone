//
//  Globals.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 15/03/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import Foundation
import Firebase

let DB_REF = Database.database().reference()
let USERS_REF = DB_REF.child("users")

let STORAGE_REF = Storage.storage().reference()
let PROFILE_IMAGES_REF = STORAGE_REF.child("profile_images")
