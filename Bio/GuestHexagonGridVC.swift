//
//  GuestHexagonGridVC.swift
//  Bio
//
//  Created by Ann McDonough on 8/5/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import AVKit
//import MBVideoPlayer
//import AVPlayer
//import WebKit
//import SPT
import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import FirebaseUI
import SDWebImage

import SwiftUI
class GuestHexagonGridVC: UIViewController, UIGestureRecognizerDelegate  { //, //UIScrollViewDelegate {
    
    
    
    var player = AVAudioPlayer()
    // var webView = WKWebView()
    @objc var panGesture  = UIPanGestureRecognizer()
    @IBOutlet weak var scrollView: UIScrollView!
    var contentViewer = UIView()
    var currentDraggedHexagonTag = -1
    //var currentDraggedHexagonFrame
    var hexIsMovable = false
    var coordinateArray: [[CGFloat]] = []
    var coordinate: [CGFloat] = []
    var imageViewArray: [UIImageView] = []
    var currentDraggedHexagonFrame = CGRect()
    var targetHexagons: [Int] = []
    var hexagonStructArray: [HexagonStructData] = []
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    //    var username = String(Auth.auth().currentUser?.email?.split(separator: "@")[0] ?? "")
    var user = Auth.auth().currentUser
    var userData: UserData? = nil
    
   
    
    //@IBOutlet weak var expandedView: UIImageView!
    var index = 0
    var index1 = 0
    //var presentingFrame = CGRect()
    
    var homeUserImageArray: [String] = []
    
    var fakeUserImageArray = [UIImage(named: "kayser1"),UIImage(named: "oldspice"),UIImage(named: "kayser3"),UIImage(named: "k34"),UIImage(named: "kayser5"),UIImage(named: "kayser6"),UIImage(named: "couch"),UIImage(named: "kayser8"),UIImage(named: "teamimpact"),UIImage(named: "k32"),UIImage(named: "bchigh"),UIImage(named: "k11"),UIImage(named: "k50"),UIImage(named: "k13"),UIImage(named: "childrens"),UIImage(named: "k15"),UIImage(named: "k16"),UIImage(named: "k36"),UIImage(named: "shockey"),UIImage(named: "k19"),UIImage(named: "stjude"),UIImage(named: "k21"),UIImage(named: "k22"),UIImage(named: "k23"),UIImage(named: "k33"),UIImage(named: "k25"),UIImage(named: "k26"),UIImage(named: "k27"),UIImage(named: "k35"),UIImage(named: "k99"),UIImage(named: "k30")]
    
    //with 3rdr row
    // var fakeUserImageArray = [UIImage(named: "kayser1"),UIImage(named: "kayser2"),UIImage(named: "kayser3"),UIImage(named: "k34"),UIImage(named: "kayser5"),UIImage(named: "kayser6"),UIImage(named: "kayser7"),UIImage(named: "kayser8"),UIImage(named: "teamimpact"),UIImage(named: "k32"),UIImage(named: "bchigh"),UIImage(named: "k11"),UIImage(named: "k50"),UIImage(named: "k13"),UIImage(named: "childrens"),UIImage(named: "k15"),UIImage(named: "k16"),UIImage(named: "k36"),UIImage(named: "shockey"),UIImage(named: "k19"),UIImage(named: "stjude"),UIImage(named: "k21"),UIImage(named: "k22"),UIImage(named: "k23"),UIImage(named: "k24"),UIImage(named: "k25"),UIImage(named: "k26"),UIImage(named: "k27"),UIImage(named: "k35"),UIImage(named: "k99"),UIImage(named: "k30"), UIImage(named: "kayser8"),UIImage(named: "teamimpact"),UIImage(named: "k32"),UIImage(named: "bchigh"),UIImage(named: "k11"),UIImage(named: "k50"),UIImage(named: "k13"),UIImage(named: "childrens"),UIImage(named: "k15"),UIImage(named: "k16"),UIImage(named: "k36"),UIImage(named: "shockey"),UIImage(named: "k19"),UIImage(named: "stjude"),UIImage(named: "k21"),UIImage(named: "k22"),UIImage(named: "k23"),UIImage(named: "k24"),UIImage(named: "k25"),UIImage(named: "k26"),UIImage(named: "k27"),UIImage(named: "k35"),UIImage(named: "k99"),UIImage(named: "k30")]
    
    
    
    var updatedUserImageArray: [UIImage] = []
    
