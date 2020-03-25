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
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Helpers
    
}
