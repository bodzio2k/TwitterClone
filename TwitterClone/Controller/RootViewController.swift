//
//  RootViewController.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 13/03/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

@objc protocol LogoutDelegate: class {
    @objc func logout(_ controller: RootViewController) -> Void
}

class RootViewController: UIViewController, EditProfileControllerDelegate {
    var navigationItemView: UIView?
    var navigationItemTitle: String?
    lazy var profiePhotoImageView: UIImageView = {
        let iv = UIImageView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(leftBarButtonItemTapped))
        let profilePhotoSize: CGFloat = 32.0
        
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = profilePhotoSize / 2.0
        iv.layer.masksToBounds = true
        iv.setDimensions(width: profilePhotoSize, height: profilePhotoSize)
        iv.addGestureRecognizer(tap)
        iv.tintColor = .lightGray
        
        return iv
    }()
    
    weak var logoutDelegate: LogoutDelegate?
    
    var currentUser: User? {
        didSet {
            guard let newValue = currentUser else {
                return
            }
            
            profiePhotoImageView.sd_setImage(with: newValue.profilePhotoURL, placeholderImage: Globals.placeholderCircle)
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profiePhotoImageView)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoutDelegate = self
        
        configureUI()
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        if let imageView = navigationItemView {
            imageView.contentMode = .scaleAspectFit
            imageView.setDimensions(width: 44.0, height: 44.0)
            imageView.sizeToFit()
            navigationItem.titleView = imageView
        }
        else {
            navigationItem.title = navigationItemTitle ?? ""
        }
    }
    
    @objc func leftBarButtonItemTapped() {
        guard let user = currentUser else {
            return
        }
        
        let controller = EditProfileController(user: user)
        controller.delegate = self
        
        let nav = UINavigationController(rootViewController: controller)
        
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.barStyle = .black
        
        present(nav, animated: true)
    }
    
    func controller(_ controller: RootViewController, updates user: User) {
        if let mainTabBarController = getKeyWindow().rootViewController as? MainTabController {
            mainTabBarController.viewControllers?.forEach({ (vc) in
                if let nav = vc as? UINavigationController, let vc = nav.viewControllers.first, let rootVc = vc as? RootViewController  {
                    rootVc.currentUser = user
                }
            })
        }
    }
}

extension RootViewController: LogoutDelegate {
    func logout(_ controller: RootViewController) {
        let alert = UIAlertController(title: nil, message: "Are You sure?", preferredStyle: .actionSheet)
        
        guard let keyWindow = UIApplication.shared.windows.first(where: {$0.isKeyWindow}), let rootViewController = keyWindow.rootViewController else {
                return
        }
        
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { (_) in
            controller.dismiss(animated: true) {
                try? Auth.auth().signOut()
                
                let nav = UINavigationController(rootViewController: LoginController())
                
                nav.modalPresentationStyle = .fullScreen
                rootViewController.present(nav, animated: true, completion: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
       
        controller.present(alert, animated: false, completion: nil)
    }
}
