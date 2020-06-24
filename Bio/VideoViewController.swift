//
//  VideoViewController.swift
//  Bio
//
//  Created by Ann McDonough on 6/24/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit

class VideoViewController: UIViewController {

    var video: Video = Video()
  
    @IBOutlet weak var videoWebView: UIWebView!
    @IBOutlet weak var videoTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        video.Key = "Ou3bl5VQ3OA"
          video.Title = "Build a Count Down Timer with Swift 4.2"
        
        videoTitle.text = video.Title
        getVideo(videoKey: video.Key)
        
        // Do any additional setup after loading the view.
    }
    
    func getVideo(videoKey:String) {
        
        let url = URL(string: "https://www.youtube.com/embed/\(videoKey)")
        videoWebView.loadRequest(URLRequest(url: url!))
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class Video{
    var Key:String = ""
    var Title:String = ""
}
