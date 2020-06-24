//
//  YoutubeTableViewCell.swift
//  Bio
//
//  Created by Ann McDonough on 6/24/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//


import UIKit

class VideoTableViewCell: UITableViewCell {

    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var videoTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
