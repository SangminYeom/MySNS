//
//  CommentCell.swift
//  MySNS
//
//  Created by SANGMIN YEOM on 2022/01/24.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
    // MARK: - properties
    var viewModal : CommentViewModel? {
        didSet {
            configure()
        }
    }
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let commentLabel = UILabel()
    
    // MARK: - lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.centerY(inView: self, leftAnchor: self.leftAnchor, paddingLeft: 8)
        profileImageView.setDimensions(height: 40, width: 40)
        profileImageView.layer.cornerRadius = 40 / 2

        addSubview(commentLabel)
        commentLabel.numberOfLines = 0
        commentLabel.centerY(inView: profileImageView,
                             leftAnchor: profileImageView.rightAnchor,
                             paddingLeft: 8)
        commentLabel.anchor(right: self.rightAnchor, paddingRight: 8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - helpers
    func configure() {
        guard let viewModel = viewModal else { return }
        
        profileImageView.sd_setImage(with: viewModel.profileImageUrl, completed: nil)
        commentLabel.attributedText = viewModel.commentLabelText()
    }
}
