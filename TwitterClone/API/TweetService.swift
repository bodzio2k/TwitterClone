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
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let timestamp = Int(Date().timeIntervalSince1970)
        
        let values = ["uid": uid, "caption": caption, "timeStamp": timestamp, "likes": 0, "retweets": 0] as [String : Any]
        
        Globals.tweets.childByAutoId().updateChildValues(values, withCompletionBlock: completion)
    }
    
    func fetchTweets( completion: @escaping ([Tweet]?, Error?) -> Void) -> Void {
        var tweets = Array<Tweet>()
        
        Globals.tweets.observe(.childAdded) { (snapshot) in
            guard let tweetsDictionary = snapshot.value as? TweetDictionary else {
                return
            }
            
            let tweetId = snapshot.key
            let tweet = Tweet(tweetId: tweetId, dictionary: tweetsDictionary)
            tweets.append(tweet)
            
            completion(tweets, nil)
        }
    }
}
