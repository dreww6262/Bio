//
//  HorizontalCircleCollectionView.swift
//  Bio
//
//  Created by Andrew Williamson on 11/12/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit

class HorizontalCircleCollectionViewHeader: UICollectionReusableView {
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let friendsLabel = UILabel()
    let featuredLabel = UILabel()
    
    let noFriendsLabel = UILabel()
    
    override func layoutSubviews() {
        self.addSubview(collectionView)
        addSubview(friendsLabel)
        addSubview(featuredLabel)
        addSubview(noFriendsLabel)
    }
   
    


    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
