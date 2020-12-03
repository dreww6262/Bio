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
import AVFoundation

class UserCell: UITableViewCell {
    
    @IBOutlet weak var followView: UIView!
    
    @IBOutlet weak var followLabel: UILabel!
    
    @IBOutlet weak var followImage: UIImageView!
    
    //  UI objects
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    var cellHeight = CGFloat()
    var userDataVM: UserDataVM?
    
    let db = Firestore.firestore()
    
    
    // default func
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .black
        
        // alignment
        let width = UIScreen.main.bounds.width
       // cellHeight =  self.frame.height
        cellHeight = 80
        print("This is cellHeight \(cellHeight)")
        
        avaImg.frame = CGRect(x: self.frame.width*(3/48), y: self.frame.height*(3/48), width: cellHeight*(42/48), height: cellHeight*(42/48))
      //  avaImg.setupHexagonMask(lineWidth: avaImg.frame.height/15, color: white, cornerRadius: avaImg.frame.height/15)
        avaImg.layer.cornerRadius = avaImg.frame.width/2
        avaImg.layer.borderWidth = 1.0
        avaImg.layer.borderColor = white.cgColor
        
        displayNameLabel.frame = CGRect(x: avaImg.frame.maxX + (self.frame.width/24), y: self.frame.height/3, width: width - avaImg.frame.maxX, height: self.frame.height*(1/4))
        
        usernameLbl.frame = CGRect(x: avaImg.frame.maxX + (self.frame.width/24), y: displayNameLabel.frame.maxY+(self.frame.height*(1/72)), width: width - avaImg.frame.maxX, height: self.frame.height/4)
        print("This is usernameLabel.frame \(usernameLbl.frame)")
        print("This is displayNameLabel.frame \(displayNameLabel.frame)")
        // followBtn.frame = CGRect(x: width - width / 3.5 - 40, y: usernameLbl.frame.height - 20, width: width / 3.5, height: width/3.5)
       // followBtn.frame = CGRect(x: width - (width/3), y: avaImg.frame.minY, width: width / 3.5, height: width/3.5)
        followView.frame = CGRect(x: width - (width/4.5), y: usernameLbl.frame.minY - (self.frame.height/8), width: width/7, height: displayNameLabel.frame.height)
        followView.layer.cornerRadius = followView.frame.size.width / 20
        followView.addSubview(followImage)
        followView.addSubview(followLabel)
        followImage.frame = CGRect(x: 0, y: 0, width: followView.frame.height, height: followView.frame.height)
        let followTap = UITapGestureRecognizer(target: self, action: #selector(followPressed))
        followView.addGestureRecognizer(followTap)
        followLabel.frame = CGRect(x: followImage.frame.maxX + (followView.frame.width/20), y: followImage.frame.minY - (followView.frame.height/5), width: 44, height: 20)
         followView.layer.cornerRadius = followView.frame.size.width/10
        print("THis is followView.frame \(followView.frame)")
        print("This is followimage.frame \(followImage.frame)")
        print("This is follow label.frame \(followLabel.frame)")
        
        // round ava
        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        avaImg.clipsToBounds = true
        
        
    }
    
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @objc func followPressed(_ sender: UIButton) {
        //let width = UIScreen.main.bounds.width
        let cell = self
        let button = self.followView
        let username = cell.usernameLbl.text!
        let userData = userDataVM?.userData.value
        if userData != nil {
            if button!.tag == 0 {
                let newFollow = ["follower": userData!.publicID, "following": username]
                db.collection("Followings").addDocument(data: newFollow as [String : Any])
                UIDevice.vibrate()
                button?.isHidden = true
//                button?.imageView?.image = UIImage(named: "checkmark32x32")
//                sender.imageView?.image = UIImage(named: "checkmark32x32")
                button?.tag = 1
                
                
                let notificationObjectref = db.collection("News2")
                   let notificationDoc = notificationObjectref.document()
                let notificationObject = NewsObject(ava: userData!.avaRef, type: "follow", currentUser: userData!.publicID, notifyingUser: cell.usernameLbl.text!, thumbResource: userData!.avaRef, createdAt: NSDate.now.description, checked: false, notificationID: notificationDoc.documentID)
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
            else {
                db.collection("Followings").whereField("follower", isEqualTo: userData!.publicID).whereField("following", isEqualTo: username).getDocuments(completion: { objects, error in
                    if error == nil {
                        guard let docs = objects?.documents else {
                            return
                        }
                        for doc in docs {
                            doc.reference.delete()
                        }
                    }
                    })

                button?.tag = 0
            }
        }
    }
    
    
}

extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
