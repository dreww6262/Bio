//
//  SubmitSuggestionsVC.swift
//  Bio
//
//  Created by Ann McDonough on 10/7/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import AVKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import FirebaseUI

class SubmitSuggestionsVC: UIViewController, UITextViewDelegate {
    var navBarView = NavBarView()
    var titleLabel1 = UILabel()
    var cancelButton = UIButton()
    var doneButton = UIButton()
    var textView = UITextView()
    var placeholderLabel = UILabel()
    let db = Firestore.firestore()

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
        self.placeholderLabel.text = "Tell us what we can do better..."
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
        navBarView.postButton.frame = CGRect(x: view.frame.width - 70 - 10, y: navBarView.frame.midY - 40/2 + 10, width: 70, height: 40)
        navBarView.postButton.titleLabel?.textAlignment = .right
        navBarView.backButton.frame = CGRect(x: 10, y: statusBarHeight + (navBarHeightRemaining - 34)/2, width: 34, height: 34)

        let yOffset = navBarView.frame.maxY
     
      //  self.navBarView.addSubview(titleLabel1)
        self.navBarView.addBehavior()
        self.navBarView.titleLabel.text = "Submit a Suggestion"
        navBarView.backButton.setImage(UIImage(named: "whiteChevron"), for: .normal)
        self.navBarView.titleLabel.textColor = .white
        print("This is navBarView.")

        
        self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y: statusBarHeight + (navBarHeightRemaining - 34)/2, width: 200, height: 25)
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(self.backButtonpressed))
        let submitTap = UITapGestureRecognizer(target: self, action: #selector(self.submitPressed))
        self.navBarView.postButton.setTitle("Submit", for: .normal)
        self.navBarView.postButton.addGestureRecognizer(submitTap)
        self.navBarView.backButton.addGestureRecognizer(dismissTap)

    }


    func setUpNavBarViewOld() {
        self.view.addSubview(navBarView)
       // self.navBarView.addSubview(titleLabel1)
        self.navBarView.addSubview(doneButton)
        self.navBarView.addSubview(cancelButton)
        self.navBarView.addBehavior()
        self.navBarView.frame = CGRect(x: -5, y: -5, width: self.view.frame.width + 10, height: (self.view.frame.height/12)+5)
        self.navBarView.backgroundColor = UIColor(cgColor: CGColor(gray: 0.05, alpha: 1.0))
        self.navBarView.layer.borderWidth = 0.25
        self.navBarView.layer.borderColor = CGColor(gray: 2/3, alpha: 1.0)
        self.navBarView.titleLabel.text = "Submit A Suggestion"
    //    self.navBarView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/15)
       // self.tableiew.frame = CGRect(x: 0, y: self.view.frame.height/12, width: self.view.frame.width, height: self.view.frame.height*(11/12))
      //  self.titleLabel1.frame = CGRect(x: 0, y: 10, width: self.view.frame.width, height: self.navBarView.frame.height-10)
        
        self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y: self.cancelButton.frame.minY, width: 200, height: 25)
        self.navBarView.titleLabel.textAlignment = .center
       
        self.navBarView.titleLabel.font = UIFont(name: "DINAlternate-Bold", size: 20)
        self.navBarView.titleLabel.textColor = .white
      //  self.navBarView.backgroundColor = .clear
        var buttonWidth = CGFloat(20)
        var buttonHeight = CGFloat(20)
        cancelButton.sizeToFit()
  //      cancelButton.frame = CGRect(x: 5, y: navBarView.frame.height/4 + 10, width: buttonWidth height: buttonHeight)
        cancelButton.frame = CGRect(x: 5, y: (navBarView.frame.height - buttonHeight)/2 + 5, width: buttonWidth, height: buttonHeight)
    //    backButton.setBackgroundImage(UIImage(named: "whiteBack"), for: .normal)
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(self.backButtonpressed))
        let submitTap = UITapGestureRecognizer(target: self, action: #selector(self.submitPressed))
                                                
        
        view.bringSubviewToFront(cancelButton)
        doneButton.sizeToFit()
        doneButton.addGestureRecognizer(submitTap)
        cancelButton.addGestureRecognizer(dismissTap)
        doneButton.setTitle("Submit", for: .normal)
        doneButton.titleLabel?.textAlignment = .right
        doneButton.titleLabel?.font = UIFont(name: "DINAlternate-Bold", size: 17)
        cancelButton.setBackgroundImage(UIImage(systemName: "chevron.left"), for: .normal)
        doneButton.setTitleColor(.systemBlue, for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.tintColor = white
        
        doneButton.frame = CGRect(x: self.view.frame.width - 88, y: (navBarView.frame.height/4) + 5, width: 88, height: navBarView.frame.height/2)
        doneButton.titleLabel?.textAlignment = .right
       // doneButton.frame = CGRect(x: view.frame.width - cancelButton.frame.width - 10, y: navBarView.frame.midY - cancelButton.frame.height/2 + 10, width: cancelButton.frame.width, height: cancelButton.frame.height)
        view.bringSubviewToFront(doneButton)
//        doneButton.titleLabel!.font = UIFont(name: "DINAlternate-Bold", size: 20)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
//    
//    func setUpNavBarView() {
//        self.view.addSubview(navBarView)
//        self.navBarView.addSubview(titleLabel1)
//        self.navBarView.addSubview(doneButton)
//        self.navBarView.addSubview(cancelButton)
//        self.navBarView.addBehavior()
//        self.navBarView.frame = CGRect(x: -5, y: -5, width: self.view.frame.width + 10, height: (self.view.frame.height/12)+5)
//        self.navBarView.backgroundColor = UIColor(cgColor: CGColor(gray: 0.05, alpha: 1.0))
//        self.navBarView.layer.borderWidth = 0.25
//        self.navBarView.layer.borderColor = CGColor(gray: 2/3, alpha: 1.0)
//        self.titleLabel1.text = "Submit A Suggestion"
//    //    self.navBarView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/15)
//       // self.tableiew.frame = CGRect(x: 0, y: self.view.frame.height/12, width: self.view.frame.width, height: self.view.frame.height*(11/12))
//        self.titleLabel1.frame = CGRect(x: 0, y: 10, width: self.view.frame.width, height: self.navBarView.frame.height-10)
//        self.titleLabel1.textAlignment = .center
//       
//        self.titleLabel1.font = UIFont(name: "DINAlternate-Bold", size: 20)
//        self.titleLabel1.textColor = .white
//      //  self.navBarView.backgroundColor = .clear
//        var buttonWidth = CGFloat(20)
//        var buttonHeight = CGFloat(20)
//        cancelButton.sizeToFit()
//  //      cancelButton.frame = CGRect(x: 5, y: navBarView.frame.height/4 + 10, width: buttonWidth height: buttonHeight)
//        cancelButton.frame = CGRect(x: 5, y: (navBarView.frame.height - buttonHeight)/2 + 5, width: buttonWidth, height: buttonHeight)
//    //    backButton.setBackgroundImage(UIImage(named: "whiteBack"), for: .normal)
//        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(self.backButtonpressed))
//        let submitTap = UITapGestureRecognizer(target: self, action: #selector(self.submitPressed))
//                                                
//        
//        view.bringSubviewToFront(cancelButton)
//        self.navBarView.postButton.sizeToFit()
//        self.navBarView.postButton.addGestureRecognizer(submitTap)
//        self.navBarView.backButton.addGestureRecognizer(dismissTap)
//        self.navBarView.postButton.setTitle("Submit", for: .normal)
//        self.navBarView.postButton.titleLabel?.textAlignment = .right
//        self.navBarView.postButton.titleLabel?.font = UIFont(name: "DINAlternate-Bold", size: 17)
//        cancelButton.setBackgroundImage(UIImage(systemName: "chevron.left"), for: .normal)
//        self.navBarView.postButton.setTitleColor(.systemBlue, for: .normal)
//        cancelButton.setTitleColor(.white, for: .normal)
//        cancelButton.tintColor = white
//        cancelButton.isHidden = true
//        self.navBarView.postButton.isHidden = false
//        doneButton.isHidden = true
//        
//        self.navBarView.postButton.frame = CGRect(x: self.view.frame.width - 88, y: (navBarView.frame.height/4) + 5, width: 88, height: navBarView.frame.height/2)
//        self.navBarView.postButton.titleLabel?.textAlignment = .right
//       // doneButton.frame = CGRect(x: view.frame.width - cancelButton.frame.width - 10, y: navBarView.frame.midY - cancelButton.frame.height/2 + 10, width: cancelButton.frame.width, height: cancelButton.frame.height)
//        view.bringSubviewToFront(doneButton)
////        doneButton.titleLabel!.font = UIFont(name: "DINAlternate-Bold", size: 20)
//    }
    
    
    
    @objc func backButtonpressed() {
        print("It should dismiss here")
        self.dismiss(animated: true)
     }
    
    @objc func submitPressed() {
        print("I hit submit!")

        
        
        if self.textView.text.isEmpty {
            print("But text is empty give an alert :( ")
            // alert message
            let alert = UIAlertController(title: "PLEASE", message: "Fill All Fields", preferredStyle: UIAlertController.Style.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        else {
            let newSuggestion = self.textView.text
            print("This is the new suggestion: \(newSuggestion)")
            //db.collection("Feedback").addDocument(data: newSuggestion as String)
            
     
            
            
            let feedbackObjectref = db.collection("Feedback")
               let feedbackDoc = feedbackObjectref.document()
            let feedbackObject = FeedbackObject(text: newSuggestion!)
               feedbackDoc.setData(feedbackObject.dictionary){ error in
                   if error == nil {
                    UIDevice.vibrate()
                       print("added feedback: \(feedbackObject)")
                    self.dismiss(animated: true)
                   }
                   else {
                       print("failed to add notification \(feedbackObject)")

                   }
               }
        }
     
     }
    
    
 

}
