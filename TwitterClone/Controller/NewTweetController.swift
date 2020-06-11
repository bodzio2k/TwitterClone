//
//  NewTweetController.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 22/03/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import UIKit

enum NewTweetConfiguration {
    case newTweet
    case reply(Tweet)
}

class NewTweetController: RootViewController {
    //MARK: Properties
    var config: NewTweetConfiguration!
    lazy var viewModel = NewTweetViewModel(config: config)
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
    lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        
        iv.backgroundColor = .red
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
         
        iv.setDimensions(width: 44.0, height: 44.0)
        iv.layer.cornerRadius = 44.0 / 2.0
            
        if let profileImageURL = currentUser?.profilePhotoURL {
            iv.sd_setImage(with: profileImageURL, completed: nil)
        }
        
        return iv
    }()
    let captionTexView = CaptionTextView()
    lazy var replyToLabel: UILabel = {
        let l = UILabel()
        
        l.font = UIFont.systemFont(ofSize: 12.0)
        l.textColor = .lightGray
        
        return l
    }()
    
    //MARK: Lifecycle
    init(user: User, config: NewTweetConfiguration) {
        super.init(nibName: nil, bundle: nil)
        
        self.config = config
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
        guard let caption = captionTexView.text else {
            return
        }
        
        TweetService.shared.newTweet(caption: caption, config: config) { (error, _) in
            if let _ = error {
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: Helpers
    override func configureUI() {
        super.configureUI()
        
        let captionStack = UIStackView(arrangedSubviews: [profileImageView, captionTexView])
        captionStack.axis = .horizontal
        captionStack.spacing = 8.0
        captionStack.distribution = .fillProportionally
        captionStack.alignment = .leading
        
        let wrapperStack = UIStackView(arrangedSubviews: [replyToLabel, captionStack])
        wrapperStack.axis = .vertical
        wrapperStack.spacing = 8.0
        wrapperStack.distribution = .fillProportionally
        
        view.addSubview(wrapperStack)
        wrapperStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8.0, paddingLeft: 16.0, paddingRight: 16.0)
        
        newTweetButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        captionTexView.captionLabel.text = viewModel.placeholderText
        replyToLabel.isHidden = !viewModel.shouldShowReplyLabel
        replyToLabel.text = viewModel.replyLabelText
    }
    
}
