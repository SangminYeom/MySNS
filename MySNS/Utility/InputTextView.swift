//
//  InputTextView.swift
//  MySNS
//
//  Created by SANGMIN YEOM on 2022/01/23.
//

import UIKit

class InputTextView: UITextView {

    // MARK: - properties
    var placeholderText: String? {
        didSet {
            placeholderLabel.text = placeholderText
        }
    }
    
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()
    
    var placeholderShouldCenter = true {
        didSet {
            if placeholderShouldCenter {
                placeholderLabel.centerY(inView: self)
                placeholderLabel.anchor(left: self.leftAnchor, right: self.rightAnchor, paddingLeft: 8)
            } else {
                placeholderLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 8,
                                        paddingLeft: 5)
            }
        }
    }
    
    // MARK: - lifecycles
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        addSubview(placeholderLabel)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextDidChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - actions
    @objc func handleTextDidChange() {
        placeholderLabel.isHidden = !self.text.isEmpty
    }
}
