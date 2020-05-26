//
//  UserCell.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 10/05/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    //MARK: Properties
    lazy var profiePhotoImageView: UIImageView = {
        let profilePhotoSize: CGFloat = 44.0
        let iv = UIImageView()
        
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = profilePhotoSize / 2.0
        iv.layer.masksToBounds = true
        iv.setDimensions(width: profilePhotoSize, height: profilePhotoSize)
        iv.backgroundColor = .twitterBlue
        
        
        return iv
    }()
    
    let fullnameLabel: UILabel = {
        let l = UILabel()
        
        l.font = UIFont.boldSystemFont(ofSize: 14.0)
        l.text = "full Name"
        
        return l
    }()
    
    let usernameLabel: UILabel = {
        let l = UILabel()
        
        l.font = UIFont.systemFont(ofSize: 12.0)
        l.textColor = .lightGray
        
        l.text = "USerName"
        
        return l
    }()
    
    //MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profiePhotoImageView)
        profiePhotoImageView.centerY(inView: self, leftAnchor: self.leftAnchor, paddingLeft: 8.0)
        
        let sv = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel])
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 2
        
        addSubview(sv)
        sv.centerY(inView: self, leftAnchor: profiePhotoImageView.rightAnchor, paddingLeft: 8.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Helpers
    func configure(for user: User) -> Void {
        profiePhotoImageView.sd_setImage(with: user.profilePhotoURL)
        usernameLabel.text = "@\(user.username)"
        fullnameLabel.text = user.fullname
    }
}
