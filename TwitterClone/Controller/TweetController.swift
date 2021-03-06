//
//  TweetController.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 27/05/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import UIKit

protocol TweetControllerDelegate: class {
    func refrechTweet(id: String)
}

class TweetController: RootViewController {
    //MARK: Properties
    var repliesCollectionView: UICollectionView!
    let cellIdentifier = "cellTweet"
    let headerIdentifer = "TweetHeader"
    var replies = Array<Tweet>()
    private var tweet: Tweet
    private lazy var actionSheetLauncher = ActionSheetLauncher(for: tweet.author)
    weak var delegate: TweetControllerDelegate?
    
    //MARK: Lifecycle
    init(tweet: Tweet) {
        self.tweet = tweet
        
        super.init(nibName: nil, bundle: nil)
        
        actionSheetLauncher.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        if parent == nil {
            delegate?.refrechTweet(id: tweet.tweetId)
        }
    }
    
    //MARK: API Calls
    func fetchReplies() -> Void {
        TweetService.shared.fetchReplies(for: tweet) { (replies) in
            self.replies = replies.sorted { $0.timestamp < $1.timestamp }
            
            self.repliesCollectionView.reloadData()
            self.checkUserLikes(completion: nil)
        }
    }
    
    fileprivate func checkUserLikes(completion: (() -> Void)?) {
        replies.forEach { (tweet) in
            TweetService.shared.checkIfUserLikes(tweet) { (didLike) in
                guard let index = self.replies.firstIndex(where: {$0.tweetId == tweet.tweetId}) else {
                    return
                }
                
                self.replies[index].didLike = didLike
                let indexPath = IndexPath(row: index, section: 0)
                self.repliesCollectionView.reloadItems(at: [indexPath])
            }
        }
        completion?()
    }
    
    //MARK: Helper
    override func configureUI() {
        super.configureUI()
        
        configureCollectionView()
        
        fetchReplies()
    }
    
    fileprivate func configureCollectionView() {
        repliesCollectionView = UICollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout())
        
        view.addSubview(repliesCollectionView)
        repliesCollectionView.addConstraintsToFillView(self.view)
        repliesCollectionView.delegate = self
        repliesCollectionView.dataSource = self
        
        repliesCollectionView.register(TweetViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        repliesCollectionView.register(TweetHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifer)
        repliesCollectionView.backgroundColor = .white
    }
}

extension TweetController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return replies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? TweetViewCell else {
            fatalError()
        }
        
        let tweet = replies[indexPath.row]
        cell.delegate = self
        cell.configure(for: tweet)
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension TweetController: UICollectionViewDelegate {
   func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifer, for: indexPath) as? TweetHeaderView else {
           fatalError()
        
        }
    
        header.delegate = self
        header.configure(for: tweet)
       
        return header
   }
}

extension TweetController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let reply = replies[indexPath.row]
        
        let viewModel = TweetViewModel(tweet: reply)
        let size = viewModel.size(for: TweetViewCell.self, width: view.frame.width)
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let viewModel = TweetViewModel(tweet: tweet)
        let size = viewModel.size(for: TweetHeaderView.self, width: view.frame.width)
        
        return size
    }
}

extension TweetController: TweetHeaderViewDelegate {
    func fetchMentionedUser(withUsername username: String) {
        UserService.shared.fetchUser(withUsername: username) { (user) in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func likeButtonTapped(at headerView: TweetHeaderView) {
        guard var tweet = headerView.tweet else {
            return
        }
        
        let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
        tweet.likes = likes
        
        TweetService.shared.like(tweet) { (err, ref) in
            if let _ = err {
                return
            }
            
            tweet.didLike.toggle()
            tweet.likes = likes
            headerView.configure(for: tweet)
            
            return
        }
    }
    
    func profilePhotoImageViewTapped() {
        let profileController = ProfileController(user: tweet.author)
        
        navigationController?.pushViewController(profileController, animated: true)
    }
    
    func replyButtonTapped() {
        tweet.replyingTo = tweet.author.username
        tweet.originalTweetId = tweet.tweetId
        
        let newTweetController = NewTweetController(user: tweet.author, config: .reply(tweet))
        let nav = UINavigationController(rootViewController: newTweetController)
        present(nav, animated: true, completion: nil)
    }
    
    func optionButtonTapped() {
        if tweet.author.isCurrentUser {
            self.actionSheetLauncher.show()
        }
        else {
            UserService.shared.isFollowed(tweet.author) { isFollowed in
                var user = self.tweet.author
                user.isFollowed = isFollowed
                
                self.actionSheetLauncher = ActionSheetLauncher(for: user)
                self.actionSheetLauncher.delegate = self
                self.actionSheetLauncher.show()
            }
        }
    }
}

extension TweetController: ActionSheetLauncherDelegate {
    func didSelect(option: ActionSheetOptions) {
        switch option {
        case .follow(let user):
            UserService.shared.follow(user) { (err, ref) in
                return
            }
        case .unfollow(let user):
            UserService.shared.unfollow(user) { (err, ref) in
                return
            }
        case .delete:
            return
        case .report:
            return
        }
    }
}

extension TweetController: TweetCellDelegate {
    func likeButtonTapped(at cell: TweetViewCell) {
        guard var tweet = cell.tweet else {
            return
        }
        
        var likes = tweet.likes
        likes = tweet.didLike ? likes - 1 : likes + 1
        tweet.likes = likes
        
        TweetService.shared.like(tweet) { (err, ref) in
            tweet.didLike.toggle()
            cell.configure(for: tweet)
        }
    }
    
    func replyButtonTapped(at cell: TweetViewCell) {
        guard var tweet = cell.tweet else {
            return
        }
        
        tweet.replyingTo = tweet.author.username
        tweet.originalTweetId = self.tweet.tweetId
        
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
