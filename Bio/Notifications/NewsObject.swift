//
//  NewsObject.swift
//  Bio
//
//  Created by Ann McDonough on 9/7/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//


import Foundation
import UIKit
import Firebase
//import Parse

struct NewsObject {  // : Codable { //Codable {
    var ava: String
    var type: String
    var currentUser: String
    var notifyingUser: String
    var thumbResource: String
    var createdAt: String
    var checked: Bool
    var notificationID: String
    



//struct Type {     //} Codable {
//    var typeString: String
//    var typeThumbnail: UIImage
//    var isAnimated: Bool
//    var contentString: String
//    //examples of types: Profile Image, Snapchat, Facebook, Twitter, Instagram, TikTok,
//    // Apple Music, Link to Bio Profile, Video Type, Image Type, Music Type
//}


var dictionary: [String: Any] {
    return ["ava": ava, "type": type, "currentUser": currentUser, "notifyingUser": notifyingUser, "thumbResource": thumbResource, "createdAt": createdAt, "checked": checked, "notificationID": notificationID]
   }
   
   
    init(ava: String, type: String, currentUser: String, notifyingUser: String, thumbResource: String, createdAt: String, checked: Bool, notificationID: String)  {
       self.ava = ava
       self.type = type
       self.currentUser = currentUser
       self.notifyingUser = notifyingUser
       self.thumbResource = thumbResource
       self.createdAt = createdAt
       self.checked = checked
        self.notificationID = notificationID
   }

   
    init(dictionary: [String: Any]) {
       let ava = dictionary["ava"] as! String? ?? ""
       let type = dictionary["type"] as! String? ?? ""
       let currentUser = dictionary["currentUser"] as! String? ?? ""
       let notifyingUser = dictionary["notifyingUser"] as! String? ?? ""
    let thumbResource = dictionary["thumbResource"] as! String? ?? ""
       let createdAt = dictionary["createdAt"] as! String? ?? ""
       let checked = dictionary["checked"] as! Bool? ?? false
        let notificationID = dictionary["notificationID"] as! String? ?? ""
       
    
        self.init(ava: ava,type: type, currentUser: currentUser, notifyingUser: notifyingUser, thumbResource: thumbResource, createdAt: createdAt, checked: checked, notificationID: notificationID)
       
   
   }


}
