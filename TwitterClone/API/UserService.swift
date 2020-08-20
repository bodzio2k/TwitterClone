//
//  UserService.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 16/03/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import Firebase

typealias DatabaseCompletion = (Error?, DatabaseReference?) -> Void

class UserService {
    static let shared = UserService()
    static let currentUserUid = Auth.auth().currentUser?.uid ?? ""
    lazy var currentUser: User? = nil
    
    init() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        fetchUser(identifiedBy: uid) { (user) in
            self.currentUser = user
        }
    }
    
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
    
    func fetchAllUser(completion: @escaping ([User]) -> Void) {
        var users = Array<User>()
        
        Globals.users.observe(.childAdded) { (snapshot) in
            guard let userDictionary = snapshot.value as? UserDictionary else {
                return
            }
            
            let uid = snapshot.key
            let user = User(identifedBy: uid, from: userDictionary)
            
            users.append(user)
            
            completion(users)
        }
    }
    
    func follow(_ followingUser: User, completion: @escaping DatabaseCompletion) {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        Globals.userFollowing.child(currentUser.uid).updateChildValues([followingUser.uid: 1]) {err, ref in
            Globals.userFollowers.child(followingUser.uid).updateChildValues([currentUser.uid: 1]) {err, ref in
                NotificationService.shared.upload(notification: .follow, user: followingUser)
                completion(err, ref)
            }
        }
    }
    
    func unfollow(_ userToUnfollow: User, completion: @escaping DatabaseCompletion) {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        Globals.userFollowing.child(currentUser.uid).child(userToUnfollow.uid).removeValue() {err, ref in
            if let err = err {
                completion(err, ref)
            }
            
            Globals.userFollowers.child(userToUnfollow.uid).child(currentUser.uid).removeValue() {err, ref in
                completion(err, ref)
            }
        }
    }
    
    func isFollowed(_ user: User, completion: @escaping (Bool) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        Globals.userFollowing.child(currentUser.uid).child(user.uid).observeSingleEvent(of: .value) { (snapshot) in
            let doesExist = snapshot.exists()
            
            completion(doesExist)
        }
    }
    
    func fetchStats(for user: User, completion: @escaping (Int, Int) -> Void) -> Void {
        var followerCount = 0
        var followingCount = 0
        
        Globals.userFollowing.child(user.uid).observeSingleEvent(of: .value) { (snapshot) in
            followingCount = snapshot.children.allObjects.count
            
            Globals.userFollowers.child(user.uid).observeSingleEvent(of: .value) { (snapshot) in
                followerCount = snapshot.children.allObjects.count
                
                completion(followingCount, followerCount)
            }
        }
    }
    
    func updataProfile(for user: User, completion: @escaping DatabaseCompletion) -> Void {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let userData = ["username": user.username, "fullname": user.fullname, "bio": user.bio ?? ""]
        Globals.users.child(uid).updateChildValues(userData, withCompletionBlock: completion)
    }
    
    func updateProfilePhoto(with image: UIImage, completion: @escaping (URL) -> Void) -> Void {
        guard let jpegData = image.jpegData(compressionQuality: 1.0) else {
            return
        }
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let filename = UUID().uuidString + ".jpeg"
        let ref = Globals.profileImages.child(filename)
        
        ref.putData(jpegData, metadata: nil) { (meta, err) in
            ref.downloadURL { (url, err) in
                guard let profilPhotoUrl = url else {
                    return
                }
                
                let values = ["profilePhotoURL": profilPhotoUrl.absoluteString]
                
                Globals.users.child(uid).updateChildValues(values) { (err, ref) in
                    completion(profilPhotoUrl)
                }
            }
        }
    }
    
    func fetchUser(withUsername username: String, completion: @escaping (User) -> Void) -> Void {
        Globals.usernames.child(username).observeSingleEvent(of: .value) { (snapshot) in
            guard let uid = snapshot.value as? String else {
                return
            }
            
            self.fetchUser(identifiedBy: uid, completion: completion)
        }
    }
}
