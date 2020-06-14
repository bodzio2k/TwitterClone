//
//  ActionSheetCell.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 13/06/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import UIKit

class ActionSheetCell: UITableViewCell {
    //MARK: Properties
    lazy var optionPhotoView: UIImageView = {
        let iv = UIImageView()
        
        iv.image = #imageLiteral(resourceName: "twitter_logo_blue")
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        
        return iv
    }()
    
    lazy var optionLabel: UILabel = {
        let l = UILabel()
        
        l.font = UIFont.boldSystemFont(ofSize: 14.0)
        l.text = "@LoL"
        return l
    }()
    
    //MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Helpers
    func configureUI() {
        addSubview(optionPhotoView)
        optionPhotoView.centerY(inView: self)
        optionPhotoView.anchor(left: self.safeAreaLayoutGuide.leftAnchor, paddingLeft: 8.0, width: 36.0, height: 36.0)
        
        addSubview(optionLabel)
        optionLabel.centerY(inView: self)
        optionLabel.anchor(left: optionPhotoView.rightAnchor, paddingLeft: 8.0)
        
    }
    
    func configure(for option: ActionSheetOptions) -> Void {
        optionLabel.text = option.description
    }
}
