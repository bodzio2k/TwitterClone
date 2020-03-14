//
//  MainTabController.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 12/03/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import UIKit

class MainTabController: UITabBarController {
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.layer.cornerRadius = 56 / 2
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: Selectors
    @objc func actionButtonTapped() {
        print("LOL")
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureControllers()
        configureActionButton()
    }
    
    //MARK: Helpers
    func configureControllers() {
        let nav1 = templateNavigationController(rootViewControler: FeedController(), image: UIImage(systemName: "house"))
        let nav2 = templateNavigationController(rootViewControler: ExploreController(), image: UIImage(systemName: "number"))
        let nav3 = templateNavigationController(rootViewControler: NotificationsController(), image: UIImage(systemName: "bell"))
        let nav4 = templateNavigationController(rootViewControler: ConversationsController(), image: UIImage(systemName: "envelope"))
        
        viewControllers = [nav1, nav2, nav3, nav4]
    }
    
    func templateNavigationController(rootViewControler: UIViewController, image: UIImage?) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewControler)
        navigationController.tabBarItem.image = image
        navigationController.navigationBar.barTintColor = .white
        
        return navigationController
    }
    
    func configureActionButton() {
        view.addSubview(actionButton)
        
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
    }
}
