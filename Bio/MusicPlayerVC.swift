//
//  MusicPlayerVC.swift
//  Bio
//
//  Created by Ann McDonough on 6/16/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

////mport AVMediaTypeVideo
//import UIKit
////import ALAssetsLibrary
////import PHPhotoLibrary
//
//class MusicPlayerVC: UIViewController {
//
// /   let AVCaptureDevice = AVCaptureDevice()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) { response in
//            if response {
//                //access granted
//            } else {
//
//            }
//        }
//
//        //Photos
//        let photos = PHPhotoLibrary.authorizationStatus()
//        if photos == .notDetermined {
//            PHPhotoLibrary.requestAuthorization({status in
//                if status == .authorized{
//                    
//                } else {}
//            })
//        }
//        
////
////        <key>NSCameraUsageDescription</key>
////        <string>You can take photos</string>
////        <key>NSPhotoLibraryUsageDescription</key>
////        <string>You can select photos to attach it on this app.</string>
////
//        
//
//        
//        
//    }
//    
//
//    func downloadVideoToCameraRoll() {
//
//    // Local variable pointing to the local file path for the downloaded video
//    var localFileUrl: String?
//
//    // A closure for generating the local file path for the downloaded video. This will be pointing to the Documents directory with a unique UDID file name.
//    let destination: (NSURL, NSHTTPURLResponse) -> (NSURL) = {
//        (temporaryURL, response) in
//
//        if let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as? NSURL {
//            let finalPath = directoryURL.URLByAppendingPathComponent("\(NSUUID()).\(response.suggestedFilename!)")
//            localFileUrl = finalPath.absoluteString
//            return finalPath
//        }
//
//        return temporaryURL
//    }
//
//    // The media post which should be downloaded
//    let postURL = NSURL(string: "https://api.instagram.com/v1/media/" + "952201134785549382_250131908" + "?access_token=" + InstagramEngine.sharedEngine().accessToken)!
//
//    // Then some magic happens that turns the postURL into the videoURL, which is the actual url of the video media:
//    let videoURL = NSURL(string: "https://scontent.cdninstagram.com/hphotos-xfp1/t50.2886-16/11104555_1603400416544760_416259564_s.mp4")!
//
//    // Download starts
//    let request = Alamofire.download(.GET, videoURL, destination)
//
//    // Completion handler for the download
//    request.response { (request, response, data, error) -> Void in
//        if let path = localFileUrl {
//            let isVideoCompatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path)
//            println("bool: \(isVideoCompatible)") // This logs out "bool: false"
//
//            let library = ALAssetsLibrary()
//
//            library.writeVideoAtPathToSavedPhotosAlbum(NSURL(string: path), completionBlock: { (url, error) -> Void in
//                // Done! Go check your camera roll
//            })
//        }
//    }
//    }
//    
//    
//    
//    
//}
