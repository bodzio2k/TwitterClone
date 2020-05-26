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
    
    func newTweet(caption: String, completion: @escaping (Error?, DatabaseReference) -> Void) {
        guard let authorId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let timestamp = Int(Date().timeIntervalSince1970)
        
        let values = ["authorId": authorId, "caption": caption, "timestamp": timestamp, "likes": 0, "retweets": 0] as [String : Any]
        
        let tweetRef = Globals.tweets.childByAutoId()
        
        tweetRef.updateChildValues(values) { (err, ref) in
            guard let tweetId = tweetRef.key else {
                return
            }
            
            Globals.userTweets.child(authorId).updateChildValues([tweetId: 1], withCompletionBlock: completion)
        }
    }
    
    func fetchTweets(completion: @escaping ([Tweet]?, Error?) -> Void) -> Void {
        var tweets = Array<Tweet>()
        var author: User?
        
        Globals.tweets.observe(.childAdded) { (snapshot) in
            guard let tweetDictionary = snapshot.value as? TweetDictionary else {
                return
            }
            
            guard let authorId = tweetDictionary["authorId"] as? String else {
                return
            }
            
            UserService.shared.fetchUser(identifiedBy: authorId) { user in
                author = user
                
                let tweetId = snapshot.key
                let tweet = Tweet(createdBy: author!, tweetId: tweetId, dictionary: tweetDictionary)
                tweets.append(tweet)
                
                completion(tweets, nil)
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
}
