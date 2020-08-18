//
//  EditProfileViewCell.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 16/08/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import UIKit

protocol EditProfileViewCellDelegate: class {
    func editChanged(_ cell: EditProfileViewCell)
}

class EditProfileViewCell: UITableViewCell {
    var user: User?
    var field: EditProfileField?
    weak var delegate: EditProfileViewCellDelegate?
    let titleLabel: UILabel = {
        let l = UILabel()
        
        l.font = UIFont.systemFont(ofSize: 16.0)
        l.text = "Title"
        
        return l
    }()
    lazy var textField: UITextField = {
        let tf = UITextField()
        
        tf.font = UIFont.systemFont(ofSize: 16.0)
        tf.textColor = .twitterBlue
        tf.placeholder = "text field"
        tf.addTarget(self, action: #selector(editChanged), for: .editingDidEnd)
        
        return tf
    }()
    lazy var bioTextView: UITextView = {
        let tv = UITextView()
        
        tv.font = UIFont.systemFont(ofSize: 16.0)
        tv.textColor = .twitterBlue
        
        return tv
    }()
    let bioPlaceHolderLabel: UILabel = {
        let l = UILabel()
        
        l.text = "Introduce Yourself"
        l.font = UIFont.systemFont(ofSize: 16.0)
        l.textColor = .lightGray
        
        return l
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(titleLabel)
        titleLabel.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        titleLabel.anchor(top: topAnchor, left: safeAreaLayoutGuide.leftAnchor, paddingTop: 12.0, paddingLeft: 16.0)
        
        addSubview(textField)
        textField.anchor(top: topAnchor, left: titleLabel.rightAnchor, right: safeAreaLayoutGuide.rightAnchor, paddingTop: 12.0, paddingLeft: 8.0, paddingRight: 16.0)
        
        addSubview(bioTextView)
        bioTextView.heightAnchor.constraint(equalToConstant: 256.0).isActive = true
        bioTextView.anchor(top: topAnchor, left: titleLabel.rightAnchor, right: safeAreaLayoutGuide.rightAnchor, paddingTop: 4.0, paddingLeft: 4.0, paddingRight: 16.0)
        
        addSubview(bioPlaceHolderLabel)
        bioPlaceHolderLabel.anchor(top: topAnchor, left: titleLabel.rightAnchor, paddingTop: 12.0, paddingLeft: 8.00)
        
        NotificationCenter.default.addObserver(self, selector: #selector(editChanged), name: UITextView.textDidEndEditingNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Helpers
    func configure(field: EditProfileField, user: User) {
        self.field = field
        self.user = user
        
        let viewModel = EditProfileViewModel(user: user, field: field)
        
        titleLabel.text = viewModel.titleLabelText
        
        textField.text = viewModel.textFieldText
        textField.placeholder = viewModel.placeholderText
        textField.isHidden = viewModel.textFieldShouldHide
        
        bioTextView.isHidden = viewModel.bioTextViewShouldHide
        bioTextView.text = viewModel.bioText
        bioPlaceHolderLabel.isHidden = viewModel.bioPlaceHolderLabelShouldHide
    }
    
    //MARK: Selectors
    @objc func editChanged() {
        delegate?.editChanged(self)
    }
}
