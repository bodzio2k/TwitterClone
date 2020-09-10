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
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        
        tf.returnKeyType = .next
        tf.keyboardType = .emailAddress
        tf.textContentType = .oneTimeCode
        
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        
        tf.returnKeyType = .go
        tf.textContentType = .oneTimeCode
        
        return tf
    }()
    
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
    
    //MARK: Selectors
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
            
            mainController.authenicateAndConfigureUI(nil)
            
            self.view.window?.frame.origin = .zero
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func onSignup() {
        let destinationController = RegistrationController()
        
        navigationController?.pushViewController(destinationController, animated: true)
    }
    
    
    @objc func onKeyboardDidShow(notification: NSNotification) {
//        guard passwordTextField.isFirstResponder else {
//            return
//        }
        
        guard let loginButtonGlobalPoint = loginButton.superview?.convert(loginButton.frame.origin, to: nil) else {
            return
        }
        
        guard let userInfo = notification.userInfo else {
            return
        }
        
        guard let keyboardheight = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size.height else {
            return
        }
        
        let viewHeight = self.view.frame.size.height
        let loginButtonLowerY = loginButtonGlobalPoint.y + loginButton.frame.height
        let obscuredAreaHeight: CGFloat = loginButtonLowerY - (viewHeight - keyboardheight)
        let viewShouldShiftUp = obscuredAreaHeight > 0.00
        let topMargin: CGFloat = 8.0
        
        if viewShouldShiftUp {
            let shiftBy: CGFloat  = -1.00 * (obscuredAreaHeight + topMargin)
            self.view.window?.frame.origin.y = shiftBy
            
            return
        }
        
        return
    }
    
    @objc func onKeyboardDidHide(notification: NSNotification) -> Void {
        self.view.window?.frame.origin.y = .zero
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDidShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDidHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
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

extension LoginController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var shouldReturn = false
        
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
            
            shouldReturn = true
        }
        
        if textField == passwordTextField {
            DispatchQueue.main.async {
                self.onLogin()
            }
            
            shouldReturn = true
        }
        
        return shouldReturn
    }
}