    //    var reOrderedCoordinateArray: [[CGFloat]] = [[946.8266739736607, 902.5],[1081.7304845413264, 902.5], [1014.2785792574934, 1020.0],   [879.3747686898278,1020.0], [811.9228634059948,902.5], [879.3747686898278,785.0],[1014.2785792574934,785.0],[946.8266739736607, 667.5],[1081.7304845413264, 667.5], [1149.1823898251594, 785.0],  [1216.6342951089923, 902.5],[1149.1823898251594, 1020.0],   [1081.7304845413264, 1137.5], [1081.7304845413264, 1137.5],[946.8266739736607, 1137.5],[811.9228634059948, 1137.5],[744.4709581221618, 1020.0],[677.0190528383291, 902.5],[744.4709581221618, 785.0],  [811.9228634059948, 667.5],[879.3747686898278, 550.0],[1014.2785792574934, 550.0],[1149.1823898251594, 550.0],[1216.6342951089923, 667.5],[1284.0862003928253, 785.0],[1351.5381056766582, 902.5], [1284.0862003928253, 1020.0], [1216.6342951089923, 1137.5],[1149.1823898251594, 1255.0], [1014.2785792574934, 1255.0],[879.3747686898278, 1255.0],  [744.4709581221618, 1255.0],[677.0190528383291, 1137.5],[609.5671475544962, 1020.0],[542.1152422706632, 902.5],[609.5671475544962, 785.0],[677.0190528383291, 667.5],[744.4709581221618, 550.0]]
    
    //       var reOrderedCoordinateArray: [[CGFloat]] = [[946.8266739736607, 902.5],[1081.7304845413264, 902.5], [1014.2785792574934, 1020.0],   [879.3747686898278,1020.0], [811.9228634059948,902.5], [879.3747686898278,785.0],[1014.2785792574934,785.0],[946.8266739736607, 667.5],[1081.7304845413264, 667.5], [1149.1823898251594, 785.0],  [1216.6342951089923, 902.5],[1149.1823898251594, 1020.0],   [1081.7304845413264, 1137.5], [1081.7304845413264, 1137.5],[946.8266739736607, 1137.5],[811.9228634059948, 1137.5],[744.4709581221618, 1020.0],[677.0190528383291, 902.5],[744.4709581221618, 785.0],  [811.9228634059948, 667.5],[879.3747686898278, 550.0],[1014.2785792574934, 550.0],[1149.1823898251594, 550.0],[1216.6342951089923, 667.5],[1284.0862003928253, 785.0],[1351.5381056766582, 902.5], [1284.0862003928253, 1020.0], [1216.6342951089923, 1137.5],[1149.1823898251594, 1255.0], [1014.2785792574934, 1255.0],[879.3747686898278, 1255.0],  [744.4709581221618, 1255.0],[677.0190528383291, 1137.5],[609.5671475544962, 1020.0],[542.1152422706632, 902.5],[609.5671475544962, 785.0],[677.0190528383291, 667.5],[744.4709581221618, 550.0], [811.9228634059948, 432.5], [946.8266739736607, 432.5], [1081.7304845413264, 432.5], [1216.6342951089923, 432.5],[1284.0862003928253, 550.0],[1351.5381056766582, 667.5], [1418.990010960491, 785.0],  [1486.441916244324, 902.5], [1418.990010960491, 1020.0],[1351.5381056766582, 1137.5],   [1284.0862003928253, 1255.0],[1216.6342951089923, 1372.5],   [1081.7304845413264, 1372.5],[946.8266739736607, 1372.5],[811.9228634059948, 1372.5],[677.0190528383291, 1372.5], [609.5671475544962, 1255.0],[542.1152422706632, 1137.5],[474.6633369868303, 1020.0],[407.2114317029974, 902.5],[474.6633369868303, 785.0],[542.1152422706632, 667.5],[609.5671475544962, 550.0],[677.0190528383291, 432.5]]
    
