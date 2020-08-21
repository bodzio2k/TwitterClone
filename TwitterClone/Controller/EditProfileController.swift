//
//  EditProfileController.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 16/08/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import UIKit

protocol EditProfileControllerDelegate: class {
    func controller(_ controller: EditProfileController, updates user: User)
    func logout()
}

class EditProfileController: RootViewController {
    private let reuseIdentifier = "EditProfileViewCell"
    private var user: User
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        
        return tv
    }()
    private lazy var headerView = EditProfileHeaderView(user: self.user)
    private let imagePicker = UIImagePickerController()
    private var selectedImage: UIImage? {
        didSet {
            rightBarButtonItem?.isEnabled = true
            headerView.profileImageView.image = selectedImage
        }
    }
    private var imageChanged: Bool {
        return selectedImage != nil
    }
    private var userProfileChanded: Bool = false {
        didSet {
            rightBarButtonItem?.isEnabled = true
        }
    }
    private lazy var logoutButton: UIButton = {
        let b = UIButton()
        
        b.setTitle("Logout", for: .normal)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
        b.setTitleColor(.red, for: .normal)
        b.addTarget(self, action: #selector(logout), for: .touchUpInside)
        
        return b
    }()
    weak var delegate: EditProfileControllerDelegate?
    
    init(user: User) {
        self.user = user
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configureNavigationBar() {
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.barTintColor = .twitterBlue
            navigationBar.barStyle = .black
            navigationBar.isTranslucent = false
            navigationBar.tintColor = .white
        }
    }
    
    fileprivate func configureImagePicker() {
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
    }
    
    override func viewDidLoad() {
        navigationItemTitle = "Edit Profile"
        leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        configureNavigationBar()
        configureTableView()
        configureImagePicker()
        
        super.viewDidLoad()
    }
    
    override func configureUI() {
        super.configureUI()
        
        view.addSubview(logoutButton)
        logoutButton.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 8.0, paddingLeft: 8.0, paddingBottom: 8.0, paddingRight: 8.0, height: 50.0)
        
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: logoutButton.topAnchor, right: view.rightAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 8.0, paddingRight: 0.0)
        
        rightBarButtonItem?.isEnabled = false
    }
    
    func configureTableView() {
        headerView.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 180.0)
        headerView.delegate = self
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView()
        tableView.register(EditProfileViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
    }
    
    //MARK: Selectors
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func done() {
        updateUserData()
        
        if imageChanged {
            updateProfilePhoto()
        }
        
        if userProfileChanded {
            updateUserData()
        }
    }
    
    @objc func logout() {
        delegate?.logout()
    }
    
    //MARK: API
    func updateUserData() -> Void {
        UserService.shared.updataProfile(for: user) { (err, ref) in
            self.dismiss(animated: true) { () in
                self.delegate?.controller(self, updates: self.user)
            }
        }
    }
    
    func updateProfilePhoto() -> Void {
        guard let image = selectedImage else {
            return
        }
        
        UserService.shared.updateProfilePhoto(with: image) { (profilePhotoUrl) in
            self.user.profilePhotoURL = profilePhotoUrl
            self.delegate?.controller(self, updates: self.user)
        }
    }
}

extension EditProfileController: EditProfileHeaderViewDelegate {
    func changeProfilePhoto() {
        present(imagePicker, animated: true)
    }
}

extension EditProfileController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EditProfileField.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EditProfileViewCell
        
        let field = EditProfileField(rawValue: indexPath.row)!
        cell.configure(field: field, user: self.user)
        cell.delegate = self
        
        return cell
    }
}

extension EditProfileController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let field = EditProfileField(rawValue: indexPath.row) else {
            return 0.0
        }
        
        let height: CGFloat = field == .bio ? 135.0 : 44.0
        
        return height
    }
}

extension EditProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[.editedImage] as? UIImage {
            self.selectedImage = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension EditProfileController: EditProfileViewCellDelegate {
    func editChanged(_ cell: EditProfileViewCell) {
        userProfileChanded = true
        
        switch cell.field {
        case .username:
            guard let username = cell.textField.text else {
                return
            }
            user.username = username
        case .fullName:
            guard let fullname = cell.textField.text else {
                return
            }
            user.fullname = fullname
        case .bio:
            guard let bio = cell.bioTextView.text else {
                return
            }
            user.bio = bio
        case .none:
            return
        }
    }
}
