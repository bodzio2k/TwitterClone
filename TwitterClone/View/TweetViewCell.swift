//
//  TweetViewCell.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 31/03/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import UIKit

protocol TweetCellDelegate: class {
    func profilePhotoImageViewTapped(at cell: TweetViewCell)
    func replyButtonTapped(at cell: TweetViewCell)
    func likeButtonTapped(at cell: TweetViewCell)
}

class TweetViewCell: UICollectionViewCell {
    //MARK: Properties
    weak var delegate: TweetCellDelegate?
    var tweet: Tweet?
    var buttons: [UIButton]!
    
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
    
    let headerLineLabel: UILabel = {
        let l = UILabel()
        
        l.font = UIFont.boldSystemFont(ofSize: 14.0)
        l.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        return l
    }()
    
    let tweetCaptionLabel: UILabel = {
        let l = UILabel()
        
        l.font = UIFont.systemFont(ofSize: 12.0)
        l.numberOfLines = 0
        l.lineBreakMode = .byWordWrapping
        l.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        return l
    }()
    
    //MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        
        addSubview(profiePhotoImageView)
        profiePhotoImageView.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, paddingTop: 8.0, paddingLeft: 12.0)
        
        addSubview(headerLineLabel)
        headerLineLabel.anchor(top: profiePhotoImageView.topAnchor, left: profiePhotoImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0.0, paddingLeft: 8.0, paddingBottom: 0.0, paddingRight: 0.0, width: nil, height: nil)
        
        addSubview(tweetCaptionLabel)
        tweetCaptionLabel.anchor(top: headerLineLabel.bottomAnchor, left: profiePhotoImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 2.0, paddingLeft: 8.0, paddingBottom: 0.0, paddingRight: 8.0, width: nil, height: nil)

        buttons = createButtons()
        let buttonStack = UIStackView(arrangedSubviews: buttons!)
        buttonStack.spacing = 2.0
        buttonStack.axis = .horizontal
        buttonStack.distribution  = .fillProportionally

        let dividerBar = UIView()
        dividerBar.backgroundColor = .systemGroupedBackground

        addSubview(dividerBar)
        dividerBar.anchor(left: safeAreaLayoutGuide.leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, height: 1.0)
        
        addSubview(buttonStack)
        buttonStack.anchor(top: nil, left: safeAreaLayoutGuide.leftAnchor, bottom: dividerBar.topAnchor, right: rightAnchor, paddingTop: 8.0, paddingBottom: 8.0)
        buttonStack.centerX(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Helpers
    fileprivate func createButtons() -> [UIButton] {
        var buttons = Array<UIButton>()
        let config = UIImage.SymbolConfiguration(pointSize: 12.0)
        
        for j in 0..<4 {
            let b = UIButton(type: .system)
            var i: UIImage?
            var systemName: String!
            var action: Selector
            
            switch j {
            case 0:
                systemName = "bubble.right"
                action = #selector(replyButtonTapped)
            case 1:
                systemName = "arrow.2.squarepath"
                action = #selector(replyButtonTapped)
            case 2:
                systemName = "heart"
                action = #selector(likeButtonTapped)
            case 3:
                systemName = "square.and.arrow.up"
                action = #selector(replyButtonTapped)
            default:
                systemName = "questionmark.diamond"
                action = #selector(replyButtonTapped)
            }
            i = UIImage(systemName: systemName, withConfiguration: config)
            b.setImage(i, for: .normal)
            b.tintColor = .systemGray
            b.addTarget(self, action: action, for: .touchUpInside)
            buttons.append(b)
        }

        return buttons
    }
    
    func configure(for tweet: Tweet) -> Void {
        self.tweet = tweet
        
        let viewModel = TweetViewModel(tweet: tweet)
        
        profiePhotoImageView.sd_setImage(with: viewModel.profilePhotoURL)
        headerLineLabel.attributedText = viewModel.headerLine
        tweetCaptionLabel.text = tweet.caption
        buttons[2].tintColor = viewModel.likeButtonTintColor
        buttons[2].setImage(viewModel.likeButtonImage, for: .normal)
    }
    
    func reconfigure() -> Void {
        if let tweet = self.tweet {
            configure(for: tweet)
        }
    }
    
    //MARK: Selectors
    @objc func profilePhotoImageViewTapped() {
        delegate?.profilePhotoImageViewTapped(at: self)
    }
    
    @objc func replyButtonTapped() {
        delegate?.replyButtonTapped(at: self)
    }
    
    @objc func likeButtonTapped() {
        delegate?.likeButtonTapped(at: self)
    }
}
