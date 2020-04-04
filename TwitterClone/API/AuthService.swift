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
    
    func signIn(withEmail email: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func createUser(_ newUser: AuthUser, completion: @escaping(Error?) -> Void) {
        var profilePhotoURL: String = ""
        
        Auth.auth().createUser(withEmail: newUser.email, password: newUser.password) { (result, error) in
            if let error = error {
                completion(error)
                
                return
            }
            
            guard let uid = result?.user.uid else {
                return
            }
            
            let filename = UUID().uuidString + ".jpeg"
            
            if let data = newUser.profilePhoto.jpegData(compressionQuality: 0.3) {
                Globals.profileImages.child(filename).putData(data, metadata: nil) { (meta, error) in
                    if let error = error {
                        completion(error)
                        
                        return
                    }
                    
                    Globals.profileImages.child(filename).downloadURL { (url, error) in
                        if let error = error {
                            completion(error)
                            
                            return
                        }
                        
                        profilePhotoURL = url?.absoluteString ?? ""
                        
                        let values = ["username": newUser.username, "fullname": newUser.fullname, "profilePhotoURL": profilePhotoURL]
                        
                        Globals.users.child(uid).updateChildValues(values) { (error, ref) in
                            if let error = error {
                                completion(error)
                                
                                return
                            }
                        }
                        
                        completion(nil)
                    }
                }
            }
        }
    }
}
