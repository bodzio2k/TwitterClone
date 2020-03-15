//
//  AuthService.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 15/03/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import UIKit
import Firebase

struct AuthUser {
    let email: String
    let username: String
    let fullname: String
    let password: String
    let profilePhoto: UIImage
}
struct AuthService {
    static let shared = AuthService()
    
    func register(_ newUser: AuthUser, completion: @escaping(Error?) -> Void) {
        Auth.auth().createUser(withEmail: newUser.email, password: newUser.password) { (result, error) in
            if let error = error {
                completion(error)
                
                return
            }
            
            guard let uid = result?.user.uid else {
                return
            }
                        
            let values = ["username": newUser.username, "fullname": newUser.fullname]
            
            USERS_REF.child(uid).updateChildValues(values) { (error, ref) in
                if let error = error {
                    completion(error)
                    
                    return
                }
            }
            
            if let data = newUser.profilePhoto.jpegData(compressionQuality: 0.3) {
                PROFILE_IMAGES_REF.child(uid).putData(data, metadata: nil) { (meta, error) in
                    if let error = error {
                        completion(error)
                        
                        return
                    }
                }
            }
            
            completion(nil)
        }
    }
}
