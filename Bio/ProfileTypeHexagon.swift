//
//  ProfileTypeHexagon.swift
//  Bio
//
//  Created by Ann McDonough on 6/28/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import Foundation
import UIKit




struct Line: Codable {
    let sport_nice: String
    var teams: [String] = []
    let commence_time: TimeInterval// gonna have to convert to time
    var sites: [Site] = []
    
}

struct Site: Codable {
    //Comment out line below, and add var site_key: String
    //this will tell us if probelm is odds or Sites
    //     var odds: Odds
    var site_key: String
    var odds: Odds
}

struct Odds: Codable {
    //try to remove the queston mark below, then keep queston mark in, can put outside brackets
    var h2h: [Double] = []
}
