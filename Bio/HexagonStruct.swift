//
//  HexagonStruct.swift
//  Bio
//
//  Created by Ann McDonough on 6/28/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import Foundation
import UIKit

struct TextPostData: Codable { //Codable {
    var text: String
    //var specificBet: String
    var time: TimeInterval
    var postingUserID: String
    var upVotes: Int
    var downVotes: Int
    var comments: [String] = []
    
    
    
  //  var userPhoto: UIImage
   // var record: String
  //  var balance: Decimal
  //  var winner: Bool
}
