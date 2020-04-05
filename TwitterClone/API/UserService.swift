//
//  UserService.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 16/03/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import Firebase

struct UserService {
    static let shared = UserService()
    
    func fetchUser(identifiedBy uidToFetch: String? = nil, completion: @escaping (User) -> Void) {
        var uid: String
        
        uid = uidToFetch ?? Auth.auth().currentUser?.uid ?? ""
        
        Globals.users.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? Dictionary<String, Any> else {
                return
            }
            
            let user = User(identifedBy: uid, from: dictionary)
            
            completion(user)
        }
    }
}
