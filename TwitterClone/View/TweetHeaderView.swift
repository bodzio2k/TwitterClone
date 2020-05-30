//
//  TweetHeaderView.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 27/05/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import UIKit

class TweetHeaderView: UICollectionReusableView {
    //MARK: Properties
    var tweet: Tweet? {
        didSet {
            if let tweet = tweet {
                var viewModel = TweetViewModel(tweet: tweet)
                
                usernameLabel.text = viewModel.username
                fullnameLabel.text = tweet.author.fullname
                captionLabel.text = tweet.caption
                
                if let profilePhotoURL = tweet.author.profilePhotoURL {
                    profiePhotoImageView.sd_setImage(with: profilePhotoURL)
                }
                
                timestampLabel.text = viewModel.timestamp
                likesLabel.attributedText = viewModel.likesAttributedString
                retweetsLabel.attributedText = viewModel.retweetsAttributedString
            }
        }
    }
    lazy var profiePhotoImageView: UIImageView = {
       let profilePhotoSize: CGFloat = 44.0
       let iv = UIImageView()
       
       iv.contentMode = .scaleAspectFit
       iv.layer.cornerRadius = profilePhotoSize / 2.0
       iv.layer.masksToBounds = true
       iv.setDimensions(width: profilePhotoSize, height: profilePhotoSize)
       iv.backgroundColor = .twitterBlue
       
       let tap = UITapGestureRecognizer(target: self, action: #selector(profilePhotoImageViewTapped))
       iv.addGestureRecognizer(tap)
       iv.isUserInteractionEnabled = true
       
       return iv
    }()
    
    let fullnameLabel: UILabel = {
        let l = UILabel()
        
        l.font = UIFont.boldSystemFont(ofSize: 14.0)
        
        return l
    }()
    
    let usernameLabel: UILabel = {
        let l = UILabel()
        
        l.font = UIFont.boldSystemFont(ofSize: 12.0)
        l.textColor = .lightGray
        
        return l
    }()
    
    let captionLabel: UILabel = {
        let l = UILabel()
        
        l.font = UIFont.systemFont(ofSize: 20.0)
        l.numberOfLines = 0
        l.lineBreakMode = .byWordWrapping
        
        return l
    }()
    
    let timestampLabel: UILabel = {
        let l = UILabel()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        l.font = UIFont.boldSystemFont(ofSize: 12.0)
        l.textColor = .lightGray
        l.text = dateFormatter.string(from: Date())
        
        return l
    }()
    
    let optionButton: UIButton = {
        let b = UIButton(type: .system)
        b.tintColor = .lightGray
        let i = UIImage(systemName: "chevron.down")
        b.setImage(i, for: .normal)
        b.addTarget(self, action: #selector(optionButtonTapped), for: .touchUpInside)
        
        return b
    }()
    
    lazy var retweetsLabel: UILabel = {
        let l = UILabel()
        
        l.font = UIFont.systemFont(ofSize: 12.0)
        l.numberOfLines = 1
        
        return l
    }()
    
    lazy var likesLabel: UILabel = {
        let l = UILabel()
        
        l.font = UIFont.systemFont(ofSize: 12.0)
        l.numberOfLines = 1
        
        return l
    }()
    
    lazy var statsView: UIView = {
        let v = UIView()
        
        let topDivider = UIView()
        topDivider.backgroundColor = .systemGroupedBackground
        
        v.addSubview(topDivider)
        topDivider.anchor(top: v.topAnchor, left: v.leftAnchor, right: v.rightAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: v.frame.width, height: 1.0)
        
        let bottomDivider = UIView()
        bottomDivider.backgroundColor = .systemGroupedBackground
        
        let statsStack = UIStackView(arrangedSubviews: [likesLabel, retweetsLabel])
        statsStack.axis = .horizontal
        statsStack.distribution = .fillEqually
        statsStack.spacing = 8.0
        
        v.addSubview(statsStack)
        statsStack.anchor(top: topDivider.bottomAnchor, left: v.leftAnchor, paddingTop: 8.0, paddingLeft: 8.0, paddingRight: 16.0)
        
        v.addSubview(bottomDivider)
        bottomDivider.anchor(top: statsStack.bottomAnchor, left: v.leftAnchor, right: v.rightAnchor, paddingTop: 8.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: v.frame.width, height: 1.0)
        
        return v
    }()
    
    //MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(profiePhotoImageView)
        profiePhotoImageView.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, paddingTop: 8.0, paddingLeft: 8.0)
        
        addSubview(fullnameLabel)
        fullnameLabel.anchor(top: safeAreaLayoutGuide.topAnchor, left: profiePhotoImageView.rightAnchor, paddingTop: 8.0, paddingLeft: 8.0)
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: fullnameLabel.bottomAnchor, left: profiePhotoImageView.rightAnchor, paddingTop: 0.0, paddingLeft: 8.0)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: profiePhotoImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8.0, paddingLeft: 8.0, paddingBottom: 0.0, paddingRight: 8.0, width: nil, height: nil)
        
        addSubview(timestampLabel)
        timestampLabel.anchor(top: captionLabel.bottomAnchor, left: leftAnchor, paddingTop: 8.0, paddingLeft: 8.0)

        addSubview(optionButton)
        optionButton.anchor(top: safeAreaLayoutGuide.topAnchor, right: rightAnchor, paddingTop: 12.0, paddingRight: 12.0)

        addSubview(statsView)
        statsView.anchor(top: timestampLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8.0, height: 40.0)

        let buttons = createButtons()
        let buttonStack = UIStackView(arrangedSubviews: buttons)
        buttonStack.axis = .horizontal
        buttonStack.distribution  = .fillEqually

        addSubview(buttonStack)
        buttonStack.anchor(top: statsView.bottomAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Selectors
    @objc func profilePhotoImageViewTapped() {
        
    }
    
    @objc func optionButtonTapped() {
        
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
}
