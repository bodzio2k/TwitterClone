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
    var tweetsCollectionView: UICollectionView!
    let cellIdentifier = "cellTweet"
    let headerIdentifer = "TweetHeader"
    var tweets: [Tweet]?
    private let tweet: Tweet
    
    //MARK: Lifecycle
    init(tweet: Tweet) {
        self.tweet = tweet
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: API Calls
    //MARK: Helper
    override func configureUI() {
        super.configureUI()
        
        configureCollectionView()
    }
    
    fileprivate func configureCollectionView() {
        tweetsCollectionView = UICollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout())
        
        view.addSubview(tweetsCollectionView)
        //tweetsCollectionView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: -44.00, paddingLeft: 0.00, paddingBottom: 0.00, paddingRight: 0.00)
        tweetsCollectionView.addConstraintsToFillView(self.view)
        tweetsCollectionView.delegate = self
        tweetsCollectionView.dataSource = self
        
        tweetsCollectionView.register(TweetViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        tweetsCollectionView.register(TweetHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifer)
    }
}

extension TweetController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
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
        let size = CGSize(width: view.frame.width, height: 200)
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let viewModel = TweetViewModel(tweet: tweet)
        let size = viewModel.size(for: TweetHeaderView.self, width: view.frame.width)
        
        return size
    }
}
