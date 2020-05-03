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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
}

extension ProfileController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? TweetViewCell else {
            fatalError()
        }
        
        //cell.delegate = self
        
        //let tweet = tweets[indexPath.row]
        //cell.configure(for: tweet)
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifer, for: indexPath) as? ProfileHeaderView else {
            fatalError()
        }
        
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
