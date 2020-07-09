//
//  HexagonGrid3.swift
//  Bio
//
//  Created by Ann McDonough on 6/24/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import AVKit
//import WebKit
//import SPT

class HexagonGrid3: UIViewController {
    var player = AVAudioPlayer()
   // var webView = WKWebView()

    @IBOutlet weak var scrollView: UIScrollView!
    var coordinateArray: [[CGFloat]] = []
    var coordinate: [CGFloat] = []
    var imageViewArray: [UIImageView] = []
    
    @IBOutlet weak var expandedView: UIImageView!
    var index = 0
    var index1 = 0
     // var tapGesture = UITapGestureRecognizer()
    //var fakeUserImageArray: [UIImage] = []
      var fakeUserImageArray = [UIImage(named: "beachex"),UIImage(named: "forest"),UIImage(named: "skiingex"),UIImage(named: "bcex"),UIImage(named: "concertex"),UIImage(named: "instagram1ex"),UIImage(named: "instagram2ex"),UIImage(named: "instagram3ex"),UIImage(named: "volcanoex"),UIImage(named: "pastureex"),UIImage(named: "instagram1ex"),UIImage(named: "instagram2ex"),UIImage(named: "instagram3ex"),UIImage(named: "beachex"),UIImage(named: "forest"),UIImage(named: "skiingex"),UIImage(named: "bcex"),UIImage(named: "concertex"),UIImage(named: "instagram1ex"),UIImage(named: "instagram2ex"),UIImage(named: "instagram3ex"),UIImage(named: "volcanoex"),UIImage(named: "pastureex"),UIImage(named: "instagram1ex"),UIImage(named: "instagram2ex"),UIImage(named: "instagram3ex"),UIImage(named: "skiingex"),UIImage(named: "bcex"),UIImage(named: "concertex"),UIImage(named: "instagram1ex"),UIImage(named: "patinstagram")]
    var fakeUserTotalProfileArray: [UIImage] = []
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
             //   downloadFileFromURL(url: URL(string: "https://p.scdn.co/mp3-preview/18d3b87b0765cd6d8c0a418d6142b3b441c0f8b2?cid=476c620368f349cc8be5b2a29b596eaf")!)
        play(url: "https://p.scdn.co/mp3-preview/18d3b87b0765cd6d8c0a418d6142b3b441c0f8b2?cid=476c620368f349cc8be5b2a29b596eaf")
       
     // background
            let bg = UIImageView(frame: CGRect(x: -400, y: -400, width: 3000, height: 3000))
            bg.image = UIImage(named: "outerspace1")
            bg.layer.zPosition = -1
            self.view.addSubview(bg)
        
        
//        SPTAuth.defaultInstance().clientID        = "934ec9a2f19640bdaddd48aedcd4199e"
//      //  SPTAuth.defaultInstance().redirectURL     = NSURL(string: SpotifyRedirectURI)
//        //SPTAuth.defaultInstance().tokenSwapURL    = SpotifyTokenSwapURL
//    //    SPTAuth.defaultInstance().tokenRefreshURL = SpotifyTokenRefreshURL
//        SPTAuth.defaultInstance().requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope]
//
       // expandedView.isHidden = true
      
     // let tap = UITapGestureRecognizer(target: self, action: #selector(HexagonGrid3.imageTapped(sender:)))
        
      //  let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))

       // scrollView.addGestureRecognizer(tap)
        
        
//          // Do any additional setup after loading the view.
                let hexaDiameter : CGFloat = 150
                let hexaWidth = hexaDiameter * sqrt(3) * 0.5
                let hexaWidthDelta = (hexaDiameter - hexaWidth) * 0.5
                let hexaHeightDelta = hexaDiameter * 0.25
                let spacing : CGFloat = 5

        //        let rows = 10
        //        let firstRowColumns = 6

