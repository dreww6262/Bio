//
//  HexagonClass.swift
//  Bio
//
//  Created by Ann McDonough on 6/28/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import Foundation
import UIKit
//import Firebase
//import FirebaseUI

class HexagonClass {

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
    var documentID: String
    

    var dictionary: [String: Any] {
        return ["text": text, "type": type, "time": time, "postingUserID": postingUserID, "views": views, "thumnnail": thumbnail, "profilePicture": profilePicture, "location": location, "coordinateX": coordinateX, "coordinateY": coordinateY, "musicString": musicString, "videoString":  videoString, "isAnimated": isAnimated, "documentID": documentID]
    }
    
    
    init(text: String, type: Type, time: TimeInterval, postingUserID: String, views: Int, thumbnail: UIImage, profilePicture: UIImage, location: Int, coordinateX: CGFloat, coordinateY: CGFloat, musicString: String, videoString:  String, isAnimated: Bool, documentID: String) {
        self.text = text
        self.type = type
           self.time = time
           self.postingUserID = postingUserID
        self.views = views
        self.thumbnail = thumbnail
        self.profilePicture = profilePicture
        self.location = location
        self.coordinateX = coordinateX
        self.coordinateY = coordinateY
        self.musicString = musicString
        self.videoString = videoString
        self.isAnimated = isAnimated
        self.documentID = documentID
    }

    
    convenience init(dictionary: [String: Any]) {
        let text = dictionary["text"] as! String? ?? ""
        let type = dictionary["type"] as! Type? ?? Type(typeString: "", typeThumbnail: UIImage(), isAnimated: false, contentString: "")
        let time = dictionary["time"] as! TimeInterval? ?? TimeInterval()
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        let views = dictionary["views"] as! Int? ?? 0
        let thumbnail = dictionary["thumbnail"] as! UIImage? ?? UIImage()
         let profilePicture = dictionary["profilePicture"] as! UIImage? ?? UIImage()
        let location = dictionary["location"] as! Int? ?? Int()
        let coordinateX = dictionary["coordinateX"] as! CGFloat? ?? CGFloat()
     let coordinateY = dictionary["coordinateY"] as! CGFloat? ?? CGFloat()
         let musicString = dictionary["musicString"] as! String? ?? ""
           let videoString = dictionary["videoString"] as! String? ?? ""
        let isAnimated = dictionary["isAnimated"] as! Bool? ?? false
        let documentID = dictionary["documentID"] as! String? ?? ""
         

        self.init(text: text,type: type, time: time, postingUserID: postingUserID, views: views, thumbnail: thumbnail, profilePicture: profilePicture, location: location, coordinateX: coordinateX, coordinateY: coordinateY, musicString: musicString, videoString: videoString, isAnimated: isAnimated, documentID: documentID)
        
        
    
    }
    
    
//    func saveData(completed: @escaping (Bool) -> ()) {
//        let db = Firestore.firestore()
//        //grab the userID
//        guard let postingUserID1 = (Auth.auth().currentUser?.uid) else {
//            print("Error: could not save data because we don't have a valid postingUserID")
//            return completed(false)
//        }
//        self.postingUserID = postingUserID1
//        //create the dictionary represnting the data we want to save
//        let dataToSave = self.dictionary
//        print("This is self.docuementID \(self.documentID)")
//        //if we HAVE saved a record, we''ll have a document ID
//        if self.documentID != "" {
//            let ref = db.collection("textPosts").document(self.documentID)
//            ref.setData(dataToSave) { (error) in
//                if let error = error {
//                    print("Error: creating new document \(self.documentID) \(error.localizedDescription)")
//                    completed(false)
//                } else {
//                    print("new document created with ref ID \(ref.documentID ?? "unknown")")
//                    completed(true)
//                }
//            }
//        } else {
//            var ref: DocumentReference? = nil // let firestore create the new document ID
//            ref = db.collection("textPosts").addDocument(data: dataToSave) { error in
//                if let error = error {
//                    print("Error creating new document.")
//                    completed(false)
//                } else {
//                    print("new document created with ref ID \(ref?.documentID ?? "unkown")")
//                    completed(true)
//                }
//
//
//            }
//        }
//
//
//        completed(true)
//
//
//
//    }
    
    
}
