//
//  DraggableHexagonGrid.swift
//  Bio
//
//  Created by Ann McDonough on 7/13/20.
//  Copyright © 2020 Patrick McDonough. All rights re
import UIKit
import AVKit
//import WebKit
//import SPT
import SwiftUI
let red = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
let gold = #colorLiteral(red: 0.9882352941, green: 0.7607843137, blue: 0, alpha: 1)
class DraggableHexagonGrid: UIViewController, UIGestureRecognizerDelegate  { //, //UIScrollViewDelegate {

    
    
    var player = AVAudioPlayer()
   // var webView = WKWebView()
  @objc var panGesture  = UIPanGestureRecognizer()
    @IBOutlet weak var scrollView: UIScrollView!

    var currentDraggedHexagonTag = -1
    //var currentDraggedHexagonFrame
    var hexIsMovable = false
    var coordinateArray: [[CGFloat]] = []
    var coordinate: [CGFloat] = []
    var imageViewArray: [UIImageView] = []
    var currentDraggedHexagonFrame = CGRect()
    var targetHexagons: [Int] = []
    
    @IBOutlet weak var expandedView: UIImageView!
    var index = 0
    var index1 = 0
    var presentingFrame = CGRect()
    
  //  var TapGestureRecognizer()
    //var fakeUserImageArray: [UIImage] = []
//      var fakeUserImageArray = [UIImage(named: "beachex"),UIImage(named: "forest"),UIImage(named: "skiingex"),UIImage(named: "bcex"),UIImage(named: "concertex"),UIImage(named: "instagram1ex"),UIImage(named: "instagram2ex"),UIImage(named: "instagram3ex"),UIImage(named: "volcanoex"),UIImage(named: "pastureex"),UIImage(named: "instagram1ex"),UIImage(named: "instagram2ex"),UIImage(named: "instagram3ex"),UIImage(named: "beachex"),UIImage(named: "forest"),UIImage(named: "skiingex"),UIImage(named: "bcex"),UIImage(named: "concertex"),UIImage(named: "instagram1ex"),UIImage(named: "instagram2ex"),UIImage(named: "instagram3ex"),UIImage(named: "volcanoex"),UIImage(named: "pastureex"),UIImage(named: "instagram1ex"),UIImage(named: "instagram2ex"),UIImage(named: "instagram3ex"),UIImage(named: "skiingex"),UIImage(named: "bcex"),UIImage(named: "concertex"),UIImage(named: "instagram1ex"),UIImage(named: "patinstagram")]
         var fakeUserImageArray = [UIImage(named: "kayser1"),UIImage(named: "kayser2"),UIImage(named: "kayser3"),UIImage(named: "k34"),UIImage(named: "kayser5"),UIImage(named: "kayser6"),UIImage(named: "kayser7"),UIImage(named: "kayser8"),UIImage(named: "teamimpact"),UIImage(named: "k32"),UIImage(named: "bchigh"),UIImage(named: "k11"),UIImage(named: "k50"),UIImage(named: "k13"),UIImage(named: "childrens"),UIImage(named: "k15"),UIImage(named: "k16"),UIImage(named: "k36"),UIImage(named: "shockey"),UIImage(named: "k19"),UIImage(named: "stjude"),UIImage(named: "k21"),UIImage(named: "k22"),UIImage(named: "k23"),UIImage(named: "k24"),UIImage(named: "k25"),UIImage(named: "k26"),UIImage(named: "k27"),UIImage(named: "k35"),UIImage(named: "k99"),UIImage(named: "k30")]
    
    var updatedUserImageArray: [UIImage] = []
    
    var reOrderedCoordinateArray: [[CGFloat]] = [[946.8266739736607, 902.5],[1081.7304845413264, 902.5], [1014.2785792574934, 1020.0],   [879.3747686898278,1020.0], [811.9228634059948,902.5], [879.3747686898278,785.0],[1014.2785792574934,785.0],[946.8266739736607, 667.5],[1081.7304845413264, 667.5], [1149.1823898251594, 785.0],  [1216.6342951089923, 902.5],[1149.1823898251594, 1020.0],   [1081.7304845413264, 1137.5], [1081.7304845413264, 1137.5],[946.8266739736607, 1137.5],[811.9228634059948, 1137.5],[744.4709581221618, 1020.0],[677.0190528383291, 902.5],[744.4709581221618, 785.0],  [811.9228634059948, 667.5],[879.3747686898278, 550.0],[1014.2785792574934, 550.0],[1149.1823898251594, 550.0],[1216.6342951089923, 667.5],[1284.0862003928253, 785.0],[1351.5381056766582, 902.5], [1284.0862003928253, 1020.0], [1216.6342951089923, 1137.5],[1149.1823898251594, 1255.0], [1014.2785792574934, 1255.0],[879.3747686898278, 1255.0],  [744.4709581221618, 1255.0],[677.0190528383291, 1137.5],[609.5671475544962, 1020.0],[542.1152422706632, 902.5],[609.5671475544962, 785.0],[677.0190528383291, 667.5],[744.4709581221618, 550.0]]
    