    var reOrderedCoordinateArray: [[CGFloat]] = [[946.8266739736607, 902.5],[1081.7304845413264, 902.5], [1014.2785792574934, 1020.0],   [879.3747686898278,1020.0], [811.9228634059948,902.5], [879.3747686898278,785.0],[1014.2785792574934,785.0],[946.8266739736607, 667.5],[1081.7304845413264, 667.5], [1149.1823898251594, 785.0],  [1216.6342951089923, 902.5],[1149.1823898251594, 1020.0],   [1081.7304845413264, 1137.5], [1081.7304845413264, 1137.5],[946.8266739736607, 1137.5],[811.9228634059948, 1137.5],[744.4709581221618, 1020.0],[677.0190528383291, 902.5],[744.4709581221618, 785.0],  [811.9228634059948, 667.5],[879.3747686898278, 550.0],[1014.2785792574934, 550.0],[1149.1823898251594, 550.0],[1216.6342951089923, 667.5],[1284.0862003928253, 785.0],[1351.5381056766582, 902.5], [1284.0862003928253, 1020.0], [1216.6342951089923, 1137.5],[1149.1823898251594, 1255.0], [1014.2785792574934, 1255.0],[879.3747686898278, 1255.0],  [744.4709581221618, 1255.0],[677.0190528383291, 1137.5],[609.5671475544962, 1020.0],[542.1152422706632, 902.5],[609.5671475544962, 785.0],[677.0190528383291, 667.5],[744.4709581221618, 550.0]] // , /[811.9228634059948, 432.5], [946.8266739736607, 432.5], [1081.7304845413264, 432.5], [1216.6342951089923, 432.5],[1284.0862003928253, 550.0],[1351.5381056766582, 667.5], [1418.990010960491, 785.0],  [1486.441916244324, 902.5], [1418.990010960491, 1020.0],[1351.5381056766582, 1137.5],   [1284.0862003928253, 1255.0],[1216.6342951089923, 1372.5],   [1081.7304845413264, 1372.5],[946.8266739736607, 1372.5],[811.9228634059948, 1372.5],[677.0190528383291, 1372.5], [609.5671475544962, 1255.0],[542.1152422706632, 1137.5],[474.6633369868303, 1020.0],[407.2114317029974, 902.5],[474.6633369868303, 785.0],[542.1152422706632, 667.5],[609.5671475544962, 550.0],[677.0190528383291, 432.5]]
    
    //with 3rd row
    //    var reOrderedCoordinateArrayPoints: [CGPoint] = [CGPoint(x: 946.8266739736607,y: 902.5),CGPoint(x: 1081.7304845413264,y: 902.5),CGPoint(x: 1014.2785792574934,y: 1020.0), CGPoint(x: 879.3747686898278,y: 1020.0),CGPoint(x:811.9228634059948,y: 902.5), CGPoint(x: 879.3747686898278,y: 785.0),CGPoint(x: 1014.2785792574934,y: 785.0),CGPoint(x:946.8266739736607,y: 667.5),CGPoint(x:1081.7304845413264,y:667.5), CGPoint(x:1149.1823898251594,y:785.0),CGPoint(x: 1216.6342951089923,y: 902.5),CGPoint(x:1149.1823898251594,y: 1020.0),   CGPoint(x: 1081.7304845413264,y: 1137.5), CGPoint(x:1081.7304845413264, y: 1137.5),CGPoint(x:946.8266739736607,y: 1137.5),CGPoint(x: 811.9228634059948, y: 1137.5),CGPoint(x: 744.4709581221618, y: 1020.0), CGPoint(x: 677.0190528383291, y: 902.5),CGPoint(x: 744.4709581221618, y: 785.0), CGPoint(x: 811.9228634059948, y: 667.5),CGPoint(x: 879.3747686898278, y: 550.0),CGPoint(x: 1014.2785792574934, y: 550.0),CGPoint(x: 1149.1823898251594,y: 550.0),CGPoint(x:1216.6342951089923,y: 667.5),CGPoint(x:1284.0862003928253, y: 785.0),CGPoint(x:1351.5381056766582,y: 902.5), CGPoint(x:1284.0862003928253, y: 1020.0),CGPoint(x: 1216.6342951089923, y: 1137.5),CGPoint(x: 1149.1823898251594, y: 1255.0), CGPoint(x:1014.2785792574934,y:1255.0),CGPoint(x:879.3747686898278, y:1255.0),CGPoint(x:744.4709581221618, y:1255.0),CGPoint(x:677.0190528383291, y:1137.5),CGPoint(x:609.5671475544962,y: 1020.0),CGPoint(x:542.1152422706632, y: 902.5),CGPoint(x: 609.5671475544962, y: 785.0),CGPoint(x: 677.0190528383291, y: 667.5),CGPoint(x: 744.4709581221618, y: 550.0),CGPoint(x:811.9228634059948,y: 432.5), CGPoint(x: 946.8266739736607,y: 432.5), CGPoint(x:1081.7304845413264, y: 432.5), CGPoint(x: 1216.6342951089923,y: 432.5),CGPoint(x: 1284.0862003928253,y: 550.0),CGPoint(x:1351.5381056766582, y: 667.5), CGPoint(x:1418.990010960491,y: 785.0),  CGPoint(x: 1486.441916244324,y:902.5), CGPoint(x:1418.990010960491, y: 1020.0),CGPoint(x: 1351.5381056766582, y: 1137.5), CGPoint(x:1284.0862003928253,y: 1255.0),CGPoint(x: 1216.6342951089923,y: 1372.5),   CGPoint(x: 1081.7304845413264,y: 1372.5),CGPoint(x: 946.8266739736607, y: 1372.5),CGPoint(x: 811.9228634059948, y: 1372.5),CGPoint(x: 677.0190528383291,y: 1372.5), CGPoint(x: 609.5671475544962,y: 1255.0),CGPoint(x: 542.1152422706632,y: 1137.5),CGPoint(x: 474.6633369868303,y: 1020.0),CGPoint(x: 407.2114317029974, y: 902.5),CGPoint(x: 474.6633369868303, y: 785.0),CGPoint(x: 542.1152422706632,y: 667.5),CGPoint(x: 609.5671475544962,y: 550.0),CGPoint(x: 677.0190528383291, y: 432.5)]
    