                let rows = 15
                let firstRowColumns = 15

//        self.scrollView.contentSize = CGSize(width: spacing + CGFloat(firstRowColumns) * (hexaWidth + spacing), height: spacing + CGFloat(rows) * (hexaDiameter - hexaHeightDelta + spacing) + hexaHeightDelta)
//
//
////        self.scrollView.center.x = 946.8266739736607
////         self.scrollView.center.y = 902.5
//        self.scrollView.backgroundColor = UIColor.black
//           // scrollView.contentSize = imageView.bounds.size
//        self.scrollView.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
//        self.scrollView.autoresizingMask = UIView.AutoresizingMask.flexibleHeight
//
        
        
        
        var reOrderedCoordinateArray: [[CGFloat]] = [[946.8266739736607, 902.5],[1081.7304845413264, 902.5], [1014.2785792574934, 1020.0],   [879.3747686898278,1020.0], [811.9228634059948,902.5], [879.3747686898278,785.0],[1014.2785792574934,785.0],[946.8266739736607, 667.5],[1081.7304845413264, 667.5], [1149.1823898251594, 785.0],  [1216.6342951089923, 902.5],[1149.1823898251594, 1020.0],   [1081.7304845413264, 1137.5], [1081.7304845413264, 1137.5],[946.8266739736607, 1137.5],[811.9228634059948, 1137.5],[744.4709581221618, 1020.0],[677.0190528383291, 902.5],[744.4709581221618, 785.0],  [811.9228634059948, 667.5],[879.3747686898278, 550.0],[1014.2785792574934, 550.0],[1149.1823898251594, 550.0],[1216.6342951089923, 667.5],[1284.0862003928253, 785.0],[1351.5381056766582, 902.5], [1284.0862003928253, 1020.0], [1216.6342951089923, 1137.5],[1149.1823898251594, 1255.0], [1014.2785792574934, 1255.0],[879.3747686898278, 1255.0],  [744.4709581221618, 1255.0],[677.0190528383291, 1137.5],[609.5671475544962, 1020.0],[542.1152422706632, 902.5],[609.5671475544962, 785.0],[677.0190528383291, 667.5],[744.4709581221618, 550.0]]
        
        index = 0
        for coordinates in reOrderedCoordinateArray {
            print(coordinates)
            let tapGesture = UIGestureRecognizer()
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            
            let image = UIImageView(frame: CGRect(x: coordinates[0]-680,
                                                                 y: coordinates[1]-570,
                                                                 width: hexaDiameter,
                                                                 height: hexaDiameter))
                           image.contentMode = .scaleAspectFill
                           image.image = UIImage(named: "stickfigure1")
            image.isUserInteractionEnabled = true
              image.addGestureRecognizer(tap)
            var gold = #colorLiteral(red: 0.9882352941, green: 0.7607843137, blue: 0, alpha: 1)
            image.setupHexagonMask(lineWidth: 10.0, color: gold, cornerRadius: 10.0)
            view.addSubview(image)
            imageViewArray.append(image)
            imageViewArray[index].tag = index
            index = index+1
            
        }
        print(imageViewArray)
        
