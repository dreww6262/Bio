//
//  UserCell.swift
//  Bio
//
//  Created by Ann McDonough on 8/16/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

       //  UI objects
        @IBOutlet weak var avaImg: UIImageView!
        @IBOutlet weak var usernameLbl: UILabel!
        @IBOutlet weak var displayNameLabel: UILabel!
        
        @IBOutlet weak var followBtn: UIButton!
    
    
        // default func
        override func awakeFromNib() {
            super.awakeFromNib()
    
            // alignment
            let width = UIScreen.main.bounds.width
            let cellHeight = self.frame.height
    
            avaImg.frame = CGRect(x: 10, y: 10, width: cellHeight - 20, height: cellHeight - 20)
            avaImg.setupHexagonMask(lineWidth: 10.0, color: gold, cornerRadius: 10.0)
            usernameLbl.frame = CGRect(x: avaImg.frame.size.width + 20, y: self.frame.height/2, width: width / 3.2, height: 30)
            displayNameLabel.frame = CGRect(x: usernameLbl.frame.size.width + 20, y: usernameLbl.frame.height+10, width: width / 3.2, height: 30)
            followBtn.frame = CGRect(x: width - width / 3.5 - 10, y: 30, width: width / 3.5, height: 30)
            followBtn.layer.cornerRadius = followBtn.frame.size.width / 20
    
            // round ava
            avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
            avaImg.clipsToBounds = true
        }
        
    
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
