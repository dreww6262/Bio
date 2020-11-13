//
//  PostImageView.swift
//  Bio
//
//  Created by Andrew Williamson on 9/4/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit


class PostImageView: UIImageView {
    var hexData: HexagonStructData? = nil
    let textOverlay = UILabel()
    
    override func layoutSubviews() {
        self.addSubview(textOverlay)
        bringSubviewToFront(textOverlay)
    }
}
