//
//  OtherReasonVC.swift
//  Bio
//
//  Created by Ann McDonough on 1/14/21.
//  Copyright © 2021 Patrick McDonough. All rights reserved.
//

import UIKit
import AVKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import FirebaseUI

class OtherReasonVC: UIViewController, UITextViewDelegate {
    var navBarView = NavBarView()
    var titleLabel1 = UILabel()
    var cancelButton = UIButton()
    var doneButton = UIButton()
    var textView = UITextView()
    var placeholderLabel = UILabel()
    let db = Firestore.firestore()
    var hexData: HexagonStructData?
    var userDataVM: UserDataVM?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.delegate = self
setUpNavBarView()
        setUpTextView()
        // Do any additional setup after loading the view.
    }
    
    func setUpTextView() {
        self.view.addSubview(self.textView)
        self.view.addSubview(self.placeholderLabel)
        self.placeholderLabel.text = "Why are you reporting this post?"
        self.placeholderLabel.font = UIFont(name: "DINAlternate-SemiBold", size: 18)
        self.textView.font = UIFont(name: "DINAlternate-SemiBold", size: 18)
     //   self.placeholderLabel.font = UIFont.italicSystemFont(ofSize: (textView.font?.pointSize)!)
        self.placeholderLabel.sizeToFit()
        self.textView.addSubview(placeholderLabel)
        self.textView.frame = CGRect(x: 10, y: self.navBarView.frame.maxY + 20, width: self.view.frame.width - 20, height: 200)
               placeholderLabel.textColor = UIColor.systemGray4
               placeholderLabel.isHidden = !textView.text.isEmpty
        self.placeholderLabel.textColor = .systemGray4
        self.textView.textColor = .white
        self.textView.backgroundColor = .clear
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.placeholderLabel.isHidden = !textView.text.isEmpty
        }
    
    func setUpNavBarView() {
        var statusBarHeight = UIApplication.shared.statusBarFrame.height
        print("This is status bar height \(statusBarHeight)")
        self.view.addSubview(navBarView)
        self.navBarView.frame = CGRect(x: -5, y: -5, width: self.view.frame.width + 10, height: (self.view.frame.height/12)+5)
        var navBarHeightRemaining = navBarView.frame.maxY - statusBarHeight
       // navBarView.backButton.isHidden = true
        navBarView.backButton.setTitleColor(.systemBlue, for: .normal)
        self.navBarView.backgroundColor = .clear//.systemGray6
//        self.navBarView.addSubview(toSettingsButton)
//        self.navBarView.addSubview(toSearchButton)
//
        let backTap = UITapGestureRecognizer(target: self, action: #selector(self.backButtonpressed))
        backTap.numberOfTapsRequired = 1
        navBarView.backButton.isUserInteractionEnabled = true
        navBarView.backButton.addGestureRecognizer(backTap)
     
        navBarView.postButton.titleLabel?.textAlignment = .right
        navBarView.backButton.frame = CGRect(x: 10, y: statusBarHeight + (navBarHeightRemaining - 34)/2, width: 34, height: 34)
        navBarView.postButton.frame = CGRect(x: view.frame.width - 60 - 10 - 5, y: navBarView.postButton.frame.minY, width: 60, height: 34)

        let yOffset = navBarView.frame.maxY
     
      //  self.navBarView.addSubview(titleLabel1)
        self.navBarView.addBehavior()
        self.navBarView.titleLabel.text = "Report A Post"
        navBarView.backButton.setImage(UIImage(named: "whiteChevron"), for: .normal)
        self.navBarView.titleLabel.textColor = .white
        print("This is navBarView.")

        
        self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y: statusBarHeight + (navBarHeightRemaining - 34)/2, width: 200, height: 25)
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(self.backButtonpressed))
        let submitTap = UITapGestureRecognizer(target: self, action: #selector(self.submitPressed))
        self.navBarView.postButton.setTitle("Submit", for: .normal)
        self.navBarView.postButton.addGestureRecognizer(submitTap)
       // self.navBarView.postButton.titleLabel?.sizeToFit()
        self.navBarView.postButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.navBarView.backButton.addGestureRecognizer(dismissTap)

    }


    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func backButtonpressed() {
        print("It should dismiss here")
        self.dismiss(animated: true)
     }
    
    @objc func submitPressed() {
        print("I hit submit!")
        
        if textView.text != "" {
            let reportObjectref = self.db.collection("ReportedPosts")
           let reportDoc = reportObjectref.document()
            let reportObject = ReportedPostObject(reason: textView.text,post: (self.hexData?.thumbResource)!, userReporting: self.userDataVM?.userData.value?.publicID ?? "unable to find userData.publicID", userWhoWasReported: (self.hexData!.postingUserID))
           reportDoc.setData(reportObject.dictionary){ error in
               if error == nil {
                UIDevice.vibrate()
                   print("reported post reason: \(reportObject)")
                self.dismiss(animated: true)
               }
               else {
                   print("failed to report \(reportObject)")

               }
           }
     
        }
        else {
            print("give warning to enter text")
            let alert = UIAlertController(title: "No Reason Provided", message: "Provide a reason for reporting or hit Cancel", preferredStyle: UIAlertController.Style.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
     }
    
    
 

}
