//
//  ExploreController.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 12/03/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import UIKit

class ExploreController: RootViewController {

    override func viewDidLoad() {
        navigationItemTitle = "Explore"
        leftBarButtonItem = UIBarButtonItem(customView: UIImageView(image: UIImage(systemName: "globe")))
        
        super.viewDidLoad()
    }
}
