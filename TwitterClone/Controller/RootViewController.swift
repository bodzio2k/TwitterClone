//
//  RootViewController.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 13/03/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import UIKit
import SDWebImage

class RootViewController: UIViewController {
    var navigationItemView: UIView?
    var navigationItemTitle: String?
    var leftBarButtonItem: UIBarButtonItem?
    var currentUser: User? {
        didSet {
            guard let newValue = currentUser, let profilePhotoURL = newValue.profilePhotoURL else {
                return
            }
            
            let placeholderImage = UIImage(systemName: "person.crop.circle")
            let imageView = UIImageView()
            
            imageView.setDimensions(width: 32.0, height: 32.0)
            imageView.contentMode = .scaleAspectFit
            imageView.layer.cornerRadius = 32.0 / 2.0
            imageView.layer.masksToBounds = true
            imageView.sd_setImage(with: profilePhotoURL, placeholderImage: placeholderImage) { (image, error, cacheType, url) in
                return
            }
            
            leftBarButtonItem = UIBarButtonItem(customView: imageView)
        
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
            imageView.sizeToFit()
            navigationItem.titleView = imageView
        }
        else {
            navigationItem.title = navigationItemTitle ?? ""
        }
    }
    
    func configureLefBarItemButton() {
        
    }
}