    var reOrderedCoordinateArrayPoints: [CGPoint] = [CGPoint(x: 946.8266739736607,y: 902.5),CGPoint(x: 1081.7304845413264,y: 902.5),CGPoint(x: 1014.2785792574934,y: 1020.0), CGPoint(x: 879.3747686898278,y: 1020.0),CGPoint(x:811.9228634059948,y: 902.5), CGPoint(x: 879.3747686898278,y: 785.0),CGPoint(x: 1014.2785792574934,y: 785.0),CGPoint(x:946.8266739736607,y: 667.5),CGPoint(x:1081.7304845413264,y:667.5), CGPoint(x:1149.1823898251594,y:785.0),CGPoint(x: 1216.6342951089923,y: 902.5),CGPoint(x:1149.1823898251594,y: 1020.0),   CGPoint(x: 1081.7304845413264,y: 1137.5), CGPoint(x:1081.7304845413264, y: 1137.5),CGPoint(x:946.8266739736607,y: 1137.5),CGPoint(x: 811.9228634059948, y: 1137.5),CGPoint(x: 744.4709581221618, y: 1020.0), CGPoint(x: 677.0190528383291, y: 902.5),CGPoint(x: 744.4709581221618, y: 785.0), CGPoint(x: 811.9228634059948, y: 667.5),CGPoint(x: 879.3747686898278, y: 550.0),CGPoint(x: 1014.2785792574934, y: 550.0),CGPoint(x: 1149.1823898251594,y: 550.0),CGPoint(x:1216.6342951089923,y: 667.5),CGPoint(x:1284.0862003928253, y: 785.0),CGPoint(x:1351.5381056766582,y: 902.5), CGPoint(x:1284.0862003928253, y: 1020.0),CGPoint(x: 1216.6342951089923, y: 1137.5),CGPoint(x: 1149.1823898251594, y: 1255.0), CGPoint(x:1014.2785792574934,y:1255.0),CGPoint(x:879.3747686898278, y:1255.0),CGPoint(x:744.4709581221618, y:1255.0),CGPoint(x:677.0190528383291, y:1137.5),CGPoint(x:609.5671475544962,y: 1020.0),CGPoint(x:542.1152422706632, y: 902.5),CGPoint(x: 609.5671475544962, y: 785.0),CGPoint(x: 677.0190528383291, y: 667.5),CGPoint(x: 744.4709581221618, y: 550.0)]
    
    //,CGPoint(x:811.9228634059948,y: 432.5), CGPoint(x: 946.8266739736607,y: 432.5), CGPoint(x:1081.7304845413264, y: 432.5), CGPoint(x: 1216.6342951089923,y: 432.5),CGPoint(x: 1284.0862003928253,y: 550.0),CGPoint(x:1351.5381056766582, y: 667.5), CGPoint(x:1418.990010960491,y: 785.0),  CGPoint(x: 1486.441916244324,y:902.5), CGPoint(x:1418.990010960491, y: 1020.0),CGPoint(x: 1351.5381056766582, y: 1137.5), CGPoint(x:1284.0862003928253,y: 1255.0),CGPoint(x: 1216.6342951089923,y: 1372.5),   CGPoint(x: 1081.7304845413264,y: 1372.5),CGPoint(x: 946.8266739736607, y: 1372.5),CGPoint(x: 811.9228634059948, y: 1372.5),CGPoint(x: 677.0190528383291,y: 1372.5), CGPoint(x: 609.5671475544962,y: 1255.0),CGPoint(x: 542.1152422706632,y: 1137.5),CGPoint(x: 474.6633369868303,y: 1020.0),CGPoint(x: 407.2114317029974, y: 902.5),CGPoint(x: 474.6633369868303, y: 785.0),CGPoint(x: 542.1152422706632,y: 667.5),CGPoint(x: 609.5671475544962,y: 550.0),CGPoint(x: 677.0190528383291, y: 432.5)]
    
    var reOrderedCoordinateArrayPointsCentered: [CGPoint] = []
    
    
    
    var fakeUserTotalProfileArray: [UIImage] = []
    
