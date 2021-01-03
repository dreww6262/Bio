//
//  MusicItem.swift
//  Bio
//
//  Created by Andrew Williamson on 1/2/21.
//  Copyright © 2021 Patrick McDonough. All rights reserved.
//

import Foundation

class MusicItem {
    
    var track: String
    var artist: String
    var album: String
    var uri: String
    var imageUrl: String
    
    var dictionary: [String: Any] {
        return ["track": track, "artist": artist, "album": album, "uri": uri, "imageUrl": imageUrl]
    }
    
    init (track: String, artist: String, album: String, uri: String, imageUrl: String) {
        self.track = track
        self.artist = artist
        self.album = album
        self.uri = uri
        self.imageUrl = imageUrl
    }
    
    convenience init (dictionary: [String: Any]) {
        let track = dictionary["track"] as! String? ?? ""
        let artist = dictionary["artist"] as! String? ?? ""
        let album = dictionary["album"] as! String? ?? ""
        let uri = dictionary["uri"] as! String? ?? ""
        let imageUrl = dictionary["imageUrl"] as? String ?? ""
        
        self.init(track: track, artist: artist, album: album, uri: uri, imageUrl: imageUrl)
    }
    
}
