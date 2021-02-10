//
//  newsCell.swift
//  Dart1
//
//  Created by Ann McDonough on 5/22/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import Firebase
class newsCell: UITableViewCell {
    let db = Firestore.firestore()
    // UI objects
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var usernameBtn: UIButton!
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    var currentPostingUserID = ""
    
    @IBOutlet weak var rejectButton: UIButton!
    
    @IBOutlet weak var acceptButton: UIButton!
    
    var followBackButton = UIButton()
    
    let phoneButton = UIButton()
    
    var notification: NewsObject?

    // default func
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.addSubview(phoneButton)
        contentView.addSubview(followBackButton)
        
        // constraints
        avaImg.translatesAutoresizingMaskIntoConstraints = false
        usernameBtn.translatesAutoresizingMaskIntoConstraints = false
        infoLbl.translatesAutoresizingMaskIntoConstraints = false
        dateLbl.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[ava(30)]-10-[username]-7-[info]-7-[date]",
            options: [], metrics: nil, views: ["ava":avaImg as Any, "username":usernameBtn as Any, "info":infoLbl as Any, "date":dateLbl as Any]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[ava(30)]-10-|",
            options: [], metrics: nil, views: ["ava":avaImg as Any]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[username(30)]",
            options: [], metrics: nil, views: ["username":usernameBtn as Any]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[info(30)]",
            options: [], metrics: nil, views: ["info":infoLbl as Any]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[date(30)]",
            options: [], metrics: nil, views: ["date":dateLbl as Any]))
        
        // round ava
       // avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        avaImg.clipsToBounds = true
    }
 
    

    @IBAction func rejectButtonPressed(_ sender: UIButton) {
        //delete this notification from the backend and reload table view
//        db.collection("PhoneNumberRequests").whereField("requested", isEqualTo: userData!.publicID).whereField("requesting", isEqualTo: username).addSnapshotListener({ objects, error in
//            if error == nil {
//                guard let docs = objects?.documents else {
//                    return
//                }
//                for doc in docs {
//                    doc.reference.delete()
//                }
//            }
//        })
    }
        
        
    
    @IBAction func acceptButtonPressed(_ sender: Any) {
        //give them access to the phone number, hide the buttons but keep it in notifications
        let approving = self.usernameBtn.titleLabel!.text
        let newApproval = ["approver": currentPostingUserID, "approving": approving]
        db.collection("PhoneNumberApprovals").addDocument(data: newApproval as [String : Any])
        UIDevice.vibrate()
        print("This is newApproval \(newApproval)")
        
        
        //fix this
//        let phoneNumber = UserDataVM(username: currentPostingUserID).userData.value!.phoneNumber
        //hard coding phone number for now
        let phoneNumber = "617-780-7235"
        
        let notificationObjectref = db.collection("News2")
           let notificationDoc = notificationObjectref.document()
        let notificationObject = NewsObject(ava: phoneNumber, type: "approvePhoneNumber", currentUser: currentPostingUserID, notifyingUser: approving!, thumbResource: "userFiles/\(currentPostingUserID)/\(currentPostingUserID)_avatar.png", createdAt: NSDate.now.description, checked: false, notificationID: notificationDoc.documentID)
           notificationDoc.setData(notificationObject.dictionary){ error in
               //     group.leave()
               if error == nil {
                   print("added notification: \(notificationObject)")
                   
               }
               else {
                   print("failed to add notification \(notificationObject)")
                   
               }
           }
      
    }
    
}

