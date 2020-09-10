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
    //MARK: Properties
    let imagePicker = UIImagePickerController()
    var profilePhoto: UIImage?
    var contentSize: CGSize!
    var keyboardHeight: CGFloat = 0.0
    
    let plusPhotoButton: UIButton = {
        let b = UIButton()
        
        b.setImage(UIImage(named: "plus_photo"), for: .normal)
        b.tintColor = .white
        b.setDimensions(width: 128.0, height: 128.0)
        b.addTarget(self, action: #selector(onAddPhoto), for: .touchUpInside)
        
        return b
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
        
        tf.returnKeyType = .next
        tf.keyboardType = .default
        tf.textContentType = .oneTimeCode
        
        return tf
    }()
    
    let fullnameTextField: UITextField = {
        let tf = UITextField()
        
        tf.returnKeyType = .next
        tf.keyboardType = .asciiCapable
        tf.textContentType = .oneTimeCode
        
        return tf
    }()
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        
        tf.returnKeyType = .go
        tf.keyboardType = .asciiCapable
        tf.textContentType = .oneTimeCode
        
        return tf
    }()
    
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
    
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        
        sv.backgroundColor = .twitterBlue
        sv.isScrollEnabled = true
        sv.isUserInteractionEnabled = true
        sv.frame.size = self.contentSize
        sv.contentSize = self.contentSize
        sv.showsVerticalScrollIndicator = false
        
        return sv
    }()
    
    lazy var wrapperView: UIView = {
        let v = UIView()
                
        return v
    }()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentSize = view.safeAreaLayoutGuide.layoutFrame.size
        
        configureUI()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        fullnameTextField.delegate = self
        usernameTextField.delegate = self
        
        emailTextField.becomeFirstResponder()
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
    
    //MARK: Selectors
    @objc func onLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func onAddPhoto() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func onSignup() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let username = usernameTextField.text, let fullname = fullnameTextField.text else {
            return
        }
        
        let newUser = AuthUser(email: email, username: username, fullname: fullname, password: password, profilePhoto: self.profilePhoto)
        
        AuthService.shared.createUser(newUser) { (error) in
            if let error = error {
                print(error.localizedDescription)
                
                return
            }
            
            guard let mainController = self.getKeyWindow().rootViewController as? MainTabController else {
                return
            }
            
            mainController.authenicateAndConfigureUI {
                mainController.selectedIndex = 1
            }
           
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func onKeyboardDidShow(notification: NSNotification) -> Void {
        guard let userInfo = notification.userInfo else {
            return
        }
        
        guard let keyboardSize = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size else {
            return
        }
        
        keyboardHeight = keyboardSize.height
        
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: view.frame.size.height + keyboardSize.height)
    }
    
    @objc func onKeyboardDidHide(notification: NSNotification) -> Void {
        keyboardHeight = 0.0
        scrollView.contentSize = contentSize
        scrollView.scrollRectToVisible(plusPhotoButton.frame, animated: true)
    }
    
    
    //MARK: Helpers
    func configureUI() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        view.backgroundColor = .twitterBlue
        
        view.addSubview(scrollView)
        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor)
        
        scrollView.addSubview(wrapperView)
        wrapperView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: scrollView.frame.width, height: scrollView.frame.height)
        
        wrapperView.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: scrollView, topAnchor: scrollView.topAnchor)
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

        wrapperView.addSubview(stackView)
        stackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 8.0, paddingLeft: 8.0, paddingRight: 8.0)

        wrapperView.addSubview(signupButton)
        signupButton.anchor(top: stackView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24.0, paddingLeft: 8.0, paddingRight: 8.0)

        wrapperView.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(top: nil, left: view.safeAreaLayoutGuide.leftAnchor, bottom: wrapperView.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 20.0, paddingRight: 0.0, width: nil, height: nil)

        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    private func isObscuredByKeyboard(_ tf: UITextField) -> CGFloat {
        let vortex = CGPoint(x: tf.frame.minX, y: tf.frame.maxY)
        let globalPoint = tf.convert(vortex, to: view)
        let visibleAreaHeight = view.frame.height - keyboardHeight
        let obscuredHeight = visibleAreaHeight - globalPoint.y
        
        return obscuredHeight < 0.0 ? obscuredHeight * -1.0 : 0.0
    }
}

//MARK: UIImagePickerControllerDelegate
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

extension RegistrationController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var nextField: UITextField?
        
        if textField == emailTextField {
            nextField = passwordTextField
        }
        
        if textField == passwordTextField {
            nextField = fullnameTextField
        }
        
        if textField == fullnameTextField {
            nextField = usernameTextField
        }
        
        if textField == usernameTextField {
            nextField = nil
        }
        
        if let nextField = nextField {
            nextField.becomeFirstResponder()
            let obscuredArea = isObscuredByKeyboard(nextField)
            let padding: CGFloat = 8.0
            
            if obscuredArea > 0.0 {
                scrollView.setContentOffset(CGPoint(x: 0.0, y: obscuredArea + padding), animated: true)
            }
        }
        else {
            signupButton.becomeFirstResponder()
            scrollView.setContentOffset(CGPoint(x: 0.0, y: keyboardHeight), animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.onSignup()
            }
        }
        
        return true
    }
}


