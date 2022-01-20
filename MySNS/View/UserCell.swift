//
//  UserCell.swift
//  MySNS
//
//  Created by SANGMIN YEOM on 2022/01/20.
//

import UIKit

class UserCell: UITableViewCell {
    
    // MARK: - properties
    var viewModel: UserCellViewModel? {
        didSet {
                configure()
        }
    }
    private let profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.image = UIImage(named: "venom-7")
        return iv
    }()
    
    private let usernameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "venom"
        return label
    }()
    
    private let fullnameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "eee ddd"
        label.textColor = .lightGray
        return label
    }()
    
    // MARK: - lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.setDimensions(height: 48, width: 48)
        profileImageView.layer.cornerRadius = 48 / 2
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft:  12)
        
        let stack = UIStackView(arrangedSubviews: [usernameLabel, fullnameLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        
        addSubview(stack)
        stack.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - helpers
    func configure() {
        guard let viewModel = viewModel else { return }
        
        profileImageView.sd_setImage(with: viewModel.profileImageUrl, completed: nil)
        usernameLabel.text = viewModel.username
        fullnameLabel.text = viewModel.fullname
    }
}
