//
//  pictureCell.swift
//  Dart1
//
//  Created by Ann McDonough on 5/13/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit

class pictureCell: UICollectionViewCell {
    
    // holds post picture
    @IBOutlet weak var picImg: UIImageView!
    
    
    // default func
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // alignment
        let width = UIScreen.main.bounds.width
        picImg.frame = CGRect(x: 0, y: 0, width: width / 3, height: width / 3)
    }
    
}
