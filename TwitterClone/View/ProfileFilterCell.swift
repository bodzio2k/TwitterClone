//
//  ProfileFilterCell.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 26/04/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import UIKit

class ProfileFilterCell: UICollectionViewCell {
    private let selectedFont = UIFont.boldSystemFont(ofSize: 16.0)
    private let normalFont = UIFont.systemFont(ofSize: 14.0)
    private let selectedColor: UIColor = .twitterBlue
    private let normalColor: UIColor = .lightGray
    
    lazy var captionLabel: UILabel = {
        let l = UILabel()
        
        l.font = normalFont
        l.textColor = normalColor
        
        return l
    }()
    
    //MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(captionLabel)
        captionLabel.center(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            captionLabel.font = isSelected ? selectedFont : normalFont
            captionLabel.textColor = isSelected ? selectedColor : normalColor
        }
    }
}
