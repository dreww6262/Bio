//
//  UserData.swift
//  Bio
//
//  Created by Ann McDonough on 7/1/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import Foundation
import UIKit

class UserData: Equatable {
    static func == (lhs: UserData, rhs: UserData) -> Bool {
        return lhs.dictionary.description == rhs.dictionary.description
    }
    
    var email: String
    var publicID: String
    var privateID: String
    var avaRef: String
    var hexagonGridID: String
    var userPage: String
    var subscribedUsers: [String]
    var subscriptions: [String: String]
    var numPosts: Int
    var displayName: String
    var birthday: String
    var blockedUsers: [String]
    var isBlockedBy: [String]
    var pageViews: Int
    var bio: String
    var country: String
    var currentCity: String
    var gender: String
    var phoneNumber: String
    var lastTimePosted: String
    var identityValues: [String]
    var displayNameQueryable: String
    
    
    var dictionary: [String: Any] {
        return ["email": email, "publicID": publicID, "privateID": privateID, "avaRef": avaRef, "hexagonGridID": hexagonGridID, "userPage": userPage, "subscribedUsers": subscribedUsers, "subscriptions":  subscriptions, "numPosts": numPosts, "displayName": displayName, "birthday": birthday, "blockedUsers": blockedUsers, "isBlockedBy": isBlockedBy, "pageViews": pageViews, "bio": bio, "country": country, "lastTimePosted": lastTimePosted, "currentCity": currentCity, "gender": gender, "phoneNumber": phoneNumber, "identityValues": identityValues, "displayNameQueryable": displayNameQueryable]
    }
    
    
    init(email: String, publicID: String, privateID: String, avaRef: String, hexagonGridID: String, userPage: String, subscribedUsers:  [String], subscriptions: [String: String], numPosts: Int, displayName: String, birthday: String, blockedUsers: [String], isBlockedBy: [String], pageViews: Int, bio: String, country: String, lastTimePosted: String, currentCity: String, gender: String, phoneNumber: String, identityHexIDs: [String], displayNameQueryable: String) {
        
        self.email = email
        self.publicID = publicID
        self.privateID = privateID
        self.avaRef = avaRef
        self.hexagonGridID = hexagonGridID
        self.userPage = userPage
        self.subscribedUsers = subscribedUsers
        self.subscriptions = subscriptions
        self.numPosts = numPosts
        self.displayName = displayName
        self.birthday = birthday
        self.blockedUsers = blockedUsers
        self.isBlockedBy = isBlockedBy
        self.pageViews = pageViews
        self.bio = bio
        self.country = country
        self.lastTimePosted = lastTimePosted
        self.currentCity = currentCity
        self.gender = gender
        self.phoneNumber = phoneNumber
        self.identityValues = identityHexIDs
        self.displayNameQueryable = displayNameQueryable
    }
    
    
    convenience init(dictionary: [String: Any]) {
        let email = dictionary["email"] as! String? ?? ""
        let publicID = dictionary["publicID"] as! String? ?? ""
        let privateID = dictionary["privateID"] as! String? ?? ""
        let avaRef = dictionary["avaRef"] as! String? ?? ""
        let hexagonGridID = dictionary["hexagonGridID"] as! String? ?? ""
        let userPage = dictionary["userPage"] as! String? ?? ""
        let subscribedUsers = dictionary["subscribedUsers"] as! [String]? ?? [""]
        var subscriptions = [String: String]()
        if (dictionary["subscriptions"] is [String: String]) {
            subscriptions = dictionary["subscriptions"] as! [String: String]? ?? ["": ""]
        }
        let numPosts = Int(dictionary["numPosts"] as! Int? ?? 0)
        let displayName = dictionary["displayName"] as! String? ?? ""
        let birthday = dictionary["birthday"] as! String? ?? ""
        var blockedUsers = [String]()
        if dictionary["blockedUsers"] != nil {
            blockedUsers = dictionary["blockedUsers"] as! [String]? ?? [""]
        }
        var isBlockedBy = [String]()
        if dictionary["isBlockedBy"] != nil {
            isBlockedBy = dictionary["isBlockedBy"] as! [String]? ?? [""]
        }
        var pageViews: Int = 0
        if dictionary["pageViews"] != nil {
            pageViews = dictionary["pageViews"] as! Int? ?? 0
        }
        let bio = dictionary["bio"] as! String? ?? ""
        let country = dictionary["country"] as! String? ?? ""
        var lastTimePosted = NSDate.now.description
        if dictionary["lastTimePosted"] != nil {
            lastTimePosted = dictionary["lastTimePosted"] as! String? ?? NSDate.now.description
        
        }
        let currentCity = dictionary["currentCity"] as! String? ?? ""
        let gender = dictionary["gender"] as! String? ?? ""
        let phoneNumber = dictionary["phoneNumber"] as! String? ?? ""
        let identityHexIDs = dictionary["identityValues"] as! [String]? ?? [String]()
        
        let displayNameQueryable = (dictionary["displayNameQueryable"] as? String) ?? displayName.lowercased()
        
        
        
        
        self.init(email: email, publicID: publicID,privateID: privateID, avaRef: avaRef, hexagonGridID: hexagonGridID, userPage: userPage, subscribedUsers: subscribedUsers, subscriptions: subscriptions, numPosts: numPosts, displayName: displayName, birthday: birthday, blockedUsers: blockedUsers, isBlockedBy: isBlockedBy, pageViews: pageViews, bio: bio, country: country, lastTimePosted: lastTimePosted, currentCity: currentCity, gender: gender, phoneNumber: phoneNumber, identityHexIDs: identityHexIDs, displayNameQueryable: displayNameQueryable)
    }
}

