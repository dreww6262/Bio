//
//  ReportedPostObject.swift
//  Bio
//
//  Created by Ann McDonough on 10/15/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//


import Foundation
import UIKit
import Firebase


struct ReportedPostObject {  // : Codable { //Codable {
    var reason: String
    var post: String
    var userReporting: String
    var userWhoWasReported: String
   
    

var dictionary: [String: Any] {
    return ["reason": reason, "post": post, "userReporting": userReporting, "userWhoWasReported": userWhoWasReported]
   }
   
    init(reason: String, post: String, userReporting: String, userWhoWasReported: String)  {
       self.reason = reason
       self.post = post
       self.userReporting = userReporting
       self.userWhoWasReported = userWhoWasReported
   }

   
    init(dictionary: [String: Any]) {
       let reason = dictionary["reason"] as! String? ?? ""
        let post = dictionary["post"] as! String? ?? ""
       let userReporting = dictionary["userReporting"] as! String? ?? ""
    let userWhoWasReported = dictionary["userWhoWasReported"] as! String? ?? ""
       
    
        self.init(reason: reason,post: post, userReporting: userReporting, userWhoWasReported: userWhoWasReported)
       
   
   }


}
