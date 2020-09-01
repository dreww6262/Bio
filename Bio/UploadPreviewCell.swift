//
//  UploadPreviewCell.swift
//  Bio
//
//  Created by Ann McDonough on 8/6/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import YPImagePicker

class UploadPreviewCell: UITableViewCell {

    @IBOutlet weak var previewImage: UIImageView!
    
    @IBOutlet weak var captionField: UITextField!
    
    @IBOutlet weak var tagField: UITextField!
    
    @IBOutlet weak var locationField: UITextField!
    
    var item: YPMediaItem? 
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
