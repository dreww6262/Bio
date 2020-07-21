//
//  AlgorithmHexagonGrid.swift
//  Bio
//
//  Created by Ann McDonough on 7/10/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//


import UIKit
import AVKit
//import WebKit
//import SPT

class AlgorithmHexagonGrid: UIViewController {
    var player = AVAudioPlayer()
   // var webView = WKWebView()

    @IBOutlet weak var scrollView: UIScrollView!
    var coordinateArray: [[CGFloat]] = []
    var coordinate: [CGFloat] = []
    var imageViewArray: [UIImageView] = []
    
    @IBOutlet weak var expandedView: UIImageView!
     // var tapGesture = UITapGestureRecognizer()
    //var fakeUserImageArray: [UIImage] = []
      var fakeUserImageArray = [UIImage(named: "beachex"),UIImage(named: "forest"),UIImage(named: "skiingex"),UIImage(named: "bcex"),UIImage(named: "concertex"),UIImage(named: "instagram1ex"),UIImage(named: "instagram2ex"),UIImage(named: "instagram3ex"),UIImage(named: "volcanoex"),UIImage(named: "pastureex"),UIImage(named: "instagram1ex"),UIImage(named: "instagram2ex"),UIImage(named: "instagram3ex"),UIImage(named: "beachex"),UIImage(named: "forest"),UIImage(named: "skiingex"),UIImage(named: "bcex"),UIImage(named: "concertex"),UIImage(named: "instagram1ex"),UIImage(named: "instagram2ex"),UIImage(named: "instagram3ex"),UIImage(named: "volcanoex"),UIImage(named: "pastureex"),UIImage(named: "instagram1ex"),UIImage(named: "instagram2ex"),UIImage(named: "instagram3ex"),UIImage(named: "skiingex"),UIImage(named: "bcex"),UIImage(named: "concertex"),UIImage(named: "instagram1ex"),UIImage(named: "patinstagram")]
    var fakeUserHexagonArray: [HexagonStructData] = []
    
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
        
        var hexagonLocation = 0
        
        
        
        
        
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
                let spacing : CGFloat = 0

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
        
        
        
        //var reOrderedCoordinateArray: [[CGFloat]] = [[946.8266739736607, 902.5],[1081.7304845413264, 902.5], [1014.2785792574934, 1020.0],   [879.3747686898278,1020.0], [811.9228634059948,902.5], [879.3747686898278,785.0],[1014.2785792574934,785.0],[946.8266739736607, 667.5],[1081.7304845413264, 667.5], [1149.1823898251594, 785.0],  [1216.6342951089923, 902.5],[1149.1823898251594, 1020.0],   [1081.7304845413264, 1137.5], [1081.7304845413264, 1137.5],[946.8266739736607, 1137.5],[811.9228634059948, 1137.5],[744.4709581221618, 1020.0],[677.0190528383291, 902.5],[744.4709581221618, 785.0],  [811.9228634059948, 667.5],[879.3747686898278, 550.0],[1014.2785792574934, 550.0],[1149.1823898251594, 550.0],[1216.6342951089923, 667.5],[1284.0862003928253, 785.0],[1351.5381056766582, 902.5], [1284.0862003928253, 1020.0], [1216.6342951089923, 1137.5],[1149.1823898251594, 1255.0], [1014.2785792574934, 1255.0],[879.3747686898278, 1255.0],  [744.4709581221618, 1255.0],[677.0190528383291, 1137.5],[609.5671475544962, 1020.0],[542.1152422706632, 902.5],[609.5671475544962, 785.0],[677.0190528383291, 667.5],[744.4709581221618, 550.0]]
        
        var index = 0
        var initialX: CGFloat = 0.0
        var initialY: CGFloat = 0.0
       while (index < fakeUserImageArray.count) {
            let tapGesture = UIGestureRecognizer()
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            
            var ring = 0
            var index2 = index
            while (index2 > 0) {
                ring = ring + 1
                index2 = index2 - ring*6
            }
            if ring == 0 {
                ring = 1
            }
            let locationOfHexInOuterRing = index - 1 - 6*(ring - 1)
            let fullRing = ring * 6
            let degreeOffset: CGFloat = CGFloat(90 + ((360 / fullRing) * locationOfHexInOuterRing))
            var distance: CGFloat = (spacing * CGFloat(ring)) + (hexaDiameter * CGFloat(ring))
        
        if (index > 7 && index % 2 == 0) {
            distance = distance * CGFloat(sqrt(3)) / CGFloat(2)
        }
        
            var yCoordinate: CGFloat = 0.0
            var xCoordinate: CGFloat = 0.0
            if (index == 0) {
                xCoordinate = self.view.frame.width/2
                yCoordinate = self.view.frame.height/2
                initialX = xCoordinate
                initialY = yCoordinate
                print("ycoordinate index 0 \(initialY - 75)")
            }
            else if degreeOffset <= 180 {
                print("180: This was hit at index \(index)")
                let refDegree = degreeOffset - 90
                let refRad: CGFloat = refDegree / 360 * 2 * CGFloat(Double.pi)
                yCoordinate = initialY + sin(refRad) * distance
                xCoordinate = initialX + cos(refRad) * distance
            }
            else if degreeOffset <= 270 {
                 print("270: This was hit at index \(index)")
                let refDegree = degreeOffset - 180
                let refRad: CGFloat = refDegree / 360 * 2 * CGFloat(Double.pi)
                yCoordinate = initialY + cos(refRad) * distance
                xCoordinate = initialX - sin(refRad) * distance
            }
            else if degreeOffset <= 360 {
                 print("360: This was hit at index \(index)")
                let refDegree = degreeOffset - 270
                let refRad: CGFloat = refDegree / 360 * 2 * CGFloat(Double.pi)
                yCoordinate = initialY - sin(refRad) * distance
                xCoordinate = initialX - cos(refRad) * distance
            }
            else if degreeOffset <= 450 {
                 print("450: This was hit at index \(index)")
                let refDegree = degreeOffset - 360
                let refRad: CGFloat = refDegree / 360 * 2 * CGFloat(Double.pi)
                yCoordinate = initialY - cos(refRad) * distance
                xCoordinate = initialX + sin(refRad) * distance
            }
        if (index == 5) {
            print ("y coordinate index 5 \(yCoordinate - 75)")
        }
            
            let image = UIImageView(frame: CGRect(x: xCoordinate,                                                                 y: yCoordinate,
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
        
        populateFakeUserPhotos()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true) // No need for semicolon
        print("viewwillappear")
           // Do any additional setup after loading the view.
                        let hexaDiameter : CGFloat = 150
                        let hexaWidth = hexaDiameter * sqrt(3) * 0.5
                        let hexaWidthDelta = (hexaDiameter - hexaWidth) * 0.5
                        let hexaHeightDelta = hexaDiameter * 0.25
                        let spacing : CGFloat = 0

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
    
    
    
    
    
   
    
   
    
    
    

    
    
    func populateFakeUserPhotos() {
        var index1 = 0
     while (index1 < fakeUserImageArray.count){
//         while (index1 < 6){
            imageViewArray[index1].image = fakeUserImageArray[index1]
            fakeUserTotalProfileArray.append(imageViewArray[index1].image!)
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
        
        
     
        
 
    
     }
    
 
    


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


