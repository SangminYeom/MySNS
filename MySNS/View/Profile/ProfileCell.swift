//
//  ProfileCell.swift
//  MySNS
//
//  Created by SANGMIN YEOM on 2022/01/18.
//

import UIKit


class ProfileCell: UICollectionViewCell {
    // MARK: - properties
    var viewModel: PostViewModel? {
        didSet {
            configure()
        }
    }
    
    private let postImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "venom-7")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .lightGray
        
        addSubview(postImageView)
        postImageView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        guard let viewModel = viewModel else {
            return
        }
        
        postImageView.sd_setImage(with: viewModel.imageUrl, completed: nil)
    }
}