        populateSocialMedia()
        populateFakeUserPhotos()
        
        
    }
    
    func viewWillAppear() {
        super.viewWillAppear(true) // No need for semicolon
           // Do any additional setup after loading the view.
                        let hexaDiameter : CGFloat = 150
                        let hexaWidth = hexaDiameter * sqrt(3) * 0.5
                        let hexaWidthDelta = (hexaDiameter - hexaWidth) * 0.5
                        let hexaHeightDelta = hexaDiameter * 0.25
                        let spacing : CGFloat = 5

                //        let rows = 10
                //        let firstRowColumns = 6

                        let rows = 15
                        let firstRowColumns = 15
                        
                self.scrollView.contentSize = CGSize(width: spacing + CGFloat(firstRowColumns) * (hexaWidth + spacing), height: spacing + CGFloat(rows) * (hexaDiameter - hexaHeightDelta + spacing) + hexaHeightDelta)
                
                
        //        self.scrollView.center.x = 946.8266739736607
        //         self.scrollView.center.y = 902.5
                self.scrollView.backgroundColor = UIColor.black
                   // scrollView.contentSize = imageView.bounds.size
                self.scrollView.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
                self.scrollView.autoresizingMask = UIView.AutoresizingMask.flexibleHeight
    }
    
    
    
    
    
    func populateSocialMedia() {
       imageViewArray[0].image = UIImage(named: "patsbitmoji")
     //   imageViewArray[0].loadGif(name: "hockeygif")
        fakeUserTotalProfileArray.append(imageViewArray[0].image!)
        imageViewArray[1].image = UIImage(named: "facebooklogo")
        fakeUserTotalProfileArray.append(imageViewArray[1].image!)
           imageViewArray[2].image = UIImage(named: "instagramLogo")
        fakeUserTotalProfileArray.append(imageViewArray[2].image!)
           imageViewArray[3].image = UIImage(named: "twitter")
        fakeUserTotalProfileArray.append(imageViewArray[3].image!)
           imageViewArray[4].image = UIImage(named: "spotifylogo")
        fakeUserTotalProfileArray.append(imageViewArray[4].image!)
           imageViewArray[5].image = UIImage(named: "snapchatlogo")
        fakeUserTotalProfileArray.append(imageViewArray[5].image!)
           imageViewArray[6].image = UIImage(named: "tiktoklogo")
        fakeUserTotalProfileArray.append(imageViewArray[6].image!)
        
    }
    
   func openInstagram(instagramHandle: String) {
       guard let url = URL(string: "https://instagram.com/\(instagramHandle)")  else { return }
       if UIApplication.shared.canOpenURL(url) {
           if #available(iOS 10.0, *) {
               UIApplication.shared.open(url, options: [:], completionHandler: nil)
           } else {
               UIApplication.shared.openURL(url)
           }
       }
   }
   
    func openTikTok(tikTokHandle: String) {
        guard let url = URL(string: tikTokHandle)  else { return }
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func openSpotifySong() {
      //  UIApplication.shared.open(URL(string: "spotify:artist:4gzpq5DPGxSnKTe4SA8HAU")!, options: [:], completionHandler: nil)
       // UIApplication.shared.openURL(URL(string: "spotify:track:1dNIEtp7AY3oDAKCGg2XkH")!)
    //   UIApplication.shared.open(URL(string: "spotify:track:1dNIEtp7AY3oDAKCGg2XkH")!, options: [:], completionHandler: nil)
    UIApplication.shared.open(URL(string: "https://p.scdn.co/mp3-preview/18d3b87b0765cd6d8c0a418d6142b3b441c0f8b2?cid=476c620368f349cc8be5b2a29b596eaf" )!, options: [:], completionHandler: nil)
        
     //   UIApplication.shared.
     //   UIApplication.shared.open(<#T##url: URL##URL#>, options: <#T##[UIApplication.OpenExternalURLOptionsKey : Any]#>, completionHandler: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)
       // UIApplication.
    //  "https://p.scdn.co/mp3-preview/18d3b87b0765cd6d8c0a418d6142b3b441c0f8b2?cid=476c620368f349cc8be5b2a29b596eaf"
        
      //  URL(string: "spotify:track:1dNIEtp7AY3oDAKCGg2XkH")
    }
    
    
    
    

    func openFacebook(facebookHandle: String) {
    let webURL: NSURL = NSURL(string: "https://www.facebook.com/ID")!
    let IdURL: NSURL = NSURL(string: "fb://profile/ID")!

    if(UIApplication.shared.canOpenURL(IdURL as URL)){
        // FB installed
        UIApplication.shared.open(webURL as URL, options: [:], completionHandler: nil)
    } else {
        // FB is not installed, open in safari
        UIApplication.shared.open(webURL as URL, options: [:], completionHandler: nil)
    }
    
    }
    
    func openTwitter(twitterHandle: String) {
        guard let url = URL(string: "https://twitter.com/\(twitterHandle)")  else { return }
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func openSnapchat(snapchatUsername: String) {
      let username = snapchatUsername
         let appURL = URL(string: "snapchat://add/\(username)")!
         let application = UIApplication.shared

         if application.canOpenURL(appURL) {
             application.open(appURL)

         } else {
             // if Snapchat app is not installed, open URL inside Safari
             let webURL = URL(string: "https://www.snapchat.com/add/\(username)")!
             application.open(webURL)

         }
    }
    
    
    func populateFakeUserPhotos() {
        index1 = 0
        for image in fakeUserImageArray {
            imageViewArray[index1+7].image = fakeUserImageArray[index1]
            fakeUserTotalProfileArray.append(imageViewArray[index1+7].image!)
        index1 = index1+1
//            fakeUserTotalProfileArray[0].loadGif(named: "hockeygif")
        }
    }
    
    
    
//     @objc func imageTapped(_ sender: UITapGestureRecognizer){
//        print("I tapped image with tag \(sender.view!.tag)")
//       // let newImage.tag = sender.view!.tag
//
//    }
    
    @objc func imageTapped(sender: UITapGestureRecognizer){
           print("🎯🎯🎯🎯🎯🎯🎯I tapped image with tag \(sender.view!.tag)")
          // let newImage.tag = sender.view!.tag
        let newImageView = UIImageView(image: fakeUserTotalProfileArray[sender.view!.tag])
              newImageView.frame = UIScreen.main.bounds
              newImageView.backgroundColor = .black
              newImageView.contentMode = .scaleAspectFit
              newImageView.isUserInteractionEnabled = true
              let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
              newImageView.addGestureRecognizer(tap)
              self.view.addSubview(newImageView)
              self.navigationController?.isNavigationBarHidden = true
              self.tabBarController?.tabBar.isHidden = true
       }
    
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
//    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
//        // handling code
//    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        print("🎯🎯🎯🎯🎯Hello World")
        print("🎯🎯🎯🎯🎯🎯🎯I tapped image with tag \(sender.view!.tag)")
        if sender.view!.tag == 0 {
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//            let userProfile = storyBoard.instantiateViewController(withIdentifier: "UserProfile") as! UserProfile
//            self.present(userProfile, animated:true, completion:nil)
//        }
    
//
//    let userProfile = UserProfile()
//            self.navigationController?.pushViewController(userProfile, animated: true)
//
//            let storyBoard: UIStoryboard = UIStoryboard(name: "UserProfile", bundle: nil)
//            let userProfile = storyBoard.instantiateViewController(withIdentifier: "userProfile") as! UserProfile
//            self.present(userProfile, animated: true, completion: nil)
            

    }
        
        if sender.view!.tag == 1 {
               openFacebook(facebookHandle: "")
               }
        
        if sender.view!.tag == 2 {
        openInstagram(instagramHandle: "patmcdonough42")
        }
        
        if sender.view!.tag == 3 {
            openTwitter(twitterHandle: "kanyewest")
        }
        
        if sender.view!.tag == 4 {
            openSpotifySong()
        }
        
        if sender.view!.tag == 5 {
           openSnapchat(snapchatUsername: "patmcdonough42")
        }
        
        if sender.view!.tag == 6 {
           openTikTok(tikTokHandle: "https://vm.tiktok.com/JeQCbBR/")
        }
        
        
        let newImageView = UIImageView(image: fakeUserTotalProfileArray[sender.view!.tag])
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
                     newImageView.addGestureRecognizer(tap)
         self.view.addSubview(newImageView)
        let textView = UITextView()
        textView.text = "asdfkjlasdfjasdf"
        textView.textColor = .red
       // textView.frame..x = 50.0
      //  textView.frame.layer.y = 300.0
        
      //  HexagonView.setupHexagonImageView(imageView: newImageView)
        
        
//        expandedView.image = fakeUserTotalProfileArray[sender.view!.tag]
//        expandedView.isHidden = false
//        expandedView.bringSubviewToFront(expandedView)
        
        for hexagon in fakeUserTotalProfileArray {
            
        }
        
    
     }
    
 
    
//    func downloadFileFromURL(url: URL){
//            var downloadTask = URLSessionDownloadTask()
//            downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: {
//                customURL, response, error in
//    //            print("customURL \(customURL)")
//    //            self.play(url: customURL!)
//                print("url 🎾 \(url)")
//                //self.play(url: url)
//    //            self.player.playSpotifyURI("spotify:track:03IxJiB8ZOH9hEQZF5mCNY", startingWith: 0, startingWithPosition: 0, callback: { (error) in
//    //            })
//                self.play(url: url)
//
//            })
//
//            downloadTask.resume()
//
//
//        }

        func play(url: String) {

            do {
                var urlStringTurnURL = URL(string: url)
                //player = try AVAudioPlayer(contentsOf: url)
                player = try AVAudioPlayer(contentsOf: urlStringTurnURL!)
                player.prepareToPlay()
                player.play()

            }
            catch{
                print(error)
            }


        }
    
    
    
    
    
    
}


