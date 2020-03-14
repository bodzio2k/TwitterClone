//
//  Utilities.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 14/03/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import UIKit

class Utilities {
    static func containerView(withImage image: UIImage?, for textField: UITextField, placeholder: String) -> UIView {
        let root = UIView()
        let imageView = UIImageView(image: image)
        let divider = UIView()
        let placeholderAttrs = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        root.addSubview(imageView)
        imageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        imageView.tintColor = .white
        imageView.anchor(left: root.leftAnchor, bottom: root.bottomAnchor, paddingBottom: 8.0)
        imageView.contentMode = .scaleAspectFit
        
        root.addSubview(textField)
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: placeholderAttrs)
        textField.anchor(left: imageView.rightAnchor, right: root.rightAnchor)
        textField.centerY(inView: imageView)
        textField.textColor = .white
        textField.font = UIFont.systemFont(ofSize: 16.0)
        root.addSubview(divider)
        divider.anchor(left: root.leftAnchor, bottom: root.bottomAnchor, right: root.rightAnchor, height: 1.0)
        divider.backgroundColor = .white
        
        root.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        root.backgroundColor = .twitterBlue
        
        return root
    }
}
