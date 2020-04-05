//
//  TweetViewCell.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 31/03/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import UIKit

class TweetViewCell: UICollectionViewCell {
    //MARK: Properties
     let profiePhotoImageView: UIImageView = {
        let profilePhotoSize: CGFloat = 44.0
        let iv = UIImageView()
        
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = profilePhotoSize / 2.0
        iv.layer.masksToBounds = true
        iv.setDimensions(width: profilePhotoSize, height: profilePhotoSize)
        iv.backgroundColor = .twitterBlue
        
        return iv
    }()
    
    let headerLineLabel: UILabel = {
        let l = UILabel()
        
        l.font = UIFont.boldSystemFont(ofSize: 14.0)
        l.text = "Hi there"
        
        return l
    }()
    
    let tweetCaptionLabel: UILabel = {
        let l = UILabel()
        
        l.font = UIFont.systemFont(ofSize: 12.0)
        l.text = "Hello there"
        
        return l
    }()
    
    //MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        
        addSubview(profiePhotoImageView)
        profiePhotoImageView.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, paddingTop: 8.0, paddingLeft: 12.0)
        
        let tweetStack = UIStackView(arrangedSubviews: [headerLineLabel, tweetCaptionLabel])
        tweetStack.axis = .vertical
        tweetStack.distribution = .fillProportionally
        
        addSubview(tweetStack)
        tweetStack.anchor(top: safeAreaLayoutGuide.topAnchor, left: profiePhotoImageView.rightAnchor, right: rightAnchor, paddingTop: 8.0, paddingLeft: 12.0)
        
        let buttons = createButtons()
        let buttonStack = UIStackView(arrangedSubviews: buttons)
        buttonStack.axis = .horizontal
        buttonStack.distribution  = .fillEqually
        
        addSubview(buttonStack)
        buttonStack.anchor(top: nil, left: safeAreaLayoutGuide.leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingBottom: 8.0)
        buttonStack.centerX(inView: self)
        
        let dividerBar = UIView()
        dividerBar.backgroundColor = .lightGray
        
        addSubview(dividerBar)
        dividerBar.anchor(left: safeAreaLayoutGuide.leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, height: 1.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Helpers
    fileprivate func createButtons() -> [UIView] {
        var buttons = Array<UIView>()
        
        for j in 0..<4 {
            let b = UIButton(type: .system)
            var i: UIImage?
            var systemName: String!
            
            switch j {
            case 0:
                systemName = "bubble.right"
            case 1:
                systemName = "arrow.2.squarepath"
            case 2:
                systemName = "heart"
            case 3:
                systemName = "square.and.arrow.up"
            default:
                systemName = "questionmark.diamond"
            }
            i = UIImage(systemName: systemName)
            b.setImage(i, for: .normal)
            b.tintColor = .systemGray
            buttons.append(b)
        }

        return buttons
    }
    
    func configure(for tweet: Tweet) -> Void {
        let viewModel = TweetViewModel(tweet: tweet)
        
        profiePhotoImageView.sd_setImage(with: viewModel.profilePhotoURL)
        headerLineLabel.attributedText = viewModel.headerLine
        tweetCaptionLabel.text = tweet.caption
    }    
}