extension UIImageView {

    public func loadGif(name: String) {
        DispatchQueue.global().async {
            let image = UIImage.gif(name: name)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }

    @available(iOS 9.0, *)
    public func loadGif(asset: String) {
        DispatchQueue.global().async {
            let image = UIImage.gif(asset: asset)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }

}

extension UIImage {

    public class func gif(data: Data) -> UIImage? {
        // Create source from data
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("SwiftGif: Source for the image does not exist")
            return nil
        }

        return UIImage.animatedImageWithSource(source)
    }

    public class func gif(url: String) -> UIImage? {
        // Validate URL
        guard let bundleURL = URL(string: url) else {
            print("SwiftGif: This image named \"\(url)\" does not exist")
            return nil
        }

        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(url)\" into NSData")
            return nil
        }

        return gif(data: imageData)
    }

    public class func gif(name: String) -> UIImage? {
        // Check for existance of gif
        guard let bundleURL = Bundle.main
          .url(forResource: name, withExtension: "gif") else {
            print("SwiftGif: This image named \"\(name)\" does not exist")
            return nil
        }

        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }

        return gif(data: imageData)
    }

    @available(iOS 9.0, *)
    public class func gif(asset: String) -> UIImage? {
        // Create source from assets catalog
        guard let dataAsset = NSDataAsset(name: asset) else {
            print("SwiftGif: Cannot turn image named \"\(asset)\" into NSDataAsset")
            return nil
        }

        return gif(data: dataAsset.data)
    }

    internal class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1

        // Get dictionaries
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        defer {
            gifPropertiesPointer.deallocate()
        }
        let unsafePointer = Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()
        if CFDictionaryGetValueIfPresent(cfProperties, unsafePointer, gifPropertiesPointer) == false {
            return delay
        }

        let gifProperties: CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)

        // Get delay time
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }

        if let delayObject = delayObject as? Double, delayObject > 0 {
            delay = delayObject
        } else {
            delay = 0.1 // Make sure they're not too fast
        }

        return delay
    }

    internal class func gcdForPair(_ lhs: Int?, _ rhs: Int?) -> Int {
        var lhs = lhs
        var rhs = rhs
        // Check if one of them is nil
        if rhs == nil || lhs == nil {
            if rhs != nil {
                return rhs!
            } else if lhs != nil {
                return lhs!
            } else {
                return 0
            }
        }

        // Swap for modulo
        if lhs! < rhs! {
            let ctp = lhs
            lhs = rhs
            rhs = ctp
        }

        // Get greatest common divisor
        var rest: Int
        while true {
            rest = lhs! % rhs!

            if rest == 0 {
                return rhs! // Found it
            } else {
                lhs = rhs
                rhs = rest
            }
        }
    }

    internal class func gcdForArray(_ array: [Int]) -> Int {
        if array.isEmpty {
            return 1
        }

        var gcd = array[0]

        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }

        return gcd
    }

    internal class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()

        // Fill arrays
        for index in 0..<count {
            // Add image
            if let image = CGImageSourceCreateImageAtIndex(source, index, nil) {
                images.append(image)
            }

            // At it's delay in cs
            let delaySeconds = UIImage.delayForImageAtIndex(Int(index),
                source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }

        // Calculate full duration
        let duration: Int = {
            var sum = 0

            for val: Int in delays {
                sum += val
            }

            return sum
            }()

        // Get frames
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()

        var frame: UIImage
        var frameCount: Int
        for index in 0..<count {
            frame = UIImage(cgImage: images[Int(index)])
            frameCount = Int(delays[Int(index)] / gcd)

            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }

        // Heyhey
        let animation = UIImage.animatedImage(with: frames,
            duration: Double(duration) / 1000.0)

        return animation
    }

}