    override func viewDidLoad() {
        print("This is current user email: \(user?.email)")
        //print(fakeUserImageArray.count)
        super.viewDidLoad()
        //   downloadFileFromURL(url: URL(string: "https://p.scdn.co/mp3-preview/18d3b87b0765cd6d8c0a418d6142b3b441c0f8b2?cid=476c620368f349cc8be5b2a29b596eaf")!)

        

        

        
        

        
        for point in reOrderedCoordinateArrayPoints {
            var newPointX = point.x - 604 //680
            var newPointY = point.y - 493 //570
            var newPoint = CGPoint(x: newPointX, y: newPointY)
            reOrderedCoordinateArrayPointsCentered.append(newPoint)
            
        }
        let contentTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleContentViewerTap))
        contentViewer.addGestureRecognizer(contentTapGesture)
        
        
        
        
        play(url: "https://p.scdn.co/mp3-preview/18d3b87b0765cd6d8c0a418d6142b3b441c0f8b2?cid=476c620368f349cc8be5b2a29b596eaf")
        
        
        // zoom stuff
        //  let delegate = scrollView.delegate
        // let scrollViewFrame = scrollV
        //viewForZooming(in: scrollView)
        
        
        
        // background
        let bg = UIImageView(frame: CGRect(x: -400, y: -400, width: 3000, height: 3000))
        bg.image = UIImage(named: "whitebg")
        bg.layer.zPosition = -1
        scrollView.addSubview(bg)
        
        
        //hide buttons
     
        
        
        if (userData != nil) {
            createImageViews()
        }
        else {
            print("SHOULD NOT EVER HAPPEN. This vc should be prepopulated with userdata that has been passed through.  Defaults to getting signed in user data.")
            db.collection("UserData").whereField("email", isEqualTo: user?.email).addSnapshotListener({ objects, error in
                if (error == nil) {
                    if (objects!.documents.capacity > 0) {
                        self.userData = UserData(dictionary: objects!.documents[0].data())
                        self.createImageViews()
                    }
                    else {
                        print("getting userdata failed: no users by that email")
                    }
                }
                else {
                    print("error on getting userdata before adding image views")
                }
            })
        }
        
        
        //print(imageViewArray)
        
        // populateSocialMedia()
        // populateFakeUserPhotos()
        //populateHexagonGrid()
        
    }
    
    func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt(xDist * xDist + yDist * yDist))
    }
    
    @IBAction func friendsButtonClicked(_ sender: UIButton) {
      let profileHexGrid =   storyboard?.instantiateViewController(identifier: "ProfileHexGrid") as! BioProfileHexagonGrid2
        show(profileHexGrid, sender: nil)
    }
    
    
    func createImageViews() {
        let hexaDiameter : CGFloat = 150
        
        let numPosts = self.userData?.numPosts ?? 0
        print("userdata \(self.userData)")
        
        if (numPosts == 0) {
            print("why no posts")
        }
        
        var i = 0
        while i < numPosts + 1 {
            let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longTap))
            //            let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(dragItem(_:)))
            let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(self.dragged))
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
            
            let image = UIImageView(frame: CGRect(x: self.reOrderedCoordinateArray[i][0]-680,
                                                  y: self.reOrderedCoordinateArray[i][1]-570,
                                                  width: hexaDiameter,
                                                  height: hexaDiameter))
            image.contentMode = .scaleAspectFill
            image.image = UIImage()
            
            
            image.addGestureRecognizer(longGesture)
            image.addGestureRecognizer(tapGesture)
            image.isUserInteractionEnabled = true
            image.addGestureRecognizer(dragGesture)
            //    var gold = #colorLiteral(red: 0.9882352941, green: 0.7607843137, blue: 0, alpha: 1)
            image.setupHexagonMask(lineWidth: 10.0, color: .darkGray, cornerRadius: 10.0)
            if i == 0 {
                image.setupHexagonMask(lineWidth: 10.0, color: .white, cornerRadius: 10.0)
            }
            self.scrollView.addSubview(image)
            self.imageViewArray.append(image)
            self.imageViewArray[i].tag = i
            i = i+1
        }
        
        self.populateUserAvatar()
        print("finished avatar")
        loadData {
            print("loading data 💡💡💡💡💡💡💡💡💡💡💡💡💡💡💡💡💡💡💡💡")
            self.populateHexagonGrid2()
            print("finished hexGrid2")
        }
