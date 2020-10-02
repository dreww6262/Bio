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
    
    @IBOutlet weak var verifyView: UIView!
    
    @IBOutlet weak var verifyLabel: UILabel!
    
    @IBOutlet weak var verifyImage: UIImageView!
    
    //  UI objects
    @IBOutlet weak var socialMediaIcon: UIImageView!

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var interactiveTextField: UITextField!

    var cellHeight = CGFloat()
    var userData: UserData?
    
    let db = Firestore.firestore()
    
    
    // default func
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .black
        
        // alignment
        let width = UIScreen.main.bounds.width
       // cellHeight =  self.frame.height
        cellHeight = 50
        print("This is cellHeight \(cellHeight)")
        
        socialMediaIcon.frame = CGRect(x: self.frame.width*(3/48), y: self.frame.height*(3/48), width: cellHeight*(42/48), height: cellHeight*(42/48))
        //socialMediaIcon.setupHexagonMask(lineWidth: socialMediaIcon.frame.height/15, color: gold, cornerRadius: socialMediaIcon.frame.height/15)
        textField.frame = CGRect(x: socialMediaIcon.frame.maxX + (self.frame.width/24), y: self.frame.height/3, width: width - socialMediaIcon.frame.maxX, height: self.frame.height*(1/4))
        interactiveTextField.frame = textField.frame
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: 22, width: interactiveTextField.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.white.cgColor
        interactiveTextField.borderStyle = UITextField.BorderStyle.none
        interactiveTextField.layer.addSublayer(bottomLine)
       
        print("This is textfield.frame \(textField.frame)")
        print("This is interactivetextfield.frame \(interactiveTextField.frame)")
        // followBtn.frame = CGRect(x: width - width / 3.5 - 40, y: usernameLbl.frame.height - 20, width: width / 3.5, height: width/3.5)
       // followBtn.frame = CGRect(x: width - (width/3), y: avaImg.frame.minY, width: width / 3.5, height: width/3.5)
        verifyView.frame = CGRect(x: width - (width/4.5), y: interactiveTextField.frame.minY - (self.frame.height/8), width: width/7, height: interactiveTextField.frame.height)
        verifyView.layer.cornerRadius = verifyView.frame.size.width / 20
        verifyView.addSubview(verifyImage)
        verifyView.addSubview(verifyLabel)
        verifyView.isHidden = true
        verifyImage.frame = CGRect(x: 0, y: 0, width: verifyView.frame.height, height: verifyView.frame.height)
        //let followTap = UITapGestureRecognizer(target: self, action: #selector(followPressed))
        //verifyView.addGestureRecognizer(followTap)
        verifyLabel.frame = CGRect(x: verifyImage.frame.maxX + (verifyView.frame.width/20), y: verifyImage.frame.minY - (verifyView.frame.height/5), width: 44, height: 20)
         verifyView.layer.cornerRadius = verifyView.frame.size.width/10
        print("THis is followView.frame \(verifyView.frame)")
        print("This is followimage.frame \(verifyImage.frame)")
        print("This is follow label.frame \(verifyLabel.frame)")
        
        // round ava
       // socialMediaIcon.layer.cornerRadius = socialMediaIcon.frame.size.width / 2
        socialMediaIcon.clipsToBounds = true
    }
    
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
   
}
