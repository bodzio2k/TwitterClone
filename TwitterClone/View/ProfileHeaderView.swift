//
//  ProfileHeader.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 21/04/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import UIKit

protocol ProfileHeaderViewDelegate {
    func dismiss()
    func actionButtonTapped(_ user: User)
    func didSelect(filter: ProfileFilterOption)
}

class ProfileHeaderView: UICollectionReusableView {
    //MARK: Properties
    var delegate: ProfileHeaderViewDelegate?
    
    var user: User? {
        didSet {
            guard let user = user else {
                return
            }
            
            let viewModel = ProfileHeaderViewModel(user: user)
            
            actionButton.setTitle(viewModel.actionButtonTitle, for: .normal)
            
            followingLabel.attributedText = viewModel.following
            followersLabel.attributedText = viewModel.followers
            
            profileImageView.sd_setImage(with: user.profilePhotoURL, completed: nil)
            
            profileNameLabel.text = user.fullname
            usernameLabel.text = "@\(user.username)"
            
            bioLabel.text = user.bio
            
            actionButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        }
    }
    
    let dissmisalButton: UIButton = {
        let b = UIButton(type: UIButton.ButtonType.system)
        let i = UIImage(systemName: "arrow.left")?.withTintColor(.white).withRenderingMode(.alwaysOriginal)
        
        b.setImage(i, for: .normal)
        b.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        
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
    
    let actionButton: UIButton = {
        let b = UIButton(type: .system)
        
        b.setTitle("Follow", for: .normal)
        b.setTitleColor(.twitterBlue, for: .normal)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
        b.backgroundColor = .white
        b.layer.borderWidth = 1.25
        b.layer.borderColor = UIColor.twitterBlue.cgColor
        b.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        
        return b
    }()
    
    let profileNameLabel: UILabel = {
        let l = UILabel()
        
        l.font = UIFont.boldSystemFont(ofSize: 24.0)
        
        return l
    }()
    
    let usernameLabel: UILabel = {
        let l = UILabel()
        
        l.font = UIFont.systemFont(ofSize: 14.0)
        l.textColor = .lightGray
        
        return l
    }()
    
    let bioLabel: UILabel = {
        let l = UILabel()
        
        l.font = UIFont.systemFont(ofSize: 14.0)
        l.numberOfLines = 0
        l.lineBreakMode = .byWordWrapping
        
        return l
    }()
    
    lazy var followingLabel: UILabel = {
        let l = UILabel()
        
        l.font = UIFont.systemFont(ofSize: 12.0)
        l.numberOfLines = 0
        
        return l
    }()
    
    lazy var followersLabel: UILabel = {
        let l = UILabel()
        
        l.font = UIFont.systemFont(ofSize: 12.0)
        l.numberOfLines = 0
        
        return l
    }()
    
    
    let filterView = ProfileFilterView()
    
    //MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        configureUI()
        
        filterView.delegate = self
        
        let selectedItem = IndexPath(row: 0, section: 0)
        filterView.filterCollectionView.selectItem(at: selectedItem, animated: false, scrollPosition: .left)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Selectors
    @objc func dismiss() {
        delegate?.dismiss()
    }
    
    @objc func actionButtonTapped() {
        if let user = user {
            delegate?.actionButtonTapped(user)
        }
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
        
        addSubview(actionButton)
        actionButton.anchor(top: containerView.bottomAnchor, right: rightAnchor, paddingTop: 16.0, paddingRight: 8.0)
        actionButton.setDimensions(width: 128, height: 32.0)
        actionButton.layer.cornerRadius = 16.0
        
        let wrapperStack = UIStackView(arrangedSubviews: [profileNameLabel, usernameLabel, bioLabel])
        wrapperStack.axis = .vertical
        wrapperStack.distribution = .fillProportionally
        wrapperStack.spacing = 4.0
        
        addSubview(wrapperStack)
        wrapperStack.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8.0, paddingLeft: 8.0, paddingRight: 20.0)

        let followingStack = UIStackView(arrangedSubviews: [followingLabel, followersLabel])
        followingStack.axis = .horizontal
        followingStack.distribution = .fill
        followingStack.spacing = 8.0
        
        addSubview(followingStack)
        followingStack.anchor(top: wrapperStack.bottomAnchor, left: leftAnchor, right: nil, paddingTop: 4.0, paddingLeft: 8.0, paddingRight: 20.0)
        
        addSubview(filterView)
        filterView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 50.0)
    }
}

extension ProfileHeaderView: ProfileFilterViewDelegate {
    func profileFilterView(_ filterView: ProfileFilterView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedOption = ProfileFilterOption(rawValue: indexPath.row) else {
            return
        }
        
        delegate?.didSelect(filter: selectedOption)
    }
}
