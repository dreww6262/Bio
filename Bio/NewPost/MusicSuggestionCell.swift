//
//  MusicSuggestionCell.swift
//  Bio
//
//  Created by Andrew Williamson on 1/2/21.
//  Copyright © 2021 Patrick McDonough. All rights reserved.
//

import UIKit

class MusicSuggestionCell: UITableViewCell {
    
    let trackLabel = UILabel()
    let artistLabel = UILabel()
    let albumLabel = UILabel()
    
    var musicItem: MusicItem?

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        contentView.addSubview(trackLabel)
        contentView.addSubview(artistLabel)
        contentView.addSubview(albumLabel)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