    var reOrderedCoordinateArrayPoints: [CGPoint] = [CGPoint(x: 946.8266739736607,y: 902.5),CGPoint(x: 1081.7304845413264,y: 902.5),CGPoint(x: 1014.2785792574934,y: 1020.0), CGPoint(x: 879.3747686898278,y: 1020.0),CGPoint(x:811.9228634059948,y: 902.5), CGPoint(x: 879.3747686898278,y: 785.0),CGPoint(x: 1014.2785792574934,y: 785.0),CGPoint(x:946.8266739736607,y: 667.5),CGPoint(x:1081.7304845413264,y:667.5), CGPoint(x:1149.1823898251594,y:785.0),CGPoint(x: 1216.6342951089923,y: 902.5),CGPoint(x:1149.1823898251594,y: 1020.0),   CGPoint(x: 1081.7304845413264,y: 1137.5), CGPoint(x:1081.7304845413264, y: 1137.5),CGPoint(x:946.8266739736607,y: 1137.5),CGPoint(x: 811.9228634059948, y: 1137.5),CGPoint(x: 744.4709581221618, y: 1020.0), CGPoint(x: 677.0190528383291, y: 902.5),CGPoint(x: 744.4709581221618, y: 785.0), CGPoint(x: 811.9228634059948, y: 667.5),CGPoint(x: 879.3747686898278, y: 550.0),CGPoint(x: 1014.2785792574934, y: 550.0),CGPoint(x: 1149.1823898251594,y: 550.0),CGPoint(x:1216.6342951089923,y: 667.5),CGPoint(x:1284.0862003928253, y: 785.0),CGPoint(x:1351.5381056766582,y: 902.5), CGPoint(x:1284.0862003928253, y: 1020.0),CGPoint(x: 1216.6342951089923, y: 1137.5),CGPoint(x: 1149.1823898251594, y: 1255.0), CGPoint(x:1014.2785792574934,y:1255.0),CGPoint(x:879.3747686898278, y:1255.0),  CGPoint(x:744.4709581221618, y:1255.0),CGPoint(x:677.0190528383291, y:1137.5),CGPoint(x:609.5671475544962,y: 1020.0),CGPoint(x:542.1152422706632, y: 902.5),CGPoint(x: 609.5671475544962, y: 785.0),CGPoint(x: 677.0190528383291, y: 667.5),CGPoint(x: 744.4709581221618, y: 550.0)]
    
    var reOrderedCoordinateArrayPointsCentered: [CGPoint] = []
    
    
    
    var fakeUserTotalProfileArray: [UIImage] = []
    
