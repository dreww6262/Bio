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
    
    @IBOutlet weak var tagView: UIView!
    
    @IBOutlet weak var tagLabel: UILabel!
    
    @IBOutlet weak var tagArrow: UIImageView!
    
    @IBOutlet weak var locationView: UIView!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var locationArrow: UIImageView!
    
    
    var item: YPMediaItem?
    
    var bottomLine = CALayer()
    var bottomLine2 = CALayer()
    var bottomLine3 = CALayer()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      // previewImage.frame = CGRect(x: 10 , y: self.frame.height-previewImage.frame.height/2, width: previewImage.frame.width, height: previewImage.frame.height)
        tagView.addSubview(tagLabel)
        locationView.addSubview(locationLabel)
        tagView.addSubview(tagArrow)
        locationView.addSubview(locationArrow)
        
        //test if need
        tagLabel.text = "Tag Friends"
        locationLabel.text = "Add Location"
        tagLabel.textColor = .white
        locationLabel.textColor = .white
        previewImage.frame = CGRect(x: 0 , y: 30, width: previewImage.frame.width, height: previewImage.frame.height)
        tagView.frame = CGRect(x: 0, y: previewImage.frame.maxY + 2, width: self.frame.width, height: 44)
        locationView.frame = CGRect(x: 0, y: tagView.frame.maxY, width: self.frame.width, height: 44)
        
        bottomLine.frame = CGRect(x: 0, y: self.previewImage.frame.maxY + 5, width: self.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.systemGray4.cgColor
        self.layer.addSublayer(bottomLine)
        
        bottomLine2.frame = CGRect(x: 0, y: self.tagView.frame.maxY , width: self.frame.width, height: 1.0)
        bottomLine2.backgroundColor = UIColor.systemGray4.cgColor
        self.layer.addSublayer(bottomLine2)
        
        bottomLine3.frame = CGRect(x: 0, y: self.locationView.frame.maxY , width: self.frame.width, height: 1.0)
        bottomLine3.backgroundColor = UIColor.systemGray4.cgColor
        self.layer.addSublayer(bottomLine3)
        
        captionField.frame = CGRect(x: previewImage.frame.maxX, y: previewImage.frame.minY, width: self.frame.width - previewImage.frame.maxX, height: self.frame.height - locationView.frame.minY)
        
        tagLabel.frame = tagView.frame
        locationLabel.frame = locationView.frame
        tagArrow.frame = CGRect(x: self.frame.width - 30, y: 0, width: 25, height: 25)
        
        tagLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        locationLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: false)

        // Configure the view for the selected state
    }

}
