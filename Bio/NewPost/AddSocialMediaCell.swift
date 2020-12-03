//
//  AddSocialMediaCell.swift
//  Bio
//
//  Created by Ann McDonough on 9/30/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import AVFoundation

class AddSocialMediaCell: UITableViewCell {
    
    //  UI objects
    @IBOutlet weak var socialMediaIcon: UIImageView!

    let interactiveTextField = UITextField()

    
    let db = Firestore.firestore()
    
    let circularMask = UIImageView()
    
    // default func
    override func layoutSubviews() {
        self.backgroundColor = .black
        
        contentView.addSubview(interactiveTextField)
        
        // alignment
       // cellHeight =  self.frame.height
        let cellHeight: CGFloat = self.contentView.frame.height
        print("This is cellHeight \(cellHeight)")
        
        socialMediaIcon.frame = CGRect(x: 16, y: 0.125 * cellHeight, width: cellHeight*(3/4), height: cellHeight*(3/4))
        //socialMediaIcon.setupHexagonMask(lineWidth: socialMediaIcon.frame.height/15, color: gold, cornerRadius: socialMediaIcon.frame.height/15)
        interactiveTextField.frame = CGRect(x: socialMediaIcon.frame.maxX + 16, y: cellHeight/3, width: contentView.frame.width - socialMediaIcon.frame.maxX - 16, height: cellHeight / 3)
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: interactiveTextField.frame.height + 4, width: interactiveTextField.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.systemGray4.cgColor
        interactiveTextField.borderStyle = UITextField.BorderStyle.none
        interactiveTextField.layer.addSublayer(bottomLine)
       
        print("This is interactivetextfield.frame \(interactiveTextField.frame)")
       
//        verifyView.frame = CGRect(x: width - (width/4.5), y: interactiveTextField.frame.minY - (self.frame.height/8), width: width/7, height: interactiveTextField.frame.height)
//        verifyView.layer.cornerRadius = verifyView.frame.size.width / 20
//        verifyView.addSubview(verifyImage)
//        verifyView.addSubview(verifyLabel)
//        verifyView.isHidden = true
//        verifyImage.frame = CGRect(x: 0, y: 0, width: verifyView.frame.height, height: verifyView.frame.height)
//        //let followTap = UITapGestureRecognizer(target: self, action: #selector(followPressed))
//        //verifyView.addGestureRecognizer(followTap)
//        verifyLabel.frame = CGRect(x: verifyImage.frame.maxX + (verifyView.frame.width/20), y: verifyImage.frame.minY - (verifyView.frame.height/5), width: 44, height: 20)
//         verifyView.layer.cornerRadius = verifyView.frame.size.width/10
//        print("THis is followView.frame \(verifyView.frame)")
//        print("This is followimage.frame \(verifyImage.frame)")
//        print("This is follow label.frame \(verifyLabel.frame)")
        
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
