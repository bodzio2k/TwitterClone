//
//  EditProfileHeaderView.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 16/08/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import UIKit

protocol EditProfileHeaderViewDelegate: class {
    func changeProfilePhoto()
}

class EditProfileHeaderView: UIView {
    //MARK: Properties
    private let user: User
    var delegate: EditProfileHeaderViewDelegate?
    lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        
        iv.backgroundColor = .white
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 4.0
        iv.tintColor = .lightGray
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(changeProfilePhoto))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        
        iv.sd_setImage(with: user.profilePhotoURL, placeholderImage: Globals.placeholderCropCircleFill)
        
        return iv
    }()
    
    //MARK: Lifycycle
    init(user: User) {
        let profilePhotoSize: CGFloat = 140.0
        self.user = user
        
        super.init(frame: .zero)
        
        self.backgroundColor = .twitterBlue
        
        addSubview(profileImageView)
        profileImageView.center(inView: self)
        profileImageView.setDimensions(width: profilePhotoSize, height: profilePhotoSize)
        profileImageView.layer.cornerRadius = profilePhotoSize / 2.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Selectors
    @objc func changeProfilePhoto() {
        delegate?.changeProfilePhoto()
    }
}
