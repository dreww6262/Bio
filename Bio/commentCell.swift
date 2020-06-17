//
//  commentCell.swift
//  Dart1
//
//  Created by Ann McDonough on 5/22/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit

class commentCell: UITableViewCell {

    // UI objects
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var usernameBtn: UIButton!
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    
    // default func
    override func awakeFromNib() {
        super.awakeFromNib()
    
        // alignment
        avaImg.translatesAutoresizingMaskIntoConstraints = false
        usernameBtn.translatesAutoresizingMaskIntoConstraints = false
        commentLbl.translatesAutoresizingMaskIntoConstraints = false
        dateLbl.translatesAutoresizingMaskIntoConstraints = false
        
        // constraints
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-5-[username]-(-2)-[comment]-5-|",
            options: [], metrics: nil, views: ["username":usernameBtn as Any, "comment":commentLbl as Any]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-15-[date]",
            options: [], metrics: nil, views: ["date":dateLbl as Any]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[ava(40)]",
            options: [], metrics: nil, views: ["ava":avaImg as Any]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[ava(40)]-13-[comment]-20-|",
            options: [], metrics: nil, views: ["ava":avaImg as Any, "comment":commentLbl as Any]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[ava]-13-[username]",
            options: [], metrics: nil, views: ["ava":avaImg as Any, "username":usernameBtn as Any]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[date]-10-|",
            options: [], metrics: nil, views: ["date":dateLbl as Any]))
        
        
        // round ava
        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        avaImg.clipsToBounds = true
    }

}
