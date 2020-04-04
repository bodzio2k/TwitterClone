//
//  FeedController.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 12/03/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import UIKit

class FeedController: RootViewController {
    var tweetsCollectionView: UICollectionView!
    let cellIdentifier = "cellTweet"
    
    override func viewDidLoad() {
        navigationItemView = UIImageView(image: UIImage(named: "twitter_logo_blue"))

        super.viewDidLoad()
    }
    
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

extension FeedController: UICollectionViewDelegate {
    
}

extension FeedController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? TweetViewCell else {
            fatalError()
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
}

extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: view.frame.width, height: 100)
        
        return size
    }
}
