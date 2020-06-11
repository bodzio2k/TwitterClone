//
//  TweetController.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 27/05/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import UIKit

class TweetController: RootViewController {
    //MARK: Properties
    var repliesCollectionView: UICollectionView!
    let cellIdentifier = "cellTweet"
    let headerIdentifer = "TweetHeader"
    var replies = Array<Tweet>()
    private let tweet: Tweet
    
    //MARK: Lifecycle
    init(tweet: Tweet) {
        self.tweet = tweet
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
    
    //MARK: API Calls
    func fetchReplies() -> Void {
        TweetService.shared.fetchReplies(for: tweet) { (replies) in
            self.replies = replies
            
            self.repliesCollectionView.reloadData()
        }
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
       
       header.tweet = tweet
       
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
