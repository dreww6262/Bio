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
    var statusBarHeight = UIApplication.shared.statusBarFrame.height

    var backButton = UIButton()
    var postButton = UIButton()
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
        print("This is status bar height \(statusBarHeight)")
        self.isUserInteractionEnabled = true
        let superView = self.superview!
        let superFrame = superView.frame
        self.frame = CGRect(x: -5, y: -5, width: superView.frame.width + 10, height: (superView.frame.height/12)+5)
        var navBarHeightRemaining = self.frame.maxY - statusBarHeight
        superView.addSubview(backButton)
        superView.addSubview(titleLabel)
        superView.addSubview(postButton)
        backButton.setImage(UIImage(named: "whiteChevron"), for: .normal)
        postButton.setTitle("Post", for: .normal)
        postButton.setTitleColor(myCoolBlue, for: .normal)
//        let buttonWidth = CGFloat(60)
//        let halfButtonWidth = CGFloat(30)

//        backButton.frame = CGRect(x: 10, y: statusBarHeight + (self.frame.height - 25)/2, width: 25, height: 25)
//        postButton.frame = CGRect(x: self.frame.width - 60, y: self.frame.height - 30, width: 50, height: 25)
        backButton.frame = CGRect(x: 10, y: statusBarHeight + (navBarHeightRemaining - 25)/2, width: 25, height: 25)
        postButton.frame = CGRect(x: superView.frame.width - 35, y: statusBarHeight + (navBarHeightRemaining - 25)/2, width: 25, height: 25)
        
        titleLabel.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        titleLabel.text = "Example Title Text"
        titleLabel.textAlignment = .center
        postButton.contentHorizontalAlignment = .right
        titleLabel.font = UIFont(name: "DINAlternate-Bold", size: 20)
        titleLabel.textColor = .white
        self.backgroundColor = UIColor(cgColor: CGColor(gray: 0.05, alpha: 1.0))
        self.layer.borderWidth = 0.25
        self.layer.borderColor = CGColor(gray: 2/3, alpha: 1.0)
    

        
        //let superView = self.superview!
        //let superFrame = superView.frame
        //self.addSubview(backButton)
            
        //backButton.frame = CGRect(x: 5, y: 5, width: 44, height: self.frame.height)
        
        //self.addSubview(titleLabel)
        //titleLabel.frame = CGRect(x: self.frame.midX - 30, y: self.frame.height/4, width: 60, height: self.frame.height/2)
        //titleLabel.text = "Settings"
        //let backTap = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
        //backButton.addGestureRecognizer(backTap)


    }
    
//    @objc func backButtonTapped(sender: UITapGestureRecognizer) {
//        //dismiss(animated: false, completion: nil)
//        print("Tapped back button. should dismiss!")
//    }
    
    
    
  
}