//
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
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
        
        //scroll view stuff 2
        self.scrollView.contentSize = CGSize(width: spacing + CGFloat(firstRowColumns) * (hexaWidth + spacing), height: spacing + CGFloat(rows) * (hexaDiameter - hexaHeightDelta + spacing) + hexaHeightDelta)
        
        
        //scrollViewStuff1
        self.scrollView.backgroundColor = UIColor.black
        // scrollView.contentSize = imageView.bounds.size
        self.scrollView.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
        self.scrollView.autoresizingMask = UIView.AutoresizingMask.flexibleHeight
        let location = CGPoint(x: reOrderedCoordinateArrayPoints[0].x - self.view.frame.width*2.125, y: reOrderedCoordinateArrayPoints[0].y - self.view.frame.height*1.2)
        self.scrollView.contentOffset = location
    }
    
    
    
    func loadData(completed: @escaping () -> ()) {
        print("in load data funtion")
        let hexQuery = db.collection("Hexagons").whereField("postingUserID", isEqualTo: userData?.publicID)
        hexQuery.addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("error loading home photos: \n \(error!.localizedDescription)")
                return completed()
            }
            self.hexagonStructArray = []
            //there are querySnapshot!.documents.count docments in the spots snapshot
            
            for document in querySnapshot!.documents {
                print(document)
                let newHexagonPost = HexagonStructData(dictionary: document.data())
                self.hexagonStructArray.append(newHexagonPost)
                print("Loaded: \(newHexagonPost)")
            }
            // self.populateHexagonGrid()
            
            
            completed()
            return
        }
        //completed()
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
        imageViewArray[4].image = UIImage(named: "appleMusicLogo")
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
    
    
    
    
    
    
    
    //    func populateFakeUserPhotos() {
    //        index1 = 0
    //        for image in self.hexagonStructArray {
    //            self.hexagonStructArray[index1+7].image = fakeUserImageArray[index1]
    //            print("This is image \(self.hexagonStructArray[index1+7].image)")
    //            fakeUserTotalProfileArray.append(imageViewArray[index1+7].image!)
    //            index1 = index1+1
    //            //            fakeUserTotalProfileArray[0].loadGif(named: "hockeygif")
    //        }
    //    }
    
//    func populateHexagonGrid() {
//        var index3 = 0
//        // to for hexstruct array once algorithm done
//        //  for hexagon in self.hexagonStructArray {
//        for hexagon in self.imageViewArray {
//            print("This is imageviewArray.count \(imageViewArray.count)")
//            print("this is hexagonstructArray.count \(hexagonStructArray.count)")
//            let ref = storage.child(self.hexagonStructArray[index3].thumbResource)
//            imageViewArray[index3].sd_setImage(with: ref)
//            index3 += 1
//        }
//    }
//
    func populateHexagonGrid2() {
        var index3 = 0
        print ("in hex grid 2 \(self.hexagonStructArray.count)")
        // to for hexstruct array once algorithm done
        //  for hexagon in self.hexagonStructArray {
        for hexagon in self.hexagonStructArray {
            print("This is imageviewArray.count \(imageViewArray.count)")
            print("this is hexagonstructArray.count \(hexagonStructArray.count)")
            let ref = storage.child(self.hexagonStructArray[index3].thumbResource)
            print("ref: \(ref)")
            imageViewArray[index3+1].sd_setImage(with: ref)
            print("This is the imageView.image \(imageViewArray[index3].image)")
            print("This is ref \(index3) \(ref)")
            index3 += 1
        }
    }
    
    func populateUserAvatar() {
        // to for hexstruct array once algorithm done
        let ref = self.storage.child(userData!.avaRef)
        print(ref)
        self.imageViewArray[0].sd_setImage(with: ref)
        print("This is the imageView.image \(self.imageViewArray[0].image)")
        print("This is ref \(0) \(ref)")
    }
    
    
    var dragView : UIView? = nil
    var ogPosition: CGPoint = CGPoint(x: 0.0, y:
        0.0)
    @objc func dragged(sender : UIPanGestureRecognizer) {
        
        // if hexagon is in movable mode.
        if (hexIsMovable) {
            var newIndex: Int = 0
            var currentHexagonCenter = CGPoint(x:0.0, y:0.0)
            
            print("I am movable")
            //if the state has begun, store dragview for first time and center, bring scrollview subview to front
            if (sender.state == .began) {
                
                dragView = sender.view
                dragView?.center = sender.location(in: scrollView)
                scrollView.bringSubviewToFront(dragView!)
                
            }
                
                // if sender state is changed, store deltas and check if srollview needs to pan
            else if (sender.state == .changed) {
                let xDelta = dragView!.center.x - sender.location(in: scrollView).x
                let yDelta = dragView!.center.y - sender.location(in: scrollView).y
                dragView?.center = sender.location(in: scrollView)
                self.scrollIfNeeded(location: sender.location(in: scrollView.superview), xDelta: xDelta, yDelta: yDelta)
                print("This is newIndex before \(newIndex)")
                currentHexagonCenter = (sender.view?.center)!
                newIndex = findIntersectingHexagon(hexCenter: currentHexagonCenter)
                print("This is current newIndex \(newIndex)")
                // if this center < radius/150 distance from any point in coordinate array,
                print("just before finding newIndex")
                print("This is currentCenter \(currentHexagonCenter)")
            }
            else if (sender.state == .ended) {
                currentHexagonCenter = (sender.view?.center)!
                print("This is newIndex before \(newIndex)")
                newIndex = findIntersectingHexagon(hexCenter: currentHexagonCenter)
                print("This is current newIndex \(newIndex)")
                hexIsMovable = false
                var originalFrame = currentDraggedHexagonFrame
                var tempImage1 = imageViewArray[currentDraggedHexagonTag].image
                var tempImage2 = imageViewArray[newIndex].image
                imageViewArray[currentDraggedHexagonTag].frame = originalFrame
                imageViewArray[currentDraggedHexagonTag].image = tempImage2
                imageViewArray[newIndex].image = tempImage1
                self.imageViewArray[currentDraggedHexagonTag].setupHexagonMask(lineWidth: 10.0, color: gold, cornerRadius: 10.0)
                self.imageViewArray[newIndex].setupHexagonMask(lineWidth: 10.0, color: gold, cornerRadius: 10.0)
                
            }
        }
            
            // if hexagon is not in movable mode
        else {
            // set original position so we know how to adjust the screen with translation
            if (sender.state == .began) {
                //sender.view?.isUserInteractionEnabled = false
                ogPosition = scrollView.contentOffset
            }
                
                // if drag is changed, compare to translation and adjust scrollview frame
            else if (sender.state == .changed) {
                var scrollOffset = ogPosition
                let translation = sender.translation(in: scrollView.superview)
                //print("translation.x \(translation.x)")
                //print ("translation.y \(translation.y)")
                scrollOffset.x = ogPosition.x - translation.x
                scrollOffset.y = ogPosition.y - translation.y
                let rect = CGRect(x: scrollOffset.x, y: scrollOffset.y, width: scrollView.bounds.size.width, height: scrollView.bounds.size.height)
                scrollView.scrollRectToVisible(rect, animated: true)
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
    
    
    
    @objc func dismissFullscreenImageHandler(_ sender: UITapGestureRecognizer) {
        dismissFullscreenImage(view: sender.view!)
    }
    
    func dismissFullscreenImage(view: UIView) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        view.removeFromSuperview()
    }
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        print("🎯🎯🎯🎯🎯Hello World")
        print("🎯🎯🎯🎯🎯🎯🎯I tapped image with tag \(sender.view!.tag)")
        //if sender.view!.tag == 0 {
        let tappedHex = hexagonStructArray[sender.view!.tag - 1]
        
        //if hex is for other app link
        if tappedHex.type.split(separator: "_")[0] == "socialmedia" {
            let url = URL(string: tappedHex.resource)
            if UIApplication.shared.canOpenURL(url!) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url!)
                }
            }
            else {
                
            }
            
        }
        else {
            // do other stuff
        }
