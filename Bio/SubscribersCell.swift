////
////  SubscribersCell.swift
////  Bio
////
////  Created by Ann McDonough on 7/8/20.
////  Copyright © 2020 Patrick McDonough. All rights reserved.
////
//
//import UIKit
////import Parse
//
//
//class SubscribersCell: UITableViewCell {
//
//    // UI objects
//    @IBOutlet weak var avaImg: UIImageView!
//    
//    @IBOutlet weak var fullnameLbl: UILabel!
//    @IBOutlet weak var usernameLbl: UILabel!
//    
//    @IBOutlet weak var followBtn: UIButton!
//    
//    
//    // default func
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        
//        // alignment
//        let width = UIScreen.main.bounds.width
//        
//        avaImg.frame = CGRect(x: 10, y: 10, width: width / 5.3, height: width / 5.3)
//        fullnameLbl.frame = CGRect(x: avaImg.frame.size.width + 20, y: 28, width: width / 3.2, height: 30)
//        usernameLbl.frame = CGRect(x: avaImg.frame.size.width + 20, y: fullnameLbl.frame.height + 35, width: width / 3.2, height: 30)
//        followBtn.frame = CGRect(x: width - width / 3.5 - 10, y: 30, width: width / 3.5, height: 30)
//        followBtn.layer.cornerRadius = followBtn.frame.size.width / 20
//        
//        // round ava
//        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
//        avaImg.clipsToBounds = true
//    }
//    
//    
//    // clicked follow / unfollow
//    @IBAction func followBtn_click(_ sender: AnyObject) {
//        
//        let title = followBtn.title(for: UIControl.State())
//        
//        // to follow
////         now to subscribe
//        if title == "SUBSCRIBE" {
//            print("At first you werent subscribed, but now you should be")
//            let object = PFObject(className: "Follow")
//            object["follower"] = PFUser.current()?.username
//            object["following"] = usernameLbl.text
//            object.saveInBackground(block: { (success, error) -> Void in
//                if success {
//                    self.followBtn.setTitle("SUBSCRIBED", for: UIControl.State())
//                    self.followBtn.backgroundColor = .green
//                } else {
//                    print(error?.localizedDescription as Any)
//                }
//            })
//            
//            
//            
//        // unfollow
//        } else {
//            print("Title = \(title)")
//            let query = PFQuery(className: "Follow")
//             print("At first you were subscribed, but now you should NOT be")
//            query.whereKey("follower", equalTo: PFUser.current()!.username!)
//            query.whereKey("following", equalTo: usernameLbl.text!)
//            query.findObjectsInBackground(block: { (objects, error) -> Void in
//                if error == nil {
//                    
//                    for object in objects! {
//                        object.deleteInBackground(block: { (success, error) -> Void in
//                            if success {
//                                self.followBtn.setTitle("SUBSCRIBE", for: UIControl.State())
//                                print("The follow button should be changed to SUBSCRIBE")
//                                self.followBtn.backgroundColor = .red
//                            } else {
//                                print(error?.localizedDescription as Any)
//                            }
//                        })
//                    }
//                    
//                } else {
//                    print(error?.localizedDescription as Any)
//                }
//            })
//            
//        }
//        
//    }
//    
//    
//
//}
