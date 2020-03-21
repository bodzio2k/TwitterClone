//
//  LoginController.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 14/03/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    //MARK: Properties
    let logoImageView: UIImageView = {
        let iv = UIImageView()
        
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "TwitterLogo")
        
        return iv
    }()
    
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    
    let loginButton: UIButton = {
        let b = UIButton(type: .system)
        
        b.setTitle("Log In", for: .normal)
        b.setTitleColor(.twitterBlue, for: .normal)
        b.backgroundColor = .white
        b.layer.cornerRadius = 4.0
        b.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        b.addTarget(self, action: #selector(onLogin), for: .touchUpInside)
        
        return b
    }()
    
    let signupButton: UIButton = {
        let b = Utilities.attributedButton("Don't have account?", " Sign Up")
        b.addTarget(self, action: #selector(onSignup), for: .touchUpInside)
        
        return b
    }()
    
    //MARK Selectors
    @objc func onLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        
        AuthService.shared.signIn(withEmail: email, password: password) { (result, error) in
            if let _  = error {
                return
            }
            
            guard let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow == true }) else {
                return
            }
            
            guard let mainController = keyWindow.rootViewController as? MainTabController else {
                return
            }
            
            mainController.authenicateAndConfigureUI()
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func onSignup() {
        let destinationController = RegistrationController()
        
        navigationController?.pushViewController(destinationController, animated: true)
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    //MARK: Helpers
    func configureUI() {
        view.backgroundColor = .twitterBlue
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        view.addSubview(logoImageView)
        logoImageView.centerX(inView: view, topAnchor: view.layoutMarginsGuide.topAnchor)
        logoImageView.setDimensions(width: 150.0, height: 150.0)
        
        let emailContainerView = Utilities.containerView(withImage: UIImage(systemName: "envelope"), for: emailTextField, placeholder: "Email")
        let passwpordContainerView = Utilities.containerView(withImage: UIImage(systemName: "lock"), for: passwordTextField, placeholder: "Password")
        passwordTextField.isSecureTextEntry = true
        
        let stackView = UIStackView(arrangedSubviews: [emailContainerView, passwpordContainerView])
        stackView.axis = .vertical
        stackView.spacing = 8.0
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: logoImageView.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 8.0, paddingLeft: 8.0, paddingRight: 8.0)
        
        view.addSubview(loginButton)
        loginButton.anchor(top: stackView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24.0, paddingLeft: 8.0, paddingRight: 8.0)

        view.addSubview(signupButton)
        signupButton.anchor(left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingLeft: 8.0, paddingRight: 8.0)
    }
}
