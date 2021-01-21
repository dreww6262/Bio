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
               placeholderLabel.textColor = UIColor(red: 0.82, green: 0.82, blue: 0.84, alpha: 1.00)
               placeholderLabel.isHidden = !textView.text.isEmpty
        self.placeholderLabel.textColor = UIColor(red: 0.82, green: 0.82, blue: 0.84, alpha: 1.00)
        self.textView.textColor = .white
        self.textView.backgroundColor = .clear
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.placeholderLabel.isHidden = !textView.text.isEmpty
        }
    
    func setUpNavBarView() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
//        print("This is status bar height \(statusBarHeight)")
        self.view.addSubview(navBarView)
        self.navBarView.frame = CGRect(x: -5, y: -5, width: self.view.frame.width + 10, height: (self.view.frame.height/12)+5)
        self.navBarView.addBehavior()
        let navBarHeightRemaining = navBarView.frame.maxY - statusBarHeight
       // navBarView.backButton.isHidden = true
        navBarView.backButton.setTitleColor(.systemBlue, for: .normal)
        self.navBarView.backgroundColor = .clear//UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.00)
//        self.navBarView.addSubview(toSettingsButton)
//        self.navBarView.addSubview(toSearchButton)
//
        let backTap = UITapGestureRecognizer(target: self, action: #selector(self.backButtonpressed))
        backTap.numberOfTapsRequired = 1
        navBarView.backButton.isUserInteractionEnabled = true
        navBarView.backButton.addGestureRecognizer(backTap)
        navBarView.postButton.frame = CGRect(x: view.frame.width - 70 - 10, y: statusBarHeight + (navBarHeightRemaining - 34)/2, width: 70, height: 25)
        navBarView.postButton.titleLabel?.textAlignment = .right
        navBarView.backButton.frame = CGRect(x: 10, y: statusBarHeight + (navBarHeightRemaining - 34)/2, width: 34, height: 34)

     
      //  self.navBarView.addSubview(titleLabel1)
        self.navBarView.titleLabel.text = "Submit a Suggestion"
        navBarView.backButton.setImage(UIImage(named: "whiteChevron"), for: .normal)
        self.navBarView.titleLabel.textColor = .white
//        print("This is navBarView.")

        
        self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y: statusBarHeight + (navBarHeightRemaining - 34)/2, width: 200, height: 25)
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(self.backButtonpressed))
        let submitTap = UITapGestureRecognizer(target: self, action: #selector(self.submitPressed))
        self.navBarView.postButton.setTitle("Submit", for: .normal)
        self.navBarView.postButton.addGestureRecognizer(submitTap)
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
