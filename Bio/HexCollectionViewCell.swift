//
//  HexCollectionViewCell.swift
//  Bio
//
//  Created by Ann McDonough on 8/31/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit

class HexCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    // default func
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .red
        
        // alignment
        let width = UIScreen.main.bounds.width
        let cellHeight = self.frame.height
        
        imageView.frame = CGRect(x: 0, y: 0, width: cellHeight, height: cellHeight)
        imageView.setupHexagonMask(lineWidth: imageView.frame.height/15, color: gold, cornerRadius: imageView.frame.height/15)
    }
    
    
    
    
    
}

