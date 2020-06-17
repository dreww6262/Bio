//
//  followersCell.swift
//  Dart1
//
//  Created by Ann McDonough on 5/13/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import Parse


class followersCell: UITableViewCell {

    // UI objects
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    
    
    // default func
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // alignment
        let width = UIScreen.main.bounds.width
        
        avaImg.frame = CGRect(x: 10, y: 10, width: width / 5.3, height: width / 5.3)
        usernameLbl.frame = CGRect(x: avaImg.frame.size.width + 20, y: 28, width: width / 3.2, height: 30)
        followBtn.frame = CGRect(x: width - width / 3.5 - 10, y: 30, width: width / 3.5, height: 30)
        followBtn.layer.cornerRadius = followBtn.frame.size.width / 20
        
        // round ava
        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        avaImg.clipsToBounds = true
    }
    
    
    // clicked follow / unfollow
    @IBAction func followBtn_click(_ sender: AnyObject) {
        
        let title = followBtn.title(for: UIControl.State())
        
        // to follow
        if title == "FOLLOW" {
            let object = PFObject(className: "follow")
            object["follower"] = PFUser.current()?.username
            object["following"] = usernameLbl.text
            object.saveInBackground(block: { (success, error) -> Void in
                if success {
                    self.followBtn.setTitle("FOLLOWING", for: UIControl.State())
                    self.followBtn.backgroundColor = .green
                } else {
                    print(error?.localizedDescription as Any)
                }
            })
            
        // unfollow
        } else {
            let query = PFQuery(className: "follow")
            query.whereKey("follower", equalTo: PFUser.current()!.username!)
            query.whereKey("following", equalTo: usernameLbl.text!)
            query.findObjectsInBackground(block: { (objects, error) -> Void in
                if error == nil {
                    
                    for object in objects! {
                        object.deleteInBackground(block: { (success, error) -> Void in
                            if success {
                                self.followBtn.setTitle("FOLLOW", for: UIControl.State())
                                self.followBtn.backgroundColor = .lightGray
                            } else {
                                print(error?.localizedDescription as Any)
                            }
                        })
                    }
                    
                } else {
                    print(error?.localizedDescription as Any)
                }
            })
            
        }
        
    }
    
    

}
