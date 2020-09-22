//
//  NavBarView.swift
//  Bio
//
//  Created by Ann McDonough on 9/22/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class NavBarView: UIView {
    
    var backButton = UIButton()
    var titleLabel = UILabel()
    var user = Auth.auth().currentUser
        
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //addBehavior()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    func addBehavior() {
        
        self.isUserInteractionEnabled = true
        let superView = self.superview!
        let superFrame = superView.frame
        self.addSubview(backButton)
            
        backButton.frame = CGRect(x: 5, y: 5, width: 44, height: self.frame.height)
        
        self.addSubview(titleLabel)
        titleLabel.frame = CGRect(x: self.frame.midX - 30, y: self.frame.height/4, width: 60, height: self.frame.height/2)
        titleLabel.text = "Settings"
        //let backTap = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
        //backButton.addGestureRecognizer(backTap)


    }
    
//    @objc func backButtonTapped(sender: UITapGestureRecognizer) {
//        //dismiss(animated: false, completion: nil)
//        print("Tapped back button. should dismiss!")
//    }
    
    
    
  
}
