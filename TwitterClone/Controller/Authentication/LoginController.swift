//
//  LoginController.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 14/03/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    //MARK: -Properties
    let logoImageView: UIImageView = {
        let iv = UIImageView()
        
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "TwitterLogo")
        
        return iv
    }()
    
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    
    //MARK: -Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    //MARK: -Helpers
    func configureUI() {
        view.backgroundColor = .twitterBlue
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        view.addSubview(logoImageView)
        logoImageView.centerX(inView: view, topAnchor: view.layoutMarginsGuide.topAnchor)
        logoImageView.setDimensions(width: 150.0, height: 150.0)
        
        let emailContainerView = Utilities.containerView(withImage: UIImage(systemName: "envelope"), for: emailTextField, placeholder: "Email")
        let passwpordContainerView = Utilities.containerView(withImage: UIImage(systemName: "lock"), for: passwordTextField, placeholder: "Password")
        
        let stackView = UIStackView(arrangedSubviews: [emailContainerView, passwpordContainerView])
        stackView.axis = .vertical
        stackView.spacing = 8.0
        
        view.addSubview(stackView)
        stackView.anchor(top: logoImageView.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 8.0, paddingLeft: 8.0, paddingRight: 8.0)
        
    }
}
