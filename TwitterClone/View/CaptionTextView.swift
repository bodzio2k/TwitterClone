//
//  CaptionTextView.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 29/03/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import UIKit

class CaptionTextView: UITextView {
    let captionLabel: UILabel = {
        let l = UILabel()
        
        l.font = UIFont.systemFont(ofSize: 16.0)
        l.textColor = .darkGray
        l.text = "What is happening?"
        
        return l
    }()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        delegate = self
        isScrollEnabled = false
        font = UIFont.systemFont(ofSize: 16.0)
        
        addSubview(captionLabel)
        
        captionLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 8.0, paddingLeft: 4.0)
        backgroundColor = .white
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CaptionTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        captionLabel.isHidden = !textView.text.isEmpty
    }
}
