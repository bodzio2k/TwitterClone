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
    var profiePhotoImageView: UIImageView = UIImageView()
    let profilePhotoSize: CGFloat = 32.0
    var currentUser: User? {
        didSet {
            print("User did set.")
            
            guard let newValue = currentUser, let profilePhotoURL = newValue.profilePhotoURL else {
                return
            }
            
            let placeholderImage = UIImage(systemName: "person.crop.circle")
            
            profiePhotoImageView.sd_setImage(with: profilePhotoURL, placeholderImage: placeholderImage)
            profiePhotoImageView.contentMode = .scaleAspectFit
            profiePhotoImageView.layer.cornerRadius = profilePhotoSize / 2.0
            profiePhotoImageView.layer.masksToBounds = true
            profiePhotoImageView.setDimensions(width: profilePhotoSize, height: profilePhotoSize)
            
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profiePhotoImageView)
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
            imageView.setDimensions(width: 44.0, height: 44.0)
            imageView.sizeToFit()
            navigationItem.titleView = imageView
        }
        else {
            navigationItem.title = navigationItemTitle ?? ""
        }
    }
}
