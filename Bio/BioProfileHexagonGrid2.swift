//
//  BioProfileHexagonGrid2.swift
//  Bio
//
//  Created by Ann McDonough on 7/21/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.


import UIKit
import AVKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseUI
import FirebaseStorage
//import Parse
//import WebKit
//import SPT



class BioProfileHexagonGrid2: UIViewController {
    //var user = PFUser.current()!.username!
    var user = Auth.auth().currentUser
    var storage = Storage.storage().reference()
    var contentViewer = UIView()
    //    var usernameArray = [String]()
    //     var avaArray = [PFFileObject]()
    // array showing who we follow
    var followArray = [String]()
    var followingUserDataArray = [UserData]()
    let db = Firestore.firestore()
    var userData: UserData?
    //var hexagonDataArray = [HexagonStructData]()
    
    //    var player = AVAudioPlayer()
    // var webView = WKWebView()
    
    @IBOutlet weak var scrollView: UIScrollView!
    var coordinateArray: [[CGFloat]] = []
    var coordinate: [CGFloat] = []
    var imageViewArray: [UIImageView] = []
    
    @IBOutlet weak var expandedView: UIImageView!
    
    let hexaDiameter : CGFloat = 150
    var hexaWidth : CGFloat = 0.0
    var hexaWidthDelta : CGFloat = 0.0
    var hexaHeightDelta : CGFloat = 0.0
    let spacing : CGFloat = 5
    
    var customTabBar: TabNavigationMenu!
    
    
    // var tapGesture = UITapGestureRecognizer()
    //var fakeUserImageArray: [UIImage] = []
    var currentUserFollowingAvatarsArray: [UIImage] = []
    var fakeUserImageArray = [UIImage(named: "beachex"),UIImage(named: "forest"),UIImage(named: "skiingex"),UIImage(named: "bcex"),UIImage(named: "concertex"),UIImage(named: "instagram1ex"),UIImage(named: "instagram2ex"),UIImage(named: "instagram3ex"),UIImage(named: "volcanoex"),UIImage(named: "pastureex"),UIImage(named: "instagram1ex"),UIImage(named: "instagram2ex"),UIImage(named: "instagram3ex"),UIImage(named: "beachex"),UIImage(named: "forest"),UIImage(named: "skiingex"),UIImage(named: "bcex"),UIImage(named: "concertex"),UIImage(named: "instagram1ex"),UIImage(named: "instagram2ex"),UIImage(named: "instagram3ex"),UIImage(named: "volcanoex"),UIImage(named: "pastureex"),UIImage(named: "instagram1ex"),UIImage(named: "instagram2ex"),UIImage(named: "instagram3ex"),UIImage(named: "skiingex"),UIImage(named: "bcex"),UIImage(named: "concertex"),UIImage(named: "instagram1ex"),UIImage(named: "patinstagram")]
    var fakeUserTotalProfileArray: [UIImage] = []
    
    
    var reorderedCoordinateArrayPointsCentered: [CGPoint] = []
    var reOrderedCoordinateArrayPoints: [CGPoint] = [CGPoint(x: 946.8266739736607,y: 902.5),CGPoint(x: 1081.7304845413264,y: 902.5),CGPoint(x: 1014.2785792574934,y: 1020.0), CGPoint(x: 879.3747686898278,y: 1020.0),CGPoint(x:811.9228634059948,y: 902.5), CGPoint(x: 879.3747686898278,y: 785.0),CGPoint(x: 1014.2785792574934,y: 785.0),CGPoint(x:946.8266739736607,y: 667.5),CGPoint(x:1081.7304845413264,y:667.5), CGPoint(x:1149.1823898251594,y:785.0),CGPoint(x: 1216.6342951089923,y: 902.5),CGPoint(x:1149.1823898251594,y: 1020.0),   CGPoint(x: 1081.7304845413264,y: 1137.5), CGPoint(x:1081.7304845413264, y: 1137.5),CGPoint(x:946.8266739736607,y: 1137.5),CGPoint(x: 811.9228634059948, y: 1137.5),CGPoint(x: 744.4709581221618, y: 1020.0), CGPoint(x: 677.0190528383291, y: 902.5),CGPoint(x: 744.4709581221618, y: 785.0), CGPoint(x: 811.9228634059948, y: 667.5),CGPoint(x: 879.3747686898278, y: 550.0),CGPoint(x: 1014.2785792574934, y: 550.0),CGPoint(x: 1149.1823898251594,y: 550.0),CGPoint(x:1216.6342951089923,y: 667.5),CGPoint(x:1284.0862003928253, y: 785.0),CGPoint(x:1351.5381056766582,y: 902.5), CGPoint(x:1284.0862003928253, y: 1020.0),CGPoint(x: 1216.6342951089923, y: 1137.5),CGPoint(x: 1149.1823898251594, y: 1255.0), CGPoint(x:1014.2785792574934,y:1255.0),CGPoint(x:879.3747686898278, y:1255.0),CGPoint(x:744.4709581221618, y:1255.0),CGPoint(x:677.0190528383291, y:1137.5),CGPoint(x:609.5671475544962,y: 1020.0),CGPoint(x:542.1152422706632, y: 902.5),CGPoint(x: 609.5671475544962, y: 785.0),CGPoint(x: 677.0190528383291, y: 667.5),CGPoint(x: 744.4709581221618, y: 550.0)]
    
    
    let rows = 15
    let firstRowColumns = 15
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hexaWidth = hexaDiameter * CGFloat(sqrt(3)) * CGFloat(0.5)
        hexaWidthDelta = (hexaWidth)*CGFloat(0.5)
        hexaHeightDelta = hexaDiameter * CGFloat(0.25)
        //   downloadFileFromURL(url: URL(string: "https://p.scdn.co/mp3-preview/18d3b87b0765cd6d8c0a418d6142b3b441c0f8b2?cid=476c620368f349cc8be5b2a29b596eaf")!)
        
