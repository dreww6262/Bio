//
//  SettingsCell.swift
//  Bio
//
//  Created by Ann McDonough on 8/20/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var userDataLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
