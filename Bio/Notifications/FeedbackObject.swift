//
//  FeedbackObject.swift
//  Bio
//
//  Created by Ann McDonough on 10/7/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//


import Foundation
import UIKit
import Firebase
//import Parse

struct FeedbackObject {  // : Codable { //Codable {
    var text: String
   
    



//struct Type {     //} Codable {
//    var typeString: String
//    var typeThumbnail: UIImage
//    var isAnimated: Bool
//    var contentString: String
//    //examples of types: Profile Image, Snapchat, Facebook, Twitter, Instagram, TikTok,
//    // Apple Music, Link to Bio Profile, Video Type, Image Type, Music Type
//}


var dictionary: [String: Any] {
    return ["text": text]
   }
   
   
    init(text: String)  {
       self.text = text
   }

   
    init(dictionary: [String: Any]) {
       let text = dictionary["text"] as! String? ?? ""
    
        self.init(text: text)
   
   }


}
