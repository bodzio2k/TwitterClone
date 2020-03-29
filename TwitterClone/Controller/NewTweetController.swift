//
//  NewTweetController.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 22/03/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import UIKit

class NewTweetController: RootViewController {
    //MARK: Properties
    lazy var newTweetButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Tweet", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        button.backgroundColor = .twitterBlue
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 32.0 / 2
        button.addTarget(self, action: #selector(onNewTweet), for: .touchUpInside)
        
        return button
    }()
    let profileImageView = UIImageView()
    let tweetEditView = CaptionTextView()
    
    //MARK: Lifecycle
    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        
        self.currentUser = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(onCancel))
        rightBarButtonItem = UIBarButtonItem(customView: newTweetButton)
        
        super.viewDidLoad()
    }
    
    //MARK: Selectors
    @objc func onCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func onNewTweet() {
        guard let caption = tweetEditView.text else {
            return
        }
        
        TweetService.shared.newTweet(caption: caption) { (error, _) in
            if let _ = error {
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: Helpers
    override func configureUI() {
        super.configureUI()
        
        let profileImageSize: CGFloat = 48.0
        let stack = UIStackView(arrangedSubviews: [profileImageView, tweetEditView])
        
        stack.axis = .horizontal
        stack.spacing = 8.0
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingRight: 16.0)
        
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.clipsToBounds = true
        profileImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 16.0, paddingLeft: 16.0)
        profileImageView.setDimensions(width: profileImageSize, height: profileImageSize)
        profileImageView.sd_setImage(with: currentUser?.profilePhotoURL, completed: nil)
        profileImageView.layer.cornerRadius = profileImageSize / 2.0
        
        /*tweetEditView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 8.0, paddingLeft: 8.0, paddingBottom: 8.0, paddingRight: 8.0, width: nil, height: nil)*/
    }
    
}
