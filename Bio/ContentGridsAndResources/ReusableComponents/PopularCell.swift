//
//  PopularCell.swift
//  Bio
//
//  Created by Andrew Williamson on 11/12/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit

class PopularCell: UICollectionViewCell {
    var userData: UserData?
    var usernameLabel = UILabel()
    var displayNameLabel = UILabel()
    var image = UIImageView()
    var followView = UIView()
    var followImage = UIImageView()
    var followLabel = UILabel()
    var userDescriptionLabel = UILabel()
    
    override func layoutSubviews() {
        contentView.addSubview(usernameLabel)
        contentView.addSubview(displayNameLabel)
        contentView.addSubview(image)
        contentView.addSubview(followView)
        contentView.addSubview(userDescriptionLabel)
        followView.addSubview(followImage)
        followView.addSubview(followLabel)
    }
}