        // background
        let bg = UIImageView(frame: CGRect(x: -400, y: -400, width: 3000, height: 3000))
        bg.image = UIImage(named: "outerspace1")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
//        if (userData == nil) {
//            db.collection("UserData").document(user!.uid).getDocument(completion: {obj,error in
//                if (error == nil) {
//                    self.userData = UserData(dictionary: obj!.data()!)
//                    self.loadFollowings()
//                }
//                else {
//                    print("could not load userdata from \(self.user?.email)")
//                    print(error?.localizedDescription)
//                }
//            })
//        }
//        else {
//            loadFollowings()
//        }
        print("hexagon data array viewdidload 🤽‍♂️🤽‍♂️🤽‍♂️")
    }
    
    func refresh() {
        loadView()
        if (userData == nil) {
            db.collection("UserData").document(user!.uid).getDocument(completion: {obj,error in
                if (error == nil) {
                    self.userData = UserData(dictionary: obj!.data()!)
                    self.loadFollowings()
                }
                else {
                    print("could not load userdata from \(self.user?.email)")
                    print(error?.localizedDescription)
                }
            })
        }
        else {
            loadFollowings()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        super.viewWillAppear(true) // No need for semicolon
        
        
        self.scrollView.maximumZoomScale = 3
        let rows = 15
        let firstRowColumns = 15
        
        let scrollviewWidth: CGFloat = self.spacing + (CGFloat(firstRowColumns) * (CGFloat(self.hexaWidth) + self.spacing))
        let scrollviewHeight: CGFloat = self.spacing + (CGFloat(rows) * CGFloat(self.hexaDiameter - CGFloat(self.hexaHeightDelta) + self.spacing)) + CGFloat(self.hexaHeightDelta)
        
        self.scrollView.contentSize = CGSize(width: scrollviewWidth, height: scrollviewHeight)
        print("Scrollview content size: \(self.scrollView.contentSize)")
        print("View content size: \(self.view.frame.size)")
        
        
        //        self.scrollView.center.x = 946.8266739736607
        //         self.scrollView.center.y = 902.5
        self.scrollView.backgroundColor = UIColor.black
        // scrollView.contentSize = imageView.bounds.size
        self.scrollView.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
        self.scrollView.autoresizingMask = UIView.AutoresizingMask.flexibleHeight

    }
    
    
    
    
    
    
    
    // loading followings
    func loadFollowings() {
        print("starting load followings")
        print("This is user \(user)")
        // STEP 1. Find people followed by User
        let followCollection = db.collection("Followings")
        let usernameText:String = userData!.publicID

        print("usernameText \(usernameText)")
        self.followArray.removeAll(keepingCapacity: false)
        
        self.followingUserDataArray.removeAll(keepingCapacity: false)
        self.followingUserDataArray.append(self.userData!)

        let followQuery = followCollection.whereField("follower", isEqualTo: usernameText).addSnapshotListener({ (objects, error) -> Void in
            if error == nil {
                print("no error")
                
                // STEP 2. Hold received data in followArray
                // find related objects in "follow" class of Parse
                for object in objects!.documents {
                    print (object.data())
                    self.followArray.append(object.get("following") as! String)
                    print("Now this is followArray \(self.followArray)")
                }
                
                // STEP 3. Basing on followArray information (inside users) show infromation from User class of Parse
                // find users followeb by user
                if (!self.followArray.isEmpty) {
                    let userDataCollection = self.db.collection("UserData")
                    let userDataQuery = userDataCollection.whereField("publicID", in: self.followArray)
                    
                    userDataQuery.addSnapshotListener( { (objects, error) -> Void in
                        if error == nil {
                            guard let documents = objects?.documents else {
                                print("could not get documents from objects?.documents")
                                print(error?.localizedDescription)
                                return
                            }

                            for object in documents {
                                self.followingUserDataArray.append(UserData(dictionary: object.data()))
                            }
                            self.followingUserDataArray.forEach({ doc in
                                print(doc.publicID)
                            })
                            self.loadProfileHexagons()
                            
                        } else {
                            print("could not get userdata for followings")
                            print(error!.localizedDescription)
                        }
                        
                    })
                }
                else {
                    self.loadProfileHexagons()
                }
                
                
            } else {
                print("could not get followings")
                print(error!.localizedDescription)
            }
            
            
        })
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
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        print("🎯🎯🎯🎯🎯Hello World")
        print("🎯🎯🎯🎯🎯🎯🎯I tapped image with tag \(sender.view!.tag)")
        let username = followingUserDataArray[sender.view!.tag].publicID
        print("🎯🎯🎯🎯🎯🎯🎯 I tapped image with associated username: \(username)")
        let guestVC = storyboard?.instantiateViewController(identifier: "guestGridVC") as! GuestHexagonGridVC
        //guestVC.user = user
        guestVC.userData = followingUserDataArray[sender.view!.tag]
        show(guestVC, sender: nil)
        // TODO: use tag to get index of userdata to go to new hex grid as guest.
        
    }
    
    
    func loadProfileHexagons() {

        //adjust coordinates
        
        for point in self.reOrderedCoordinateArrayPoints {
            var newPointX = point.x - 104 //680
            var newPointY = point.y - 493 //570
            var newPoint = CGPoint(x: newPointX, y: newPointY)
            reorderedCoordinateArrayPointsCentered.append(newPoint)
            
        }
        let contentTapGesture = UITapGestureRecognizer(target: self, action: #selector(DraggableHexagonGrid.handleContentViewerTap))
        self.contentViewer.addGestureRecognizer(contentTapGesture)
        
        
        
        
        //          // Do any additional setup after loading the view.
        let hexaDiameter : CGFloat = 150
        
        var thisIndex = 0
        for data in followingUserDataArray {
            //print(coordinates)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            print("follower username \(data.publicID)")
            
            
            let currentAvaRef = storage.child(data.avaRef)
            
            let currentAva = UIImageView()
            currentAva.sd_setImage(with: currentAvaRef)
            let defaultProfileImage = UIImage(named: "boyprofile")
            let newThumb = currentAva.image ?? defaultProfileImage
            
            
            let image = UIImageView(frame: CGRect(x: reOrderedCoordinateArrayPoints[thisIndex].x-680,
                                                  y: reOrderedCoordinateArrayPoints[thisIndex].y-570,
                                                  width: hexaDiameter,
                                                  height: hexaDiameter))
            image.contentMode = .scaleAspectFill
            image.image = newThumb ?? defaultProfileImage
            image.tag = thisIndex
            
            
            // image.addGestureRecognizer(longGesture)
            image.addGestureRecognizer(tapGesture)
            image.isUserInteractionEnabled = true
            //   image.addGestureRecognizer(dragGesture)
            //    var gold = #colorLiteral(red: 0.9882352941, green: 0.7607843137, blue: 0, alpha: 1)
            image.setupHexagonMask(lineWidth: 10.0, color: gold, cornerRadius: 10.0)
            if thisIndex == 0 {
                image.setupHexagonMask(lineWidth: 10.0, color: purple, cornerRadius: 10.0)
            }
            scrollView.addSubview(image)
            imageViewArray.append(image)
            imageViewArray[thisIndex].tag = thisIndex
            thisIndex = thisIndex+1
            
        }
    
        //self.view.frame.origin = imageViewArray[0].frame.origin
        print("imageViewArray: \(imageViewArray)")

    }

    
}
