//
//  CommentCell.swift
//  MySNS
//
//  Created by SANGMIN YEOM on 2022/01/24.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
    // MARK: - properties
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        let attributedString  = NSMutableAttributedString(string: "joker  ",
                                                          attributes: [.font:UIFont.boldSystemFont(ofSize: 14)])
        attributedString.append(NSAttributedString(string: "some comment for you...",
                                                   attributes:[.font:UIFont.systemFont(ofSize: 14)]))
        
        label.attributedText = attributedString
        
        return label
    }()
    
    // MARK: - lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.centerY(inView: self, leftAnchor: self.leftAnchor, paddingLeft: 8)
        profileImageView.setDimensions(height: 40, width: 40)
        profileImageView.layer.cornerRadius = 40 / 2

        addSubview(commentLabel)
        commentLabel.centerY(inView: profileImageView,
                             leftAnchor: profileImageView.rightAnchor,
                             paddingLeft: 8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
