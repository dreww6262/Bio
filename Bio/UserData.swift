//
//  UserData.swift
//  Bio
//
//  Created by Ann McDonough on 7/1/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import Foundation
import UIKit
//import Firebase
//import FirebaseUI

class UserData {
    
    var publicID: String
    var privateID: String
    var avaLink: String
    var instagramUsername: String
    var snapchatUsername: String
    var twitterHandle: String
    var facebookInfo: String
    var appleMusicInfo: String
    var venmoUsername: String
    var pinterestUsername: String
    var poshmarkUsername: String
    var hexagonGridID: String
    var userPage: String
    var subscribedUsers: [String]
    var subscriptions: [String]

    

    var dictionary: [String: Any] {
        return ["publicID": publicID, "privateID": privateID, "avaLink": avaLink, "instagramUsername": instagramUsername, "snapchatUsername": snapchatUsername, "twitterHandle": twitterHandle, "facebookInfo": facebookInfo, "appleMusicInfo": appleMusicInfo, "venmoUsername": venmoUsername, "pinterestUsername": pinterestUsername, "poshmarkUsername": poshmarkUsername, "hexagonGridID": hexagonGridID, "userPage": userPage, "subscribedUsers": subscribedUsers, "subscriptions":  subscriptions]
    }
    
    
    init(publicID: String, privateID: String, avaLink: String, instagramUsername: String, snapchatUsername: String, twitterHandle: String, facebookInfo: String, appleMusicInfo: String, venmoUsername: String, pinterestUsername: String, poshmarkUsername: String, hexagonGridID: String, userPage: String, subscribedUsers:  [String], subscriptions: [String]) {
        self.publicID = publicID
        self.privateID = privateID
        self.avaLink = avaLink
        self.instagramUsername = instagramUsername
        self.snapchatUsername = snapchatUsername
        self.twitterHandle = twitterHandle
        self.facebookInfo = facebookInfo
        self.appleMusicInfo = appleMusicInfo
        self.venmoUsername = venmoUsername
        self.pinterestUsername = pinterestUsername
        self.poshmarkUsername = poshmarkUsername
        self.hexagonGridID = hexagonGridID
        self.userPage = userPage
        self.subscribedUsers = subscribedUsers
        self.subscriptions = subscriptions
    }

    
    convenience init(dictionary: [String: Any]) {
        let publicID = dictionary["publicID"] as! String? ?? ""
        let privateID = dictionary["privateID"] as! String? ?? ""
        let avaLink = dictionary["avaLink"] as! String? ?? ""
        let instagramUsername = dictionary["instagramUsername"] as! String? ?? ""
        let snapchatUsername = dictionary["snapchatUsername"] as! String? ?? ""
        let twitterHandle = dictionary["twitterHandle"] as! String? ?? ""
        let facebookInfo = dictionary["facebookInfo"] as! String? ?? ""
         let appleMusicInfo = dictionary["appleMusicInfo"] as! String? ?? ""
        let venmoUsername = dictionary["venmoUsername"] as! String? ?? ""
        let pinterestUsername = dictionary["pinterestUsername"] as! String? ?? ""
        let poshmarkUsername = dictionary["poshmarkUsername"] as! String? ?? ""
        let hexagonGridID = dictionary["hexagonGridID"] as! String? ?? ""
     let userPage = dictionary["userPage"] as! String? ?? ""
         let subscribedUsers = dictionary["subscribedUsers"] as! [String]? ?? [""]
           let subscriptions = dictionary["subscriptions"] as! [String]? ?? [""]

         

        self.init(publicID: publicID,privateID: privateID, avaLink: avaLink, instagramUsername: instagramUsername, snapchatUsername: snapchatUsername, twitterHandle: twitterHandle, facebookInfo: facebookInfo, appleMusicInfo: appleMusicInfo, venmoUsername: venmoUsername, pinterestUsername: pinterestUsername, poshmarkUsername: poshmarkUsername, hexagonGridID: hexagonGridID, userPage: userPage, subscribedUsers: subscribedUsers, subscriptions: subscriptions)
        
    
    }
    
    
    
    
}

