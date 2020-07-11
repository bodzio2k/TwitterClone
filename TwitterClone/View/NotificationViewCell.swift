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
        iv.backgroundColor = .twitterBlue
        
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
    
    //MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profiePhotoImageView)
        profiePhotoImageView.centerY(inView: self)
        profiePhotoImageView.anchor(left: safeAreaLayoutGuide.leftAnchor, paddingLeft: 8.0)
        
        addSubview(label)
        label.centerY(inView: self)
        label.anchor(left: profiePhotoImageView.rightAnchor, paddingLeft: 8.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Helpers
    func configure(for notifiation: Notification) -> Void {
        self.notification = notifiation
        let viewModel = NotificationViewModel(notifiation)
        
        label.attributedText = viewModel.notificationText
        profiePhotoImageView.sd_setImage(with: viewModel.profilePhotoUrl, completed: nil)
    }
    
    //MARK: Selectors
    @objc func profilePhotoImageTapped() {
        delegate?.profiePhotoImageViewTapped(at: self)
    }
}
