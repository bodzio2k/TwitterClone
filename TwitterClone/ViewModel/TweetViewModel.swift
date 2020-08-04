//
//  TweetViewModel.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 05/04/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import UIKit

struct TweetViewModel {
    private let tweet: Tweet
    private let user: User
    private let componentsFormatter = DateComponentsFormatter()
    private let now = Date()
    private let dateFormatter = DateFormatter()
    
    private let grayedTextAttrs = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
    private let normalTextAttrs = [NSAttributedString.Key.foregroundColor: UIColor.black]
    
    private let profilePhotoDimension: CGFloat = 44.0
    
    var profilePhotoURL: URL? {
        return user.profilePhotoURL
    }
    
    var headerLine: NSAttributedString {
        let headerLine = NSMutableAttributedString()
        let username: NSAttributedString
        let fullname: NSAttributedString
        let timestamp: NSAttributedString
        
        fullname = NSAttributedString(string: user.fullname, attributes: [.font: UIFont.boldSystemFont(ofSize: 12.0)])
        username = NSAttributedString(string: " @\(user.username)", attributes: [.font: UIFont.systemFont(ofSize: 12.0), .foregroundColor: UIColor.lightGray])
        timestamp = NSAttributedString(string: " • \(componentsFormatter.string(from: tweet.timestamp, to: now)!)", attributes: [.font: UIFont.systemFont(ofSize: 12.0), .foregroundColor: UIColor.lightGray])
        
        headerLine.append(fullname)
        headerLine.append(username)
        headerLine.append(timestamp)
        
        return headerLine
    }
    
    lazy var timestamp: String = {
        return dateFormatter.string(from: tweet.timestamp)
    }()
    
    lazy var likesAttributedString: NSAttributedString = {
        let likesString = NSAttributedString(string: "Likes ", attributes: grayedTextAttrs)
        let likesCount = NSAttributedString(string: "\(tweet.likes)", attributes: normalTextAttrs)
        let finalTextOutput = NSMutableAttributedString()
        
        finalTextOutput.append(likesString)
        finalTextOutput.append(likesCount)
        
        return finalTextOutput
    }()
    
    lazy var retweetsAttributedString: NSAttributedString = {
        let followersString = NSAttributedString(string: "Retweets ", attributes: grayedTextAttrs)
        let followerCount = NSAttributedString(string: "\(tweet.retweets)", attributes: normalTextAttrs)
        let finalTextOutput = NSMutableAttributedString()
        
        finalTextOutput.append(followersString)
        finalTextOutput.append(followerCount)
        
        return finalTextOutput
    }()
    
    var username: String {
        return "@\(tweet.author.username)"
    }
    
    var likeButtonTintColor: UIColor {
        return tweet.didLike ? UIColor.red : UIColor.lightGray
    }
    
    var likeButtonImage: UIImage {
        let systemName = tweet.didLike ? "suit.heart.fill" : "suit.heart"
        
        return UIImage(systemName: systemName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 12.0))!
    }
    
    func size(for view: AnyClass, width: CGFloat) -> CGSize {
        var calculatedSize: CGSize!
        let measurementLabel = UILabel()
        var height: CGFloat!
        var actualWidth: CGFloat!
        let fontSize: CGFloat!
        let additionalSpace: CGFloat!
        
        switch view {
        case is TweetHeaderView.Type:
            actualWidth = width - 2.0 * 8.0
            fontSize = 20.0
            additionalSpace = 182.0
        case is TweetViewCell.Type:
            actualWidth = (width - profilePhotoDimension) - 3.0 * 8.0
            fontSize = 12.0
            additionalSpace = 92.0
        default:
            actualWidth = width
            fontSize = 12.0
            additionalSpace = 82.0
        }
        
        measurementLabel.text = tweet.caption
        measurementLabel.numberOfLines = 0
        measurementLabel.font = UIFont.systemFont(ofSize: fontSize)
        measurementLabel.lineBreakMode = .byWordWrapping
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false
        measurementLabel.widthAnchor.constraint(equalToConstant: actualWidth).isActive = true
        
        height = measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize).height
        height += additionalSpace
        calculatedSize = CGSize(width: width, height: height)
        
        return calculatedSize
    }
    
    init(tweet: Tweet) {
        self.tweet = tweet
        self.user = tweet.author
        
        componentsFormatter.allowedUnits = [.second, .minute, .weekday]
        componentsFormatter.maximumUnitCount = 1
        componentsFormatter.unitsStyle = .brief
        
        dateFormatter.dateStyle = .long
    }
}
