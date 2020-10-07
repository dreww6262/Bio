//
//  SubmitSuggestionsVC.swift
//  Bio
//
//  Created by Ann McDonough on 10/7/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit

class SubmitSuggestionsVC: UIViewController {
    var navBarView = NavBarView()
    var titleLabel1 = UILabel()
    var cancelButton = UIButton()
    var doneButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
setUpNavBarView()
        // Do any additional setup after loading the view.
    }
    

    func setUpNavBarView() {
        self.view.addSubview(navBarView)
        self.navBarView.addSubview(titleLabel1)
        self.navBarView.addSubview(doneButton)
        self.navBarView.addSubview(cancelButton)
        self.navBarView.addBehavior()
        self.navBarView.frame = CGRect(x: -5, y: -5, width: self.view.frame.width + 10, height: (self.view.frame.height/12)+5)
        self.navBarView.backgroundColor = UIColor(cgColor: CGColor(gray: 0.05, alpha: 1.0))
        self.navBarView.layer.borderWidth = 0.25
        self.navBarView.layer.borderColor = CGColor(gray: 2/3, alpha: 1.0)
        self.titleLabel1.text = "Submit A Suggestion"
    //    self.navBarView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/15)
       // self.tableiew.frame = CGRect(x: 0, y: self.view.frame.height/12, width: self.view.frame.width, height: self.view.frame.height*(11/12))
        self.titleLabel1.frame = CGRect(x: 0, y: 10, width: self.view.frame.width, height: self.navBarView.frame.height-10)
        self.titleLabel1.textAlignment = .center
       
        self.titleLabel1.font = UIFont(name: "DINAlternate-Bold", size: 22)
        self.titleLabel1.textColor = .white
      //  self.navBarView.backgroundColor = .clear
        var buttonWidth = CGFloat(40)
        var buttonHeight = CGFloat(40)
        cancelButton.sizeToFit()
  //      cancelButton.frame = CGRect(x: 5, y: navBarView.frame.height/4 + 10, width: buttonWidth height: buttonHeight)
        cancelButton.frame = CGRect(x: 5, y: (navBarView.frame.height - buttonHeight)/2, width: buttonWidth, height: buttonHeight)
    //    backButton.setBackgroundImage(UIImage(named: "whiteBack"), for: .normal)
        
        
        view.bringSubviewToFront(cancelButton)
        doneButton.sizeToFit()
        doneButton.setTitle("Submit", for: .normal)
        cancelButton.setBackgroundImage(UIImage(systemName: "chevron_left"), for: .normal)
        doneButton.setTitleColor(.systemBlue, for: .normal)
        
        doneButton.frame = CGRect(x: self.view.frame.width - buttonWidth, y: (navBarView.frame.height/4), width: 88, height: navBarView.frame.height/2)
        doneButton.titleLabel?.textAlignment = .right
       // doneButton.frame = CGRect(x: view.frame.width - cancelButton.frame.width - 10, y: navBarView.frame.midY - cancelButton.frame.height/2 + 10, width: cancelButton.frame.width, height: cancelButton.frame.height)
        view.bringSubviewToFront(doneButton)
//        doneButton.titleLabel!.font = UIFont(name: "DINAlternate-Bold", size: 20)
    }
 

}
