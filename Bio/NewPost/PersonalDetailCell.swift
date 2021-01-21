//
//  PersonalDetailCell.swift
//  Bio
//
//  Created by Ann McDonough on 12/9/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import AVFoundation

class PersonalDetailCell: UITableViewCell, UITextFieldDelegate {
    
    //  UI objects
    @IBOutlet weak var socialMediaIcon: UIImageView!

    let interactiveTextField = UITextField()
var xButton = UIButton()
    
    let db = Firestore.firestore()
    
    let circularMask = UIImageView()
    
    // default func
    override func layoutSubviews() {
        self.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.00)
        
        contentView.addSubview(interactiveTextField)
        contentView.addSubview(xButton)
        self.backgroundColor = .white
        // alignment
       // cellHeight =  self.frame.height
        let cellHeight: CGFloat = self.contentView.frame.height
        print("This is cellHeight \(cellHeight)")
     //   self.frame = self.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        interactiveTextField.delegate = self
        socialMediaIcon.frame = CGRect(x: 16, y: 0.125 * cellHeight, width: cellHeight*(3/4), height: cellHeight*(3/4))
        //socialMediaIcon.setupHexagonMask(lineWidth: socialMediaIcon.frame.height/15, color: gold, cornerRadius: socialMediaIcon.frame.height/15)
        interactiveTextField.frame = CGRect(x: socialMediaIcon.frame.maxX + 16, y: cellHeight/3, width: contentView.frame.width - socialMediaIcon.frame.maxX - 16, height: cellHeight / 3)
        var xButtonWidth = CGFloat(16.0)
        xButton.frame = CGRect(x: self.frame.width - xButtonWidth - 15, y: (cellHeight - xButtonWidth)/2, width: xButtonWidth, height: xButtonWidth)
        xButton.setImage(UIImage(named: "x"), for: .normal)
        let bottomLine = CALayer()
        bottomLine.isHidden = true
        bottomLine.frame = CGRect(x: 0.0, y: interactiveTextField.frame.height + 4, width: interactiveTextField.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor(red: 0.82, green: 0.82, blue: 0.84, alpha: 1.00).cgColor
        interactiveTextField.borderStyle = UITextField.BorderStyle.none
        interactiveTextField.layer.addSublayer(bottomLine)
       
        print("This is interactivetextfield.frame \(interactiveTextField.frame)")
       

        // round ava
       // socialMediaIcon.layer.cornerRadius = socialMediaIcon.frame.size.width / 2
        socialMediaIcon.clipsToBounds = true
        socialMediaIcon.layer.cornerRadius = socialMediaIcon.frame.height / 2
        socialMediaIcon.layer.borderColor = UIColor.white.cgColor
        socialMediaIcon.layer.borderWidth = 1.5
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        interactiveTextField.text = ""
    }
    
    
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
   
}
