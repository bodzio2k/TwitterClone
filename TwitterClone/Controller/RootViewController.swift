//
//  RootViewController.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 13/03/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    var navigationItemView: UIView?
    var navigationItemTitle: String?
    var leftBarButtonItem: UIBarButtonItem?
    var currentUser: User? {
        didSet {
            guard let newUser = currentUser, let profilePhotoURL = newUser.profilePhotoUrl else {
                return
            }
            
            leftBarButtonItem = UIBarButtonItem(customView: UIImageView(image: UIImage(systemName: "person.crop.circle")))
            navigationItem.leftBarButtonItem = leftBarButtonItem
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        if let imageView = navigationItemView {
            imageView.contentMode = .scaleAspectFit
            navigationItem.titleView = imageView
        }
        else {
            navigationItem.title = navigationItemTitle ?? ""
        }
    }
}
