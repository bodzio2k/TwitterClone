//
//  MainTabController.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 12/03/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import UIKit
import Firebase

class MainTabController: UITabBarController {
    //MARK: -Properties
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.layer.cornerRadius = 56 / 2
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: -Selectors
    @objc func actionButtonTapped() {
        let newTweetController = NewTweetController()
        let nav = UINavigationController(rootViewController: newTweetController)
        
        present(nav, animated: true)
    }
    
    //MARK: -Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //try? Auth.auth().signOut()
            
        authenicateAndConfigureUI()
    }
    
    //MARK: -API
    func authenicateAndConfigureUI() {
        let isLoggedIn = Auth.auth().currentUser != nil
        
        if !isLoggedIn {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                
                nav.modalPresentationStyle = .fullScreen
                
                self.present(nav, animated: true)
            }
        }
        else {
            configureControllers()
            configureActionButton()
            
            UserService.shared.fetchUser { user in
                let _ = (self.viewControllers ?? []).map { (viewController) -> Void in
                    guard let nav = viewController as? UINavigationController else {
                        return
                    }
                    
                    guard let vc = nav.viewControllers.first as? RootViewController else {
                        return
                    }
                    
                    vc.currentUser = user
                    
                    return
                }
            }
        }
    }
    //MARK: -Helpers
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
