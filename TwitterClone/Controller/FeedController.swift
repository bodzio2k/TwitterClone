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
        
        TweetService.shared.fetchTweets { (tweets, error) in
            if let _ = error {
                return
            }
            
            if let tweets = tweets {
                self.tweets = tweets
            }
            
            self.tweetsCollectionView.reloadData()
        }
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
    func profilePhotoImageViewTapped(at cell: TweetViewCell) {
        guard let user = cell.tweet?.author else {
            return
        }
        
        let profileController = ProfileController(user: user)
        
        navigationController?.pushViewController(profileController, animated: true)
    }
}
