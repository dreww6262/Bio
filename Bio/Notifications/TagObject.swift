//
//  TagObject.swift
//  Bio
//
//  Created by Ann McDonough on 10/13/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//


import Foundation
import UIKit
import Firebase
//import Parse

struct TagObject {  // : Codable { //Codable {
    var postingUserID: String
    var type: String
    var taggedUser: String
    var thumbResource: String
    var createdAt: String
    var notificationID: String
    var percentWidthX: Double
    var percentHeightY: Double
    


var dictionary: [String: Any] {
    return ["postingUserID": postingUserID, "type": type, "taggedUser": taggedUser, "thumbResource": thumbResource, "createdAt": createdAt, "notificationID": notificationID, "percentWidthX": percentWidthX, "percentHeightY": percentHeightY]
   }
   
   
    init(postingUserID: String, type: String, taggedUser: String, thumbResource: String, createdAt: String, notificationID: String, percentWidthX: Double, percentHeightY: Double)  {
       self.postingUserID = postingUserID
       self.type = type
       self.taggedUser = taggedUser
       self.thumbResource = thumbResource
       self.createdAt = createdAt
        self.notificationID = notificationID
        self.percentWidthX = percentWidthX
        self.percentHeightY = percentHeightY
   }

   
    init(dictionary: [String: Any]) {
       let postingUserID = dictionary["postingUserID"] as! String? ?? ""
       let type = dictionary["type"] as! String? ?? ""
       let taggedUser = dictionary["taggedUser"] as! String? ?? ""
    let thumbResource = dictionary["thumbResource"] as! String? ?? ""
       let createdAt = dictionary["createdAt"] as! String? ?? ""
        let notificationID = dictionary["notificationID"] as! String? ?? ""
        let percentWidthX = dictionary["percentWidthX"] as! Double? ?? 0
         let percentHeightY = dictionary["percentHeightY"] as! Double? ?? 0
       
    
        self.init(postingUserID: postingUserID,type: type, taggedUser: taggedUser, thumbResource: thumbResource, createdAt: createdAt, notificationID: notificationID, percentWidthX: percentWidthX, percentHeightY: percentHeightY)
       
   
   }


}

