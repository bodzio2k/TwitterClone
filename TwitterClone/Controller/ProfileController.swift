//
//  ProfileController.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 18/04/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import UIKit

class ProfileController: RootViewController {
    //MARK: Properties
    var tweetsCollectionView: UICollectionView!
    let cellIdentifier = "cellTweet"
    let headerIdentifer = "profileHeader"
    var user: User
    var tweets: [Tweet]?
    
    //MARK: Lifecycle
    init(user: User) {
        self.user = user
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
    //MARK: Helpers
    override func configureUI() {
        super.configureUI()
        
        configureCollectionView()
        fetchTweets()
        checkIsUserFollowed()
        fetchUserStats()
    }
    
    fileprivate func configureCollectionView() {
        tweetsCollectionView = UICollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout())
        
        view.addSubview(tweetsCollectionView)
        tweetsCollectionView.backgroundColor = .white
        tweetsCollectionView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: -44.00, paddingLeft: 0.00, paddingBottom: 0.00, paddingRight: 0.00)
        
        tweetsCollectionView.delegate = self
        tweetsCollectionView.dataSource = self
        
        tweetsCollectionView.register(TweetViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        tweetsCollectionView.register(ProfileHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifer)
    }
    
    //MARK: API calls
    func fetchTweets() -> Void {
        TweetService.shared.fetchTweets(for: user) { (tweets, err) in
            self.tweets = tweets
            self.tweetsCollectionView.reloadData()
        }
    }
    
    func checkIsUserFollowed() -> Void {
        guard UserService.currentUserUid != user.uid else {
            return
        }
        
        UserService.shared.isFollowed(user) { (isFollowed) in
            self.user.isFollowed = isFollowed
            
            self.tweetsCollectionView.reloadData()
        }
    }
    
    func fetchUserStats() -> Void {
        UserService.shared.fetchStats(for: user) { (followingCount, followerCount) in
            self.user.followingCount = followingCount
            self.user.followerCount = followerCount
            
            self.tweetsCollectionView.reloadData()
        }
    }
}

extension ProfileController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? TweetViewCell else {
            fatalError()
        }
        
//        cell.delegate = self
//
        if let tweet = tweets?[indexPath.row] {
            cell.configure(for: tweet)
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifer, for: indexPath) as? ProfileHeaderView else {
            fatalError()
        }
        
        header.user = self.user
        header.delegate = self
        
        return header
    }
}

extension ProfileController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: view.frame.width, height: 200)
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let size = CGSize(width: view.frame.width, height: 350)
        
        return size
    }
}

extension ProfileController: ProfileHeaderViewDelegate {
    func actionButtonTapped(_ user: User) {
        if user.isFollowed {
            UserService.shared.unfollow(user) { (err, ref) in
                if let err = err {
                    fatalError(err.localizedDescription)
                }
            }
        } else {
            UserService.shared.follow(user) { (err, ref) in
                if let err = err {
                    fatalError(err.localizedDescription)
                }
            }
        }
        
        self.user.isFollowed.toggle()
        tweetsCollectionView.reloadData()
    }
    
    func dismiss() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
        
        navigationController?.popViewController(animated: true)
    }
}
