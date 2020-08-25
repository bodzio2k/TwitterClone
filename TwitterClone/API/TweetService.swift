//
//      .swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 29/03/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import Foundation
import Firebase

struct TweetService {
    static let shared = TweetService()
    
    func newTweet(caption: String, config: NewTweetConfiguration, completion: @escaping (Error?, DatabaseReference) -> Void) {
        guard let authorId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let timestamp = Int(Date().timeIntervalSince1970)
        
        var values = ["authorId": authorId, "caption": caption, "timestamp": timestamp, "likes": 0, "retweets": 0] as [String : Any]
        
        switch config {
        case .newTweet:
            let tweetRef = Globals.tweets.childByAutoId()
            
            tweetRef.updateChildValues(values) { (err, ref) in
                guard let tweetId = tweetRef.key else {
                    return
                }
                
                Globals.userTweets.child(authorId).updateChildValues([tweetId: 1], withCompletionBlock: completion)
            }
        case .reply(let tweet):
            guard let replyingTo = tweet.replyingTo, let originalTweetId = tweet.originalTweetId else {
                return
            }
            
            values["replyingTo"] = replyingTo
            values["originalTweetId"] = originalTweetId
            
            let tweetReplyRef = Globals.tweetReplies.child(tweet.tweetId).childByAutoId()
            
            tweetReplyRef.updateChildValues(values) { (err, ref) in
                guard let replyId = ref.key else {
                    return
                }
                
                Globals.userReplies.child(authorId).updateChildValues([tweet.tweetId : replyId], withCompletionBlock: completion)
            }
        }

    }
    
    func fetchTweets(completion: @escaping ([Tweet]?, Error?) -> Void) -> Void {
        var tweets = Array<Tweet>()
        
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            return
        }
        
        Globals.userFollowing.child(currentUserId).observe(.childAdded) { snapshot in
            let followingUserId = snapshot.key
            
            Globals.userTweets.child(followingUserId).observe(.childAdded) { snapshot in
                let tweetId = snapshot.key
                
                self.fetchTweet(with: tweetId) { tweet in
                    tweets.append(tweet)
                    completion(tweets, nil)
                }
            }
        }
        
