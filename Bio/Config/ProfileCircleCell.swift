//
//  ProfileCircleCell.swift
//  Bio
//
//  Created by Ann McDonough on 10/26/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit

class ProfileCircleCell: UICollectionViewCell {
    
    var imageView = UIImageView()
    
     var label = UILabel()
    
    override func layoutSubviews() {
        contentView.addSubview(imageView)
        contentView.addSubview(label)
//        imageView.layer.cornerRadius = imageView.frame.width/2
//        imageView.clipsToBounds = true 
    }
    
}