    override func viewDidLoad() {
        print(fakeUserImageArray.count)
        super.viewDidLoad()
             //   downloadFileFromURL(url: URL(string: "https://p.scdn.co/mp3-preview/18d3b87b0765cd6d8c0a418d6142b3b441c0f8b2?cid=476c620368f349cc8be5b2a29b596eaf")!)
       // presentingFrame = CGRect(from: self.scrollView.frame as! CGRect)
        presentingFrame = CGRect(x: 0, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
        
        //adjust coordinates
        
        for point in reOrderedCoordinateArrayPoints {
            var newPointX = point.x - 604 //680
            var newPointY = point.y - 493 //570
            var newPoint = CGPoint(x: newPointX, y: newPointY)
            reOrderedCoordinateArrayPointsCentered.append(newPoint)
            
        }
        
        
        
        
        play(url: "https://p.scdn.co/mp3-preview/18d3b87b0765cd6d8c0a418d6142b3b441c0f8b2?cid=476c620368f349cc8be5b2a29b596eaf")
       
        
     // zoom stuff
  //  let delegate = scrollView.delegate
   // let scrollViewFrame = scrollV
    //viewForZooming(in: scrollView)
        
        
        
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
        
        
        
        
        
        index = 0
        for coordinates in reOrderedCoordinateArray {
            print(coordinates)
            let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
//            let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(dragItem(_:)))
            let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(dragged))
            
            let image = UIImageView(frame: CGRect(x: coordinates[0]-680,
                                                                 y: coordinates[1]-570,
                                                                 width: hexaDiameter,
                                                                 height: hexaDiameter))
                           image.contentMode = .scaleAspectFill
                           image.image = UIImage(named: "stickfigure1")
            
            
            image.addGestureRecognizer(longGesture)
            image.isUserInteractionEnabled = true
            image.addGestureRecognizer(dragGesture)
        //    var gold = #colorLiteral(red: 0.9882352941, green: 0.7607843137, blue: 0, alpha: 1)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true) // No need for semicolon
        print("viewwillappear")
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
            
        //scroll view stuff 2
        self.scrollView.contentSize = CGSize(width: spacing + CGFloat(firstRowColumns) * (hexaWidth + spacing), height: spacing + CGFloat(rows) * (hexaDiameter - hexaHeightDelta + spacing) + hexaHeightDelta)
        
        //end of scrollviewstuff 5 things total including top
                
                
        //        self.scrollView.center.x = 946.8266739736607
        //         self.scrollView.center.y = 902.5
        
        
        //scrollViewStuff1
                self.scrollView.backgroundColor = UIColor.black
                   // scrollView.contentSize = imageView.bounds.size
                self.scrollView.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
                self.scrollView.autoresizingMask = UIView.AutoresizingMask.flexibleHeight
    }
    
    

   



    @objc func longTap(_ sender: UIGestureRecognizer){
        print("Long tap")
        print("🎹🎹🎹🎹🎹🎹🎹🎹🎹")
        if sender.state == .ended {
            print("UIGestureRecognizerStateEnded")
           // hexIsMovable = false
            
            //Do Whatever You want on End of Gesture
        }
        else if sender.state == .began {
            print("UIGestureRecognizerStateBegan.")
            currentDraggedHexagonTag = sender.view!.tag
            print("Now this is current dragged hexagon tag \(currentDraggedHexagonTag)")
            hexIsMovable = true
             currentDraggedHexagonFrame = imageViewArray[currentDraggedHexagonTag].frame
            //dragItem(sender as! UIPanGestureRecognizer)
          
            
        
            
        }
    }
    
    func findIntersectingHexagon(hexCenter: CGPoint) -> Int {
        //find coordinates of final location for hexagon
        var thisIndex = 0
        for coordinate in self.reOrderedCoordinateArrayPointsCentered {
            if distance(hexCenter, coordinate) < 110.0 {
                print("This is the coordinates it belongs to \(coordinate)")
                print("This is the location in the reOrderedCoordinatePointArray \(thisIndex)")
            var red = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            var gold = #colorLiteral(red: 0.9882352941, green: 0.7607843137, blue: 0, alpha: 1)
                targetHexagons.append(thisIndex)
                 self.imageViewArray[thisIndex].setupHexagonMask(lineWidth: 10.0, color: red, cornerRadius: 10.0)
                
            for target in targetHexagons {
                if target != thisIndex {
                   self.imageViewArray[target].setupHexagonMask(lineWidth: 10.0, color: gold, cornerRadius: 10.0)
                    targetHexagons.remove(at: 0)
                    print("This is target hexagons \(targetHexagons)")
                }
                }
            print("🌮🌮🌮🌮🌮🌮🌮🌮🌮🌮🌮")
                return thisIndex
            }
                
        print("Thiis is coordinate for hexCenter \(hexCenter) and for testHexagonIndex \(thisIndex): \(coordinate)")
        print(" This is the distance between hexcenter and coordinate for \(thisIndex), \(distance(hexCenter, coordinate))")
            
        thisIndex = thisIndex + 1
        
        }
        return thisIndex
        
        //calculate distance to each point in the coordinate array
        
        //if any of them are 150 or less, switch that location and push the rest
        
    }
    
    func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt(xDist * xDist + yDist * yDist))
    }
    
    
    
    func populateSocialMedia() {
       imageViewArray[0].image = UIImage(named: "kayserbitmoji")
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
            print("This is image \(imageViewArray[index1+7].image)")
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
    
    var dragView : UIView? = nil
    @objc func dragged(sender : UIPanGestureRecognizer) {
        
        // if hexagon is in movable mode.
        if (hexIsMovable) {
            
            print("I am movable")
            //if the state has begun, store dragview for first time and center, bring scrollview subview to front
            if (sender.state == .began) {
                let pannedView: UIView = sender.view!
                
                dragView = pannedView
                dragView?.center = sender.location(in: scrollView)
                scrollView.bringSubviewToFront(dragView!)
            }
                
            // if sender state is changed, store deltas and check if srollview needs to pan
            else if (sender.state == .changed) {
                let xDelta = dragView!.center.x - sender.location(in: scrollView).x
                let yDelta = dragView!.center.y - sender.location(in: scrollView).y
                dragView?.center = sender.location(in: scrollView)
                self.scrollIfNeeded(location: sender.location(in: scrollView.superview), xDelta: xDelta, yDelta: yDelta)
            }
            else if (sender.state == .ended) {
                hexIsMovable = false
            }
        }
            
        // if hexagon is not in movable mode
        else {
            
            if (sender.state == .began) {
                //sender.view?.isUserInteractionEnabled = false
                let pannedView: UIView = sender.view!
                
                dragView = pannedView
            }
            else if (sender.state == .changed) {
            
            //print("im not movable")
//
//                let xDelta = scrollView.frame.minX - sender.location(in: scrollView).x
//                let yDelta = scrollView.frame.minY - sender.location(in: scrollView).y
//                print ("xdelta \(xDelta)")
//                print ("ydelta \(yDelta)")
//                print ("sender frame \(sender.view!.frame)")
//                let speed: CGFloat = 10.0
//                let location = sender.location(in: scrollView)
//                let bounds: CGRect = scrollView.superview!.bounds
                var scrollOffset = scrollView.contentOffset
//
//                var xOfs: CGFloat = 0.0
//
//
//                    var yOfs: CGFloat = 0.0
//
//                print("checking deltas")
//                if xDelta > 0 {
//                    xOfs = CGFloat(CGFloat(speed) * location.x/bounds.size.width)
//                }
//                else if xDelta < 0 {
//                    xOfs = -1 * speed * (1.0 - location.x/bounds.size.width)
//                }
//                if yDelta > 0 {
//                    yOfs = CGFloat(CGFloat(speed) * location.y/bounds.size.height)
//                }
//                else if yDelta < 0 {
//                    yOfs = -1 * speed * (1.0 - location.y/bounds.size.height)
//                }
//                print("checking ofs")
//
//                if (xOfs < 0)
//                {
//                    if (scrollOffset.x == 0){
//                        return
//                    }
//                    if (xOfs < -scrollOffset.x){
//                        xOfs = -scrollOffset.x
//                    }
//                }
//                if (yOfs < 0)
//                {
//                    if (scrollOffset.y == 0){
//                        return
//                    }
//                    if (yOfs < -scrollOffset.y){
//                        yOfs = -scrollOffset.y
//                    }
//                }
//                print("xOfs \(xOfs)")
//                print("yOfs \(yOfs)")
                let translation = sender.translation(in: self.view)
                scrollOffset.x = scrollOffset.x - translation.x/10
                scrollOffset.y = scrollOffset.y - translation.y/10
                let rect = CGRect(x: scrollOffset.x, y: scrollOffset.y, width: scrollView.bounds.size.width, height: scrollView.bounds.size.height)
                scrollView.scrollRectToVisible(rect, animated: false)
            }
        }
        
    }
    func scrollIfNeeded(location: CGPoint, xDelta: CGFloat, yDelta: CGFloat) {
        print("im in scrollifneeded")
        let scrollSuperview: UIView = scrollView.superview!
        let bounds: CGRect = scrollSuperview.bounds
        var scrollOffset: CGPoint = scrollView.contentOffset
        var xOfs: CGFloat = 0
        var yOfs: CGFloat = 0
        let speed: CGFloat = 10.0
        
        if ((location.x > bounds.size.width * 0.7) && (xDelta < 0)) {
            print("should be panning right")
            xOfs = CGFloat(CGFloat(speed) * location.x/bounds.size.width)
        }
        if ((location.y > bounds.size.height * 0.7) && (yDelta < 0)) {
            print("should be panning down")
            yOfs = CGFloat(CGFloat(speed) * location.y/bounds.size.height)
        }
        if ((location.x < bounds.size.width * 0.3) && (xDelta > 0))
        {
            print("should be panning left")
            xOfs = -1 * speed * (1.0 - location.x/bounds.size.width)
        }

        if (xOfs < 0)
        {
            if (scrollOffset.x == 0){
                return
            }
            if (xOfs < -scrollOffset.x){
                xOfs = -scrollOffset.x
            }
        }
        
        if ((location.y < bounds.size.height * 0.3) && (yDelta > 0))
        {
            print("should be panning up")
            yOfs = -1 * speed * (1.0 - location.y/bounds.size.height)
        }

        if (yOfs < 0)
        {
            if (scrollOffset.y == 0){
                return
            }
            if (yOfs < -scrollOffset.y){
                yOfs = -scrollOffset.y
            }
        }
        scrollOffset.x = scrollOffset.x + xOfs
        scrollOffset.y = scrollOffset.y + yOfs
        let rect = CGRect(x: scrollOffset.x, y: scrollOffset.y, width: scrollView.bounds.size.width, height: scrollView.bounds.size.height)
        scrollView.scrollRectToVisible(rect, animated: false)
        var center = dragView!.center
        center.x = center.x + xOfs
        center.y = center.y + yOfs
        dragView!.center = center
    }
    
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
    
    @objc func dragItem(_ sender: UIPanGestureRecognizer){
//        print("Im in drag item")
//        let scrollSuperview: UIView = scrollView.superview!
//        let bounds: CGRect = scrollSuperview.bounds
//        var scrollOffset: CGPoint = scrollView.contentOffset
//        var xOfs: CGFloat = 0
//        var yOfs: CGFloat = 0
//        let speed: CGFloat = 10.0
//        let xDelta = dragView!.center.x - sender.location(in: scrollView).x
//        let yDelta = dragView!.center.y - sender.location(in: scrollView).y
//        let location = sender.location(in: scrollView)
        
        if hexIsMovable == false {
            presentingFrame = self.scrollView.frame
            print("I want to drag across grid")
            print("This is self.scrollview.frame \(self.scrollView.frame)")
           // self.scrollView.scrollRectToVisible(self.scrollView.frame, animated: true)
             let translation = sender.translation(in: self.view)
            print("This is the presenting frame that is about to be translated \(presentingFrame)")
            print("This is translation \(translation)")

            var visibleCGRect = CGRect(x: self.presentingFrame.minX - translation.x, y: self.presentingFrame.minY - translation.y, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
            print("This is what the visibleCGRect is after the translation x: \(visibleCGRect.minX), y: \(visibleCGRect.minY), heihgt: \(visibleCGRect.width), width: \(visibleCGRect.height)")

            //self.scrollView.center = CGPoint(x: (self.scrollView.center.x) + translation.x/30, y: (self.view.center.y) + translation.y/30)
             self.scrollView.scrollRectToVisible(visibleCGRect, animated: true)
            presentingFrame = visibleCGRect
            print("This is the new presenting frame \(presentingFrame)")
//
//
//            if ((location.x > bounds.size.width * 0.7) && (xDelta < 0)) {
//                print("should be panning right")
//                xOfs = CGFloat(CGFloat(speed) * location.x/bounds.size.width)
//            }
//            if ((location.y > bounds.size.height * 0.7) && (yDelta < 0)) {
//                print("should be panning down")
//                yOfs = CGFloat(CGFloat(speed) * location.y/bounds.size.height)
//            }
//            if ((location.x < bounds.size.width * 0.3) && (xDelta > 0))
//            {
//                print("should be panning left")
//                xOfs = -1 * speed * (1.0 - location.x/bounds.size.width)
//            }
//
//            if (xOfs < 0)
//            {
//                if (scrollOffset.x == 0){
//                    return
//                }
//                if (xOfs < -scrollOffset.x){
//                    xOfs = -scrollOffset.x
//                }
//            }
//
//            if ((location.y < bounds.size.height * 0.3) && (yDelta > 0))
//            {
//                print("should be panning up")
//                yOfs = -1 * speed * (1.0 - location.y/bounds.size.height)
//            }
//
//            if (yOfs < 0)
//            {
//                if (scrollOffset.y == 0){
//                    return
//                }
//                if (yOfs < -scrollOffset.y){
//                    yOfs = -scrollOffset.y
//                }
//            }
//
//            scrollOffset.x = scrollOffset.x + xOfs
//            scrollOffset.y = scrollOffset.y + yOfs
//            let rect = CGRect(x: scrollOffset.x, y: scrollOffset.y, width: scrollView.bounds.size.width, height: scrollView.bounds.size.height)
//            scrollView.scrollRectToVisible(rect, animated: false)
//            var center = dragView!.center
//            center.x = center.x + xOfs
//            center.y = center.y + yOfs
//            dragView!.center = center
        }
        
        
        if hexIsMovable {
        
        var selected = sender.view
    print("calling dragItem \(sender.hashValue)")
       let translation = sender.translation(in: self.view)
            self.imageViewArray[currentDraggedHexagonTag].setupHexagonMask(lineWidth: 10.0, color: .clear, cornerRadius: 10.0)
       sender.view?.center = CGPoint(x: (sender.view?.center.x)! + translation.x, y: (sender.view?.center.y)! + translation.y)
            sender.setTranslation(CGPoint.zero, in: self.view)
            var currentHexagonCenter = (sender.view?.center)!
        // if this center < radius/150 distance from any point in coordinate array,
            print("just before finding newIndex")
            print("This is currentCenter \(currentHexagonCenter)")
            var newIndex = findIntersectingHexagon(hexCenter: currentHexagonCenter)
            print("This is newIndex \(newIndex)")
        print("just after Finding INdex")
        
            if sender.state == .ended {
                hexIsMovable = false
                              print("Drag ENDED!")
                print("Time to rearrange the hexagons")
                
                print(" 🥰🥰🥰🥰Move hexagon \(currentDraggedHexagonTag) to hexagon \(newIndex)")
                             // hexIsMovable = false
                              
                              //Do Whatever You want on End of Gesture
// Directly Switch Images!!!!
                var originalFrame = currentDraggedHexagonFrame
                var tempImage1 = imageViewArray[currentDraggedHexagonTag].image
                var tempImage2 = imageViewArray[newIndex].image
                imageViewArray[currentDraggedHexagonTag].frame = originalFrame
                imageViewArray[currentDraggedHexagonTag].image = tempImage2
                imageViewArray[newIndex].image = tempImage1
                 self.imageViewArray[currentDraggedHexagonTag].setupHexagonMask(lineWidth: 10.0, color: gold, cornerRadius: 10.0)
                self.imageViewArray[newIndex].setupHexagonMask(lineWidth: 10.0, color: gold, cornerRadius: 10.0)
            
                
// insert and slide method
//
//                var originalFrame = currentDraggedHexagonFrame
//                var tempImage1 = imageViewArray[currentDraggedHexagonTag].image
//                var tempImage2 = imageViewArray[newIndex].image
//                 var tempImage3 = imageViewArray[newIndex].image
//                var imageViewsRemaining: Int = imageViewArray.count - currentDraggedHexagonTag - 1
//                   imageViewArray[newIndex].image = tempImage1
//                  imageViewArray[currentDraggedHexagonTag].frame = originalFrame
//              //  var shiftIndex = 1
//              //   while shiftIndex < imageViewsRemaining {
//
//                var shiftIndex = 1
//
//                while shiftIndex < imageViewsRemaining {
//                    //tempImage3 = imageViewArray[newIndex+shiftIndex-1].image
//                    tempImage3 = imageViewArray[newIndex+shiftIndex].image
//                    imageViewArray[newIndex+shiftIndex].image = tempImage3
//
//                    shiftIndex = shiftIndex + 1
//                }
//
//
                
                
//                while imageViewsRemaining > 0 {
//                    var tempImage3 =
//                        imageViewArray[newIndex + shiftIndex].image
//                    var tempImage4 = imageViewArray[newIndex + shiftIndex + 1].image
//                    shiftIndex = shiftIndex + 1
//              //      var tempImage5 = imageViewArray[newIndex + shiftIndex + 2].image
//                    imageViewArray[newIndex + shiftIndex].image = tempImage3
//
//                  //  shiftIndex = shiftIndex + 1
//                    imageViewsRemaining = imageViewsRemaining - 1
//                }
                
                
                
                
                
//                var tempFrame1 = imageViewArray[currentDraggedHexagonTag].frame
//                var tempFrame2 = imageViewArray[newIndex].frame
//                imageViewArray[currentDraggedHexagonTag].frame = tempFrame2
//                imageViewArray[newIndex].frame = tempFrame1
             //   imageViewArray.swapAt(currentDraggedHexagonTag, newIndex)
                
                
                
                  }
            
            
            
            
        }
        
        
    }
    
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