        Globals.userTweets.child(currentUserId).observe(.childAdded) { snapshot in
            let tweetId = snapshot.key

            self.fetchTweet(with: tweetId) { tweet in
                tweets.append(tweet)
                completion(tweets, nil)
            }
        }
//        var author: User?
//
//        Globals.tweets.observe(.childAdded) { (snapshot) in
//            guard let tweetDictionary = snapshot.value as? TweetDictionary else {
//                return
//            }
//
//            guard let authorId = tweetDictionary["authorId"] as? String else {
//                return
//            }
//
//            UserService.shared.fetchUser(identifiedBy: authorId) { user in
//                author = user
//
//                let tweetId = snapshot.key
//                let tweet = Tweet(createdBy: author!, tweetId: tweetId, dictionary: tweetDictionary)
//                tweets.append(tweet)
//
//                completion(tweets, nil)
//            }
//        }
    }
    
    func fetchTweet(with tweetId: String, completion: @escaping (Tweet) -> Void) {
        Globals.tweets.child(tweetId).observeSingleEvent(of: .value) { (snapshot) in
            guard let tweetDictionary = snapshot.value as? TweetDictionary else {
                return
            }
            
            guard let authorId = tweetDictionary["authorId"] as? String else {
                return
            }
            
            UserService.shared.fetchUser(identifiedBy: authorId) { user in
                let tweetId = snapshot.key
                let tweet = Tweet(createdBy: user, tweetId: tweetId, dictionary: tweetDictionary)
                
                completion(tweet)
            }
        }
    }
    
    func fetchTweets(for user: User, completion: @escaping ([Tweet]?, Error?) -> Void) -> Void {
        var tweets = Array<Tweet>()
        
        Globals.userTweets.child(user.uid).observe(.childAdded) { (snapshot) in
            let tweetId = snapshot.key
            
            Globals.tweets.child(tweetId).observeSingleEvent(of: .value) { (snapshot) in
                guard let tweetDictionary = snapshot.value as? TweetDictionary else {
                    return
                }
                
                let tweet = Tweet(createdBy: user, tweetId: tweetId, dictionary: tweetDictionary)
                tweets.append(tweet)
                
                completion(tweets, nil)
            }
        }        
    }
    
    func fetchTweetsLiked(by user: User, completion: @escaping ([Tweet]) -> Void) -> Void {
        var tweets = Array<Tweet>()
        
        Globals.userLikes.child(user.uid).observe(.childAdded) { (snapshot) in
            let tweetId = snapshot.key
            
            self.fetchTweet(with: tweetId) { (tweet) in
                tweet.didLike = true
                tweets.append(tweet)
                
                completion(tweets)
            }
        }
    }
    
    func fetchReplies(for tweet: Tweet, completion: @escaping ([Tweet]) -> Void) -> Void {
        var replies = Array<Tweet>()
        
        Globals.tweetReplies.child(tweet.tweetId).observe(.childAdded) { (snapshot) in
            guard let replyDictionary = snapshot.value as? TweetDictionary else {
                return
            }
            
            guard let uid = replyDictionary["authorId"] as? String else {
                return
            }
            
            UserService.shared.fetchUser(identifiedBy: uid) { (user) in
                let tweetId = snapshot.key
                let reply = Tweet(createdBy: user, tweetId: tweetId, dictionary: replyDictionary)
                replies.append(reply)
                
                completion(replies)
            }
        }
    }
    
    func fetchReplies(madeBy user: User, completion: @escaping ([Tweet]) -> Void) -> Void {
        var replies = Array<Tweet>()
        
        Globals.userReplies.child(user.uid).observe(.childAdded) { (snapshot) in
            let tweetId = snapshot.key
            
            guard let replyId = snapshot.value as? String else {
                return
            }
            
            Globals.tweetReplies.child(tweetId).child(replyId).observeSingleEvent(of: .value) { (snapshot) in
                guard let tweetDictionary = snapshot.value as? TweetDictionary else {
                    return
                }
                
                guard let authorId = tweetDictionary["authorId"] as? String else {
                    return
                }
                
                UserService.shared.fetchUser(identifiedBy: authorId) { user in
                    let tweet = Tweet(createdBy: user, tweetId: replyId, dictionary: tweetDictionary)
                    
                    replies.append(tweet)
                    completion(replies)
                }
            }
        }
    }
    
    func like(_ tweet: Tweet, completion: @escaping DatabaseCompletion) -> Void {
        var ref: DatabaseReference?
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        if tweet.isReply && tweet.originalTweetId != nil {
            ref = Globals.tweetReplies.child(tweet.originalTweetId!).child(tweet.tweetId).child("likes")
        }
        
        if !tweet.isReply {
            ref = Globals.tweets.child(tweet.tweetId).child("likes")
        }
        
        ref?.observeSingleEvent(of: .value, with: { (snapshot) in
            if let likes = snapshot.value as? Int {
                ref?.setValue(tweet.didLike ? likes - 1 : likes + 1)
            }
        })
        
        if tweet.didLike {
            Globals.userLikes.child(uid).child(tweet.tweetId).removeValue { (err, ref) in
                Globals.tweetLikes.child(tweet.tweetId).child(uid).removeValue { (err, ref) in
                    completion(err, ref)
                }
            }
        }
        else {
            Globals.tweetLikes.child(tweet.tweetId).updateChildValues([uid: 1]) { (err, ref) in
                Globals.userLikes.child(uid).updateChildValues([tweet.tweetId: 1]) { (err, ref) in
                    if let _ = err {
                        return
                    }
                    
                    NotificationService.shared.upload(notification: .like, tweet: tweet)
                    
                    completion(err, ref)
                }
            }
        }
    }
    
    func checkIfUserLikes(_ tweet: Tweet, completion: @escaping (Bool) -> Void) -> Void {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        Globals.userLikes.child(uid).child(tweet.tweetId).observeSingleEvent(of: .value) { (snapshot) in
            let snapshotExists = snapshot.exists()
            
            completion(snapshotExists)
        }
    }
}
