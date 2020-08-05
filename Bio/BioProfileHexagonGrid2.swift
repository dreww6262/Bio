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
    
    
    // var tapGesture = UITapGestureRecognizer()
    //var fakeUserImageArray: [UIImage] = []
    var currentUserFollowingAvatarsArray: [UIImage] = []
    var fakeUserImageArray = [UIImage(named: "beachex"),UIImage(named: "forest"),UIImage(named: "skiingex"),UIImage(named: "bcex"),UIImage(named: "concertex"),UIImage(named: "instagram1ex"),UIImage(named: "instagram2ex"),UIImage(named: "instagram3ex"),UIImage(named: "volcanoex"),UIImage(named: "pastureex"),UIImage(named: "instagram1ex"),UIImage(named: "instagram2ex"),UIImage(named: "instagram3ex"),UIImage(named: "beachex"),UIImage(named: "forest"),UIImage(named: "skiingex"),UIImage(named: "bcex"),UIImage(named: "concertex"),UIImage(named: "instagram1ex"),UIImage(named: "instagram2ex"),UIImage(named: "instagram3ex"),UIImage(named: "volcanoex"),UIImage(named: "pastureex"),UIImage(named: "instagram1ex"),UIImage(named: "instagram2ex"),UIImage(named: "instagram3ex"),UIImage(named: "skiingex"),UIImage(named: "bcex"),UIImage(named: "concertex"),UIImage(named: "instagram1ex"),UIImage(named: "patinstagram")]
    var fakeUserTotalProfileArray: [UIImage] = []
    
    //    var reOrderedCoordinateArray: [[CGFloat]] = [[946.8266739736607, 902.5],[1081.7304845413264, 902.5], [1014.2785792574934, 1020.0],   [879.3747686898278,1020.0], [811.9228634059948,902.5], [879.3747686898278,785.0],[1014.2785792574934,785.0],[946.8266739736607, 667.5],[1081.7304845413264, 667.5], [1149.1823898251594, 785.0],  [1216.6342951089923, 902.5],[1149.1823898251594, 1020.0],   [1081.7304845413264, 1137.5], [1081.7304845413264, 1137.5],[946.8266739736607, 1137.5],[811.9228634059948, 1137.5],[744.4709581221618, 1020.0],[677.0190528383291, 902.5],[744.4709581221618, 785.0],  [811.9228634059948, 667.5],[879.3747686898278, 550.0],[1014.2785792574934, 550.0],[1149.1823898251594, 550.0],[1216.6342951089923, 667.5],[1284.0862003928253, 785.0],[1351.5381056766582, 902.5], [1284.0862003928253, 1020.0], [1216.6342951089923, 1137.5],[1149.1823898251594, 1255.0], [1014.2785792574934, 1255.0],[879.3747686898278, 1255.0],  [744.4709581221618, 1255.0],[677.0190528383291, 1137.5],[609.567145544962, 1020.0],[542.1152422706632, 902.5],[609.5671475544962, 785.0],[677.0190528383291, 667.5],[744.4709581221618, 550.0]]
    var reorderedCoordinateArrayPointsCentered: [CGPoint] = []
    var reOrderedCoordinateArrayPoints: [CGPoint] = [CGPoint(x: 946.8266739736607,y: 902.5),CGPoint(x: 1081.7304845413264,y: 902.5),CGPoint(x: 1014.2785792574934,y: 1020.0), CGPoint(x: 879.3747686898278,y: 1020.0),CGPoint(x:811.9228634059948,y: 902.5), CGPoint(x: 879.3747686898278,y: 785.0),CGPoint(x: 1014.2785792574934,y: 785.0),CGPoint(x:946.8266739736607,y: 667.5),CGPoint(x:1081.7304845413264,y:667.5), CGPoint(x:1149.1823898251594,y:785.0),CGPoint(x: 1216.6342951089923,y: 902.5),CGPoint(x:1149.1823898251594,y: 1020.0),   CGPoint(x: 1081.7304845413264,y: 1137.5), CGPoint(x:1081.7304845413264, y: 1137.5),CGPoint(x:946.8266739736607,y: 1137.5),CGPoint(x: 811.9228634059948, y: 1137.5),CGPoint(x: 744.4709581221618, y: 1020.0), CGPoint(x: 677.0190528383291, y: 902.5),CGPoint(x: 744.4709581221618, y: 785.0), CGPoint(x: 811.9228634059948, y: 667.5),CGPoint(x: 879.3747686898278, y: 550.0),CGPoint(x: 1014.2785792574934, y: 550.0),CGPoint(x: 1149.1823898251594,y: 550.0),CGPoint(x:1216.6342951089923,y: 667.5),CGPoint(x:1284.0862003928253, y: 785.0),CGPoint(x:1351.5381056766582,y: 902.5), CGPoint(x:1284.0862003928253, y: 1020.0),CGPoint(x: 1216.6342951089923, y: 1137.5),CGPoint(x: 1149.1823898251594, y: 1255.0), CGPoint(x:1014.2785792574934,y:1255.0),CGPoint(x:879.3747686898278, y:1255.0),CGPoint(x:744.4709581221618, y:1255.0),CGPoint(x:677.0190528383291, y:1137.5),CGPoint(x:609.5671475544962,y: 1020.0),CGPoint(x:542.1152422706632, y: 902.5),CGPoint(x: 609.5671475544962, y: 785.0),CGPoint(x: 677.0190528383291, y: 667.5),CGPoint(x: 744.4709581221618, y: 550.0)]
    
    
    //        let rows = 10
    //        let firstRowColumns = 6
    
    let rows = 15
    let firstRowColumns = 15
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = false
        db.settings = settings
        
        hexaWidth = hexaDiameter * CGFloat(sqrt(3)) * CGFloat(0.5)
        hexaWidthDelta = (hexaWidth)*CGFloat(0.5)
        hexaHeightDelta = hexaDiameter * CGFloat(0.25)
        //   downloadFileFromURL(url: URL(string: "https://p.scdn.co/mp3-preview/18d3b87b0765cd6d8c0a418d6142b3b441c0f8b2?cid=476c620368f349cc8be5b2a29b596eaf")!)
        
        // background
        let bg = UIImageView(frame: CGRect(x: -400, y: -400, width: 3000, height: 3000))
        bg.image = UIImage(named: "outerspace1")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
        
        loadFollowings()
        print("hexagon data array viewdidload 🤽‍♂️🤽‍♂️🤽‍♂️")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        super.viewWillAppear(true) // No need for semicolon
        
                Auth.auth().signIn(withEmail: "mauser@fakeemail.bio97.com", password: "password", completion: { result, error in
                    if error == nil {
                        self.user = result?.user
                    
        
                        self.scrollView.maximumZoomScale = 3
        // Do any additional setup after loading the view.
        //        let rows = 10
        //        let firstRowColumns = 6
        
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
        
        //     loadProfileHexagons()
                    }
                    else {
                        print(error?.localizedDescription)
                    }
        })
    }
    
    
    
    
    
    
    
    // loading followings
    func loadFollowings() {
        print("starting load followings")
        print("This is user \(user)")
        // STEP 1. Find people followed by User
        let followCollection = db.collection("Followings")
        let usernameText:String = String(user?.email?.split(separator: "@")[0] ?? "")
        let followQuery = followCollection.whereField("follower", isEqualTo: usernameText)
        print("usernameText \(usernameText)")
        self.followArray.removeAll(keepingCapacity: false)
        followArray.append(usernameText)
        
        // followQuery.addDescendingOrder("createdAt")
        followQuery.addSnapshotListener({ (objects, error) -> Void in
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
                    //userDataQuery.order(by: "createdAt")
//                    self.db.clearPersistence { (error) in
//                        if(error != nil) {
//                            print(error?.localizedDescription)
//                        }
//                    }
                    userDataQuery.addSnapshotListener( { (objects, error) -> Void in
                        if error == nil {
                            guard let documents = objects?.documents else {
                                print(error?.localizedDescription)
                                return
                            }
                            
                            // clean up
                            //                         self.usernameArray.removeAll(keepingCapacity: false)
                            //                         self.avaArray.removeAll(keepingCapacity: false)
                            //self.hexagonDataArray.removeAll(keepingCapacity: false)
                            self.followingUserDataArray.removeAll(keepingCapacity: false)
                            
                            // find related objects in "User" class of Parse
                            //                                var newHexagon: HexagonStructData
                            for object in objects!.documents {
                                print("This is objects and count \(objects!.documents.count) and \(objects?.documents)")
                                self.followingUserDataArray.append(UserData(dictionary: object.data()))
                            }
                            self.loadProfileHexagons()
                            
                        } else {
                            print(error!.localizedDescription)
                        }
                        
                    })
                }
                
                
            } else {
                print(error!.localizedDescription)
            }
            
            
        })
    }
    
    
    
    
    //
    //        func populateFakeUserPhotos() {
    //            index1 = 0
    //            for image in fakeUserImageArray {
    //                imageViewArray[index1+7].image = fakeUserImageArray[index1]
    //                fakeUserTotalProfileArray.append(imageViewArray[index1+7].image!)
    //                index1 = index1+1
    //                //            fakeUserTotalProfileArray[0].loadGif(named: "hockeygif")
    //            }
    //        }
    
    //    func populateUserProfileHexagon(hexagon: HexagonStructData) {
    //            print("Im inside populate userprofile Hexagon 🤽‍♂️🤽‍♂️🤽‍♂️")
    //
    //
    //            let tapGesture = UIGestureRecognizer()
    //            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
    //            let hexagonLocation = hexagon.location
    //        let image = UIImageView(frame: CGRect(x: (reOrderedCoordinateArrayPoints[hexagonLocation].x)-880,
    //                                              y: reOrderedCoordinateArrayPoints[hexagonLocation].y-700,
    //                                                  width: hexaDiameter,
    //                                                  height: hexaDiameter))
    //            image.contentMode = .scaleAspectFill
    //            image.isUserInteractionEnabled = true
    //            image.addGestureRecognizer(tap)
    //            var gold = #colorLiteral(red: 0.9882352941, green: 0.7607843137, blue: 0, alpha: 1)
    //            image.setupHexagonMask(lineWidth: 10.0, color: gold, cornerRadius: 10.0)
    ////            view.addSubview(image)
    //            //imageViewArray.append(image)
    //            //imageViewArray[hexagonLocation].tag = hexagonLocation
    //
    ////        hexagon.thumbnail.{ (data, error) -> Void in
    ////                if error == nil {
    ////                    print("This is imageviewarray.count \(self.imageViewArray.count)")
    ////                    print("hexagonDataarray.count \(self.hexagonDataArray.count)")
    ////                    let imageData = UIImage(data: data!) ?? UIImage()
    ////                    image.image = imageData
    ////                    self.view.addSubview(image)
    ////                    self.imageViewArray.append(image)
    ////                    self.imageViewArray[hexagonLocation].tag = hexagonLocation
    ////                    print("loaded thumbnail \(hexagonLocation)")
    ////                }
    ////            }
    //            print("loaded hex view \(hexagonLocation) !!!!!!")
    //
    //
    //
    //            //var imageData = UIImage()
    //            //        print("This is ava array and count \(avaArray.count) \(avaArray)")
    ////            for hexagon in hexagonDataArray {
    ////                print("Im in for loop before get data")
    ////                hexagon.thumbnail.getDataInBackground { (data, error) -> Void in
    ////                    if error == nil {
    ////                        print("This is imageviewarray.count \(self.imageViewArray.count)")
    ////                        print("hexagonDataarray.count \(self.hexagonDataArray.count)")
    ////                        print("this is hexagon for index \(index2): \(hexagon)")
    ////                        imageData = UIImage(data: data!) ?? UIImage()
    ////                        self.imageViewArray[index2].image = imageData
    ////                        index2 = index2 + 1
    ////                        // let newHexagon = HexagonStructData(text: <#String#>, type: <#Type#>, time: <#TimeInterval#>, postingUserID: <#String#>, views: <#Int#>, thumbnail: <#UIImage#>, profilePicture: <#UIImage#>, location: <#Int#>, coordinateX: <#CGFloat#>, coordinateY: <#CGFloat#>, musicString: <#String#>, videoString: <#String#>, isAnimated: <#Bool#>)
    ////                        //  newHexagon.
    ////                        //  hexagonDataArray.append(newHexagon)
    ////                    }
    ////                }
    //                //   imageViewArray[index1].image = imageData
    //                // avaArray[index1].image = avaArray[index1]
    //                //fakeUserTotalProfileArray.append(imageViewArray[index1+7].image!)
    //                //  currentUserFollowingAvatarsArray.append(imageData)
    //                //            fakeUserTotalProfileArray[0].loadGif(named: "hockeygif")
    //
    //        }
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
        // TODO: use tag to get index of userdata to go to new hex grid as guest.
        
    }
    
    
    func loadProfileHexagons() {
        //print(fakeUserImageArray.count)
        //   downloadFileFromURL(url: URL(string: "https://p.scdn.co/mp3-preview/18d3b87b0765cd6d8c0a418d6142b3b441c0f8b2?cid=476c620368f349cc8be5b2a29b596eaf")!)
        // presentingFrame = CGRect(from: self.scrollView.frame as! CGRect)
        //presentingFrame = CGRect(x: 0, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
        
        //adjust coordinates
        
        for point in self.reOrderedCoordinateArrayPoints {
            var newPointX = point.x - 604 //680
            var newPointY = point.y - 493 //570
            var newPoint = CGPoint(x: newPointX, y: newPointY)
            reorderedCoordinateArrayPointsCentered.append(newPoint)
            
        }
        let contentTapGesture = UITapGestureRecognizer(target: self, action: #selector(DraggableHexagonGrid.handleContentViewerTap))
        self.contentViewer.addGestureRecognizer(contentTapGesture)
        
        
        
        
        //          // Do any additional setup after loading the view.
        let hexaDiameter : CGFloat = 150
        
        var thisIndex = 0
        for followInstance in followArray {
            //print(coordinates)
        
            let currentUsername = followingUserDataArray[thisIndex].publicID
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            print("follower username \(currentUsername)")
            
            
            let currentAvaRef = storage.child(followingUserDataArray[thisIndex].avaRef)
            
            let currentAva = UIImageView()
            currentAva.sd_setImage(with: currentAvaRef)
            let defaultProfileImage = UIImage(named: "kbit")
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
        print(imageViewArray)
        
        //        populateSocialMedia()
        //        populateFakeUserPhotos()
        
        
    }
    
    
    
    
    
    
    
    
    
}
