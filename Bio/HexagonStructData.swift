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
    var text: String
    var type: Type
    var time: TimeInterval
    var postingUserID: String
    var views: Int
    var thumbnail: UIImage
    var profilePicture: UIImage
    var location: Int
    var coordinateX: CGFloat
    var coordinateY: CGFloat
    var musicString: String
    var videoString: String
    var isAnimated: Bool
    var isDraggable: Bool
}


struct Type {     //} Codable {
    var typeString: String
    var typeThumbnail: UIImage
    var isAnimated: Bool
    var contentString: String
    //examples of types: Profile Image, Snapchat, Facebook, Twitter, Instagram, TikTok,
    // Apple Music, Link to Bio Profile, Video Type, Image Type, Music Type
}


