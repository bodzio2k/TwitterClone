//
//  NotificationViewCell.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 06/07/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import UIKit

protocol NotificationViewCellDelegate: class {
    func profiePhotoImageViewTapped(at cell: NotificationViewCell)
    func followButtonTapped(at cell: NotificationViewCell)
}

class NotificationViewCell: UITableViewCell {
    //MARK: Properties
    var notification: Notification?
    lazy var profiePhotoImageView: UIImageView = {
        let profilePhotoSize: CGFloat = 44.0
        let iv = UIImageView()
        
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = profilePhotoSize / 2.0
        iv.layer.masksToBounds = true
        iv.setDimensions(width: profilePhotoSize, height: profilePhotoSize)
        iv.tintColor = .lightGray
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(profilePhotoImageTapped))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        
        return iv
    }()
    weak var delegate: NotificationViewCellDelegate?
    
    lazy var label: UILabel = {
        let l = UILabel()
        
        l.font = UIFont.boldSystemFont(ofSize: 14.0)
        
        return l
    }()
    
    lazy var followButton: UIButton = {
        let b = UIButton(type: .system)
        
        b.setTitle("Follow", for: .normal)
        b.setTitleColor(.twitterBlue, for: .normal)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
        b.backgroundColor = .white
        b.layer.borderWidth = 1.25
        b.layer.borderColor = UIColor.twitterBlue.cgColor
        b.addTarget(self, action: #selector(followButtonTapped), for: .touchUpInside)
        b.isHidden = true
        
        return b
    }()
    
    //MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profiePhotoImageView)
        profiePhotoImageView.centerY(inView: self)
        profiePhotoImageView.anchor(left: safeAreaLayoutGuide.leftAnchor, paddingLeft: 8.0)
        
        addSubview(followButton)
        followButton.centerY(inView: self)
        followButton.anchor(right: safeAreaLayoutGuide.rightAnchor, paddingRight: 8.0)
        followButton.setDimensions(width: 88.0, height: 32.0)
        followButton.layer.cornerRadius = 16.0
        
        addSubview(label)
        label.centerY(inView: self)
        label.anchor(left: profiePhotoImageView.rightAnchor, right: followButton.leftAnchor, paddingLeft: 8.0, paddingRight: 2.0)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Helpers
    func configure(for notifiation: Notification) -> Void {
        self.notification = notifiation
        let viewModel = NotificationViewModel(notifiation)
        
        label.attributedText = viewModel.notificationText
        label.numberOfLines = viewModel.notificationTextNumberOfLines
        profiePhotoImageView.sd_setImage(with: viewModel.profilePhotoUrl, placeholderImage: Globals.placeholderCircle)
        followButton.isHidden = viewModel.shouldHideFollowButton
        followButton.setTitle(viewModel.followButtonText, for: .normal)
    }
    
    func reconfigure() -> Void {
        if let notification = self.notification {
            configure(for: notification)
        }
    }
    
    //MARK: Selectors
    @objc func profilePhotoImageTapped() {
        delegate?.profiePhotoImageViewTapped(at: self)
    }
    
    @objc func followButtonTapped() {
        delegate?.followButtonTapped(at: self)
    }
}
