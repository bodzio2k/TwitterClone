//
//  ProfileFilterView.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 26/04/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import UIKit

protocol ProfileFilterViewDelegate: class {
    func profileFilterView(_ filterView: ProfileFilterView, didSelectItemAt indexPath: IndexPath) -> Void
}

class ProfileFilterView: UIView {
    //MARK: Properties
    let reuseIdentifier = "ProfileFilterCell"
    weak var delegate: ProfileFilterViewDelegate?
    
    lazy var filterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        cv.isUserInteractionEnabled = true
        
        cv.register(ProfileFilterCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        cv.dataSource = self
        cv.delegate = self
        
        return cv
    }()
    
    //MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .red
        
        addSubview(filterCollectionView)
        filterCollectionView.addConstraintsToFillView(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProfileFilterView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProfileFilterCell
        var caption: String!
        var isSelected = false
        
        switch indexPath.row {
        case 0:
            caption = "Tweets"
            isSelected = true
        case 1:
            caption = "Tweets & replies"
        case 2:
            caption = "Likes"
        default:
            caption = "-----"
        }
        
        cell.captionLabel.text = caption
        cell.isSelected = isSelected
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
}

extension ProfileFilterView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 3.0, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension ProfileFilterView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.profileFilterView(self, didSelectItemAt: indexPath)
    }
}
