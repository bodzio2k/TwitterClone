//
//  FeedController.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 12/03/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import UIKit

class FeedController: RootViewController {
    //MARK: Properties
    var tweetsCollectionView: UICollectionView!
    let cellIdentifier = "cellTweet"
    var tweets = Array<Tweet>()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        navigationItemView = UIImageView(image: UIImage(named: "twitter_logo_blue"))

        super.viewDidLoad()
        
        fetchTweets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.checkUserLikes(completion: nil)
    }
    
    //MARK: Selectors
    @objc func refresh() {
        tweetsCollectionView.refreshControl?.beginRefreshing()
        fetchTweets()
    }
    
    //MARK: API
    fileprivate func fetchTweets() {
        TweetService.shared.fetchTweets { (tweets, error) in
            if let _ = error {
                return
            }
            
            if let tweets = tweets {
                self.tweets = tweets.sorted(by: { (t1, t2) -> Bool in
                    return t1.timestamp > t2.timestamp
                })
            }
            
            self.tweetsCollectionView.performBatchUpdates({
                self.tweetsCollectionView.reloadData()
                self.checkUserLikes(completion: nil)
            }) { (_) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.tweetsCollectionView.refreshControl?.endRefreshing()
                }
            }
        }
    }
    
    func fetchTweet(with tweetId: String) -> Void {
        if let index = tweets.firstIndex(where: {$0.tweetId == tweetId}) {
            TweetService.shared.fetchTweet(with: tweetId) { (tweet) in
                self.tweets[index] = tweet
            }
        }
    }
    
    fileprivate func checkUserLikes(completion: (() -> Void)?) {
        tweets.forEach { (tweet) in
            TweetService.shared.checkIfUserLikes(tweet) { (didLike) in
                guard let index = self.tweets.firstIndex(where: {$0.tweetId == tweet.tweetId}) else {
                    return
                }
                
                self.tweets[index].didLike = didLike
                let indexPath = IndexPath(row: index, section: 0)
                self.tweetsCollectionView.reloadItems(at: [indexPath])
            }
        }
        completion?()
    }
    
    //MARK: Helpers
    fileprivate func configureCollectionView() {
        tweetsCollectionView = UICollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout())
        
        view.addSubview(tweetsCollectionView)
        tweetsCollectionView.backgroundColor = .white
        tweetsCollectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0.00, paddingLeft: 0.00, paddingBottom: 0.00, paddingRight: 0.00)
        
        tweetsCollectionView.delegate = self
        tweetsCollectionView.dataSource = self
        
        tweetsCollectionView.register(TweetViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tweetsCollectionView.refreshControl = refreshControl
    }
    
    override func configureUI() {
        super.configureUI()
        
        configureCollectionView()
    }
}

extension FeedController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? TweetViewCell else {
            fatalError()
        }
        
        cell.delegate = self
        
        let tweet = tweets[indexPath.row]
        cell.configure(for: tweet)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tweet = tweets[indexPath.row]
        let tweetController = TweetController(tweet: tweet)
        
        tweetController.delegate = self
        navigationController?.pushViewController(tweetController, animated: true)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
}

extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tweet = tweets[indexPath.row]
        
        let viewModel = TweetViewModel(tweet: tweet)
        let size = viewModel.size(for: TweetViewCell.self, width: view.frame.width)
        
        return size
    }
}

extension FeedController: TweetCellDelegate {
    func fetchMentionedUser(withUsername username: String) {
        UserService.shared.fetchUser(withUsername: username) { (user) in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func likeButtonTapped(at cell: TweetViewCell) {
        guard var cellTweet = cell.tweet else {
            return
        }
        
        var likes = cellTweet.likes
        likes = cellTweet.didLike ? likes - 1 : likes + 1
        cellTweet.likes = likes
        
        if let indexInFeed = tweets.firstIndex(where: { $0.tweetId == cellTweet.tweetId }) {
            tweets[indexInFeed] = cellTweet
        }
        
        TweetService.shared.like(cellTweet) { (err, ref) in
            if let _ = err {
                return
            }
            
            cell.tweet?.didLike.toggle()
            cell.tweet?.likes = likes
            cell.configure(for: cellTweet)
            
            self.checkUserLikes(completion: nil)
        }
    }
    
    func replyButtonTapped(at cell: TweetViewCell) {
        guard var tweet = cell.tweet else {
            return
        }
        
        tweet.replyingTo = tweet.author.username
        tweet.originalTweetId = tweet.tweetId
        let newTweetController = NewTweetController(user: tweet.author, config: .reply(tweet))
        let nav = UINavigationController(rootViewController: newTweetController)
   
        present(nav, animated: true, completion: nil)
    }
    
    func profilePhotoImageViewTapped(at cell: TweetViewCell) {
        guard let user = cell.tweet?.author else {
            return
        }
        
        let profileController = ProfileController(user: user)
        
        navigationController?.pushViewController(profileController, animated: true)
    }
}

extension FeedController: TweetControllerDelegate {
    func refrechTweet(id: String) {
        fetchTweet(with: id)
    }
}
