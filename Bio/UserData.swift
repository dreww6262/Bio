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
    var email: String
    var publicID: String
    var privateID: String
    var avaRef: String
    var hexagonGridID: String
    var userPage: String
    var subscribedUsers: [String]
    var subscriptions: [String]
    var numPosts: Int
    
    
    
    var dictionary: [String: Any] {
        return ["email": email, "publicID": publicID, "privateID": privateID, "avaRef": avaRef, "hexagonGridID": hexagonGridID, "userPage": userPage, "subscribedUsers": subscribedUsers, "subscriptions":  subscriptions, "numPosts": numPosts]
    }
    
    
    init(email: String, publicID: String, privateID: String, avaRef: String, hexagonGridID: String, userPage: String, subscribedUsers:  [String], subscriptions: [String], numPosts: Int) {
        self.email = email
        self.publicID = publicID
        self.privateID = privateID
        self.avaRef = avaRef
        self.hexagonGridID = hexagonGridID
        self.userPage = userPage
        self.subscribedUsers = subscribedUsers
        self.subscriptions = subscriptions
        self.numPosts = numPosts
    }
    
    
    convenience init(dictionary: [String: Any]) {
        let email = dictionary["email"] as! String? ?? ""
        let publicID = dictionary["publicID"] as! String? ?? ""
        let privateID = dictionary["privateID"] as! String? ?? ""
        let avaRef = dictionary["avaRef"] as! String? ?? ""
        let hexagonGridID = dictionary["hexagonGridID"] as! String? ?? ""
        let userPage = dictionary["userPage"] as! String? ?? ""
        let subscribedUsers = dictionary["subscribedUsers"] as! [String]? ?? [""]
        let subscriptions = dictionary["subscriptions"] as! [String]? ?? [""]
        let numPosts = Int(dictionary["numPosts"] as! Int? ?? 0)
        
        
        
        self.init(email: email, publicID: publicID,privateID: privateID, avaRef: avaRef, hexagonGridID: hexagonGridID, userPage: userPage, subscribedUsers: subscribedUsers, subscriptions: subscriptions, numPosts: numPosts)
    }
}

