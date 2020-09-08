//
//  UserCell.swift
//  Bio
//
//  Created by Ann McDonough on 8/16/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class UserCell: UITableViewCell {
    
    //  UI objects
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    
    var myUsername: String?
    
    let db = Firestore.firestore()
    
    
    // default func
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .black
        
        // alignment
        let width = UIScreen.main.bounds.width
        let cellHeight = self.frame.height
        
        avaImg.frame = CGRect(x: 10, y: 10, width: cellHeight - 20, height: cellHeight - 20)
        avaImg.setupHexagonMask(lineWidth: 10.0, color: gold, cornerRadius: 10.0)
        usernameLbl.frame = CGRect(x: avaImg.frame.size.width + 20, y: self.frame.height/2, width: width / 3.2, height: 30)
        displayNameLabel.frame = CGRect(x: usernameLbl.frame.size.width + 20, y: usernameLbl.frame.height+10, width: width / 3.2, height: 30)
        // followBtn.frame = CGRect(x: width - width / 3.5 - 40, y: usernameLbl.frame.height - 20, width: width / 3.5, height: width/3.5)
        followBtn.frame = CGRect(x: width - width / 3.5 + 20, y: usernameLbl.frame.height - 20, width: width / 3.5, height: width/3.5)
        followBtn.layer.cornerRadius = followBtn.frame.size.width / 20
        
        // round ava
        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        avaImg.clipsToBounds = true
    }
    
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBAction func followPressed(_ sender: UIButton) {
        let width = UIScreen.main.bounds.width
        let cell = self
        let button = self.followBtn
        let username = cell.usernameLbl.text!
        if myUsername != nil {
            if button!.tag == 0 {
                let newFollow = ["follower": myUsername, "following": username]
                db.collection("Followings").addDocument(data: newFollow as [String : Any])
                button?.imageView?.image = UIImage(named: "friendCheck")
                button?.tag = 1
                print("It's supposed to change to check")
                button?.frame = CGRect(x: width - width / 3.5 + 20, y: usernameLbl.frame.height - 20, width: width / 3.5, height: width/3.5)
                button?.imageView?.frame = CGRect(x: width - width / 3.5 + 20, y: usernameLbl.frame.height - 20, width: width / 3.5, height: width/3.5)
                
                let notificationObject = NewsObject(dictionary: <#[String : Any]#>)
                let notificationObjectref = db.collection("News")
                   let notificationDoc = notificationObjectref.document()
                   var notificationCopy = NewsObject(dictionary: notificationObject.dictionary)
                notificationCopy.notificationID = notificationObject.notificationID
                notificationCopy.createdAt = Date()
                   notificationDoc.setData(notificationCopy.dictionary){ error in
                       //     group.leave()
                       if error == nil {
                           print("added notification: \(notificationObject)")
                           completion(true)
                       }
                       else {
                           print("failed to add notification \(notificationObject)")
                           completion(false)
                       }
                   }
                
                
                
                
                
                
                //SEND A NOTIFICATION FOR FOLLOWING! SWITCH FROM PARSE TO FIREBASE
//                if self.usernameBtn.titleLabel?.text != PFUser.current()?.username {
//                                 let newsObj = PFObject(className: "News")
//                                 newsObj["by"] = PFUser.current()?.username
//                                 newsObj["ava"] = PFUser.current()?.object(forKey: "ava") as! PFFile
//                                 newsObj["to"] = self.usernameBtn.titleLabel!.text
//                                 newsObj["owner"] = self.usernameBtn.titleLabel!.text
//                                 newsObj["uuid"] = self.uuidLbl.text
//                                 newsObj["type"] = "like"
//                                 newsObj["checked"] = "no"
//                                 newsObj.saveEventually()
//                             }
                
                
                
                
//
//                sender.imageView?.image = UIImage(named: "friendCheck")
//                        button?.tag = 1
//                        print("It's supposed to change to check")
//                sender.imageView?.frame = CGRect(x: width - width / 3.5 + 20, y: usernameLbl.frame.height - 20, width: width / 3.5, height: width/3.5)
//                        sender.imageView?.frame = CGRect(x: width - width / 3.5 + 20, y: usernameLbl.frame.height - 20, width: width / 3.5, height: width/3.5)
                
            }
            else {
                db.collection("Followings").whereField("follower", isEqualTo: myUsername!).whereField("following", isEqualTo: username).addSnapshotListener({ objects, error in
                    if error == nil {
                        guard let docs = objects?.documents else {
                            return
                        }
                        for doc in docs {
                            doc.reference.delete()
                        }
                    }
                    })
                button?.imageView?.image = UIImage(named: "addFriend")
                button?.frame = CGRect(x: width - width / 3.5 + 20, y: usernameLbl.frame.height - 20, width: width / 3.5, height: width/3.5)
                button?.imageView?.frame = CGRect(x: width - width / 3.5 + 20, y: usernameLbl.frame.height - 20, width: width / 3.5, height: width/3.5)
                button?.tag = 0
            }
          button?.frame = CGRect(x: width - width / 3.5 + 20, y: usernameLbl.frame.height - 20, width: width / 3.5, height: width/3.5)
                         button?.imageView?.frame = CGRect(x: width - width / 3.5 + 20, y: usernameLbl.frame.height - 20, width: width / 3.5, height: width/3.5)
        }
    }
    
    
//    func addNotificationObject(notificationObject: NewsObject, completion: @escaping (Bool) -> Void) {
//           let notificationObjectref = db.collection("News")
//           let notificationDoc = notificationObjectref.document()
//           var notificationCopy = NewsObject(dictionary: notificationObject.dictionary)
//        notificationCopy.notificationID = notificationObject.notificationID
//        notificationCopy.createdAt = Date()
//        notificationCopy.
//           notificationDoc.setData(notificationCopy.dictionary){ error in
//               //     group.leave()
//               if error == nil {
//                   print("added notification: \(notificationObject)")
//                   completion(true)
//               }
//               else {
//                   print("failed to add notification \(notificationObject)")
//                   completion(false)
//               }
//           }
//       }
    
    
}
