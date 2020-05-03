//
//  ProfileHeader.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 21/04/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import UIKit

class ProfileHeaderView: UICollectionReusableView {
    //MARK: Properties
    var followingCount = 0
    var followersCount = 0
    
    let dissmisalButton: UIButton = {
        let b = UIButton(type: UIButton.ButtonType.system)
        let i = UIImage(systemName: "arrow.left")?.withTintColor(.white).withRenderingMode(.alwaysOriginal)
        
        b.setImage(i, for: .normal)
        
        return b
    }()
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        
        iv.backgroundColor = .lightGray
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 4.0
        
        return iv
    }()
    
    let containerView: UIView = {
        let v = UIView()
        
        v.backgroundColor = .twitterBlue
        
        return v
    }()
    
    let followButton: UIButton = {
        let b = UIButton(type: .system)
        
        b.setTitle("Follow", for: .normal)
        b.setTitleColor(.twitterBlue, for: .normal)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
        b.backgroundColor = .white
        b.layer.borderWidth = 1.25
        b.layer.borderColor = UIColor.twitterBlue.cgColor
        
        return b
    }()
    
    let profileNameLabel: UILabel = {
        let l = UILabel()
        
        l.text = "Eddie Brock"
        l.font = UIFont.boldSystemFont(ofSize: 24.0)
        
        return l
    }()
    
    let usernameLabel: UILabel = {
        let l = UILabel()
        
        l.text = "@Eddie_Brock".lowercased()
        l.font = UIFont.systemFont(ofSize: 12)
        l.textColor = .lightGray
        
        return l
    }()
    
    let bioLabel: UILabel = {
        let l = UILabel()
        
        l.text = "Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit..."
        l.font = UIFont.systemFont(ofSize: 12.0)
        l.numberOfLines = 0
        
        return l
    }()
    
    lazy var folowingLabel: UILabel = {
        let l = UILabel()
        let grayedTextAttrs = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        let normalTextAttrs = [NSAttributedString.Key.foregroundColor: UIColor.black]
        let followingString = NSAttributedString(string: " Following ", attributes: grayedTextAttrs)
        let followingCount = NSAttributedString(string: "\(self.followingCount)", attributes: normalTextAttrs)
        let followersCount = NSAttributedString(string: "\(self.followersCount)", attributes: normalTextAttrs)
        let followersString = NSAttributedString(string: "Followers ", attributes: grayedTextAttrs)
        var finalTextOutput = NSMutableAttributedString()
        
        finalTextOutput.append(followersString)
        finalTextOutput.append(followersCount)
        finalTextOutput.append(followingString)
        finalTextOutput.append(followingCount)
        
        l.attributedText = finalTextOutput
        l.font = UIFont.systemFont(ofSize: 12.0)
        l.numberOfLines = 0
        
        return l
    }()
    
    let filterView = ProfileFilterView()
    
    let underlineView: UIView = {
        let v = UIView()
        
        v.backgroundColor = .twitterBlue
        
        return v
    }()
    
    //MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        configureUI()
        
        filterView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Helpers
    func configureUI() {
        containerView.addSubview(dissmisalButton)
        dissmisalButton.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, paddingTop: 52.0, paddingLeft: 16.0)
        
        addSubview(containerView)
        containerView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, width: frame.width, height: 108.0)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: containerView.bottomAnchor, left: leftAnchor, paddingTop: -16.0, paddingLeft: 16.0, paddingBottom: 0.0)
        profileImageView.setDimensions(width: 80.0, height: 80.0)
        profileImageView.layer.cornerRadius = 80.0 / 2.0
        
        addSubview(followButton)
        followButton.anchor(top: containerView.bottomAnchor, right: rightAnchor, paddingTop: 16.0, paddingRight: 8.0)
        followButton.setDimensions(width: 128, height: 32.0)
        followButton.layer.cornerRadius = 16.0
        
        addSubview(profileNameLabel)
        profileNameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, paddingTop: 8.0, paddingLeft: 16.0)
    
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileNameLabel.bottomAnchor, left: leftAnchor, paddingLeft: 16.0)
     
        addSubview(bioLabel)
        bioLabel.anchor(top: usernameLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8.0, paddingLeft: 16.0, paddingRight: 16.0)
        
        addSubview(folowingLabel)
        folowingLabel.anchor(top: bioLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8.0, paddingLeft: 16.0, paddingRight: 16.0)
        
        addSubview(filterView)
        filterView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 50.0)
        
        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor, bottom: bottomAnchor, width: frame.width / 3.0, height: 2.0)
    }
}

extension ProfileHeaderView: ProfileFilterViewDelegate {
    func profileFilterView(_ filterView: ProfileFilterView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = filterView.filterCollectionView.cellForItem(at: indexPath) as? ProfileFilterCell else {
            return
        }
        
        UIView.animate(withDuration: 0.3) {
            self.underlineView.frame.origin.x = cell.frame.origin.x
        }
    }
}
