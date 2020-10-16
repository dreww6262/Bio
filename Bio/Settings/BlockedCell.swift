//
//  BlockedCell.swift
//  Bio
//
//  Created by Andrew Williamson on 10/16/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit

class BlockedCell: UITableViewCell {
    
    let deleteButton = UIButton()
    let avaImage = UIImageView()
    let usernameLabel = UILabel()
    
    var blockedUserData: UserData?
    var indexPath: IndexPath?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        contentView.addSubview(deleteButton)
        contentView.addSubview(avaImage)
        contentView.addSubview(usernameLabel)
        
    }

}