//        let newImageView = UIImageView(image: fakeUserTotalProfileArray[sender.view!.tag])
//        // let newImageView = UIImageView(image: imageViewArray[sender.view!.tag].image)
//        let frame = CGRect(x: scrollView.frame.minX + scrollView.contentOffset.x, y: scrollView.frame.minY + scrollView.contentOffset.y, width: scrollView.frame.width, height: scrollView.frame.height)
//
//        newImageView.frame = frame
//        newImageView.backgroundColor = .black
//        newImageView.contentMode = .scaleAspectFit
//        newImageView.isUserInteractionEnabled = true
//        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImageHandler))
//        newImageView.addGestureRecognizer(tap)
//        self.view.addSubview(newImageView)
//        let textView = UITextView()
//        textView.text = "asdfkjlasdfjasdf"
//        textView.textColor = .red
        
        
//        if sender.view!.tag == 1 {
//            dismissFullscreenImage(view: newImageView)
//            openFacebook(facebookHandle: "")
//        }
//
//        if sender.view!.tag == 2 {
//            dismissFullscreenImage(view: newImageView)
//            openInstagram(instagramHandle: "patmcdonough42")
//        }
//
//        if sender.view!.tag == 3 {
//            dismissFullscreenImage(view: newImageView)
//            openTwitter(twitterHandle: "kanyewest")
//        }
//
//        if sender.view!.tag == 4 {
//            dismissFullscreenImage(view: newImageView)
//            openSpotifySong()
//        }
//
//        if sender.view!.tag == 5 {
//            dismissFullscreenImage(view: newImageView)
//            openSnapchat(snapchatUsername: "patmcdonough42")
//
//        }
//
//        if sender.view!.tag == 6 {
//            print("im about to play video")
//            dismissFullscreenImage(view: newImageView)
//            // openTikTok(tikTokHandle: "https://vm.tiktok.com/JeQCbBR/")
//            loadVideo(urlString: "https://firebasestorage.googleapis.com/v0/b/hw05-54fe6.appspot.com/o/example-movie.mp4?alt=media&token=4dc2f663-94a1-460a-a05f-a2ce6774ae5b")
//        }
//        if sender.view!.tag == 8 {
//            print("im about to play old spice video")
//            dismissFullscreenImage(view: newImageView)
//            // openTikTok(tikTokHandle: "https://vm.tiktok.com/JeQCbBR/")
//            // scrollView.backgroundColor = .black
//            loadVideo(urlString: "https://firebasestorage.googleapis.com/v0/b/hw05-54fe6.appspot.com/o/Old%20Spice%20%7C%20The%20Man%20Your%20Man%20Could%20Smell%20Like.mp4?alt=media&token=c465fe00-4e95-485f-bc18-2806076b82f3")
//        }
//
        
        
        //}
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
    var avPlayer: AVPlayer? = nil
    // loads video into new avplayer and overlays on current VC
    
    
    
    
    func loadVideo(urlString: String) {
        print("im in loadVideo")
        let url =  URL(string: urlString)
        let asset = AVAsset(url: url!)
        let item = AVPlayerItem(asset: asset)
        let rect = CGRect(x: scrollView.contentOffset.x, y: scrollView.contentOffset.y, width: self.view.frame.width, height: self.view.frame.height)
        contentViewer.frame = rect
        contentViewer.backgroundColor = .black
        avPlayer = AVPlayer(playerItem: item)
        let playerLayer = AVPlayerLayer(player: avPlayer)
        playerLayer.frame = self.contentViewer.bounds //bounds of the view in which AVPlayer should be displayed
        playerLayer.videoGravity = .resizeAspect
        self.contentViewer.layer.addSublayer(playerLayer)
        self.view.addSubview(contentViewer)
        playVideo()
        
    }
    
    @objc func handleContentViewerTap(sender: UITapGestureRecognizer) {
        dismissContent(view: sender.view!)
    }
    func dismissContent(view: UIView){
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        pauseVideo()
        //        for v in view.subviews {
        //            v.removeFromSuperview()
        //        }
        //        for layer in view.layer.sublayers {
        //        }
        view.removeFromSuperview()
        
    }
    
    public func playVideo() {
        avPlayer?.play()
    }
    
    public func pauseVideo() {
        avPlayer?.pause()
    }
    
}












// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

// insert and slide method
//                //
//                //                var originalFrame = currentDraggedHexagonFrame
//                //                var tempImage1 = imageViewArray[currentDraggedHexagonTag].image
//                //                var tempImage2 = imageViewArray[newIndex].image
//                //                 var tempImage3 = imageViewArray[newIndex].image
//                //                var imageViewsRemaining: Int = imageViewArray.count - currentDraggedHexagonTag - 1
//                //                   imageViewArray[newIndex].image = tempImage1
//                //                  imageViewArray[currentDraggedHexagonTag].frame = originalFrame
//                //              //  var shiftIndex = 1
//                //              //   while shiftIndex < imageViewsRemaining {
//                //
//                //                var shiftIndex = 1
//                //
//                //                while shiftIndex < imageViewsRemaining {
//                //                    //tempImage3 = imageViewArray[newIndex+shiftIndex-1].image
//                //                    tempImage3 = imageViewArray[newIndex+shiftIndex].image
//                //                    imageViewArray[newIndex+shiftIndex].image = tempImage3
//                //
//                //                    shiftIndex = shiftIndex + 1
//                //                }
//                //
//                //
//
//
//                //                while imageViewsRemaining > 0 {
//                //                    var tempImage3 =
//                //                        imageViewArray[newIndex + shiftIndex].image
//                //                    var tempImage4 = imageViewArray[newIndex + shiftIndex + 1].image
//                //                    shiftIndex = shiftIndex + 1
//                //              //      var tempImage5 = imageViewArray[newIndex + shiftIndex + 2].image
//                //                    imageViewArray[newIndex + shiftIndex].image = tempImage3
//                //
//                //                  //  shiftIndex = shiftIndex + 1
//                //                    imageViewsRemaining = imageViewsRemaining - 1
//                //                }
//
//
//
//
//
//                //                var tempFrame1 = imageViewArray[currentDraggedHexagonTag].frame
//                //                var tempFrame2 = imageViewArray[newIndex].frame
//                //                imageViewArray[currentDraggedHexagonTag].frame = tempFrame2
//                //                imageViewArray[newIndex].frame = tempFrame1
//                //   imageViewArray.swapAt(currentDraggedHexagonTag, newIndex)
//

//struct HomeHexagonGrid_Previews: PreviewProvider {
//    static var previews: some View {
//        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
//    }
//}
