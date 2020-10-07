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
    
    var bottomLine = CALayer()
    var bottomLine2 = CALayer()
    var bottomLine3 = CALayer()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      // previewImage.frame = CGRect(x: 10 , y: self.frame.height-previewImage.frame.height/2, width: previewImage.frame.width, height: previewImage.frame.height)
        previewImage.frame = CGRect(x: 10 , y: 30, width: previewImage.frame.width, height: previewImage.frame.height)
        tagField.frame = CGRect(x: 0, y: previewImage.frame.maxY + 2, width: self.frame.width, height: 30)
        locationField.frame = CGRect(x: 0, y: tagField.frame.maxY, width: self.frame.width, height: 30)
        
        bottomLine.frame = CGRect(x: 0, y: self.previewImage.frame.maxY + 5, width: self.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.systemGray4.cgColor
        self.layer.addSublayer(bottomLine)
        
        bottomLine2.frame = CGRect(x: 0, y: self.tagField.frame.maxY , width: self.frame.width, height: 1.0)
        bottomLine2.backgroundColor = UIColor.systemGray4.cgColor
        self.layer.addSublayer(bottomLine2)
        
        bottomLine3.frame = CGRect(x: 0, y: self.locationField.frame.maxY , width: self.frame.width, height: 1.0)
        bottomLine3.backgroundColor = UIColor.systemGray4.cgColor
        self.layer.addSublayer(bottomLine3)
        
        captionField.frame = CGRect(x: previewImage.frame.maxX, y: previewImage.frame.maxY*(4/5), width: self.frame.width - previewImage.frame.maxX, height: self.frame.height - tagField.frame.minY)

        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
