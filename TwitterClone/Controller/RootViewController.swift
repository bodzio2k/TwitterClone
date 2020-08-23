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

class RootViewController: UIViewController {
    var navigationItemView: UIView?
    var navigationItemTitle: String?
    var profiePhotoImageView: UIImageView = UIImageView()
    let profilePhotoSize: CGFloat = 32.0
    weak var logoutDelegate: LogoutDelegate?
    var currentUser: User? {
        didSet {
            print("User did set.")
            
            guard let newValue = currentUser, let profilePhotoURL = newValue.profilePhotoURL else {
                return
            }
            
            let placeholderImage = UIImage(systemName: "person.crop.circle")
            let tap = UITapGestureRecognizer(target: self, action: #selector(leftBarButtonItemTapped))
            
            profiePhotoImageView.sd_setImage(with: profilePhotoURL, placeholderImage: placeholderImage)
            profiePhotoImageView.contentMode = .scaleAspectFit
            profiePhotoImageView.layer.cornerRadius = profilePhotoSize / 2.0
            profiePhotoImageView.layer.masksToBounds = true
            profiePhotoImageView.setDimensions(width: profilePhotoSize, height: profilePhotoSize)
            profiePhotoImageView.addGestureRecognizer(tap)
            
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
        
        let nav = UINavigationController(rootViewController: controller)
        
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.barStyle = .black
        
        present(nav, animated: true)
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
