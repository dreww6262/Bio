//
//  ContentVideoVC.swift
//  Bio
//
//  Created by Andrew Williamson on 9/28/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import FirebaseStorage
import AVKit

class ContentVideoVC: UIViewController {
    
    var videoHex: HexagonStructData?
    var player = AVPlayer()
    let contentViewer = UIView()
    var showOpenAppButton = false
    
    let storage = FirebaseStorage.Storage.storage().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        let urlString = videoHex!.resource
        let vidRef = storage.child(urlString)
        
        
//        let placeholderImage = UIImageView()
//        self.contentViewer.addSubview(placeholderImage)
//
//        let cleanRef = videoHex!.thumbResource.replacingOccurrences(of: "/", with: "%2F")
//        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/bio-social-media.appspot.com/o/\(cleanRef)?alt=media")
//        placeholderImage.sd_setImage(with: url!, completed: {_, error, _, _ in
//            if error != nil {
//                print(error!.localizedDescription)
//            }
//        })
//
//        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
//
//        placeholderImage.frame = frame
//        placeholderImage.backgroundColor = .black
//
//        placeholderImage.contentMode = .scaleAspectFit
//        placeholderImage.isUserInteractionEnabled = true
        
        
        vidRef.downloadURL(completion: { url, error in
            if error == nil {
                let asset = AVAsset(url: url!)
                let item = AVPlayerItem(asset: asset)
                self.view.addSubview(self.contentViewer)
                let contentRect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 65)
                self.contentViewer.frame = contentRect
                self.contentViewer.backgroundColor = .black
                self.player = AVPlayer(playerItem: item)
                let playerLayer = AVPlayerLayer(player: self.player)
                playerLayer.frame = self.contentViewer.bounds //bounds of the view in which AVPlayer should be displayed
                playerLayer.videoGravity = .resizeAspect
                self.contentViewer.layer.addSublayer(playerLayer)
//                placeholderImage.removeFromSuperview()
                
            }
        })
        
//        let videoTap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
//        contentViewer.addGestureRecognizer(videoTap)
//        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.playVideo()
    }
    
    public func playVideo() {
        player.play()
    }
    
    public func pauseVideo() {
        player.pause()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        pauseVideo()
    }
    
//    @objc func handleTap(_ sender: UITapGestureRecognizer) {
//        player.pause()
//        for view in contentViewer.subviews {
//            view.removeFromSuperview()
//        }
//        contentViewer.removeFromSuperview()
//        self.dismiss(animated: false, completion: nil)
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
