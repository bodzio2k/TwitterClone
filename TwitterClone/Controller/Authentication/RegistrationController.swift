//
//  RegistrationController.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 14/03/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import UIKit
import Firebase

class RegistrationController: UIViewController {
    //MARK: -Properties
    let imagePicker = UIImagePickerController()
    var profilePhoto: UIImage?
    
    let plusPhotoButton: UIButton = {
        let b = UIButton()
        
        b.setImage(UIImage(named: "plus_photo"), for: .normal)
        b.tintColor = .white
        b.setDimensions(width: 128.0, height: 128.0)
        b.addTarget(self, action: #selector(onAddPhoto), for: .touchUpInside)
        
        return b
    }()
    
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let fullnameTextField = UITextField()
    let usernameTextField = UITextField()
    
    let signupButton: UIButton = {
        let b = UIButton(type: .system)
        
        b.setTitle("Sign Up", for: .normal)
        b.setTitleColor(.twitterBlue, for: .normal)
        b.backgroundColor = .white
        b.layer.cornerRadius = 4.0
        b.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        b.addTarget(self, action: #selector(onSignup), for: .touchUpInside)
        
        return b
    }()
    
    let alreadyHaveAccountButton: UIButton = {
        let b = Utilities.attributedButton("Already have account?", " Log In")
        b.addTarget(self, action: #selector(onLogin), for: .touchUpInside)
        
        return b
    }()
    
    //MARK: -Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    //MARK: -Selectors
    @objc func onLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func onAddPhoto() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func onSignup() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let username = usernameTextField.text, let fullname = fullnameTextField.text, let profilePhoto = self.profilePhoto else {
            return
        }
        
        let newUser = AuthUser(email: email, username: username, fullname: fullname, password: password, profilePhoto: profilePhoto)
        
        AuthService.shared.createUser(newUser) { (error) in
            if let error = error {
                print(error.localizedDescription)
                
                return
            }
            
            guard let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
                return
            }
            
            guard let mainController = keyWindow.rootViewController as? MainTabController else {
                return
            }
            
            mainController.authenicateAndConfigureUI()
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: -Helpers
    func configureUI() {
        view.backgroundColor = .twitterBlue
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view, topAnchor: view.layoutMarginsGuide.topAnchor)
        plusPhotoButton.setDimensions(width: 150.0, height: 150.0)
        
        let emailContainerView = Utilities.containerView(withImage: UIImage(systemName: "envelope"), for: emailTextField, placeholder: "Email")
        let passwpordContainerView = Utilities.containerView(withImage: UIImage(systemName: "lock"), for: passwordTextField, placeholder: "Password")
        passwordTextField.isSecureTextEntry = true
        
        let fullnameContainerView = Utilities.containerView(withImage: UIImage(systemName: "person"), for: fullnameTextField, placeholder: "Full Name")
        let usernameContainerView = Utilities.containerView(withImage: UIImage(systemName: "at"), for: usernameTextField, placeholder: "Username")
        
        let stackView = UIStackView(arrangedSubviews: [emailContainerView, passwpordContainerView, fullnameContainerView, usernameContainerView])
        stackView.axis = .vertical
        stackView.spacing = 8.0
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 8.0, paddingLeft: 8.0, paddingRight: 8.0)
        
        view.addSubview(signupButton)
        signupButton.anchor(top: stackView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24.0, paddingLeft: 8.0, paddingRight: 8.0)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingLeft: 8.0, paddingRight: 8.0)
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
}

//MARK: -UIImagePickerControllerDelegate
extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        profilePhoto = image
        plusPhotoButton.setImage(image, for: .normal)
        plusPhotoButton.imageView?.contentMode = .scaleAspectFill
        plusPhotoButton.layer.cornerRadius = 128.0 / 2.0
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 3.0
        
        dismiss(animated: true, completion: nil)
    }
}
