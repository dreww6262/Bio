//
//  HexagonStructData.swift
//  Bio
//
//  Created by Ann McDonough on 6/28/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import Foundation
import UIKit
//import Parse

struct HexagonStructData {  // : Codable { //Codable {
    var resource: String
    var type: String
    var location: Int
    var thumbResource: String
    var createdAt: TimeInterval
    var postingUserID: String
    var text: String
    var views: Int
    var isArchived: Bool
    var docID: String
    
    
//    var text: String
//    var type: Type
//    var time: TimeInterval
//    var postingUserID: String
//    var views: Int
//    var thumbnail: UIImage
//    var location: Int
//    var musicString: String
//    var videoString: String
//    var isAnimated: Bool
//    var isDraggable: Bool



//struct Type {     //} Codable {
//    var typeString: String
//    var typeThumbnail: UIImage
//    var isAnimated: Bool
//    var contentString: String
//    //examples of types: Profile Image, Snapchat, Facebook, Twitter, Instagram, TikTok,
//    // Apple Music, Link to Bio Profile, Video Type, Image Type, Music Type
//}


var dictionary: [String: Any] {
    return ["resource": resource, "type": type, "location": location, "thumbResource": thumbResource, "createdAt": createdAt, "postingUserID": postingUserID, "text": text, "views": views, "isArchived": isArchived, "docID": docID]
   }
   
   
    init(resource: String, type: String, location: Int, thumbResource: String, createdAt: TimeInterval, postingUserID: String, text: String, views: Int, isArchived: Bool, docID: String)  {
       self.resource = resource
       self.type = type
       self.location = location
       self.thumbResource = thumbResource
       self.createdAt = createdAt
       self.postingUserID = postingUserID
       self.text = text
       self.views = views
        self.isArchived = isArchived
        self.docID = docID
   }

   
    init(dictionary: [String: Any]) {
       let resource = dictionary["resource"] as! String? ?? ""
       let type = dictionary["type"] as! String? ?? ""
       let location = dictionary["location"] as! Int? ?? -1
       let thumbResource = dictionary["thumbResource"] as! String? ?? ""
    let createdAt = dictionary["createdAt"] as! TimeInterval? ?? 0.0
       let postingUserID = dictionary["postingUserID"] as! String? ?? ""
       let text = dictionary["text"] as! String? ?? ""
        let views = dictionary["views"] as! Int? ?? 0
        let isArchived = dictionary["isArchived"] as! Bool? ?? true
        let docID = dictionary["docID"] as! String? ?? ""
       
    
        self.init(resource: resource,type: type, location: location, thumbResource: thumbResource, createdAt: createdAt, postingUserID: postingUserID, text: text, views: views, isArchived: isArchived, docID: docID)
       
   
   }


}
