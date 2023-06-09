//
//  HomeHexagonGrid.swift
//  Bio
//
//  Created by Ann McDonough on 7/30/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//


import UIKit
import Foundation
import AVKit
import Firebase
import SDWebImage
import WebKit

class GuestHexagonGridVC: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate, WKUIDelegate, UIContextMenuInteractionDelegate  {
    var navBarView = NavBarView()
    var isFollowing = false
    var profileImage = UIImage()
    var navBarY = CGFloat(39)
    var newImageView = UIImageView()
    // Content presentation
    let menuView = MenuView()
    var toSearchButton = UIButton()
    var followView = UIView()
    var beenOnThisPageBefore = false
    // Firebase stuff
    var user = Auth.auth().currentUser
    var guestUserData: UserData?
    //var myUserData: UserData?
    var userDataVM: UserDataVM?
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    var profilePicCancelButton = UIButton()
    
    // UI stuff
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var returnButton: UIButton!
    
     var toSettingsButton = UIButton()
    
    var followImage = UIImageView()
    var followLabel = UILabel()
    
    var curvedRect = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
    var curvedLayer = UIImageView()
    
    // Flags and tags
    var newPostArray: [PostImageView] = []
    
    // arrays
    var imageViewArray: [PostImageView] = []
    
    // use .compare to compare dates
    var lastDateViewed: NSDate?
    
    var reOrderedCoordinateArrayPoints: [CGPoint] = [CGPoint(x: 946.8266739736607,y: 902.5), CGPoint(x: 1081.7304845413264,y: 902.5), CGPoint(x: 1014.2785792574934,y: 1020.0), CGPoint(x: 879.3747686898278,y: 1020.0), CGPoint(x:811.9228634059948,y: 902.5), CGPoint(x: 879.3747686898278,y: 785.0), CGPoint(x: 1014.2785792574934,y: 785.0), CGPoint(x: 946.8266739736607, y: 1137.5), CGPoint(x: 744.4709581221618, y: 785.0), CGPoint(x:1149.1823898251594,y:785.0), CGPoint(x: 811.9228634059948, y: 667.5), CGPoint(x:946.8266739736607,y: 667.5), CGPoint(x:1081.7304845413264,y:667.5), CGPoint(x: 1216.6342951089923,y: 902.5), CGPoint(x:1149.1823898251594,y: 1020.0), CGPoint(x:1081.7304845413264, y: 1137.5), CGPoint(x: 811.9228634059948, y: 1137.5), CGPoint(x: 744.4709581221618, y: 1020.0), CGPoint(x: 677.0190528383291, y: 902.5), CGPoint(x: 879.3747686898278, y: 550.0), CGPoint(x: 1014.2785792574934, y: 550.0), CGPoint(x: 1149.1823898251594,y: 550.0), CGPoint(x:1216.6342951089923,y: 667.5), CGPoint(x:1284.0862003928253, y: 785.0), CGPoint(x:1351.5381056766582,y: 902.5), CGPoint(x:1284.0862003928253, y: 1020.0), CGPoint(x: 1216.6342951089923, y: 1137.5), CGPoint(x: 1149.1823898251594, y: 1255.0), CGPoint(x:1014.2785792574934,y:1255.0), CGPoint(x:879.3747686898278, y:1255.0), CGPoint(x:744.4709581221618, y:1255.0), CGPoint(x:677.0190528383291, y:1137.5), CGPoint(x:609.5671475544962,y: 1020.0), CGPoint(x:542.1152422706632, y: 902.5), CGPoint(x: 609.5671475544962, y: 785.0), CGPoint(x: 677.0190528383291, y: 667.5), CGPoint(x: 744.4709581221618, y: 550.0)]
    
    var reOrderedCoordinateArrayPointsCircular: [CGPoint] = [CGPoint(x: 946.8266739736607,y: 902.5),CGPoint(x: 1081.7304845413264,y: 902.5),CGPoint(x: 1014.2785792574934,y: 1020.0), CGPoint(x: 879.3747686898278,y: 1020.0),CGPoint(x:811.9228634059948,y: 902.5), CGPoint(x: 879.3747686898278,y: 785.0),CGPoint(x: 1014.2785792574934,y: 785.0),CGPoint(x:946.8266739736607,y: 667.5),CGPoint(x:1081.7304845413264,y:667.5), CGPoint(x:1149.1823898251594,y:785.0),CGPoint(x: 1216.6342951089923,y: 902.5),CGPoint(x:1149.1823898251594,y: 1020.0), CGPoint(x:1081.7304845413264, y: 1137.5),CGPoint(x:946.8266739736607,y: 1137.5),CGPoint(x: 811.9228634059948, y: 1137.5),CGPoint(x: 744.4709581221618, y: 1020.0), CGPoint(x: 677.0190528383291, y: 902.5),CGPoint(x: 744.4709581221618, y: 785.0), CGPoint(x: 811.9228634059948, y: 667.5),CGPoint(x: 879.3747686898278, y: 550.0),CGPoint(x: 1014.2785792574934, y: 550.0),CGPoint(x: 1149.1823898251594,y: 550.0),CGPoint(x:1216.6342951089923,y: 667.5),CGPoint(x:1284.0862003928253, y: 785.0),CGPoint(x:1351.5381056766582,y: 902.5), CGPoint(x:1284.0862003928253, y: 1020.0),CGPoint(x: 1216.6342951089923, y: 1137.5),CGPoint(x: 1149.1823898251594, y: 1255.0), CGPoint(x:1014.2785792574934,y:1255.0),CGPoint(x:879.3747686898278, y:1255.0),CGPoint(x:744.4709581221618, y:1255.0),CGPoint(x:677.0190528383291, y:1137.5),CGPoint(x:609.5671475544962,y: 1020.0),CGPoint(x:542.1152422706632, y: 902.5),CGPoint(x: 609.5671475544962, y: 785.0),CGPoint(x: 677.0190528383291, y: 667.5),CGPoint(x: 744.4709581221618, y: 550.0)]
    var fourthRowArray: [CGPoint] = [CGPoint(x: 744.4709581221618, y: 315.0), CGPoint(x: 879.3747686898278,y: 315.0), CGPoint(x: 1014.2785792574934,y: 315.0), CGPoint(x: 1149.1823898251594,y: 315.0), CGPoint(x:1284.0862003928253,y: 315.0),CGPoint(x: 1351.5381056766582, y: 432.5), CGPoint(x: 1418.990010960491, y: 550.0),CGPoint(x: 1486.441916244324, y: 667.5), CGPoint(x: 1553.8938215281566, y: 785.0),CGPoint(x: 1621.3457268119896, y: 902.5), CGPoint(x: 1553.8938215281566, y: 1020.0), CGPoint(x: 1486.441916244324, y: 1137.5), CGPoint(x: 1418.990010960491, y: 1255.0), CGPoint(x: 1351.5381056766582, y: 1372.5), CGPoint(x: 1284.0862003928253, y: 1490.0), CGPoint(x: 1149.1823898251594,y: 1490.0), CGPoint(x: 1014.2785792574934, y: 1490.0), CGPoint(x: 879.3747686898278,y: 1490.0), CGPoint(x: 744.4709581221618,y: 1490.0), CGPoint(x: 609.5671475544962, y: 1490.0),      CGPoint(x: 542.1152422706632, y: 1372.5), CGPoint(x: 474.6633369868303, y: 1255.0), CGPoint(x: 407.2114317029974, y: 1137.5), CGPoint(x: 339.7595264191645, y: 1020.0), CGPoint(x: 272.3076211353316, y: 902.5),CGPoint(x: 339.7595264191645, y: 785.0), CGPoint(x: 407.2114317029974, y: 667.5), CGPoint(x: 474.6633369868303, y: 550.0), CGPoint(x: 542.1152422706632,y: 432.5),CGPoint(x: 609.5671475544962,y: 315.0)]
    
    
    
    var reOrderedCoordinateArrayPointsCentered: [CGPoint] = []
    let hexaDiameter : CGFloat = 150
    var avaImage: UIImageView?
//    var contentPages: ContentPagesVC?
    var contentPages: CustomPageView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        followView.isHidden = true
//        contentPages = storyboard?.instantiateViewController(identifier: "contentPagesVC")
        contentPages = storyboard?.instantiateViewController(identifier: "customPageView")
        contentPages?.userDataVM = userDataVM
        reOrderedCoordinateArrayPoints.append(contentsOf: fourthRowArray)
     //   addSettingsButton()
     //   addSearchButton()
        setUpNavBarView()
        navBarView.backgroundColor = .clear
        navBarView.layer.borderWidth = 0.0
        toSettingsButton.isHidden = false
        toSearchButton.isHidden = false
        setUpScrollView()
        setZoomScale()
        addReturnButton()
       
       // insertFollowButton()
      //  followView.isHidden = false
        
        addPageView()
        
        let myUserData = userDataVM?.userData.value
        if (myUserData == nil) {
            return
        }
        let dateLastViewed = myUserData?.subscriptions[guestUserData?.publicID ?? ""]
        let dateFormatter = DateFormatter()
       // dateFormatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ssZ"
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
        dateFormatter.locale = Locale.init(identifier: "en_GB")
        dateFormatter.timeZone = NSTimeZone(name: "GMT") as TimeZone?
        if (dateLastViewed != nil) {
            lastDateViewed = dateFormatter.date(from: dateLastViewed!) as NSDate?
        }
        myUserData?.subscriptions[guestUserData?.publicID ?? ""] = NSDate.now.description
        userDataVM?.updateUserData(newUserData: myUserData!, completion: {_ in })
        
        db.collection("Followings").whereField("follower", isEqualTo: myUserData!.publicID).whereField("following", isEqualTo: guestUserData!.publicID).getDocuments(completion: { obj, error in
            guard let docs = obj?.documents else {
                return
            }
            if docs.count > 0 {
                print("Isfollowing is true")
                self.isFollowing = true
                self.followView.isHidden = true
            }
            else {
                print("isfollowing is false")
                self.isFollowing = false
                self.followView.isHidden = false
            }
        })
    
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    
    func updatePages(posts: [PostImageView]) {
        var hexDatas = [HexagonStructData?](repeating: nil, count: posts.count)
        var repeats = [HexagonStructData]()
        for post in posts {
            if (post.hexData!.location - 1 >= hexDatas.count) {
                print("location >= count \(post.hexData!.location) \(hexDatas.count)")
                repeats.append(post.hexData!)
            }
            else if (hexDatas[post.hexData!.location - 1] == nil) {
                hexDatas[post.hexData!.location - 1] = post.hexData
            }
            else {
                print("was already an item here \(post.hexData!.location - 1)")
                repeats.append(post.hexData!)
            }
        }
        var c = 0
        var count = 0
        for re in repeats {
            print("repeat \(c)")
            while count < hexDatas.count {
                if (hexDatas[count] == nil) {
                    hexDatas[count] = re
                    hexDatas[count]!.location = count + 1
                    repeats[c].location = hexDatas[count]!.location
                    count += 1
                    break
                }
                count += 1
            }
            c += 1
        }
        contentPages!.hexData = hexDatas
        
        DispatchQueue.global().async {
            let dispatchGroup = DispatchGroup()
            for re in repeats {
                dispatchGroup.enter()
                self.db.collection("Hexagons2").document(re.docID).setData(re.dictionary) { _ in
                    dispatchGroup.leave()
                }
            }
            if (repeats.count > 0) {
                dispatchGroup.notify(queue: .main) {
                    self.guestUserData?.numPosts = posts.count
                    self.db.collection("UserData1").document(self.user!.uid).setData(self.guestUserData!.dictionary)
                }
            }
        }
    }
    
    func addPageView() {
        let myUserData = userDataVM?.userData.value
        db.collection("PageViews").document().setData(["viewer": myUserData?.publicID ?? "no_username", "viewed": guestUserData!.publicID, "viewedAt": Date()]) { _ in
            self.db.collection("PageViews").whereField("viewed", isEqualTo: self.guestUserData!.publicID).getDocuments(completion: { obj, error in
                if error == nil {
                    self.guestUserData?.pageViews = obj!.documents.count
                    self.db.collection("PopularUserData").getDocuments(completion: { pobj, perror in
                        if error == nil {
                            let docs = pobj!.documents
                            
                            if (docs.count < 100) {
                                let index = docs.firstIndex(where: { ref in
                                    UserData(dictionary: ref.data()).publicID == self.guestUserData?.publicID
                                })
                                if index == nil {
                                    self.db.collection("PopularUserData").document().setData(self.guestUserData!.dictionary)
                                }
                                else {
                                    docs[index!].reference.setData(self.guestUserData!.dictionary)
                                }
                                return
                            }
                            
                            let index = docs.firstIndex(where: { ref in
                                UserData(dictionary: ref.data()).publicID == self.guestUserData?.publicID
                            })
                            
                            if index != nil {
                                docs[index!].reference.setData(self.guestUserData!.dictionary)
                                return
                            }
                            
                            var least: UserData?
                            var leastRef: DocumentReference?
                            for doc in docs {
                                let data = UserData(dictionary: doc.data())
                                if data.pageViews < self.guestUserData!.pageViews {
                                    if least == nil {
                                        least = data
                                        leastRef = doc.reference
                                    }
                                    else if (least!.pageViews > data.pageViews) {
                                        least = data
                                        leastRef = doc.reference
                                    }
                                }
                            }
                            leastRef?.setData(self.guestUserData!.dictionary)
                        }
                    })
                }
            })
        }
    }
    
    // viewdidload helper functions
    func setUpScrollView() {
        scrollView.frame = view.frame
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = true
        scrollView.backgroundColor = .black
        contentView.backgroundColor = .black
        contentView.isHidden = false
        scrollView.scrollsToTop = false
        resizeScrollView(numPosts: 0)
        
        
    }
    
    func addSearchButton() {
        // self.view.addSubview(toSearchButton)
        toSearchButton.frame = CGRect(x: self.view.frame.width-45, y: navBarY, width: 25, height: 25)
        self.view.addSubview(toSearchButton)
        view.bringSubviewToFront(toSearchButton)
        // round ava
        //        toSearchButton.layer.cornerRadius = toSearchButton.frame.size.width / 2
        toSearchButton.clipsToBounds = true
        toSearchButton.isHidden = false
        
    }
    
    func setZoomScale() {
        scrollView.maximumZoomScale = 60
        scrollView.minimumZoomScale = 0.3
    }
    
    func addSettingsButton(){
        //  view.addSubview(followButton)
        toSettingsButton.frame = CGRect(x: 0, y: navBarY, width: 25, height: 25)
        view.addSubview(toSettingsButton)
        view.bringSubviewToFront(toSettingsButton)
        toSettingsButton.imageView?.image = UIImage(named: "addFriend")
        toSettingsButton.layer.cornerRadius =  toSettingsButton.frame.size.width / 2
        toSettingsButton.clipsToBounds = true
        toSettingsButton.imageView?.backgroundColor = .clear
        
        //        let tapped = UITapGestureRecognizer(target: self, action: #selector(followTapped))
        //        toSettingsButton.addGestureRecognizer(tapped)
        
    }
    
//    func insertFollowButton() {
//
//        self.view.addSubview(followView)
//        self.followView.backgroundColor = .white
//        self.followView.frame = CGRect(x: self.view.frame.midX - 45, y: navBarY, width: 90, height: 30)
//        self.followView.layer.cornerRadius = followView.frame.size.width / 20
//        self.followView.addSubview(followImage)
//        self.followView.addSubview(followLabel)
//       // self.followView.isHidden = false
//        self.followImage.frame = CGRect(x: 5, y: 0, width: followView.frame.height, height: followView.frame.height)
//        self.followView.layer.cornerRadius = followView.frame.size.width/10
//        //self.followView.clipsToBounds()
//
//        if isFollowing {
//            self.followView.isHidden = true
//            self.followImage.image = UIImage(named: "friendCheck")
//            self.followLabel.text = "Following"
//        }
//        else {
//            self.followView.isHidden = false
//            self.followImage.image = UIImage(named: "addFriend")
//            self.followLabel.text = "Follow"
//        }
//
//        //self.followImage.image = UIImage(named: "friendCheck")
//        self.followLabel.frame = CGRect(x: followImage.frame.maxX + 5, y: 0.0, width: followView.frame.width - 10, height: followView.frame.height)
//        //self.followLabel.text = "Added"
//        self.followLabel.textColor = .black
//        let tapped = UITapGestureRecognizer(target: self, action: #selector(followTapped))
//        self.followView.addGestureRecognizer(tapped)
//
//
//    }
    
    
    @objc func followTapped(_ sender: UITapGestureRecognizer) {
        //        if followLabel.text == "Add" {
        //            print("Follow the user :)")
        
        let myUserData = userDataVM?.userData.value
        if guestUserData != nil {
            if !isFollowing {
                let newFollow = ["follower": myUserData!.publicID, "following": guestUserData!.publicID]
                db.collection("Followings").addDocument(data: newFollow as [String : Any])
                UIDevice.vibrate()
                
                let notificationObjectref = db.collection("News2")
                let notificationDoc = notificationObjectref.document()
                let notificationObject = NewsObject(ava: myUserData!.avaRef, type: "follow", currentUser: myUserData!.publicID, notifyingUser: guestUserData!.publicID, thumbResource: myUserData!.avaRef, createdAt: NSDate.now.description, checked: false, notificationID: notificationDoc.documentID)
                notificationDoc.setData(notificationObject.dictionary){ error in
                    //     group.leave()
                    if error == nil {
                        //                           print("added notification: \(notificationObject)")
                        
                    }
                    else {
                        print("failed to add notification \(notificationObject)")
                        
                    }
                }
                self.followImage.image = UIImage(named: "friendCheck")
                self.followLabel.text = "Added"
                isFollowing = true
                self.followView.isHidden = true
            }
            else {
                db.collection("Followings").whereField("follower", isEqualTo: myUserData!.publicID).whereField("following", isEqualTo: guestUserData!.publicID).getDocuments(completion: { objects, error in
                    if error == nil {
                        guard let docs = objects?.documents else {
                            return
                        }
                        for doc in docs {
                            doc.reference.delete()
                        }
                    }
                })
                self.followView.isHidden = false
                self.followImage.image = UIImage(named: "addFriend")
                self.followLabel.text = "Add"
                isFollowing = false
            }
        }
    }
    
    func addReturnButton() {
        returnButton.frame = CGRect(x: view.frame.width/2-40, y: view.frame.height-112, width: 80, height: 80)
        view.bringSubviewToFront(returnButton)
        returnButton.layer.cornerRadius = returnButton.frame.size.width / 2
        //returnButton.setBackgroundImage(UIImage(named: "cancel11"), for: .normal)
        returnButton.clipsToBounds = true
        
        //add left and right people
        let rightButton = UIButton()
        view.addSubview(rightButton)
        rightButton.contentMode = .scaleAspectFit
       // rightButton.setImage(UIImage(named: "kbit2"), for: .normal)
        
        let cleanRef = guestUserData!.avaRef.replacingOccurrences(of: "/", with: "%2F")
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/bio-social-media.appspot.com/o/\(cleanRef)?alt=media")
        if (url == nil) {
            //rightButton.image = UIImage(named: "boyprofile")
            return
        }
        rightButton.sd_setImage(with: url!, for: .normal, completed: {_, error, _, _ in
            if error != nil {
                print(error!.localizedDescription)
              //  rightButton?.image = UIImage(named: "boyprofile")
            }
        })
        
        
        rightButton.frame = CGRect(x: view.frame.width - 100, y: view.frame.height-112, width: 80, height: 80)
        view.bringSubviewToFront(rightButton)
        rightButton.layer.cornerRadius = rightButton.frame.size.width / 2
        //returnButton.setBackgroundImage(UIImage(named: "cancel11"), for: .normal)
        rightButton.clipsToBounds = true
      
        
        let leftButton = UIButton()
        view.addSubview(leftButton)
        leftButton.contentMode = .scaleAspectFit
      //  leftButton.setImage(UIImage(named: "kbit2"), for: .normal)
        leftButton.frame = CGRect(x: 20, y: view.frame.height-112, width: 80, height: 80)
        leftButton.sd_setImage(with: url!, for: .normal, completed: {_, error, _, _ in
            if error != nil {
                print(error!.localizedDescription)
              //  rightButton?.image = UIImage(named: "boyprofile")
            }
        })
        view.bringSubviewToFront(leftButton)
       leftButton.layer.cornerRadius = leftButton.frame.size.width / 2
        //returnButton.setBackgroundImage(UIImage(named: "cancel11"), for: .normal)
        leftButton.clipsToBounds = true
        
        rightButton.isHidden = true
        leftButton.isHidden = true 
        
        
    }
    
    // Zoom Logic
    func resizeScrollView(numPosts: Int) {
        //        print("Contentviewframebeforeresize \(contentView.frame)")
        //var rows = 0
        var width = view.frame.width
        var height = view.frame.height
        let additionalRowWidth: CGFloat = 340.0
        
        var zoomScale: CGFloat = 1
        //     let heightDifference = height - width
        if numPosts < 7 {
            //rows = 1
            //self.scrollView.frame.width =
        }
        else if numPosts < 19 {
            //rows = 2
            width += additionalRowWidth
            height += additionalRowWidth
            zoomScale = 0.5622340592868583
        }
        else if numPosts  < 43 {
            //rows = 3
            width += (2*additionalRowWidth)
            height += (2*additionalRowWidth)
            zoomScale = 0.4026423034745347
        }
        else if numPosts < 91 {
            //rows = 4
            width += (3*additionalRowWidth)
            height += (3*additionalRowWidth)
            zoomScale = 0.3203873021737038
        }
        //  var addedWidth = 2*(rows-1)*160
        // var addedHeight =  2 * (rows-1)*160
        
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
        
        contentView.frame = CGRect(x: 0,y: 0,width: width, height: height)
        scrollView.contentSize = contentView.frame.size
        print("contentviewframe: \(contentView.frame)")
        resetCoordinatePoints()
        let contentOffset = CGPoint(x: contentView.frame.width/2 - view.frame.width/2, y: contentView.frame.height/2 - view.frame.height/2)
        scrollView.contentOffset = contentOffset
        scrollView.setZoomScale(zoomScale, animated: true)
        toSearchButton.isHidden = false
        toSettingsButton.isHidden = false
       // followView.isHidden = false
    }
    
    func resetCoordinatePoints() {
        let offsetX = reOrderedCoordinateArrayPoints[0].x - contentView.frame.midX + hexaDiameter/2
        let offsetY = reOrderedCoordinateArrayPoints[0].y - contentView.frame.midY + hexaDiameter/2
        reOrderedCoordinateArrayPointsCentered = []
        
        var count = 0
        for var coordinate in reOrderedCoordinateArrayPoints {
            coordinate.x -= offsetX
            coordinate.y -= offsetY
            
            reOrderedCoordinateArrayPoints[count] = coordinate
            
            reOrderedCoordinateArrayPointsCentered.append(CGPoint(x: coordinate.x + 0.5 * hexaDiameter, y: coordinate.y + 0.5 * hexaDiameter))
            
            count += 1
        }
    }
    
    override func viewWillLayoutSubviews() {
        setZoomScale()
    }
    
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageViewSize = contentView.frame.size
        let scrollViewSize = scrollView.bounds.size
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height)/2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width)/2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
        
        print("Zoom scale: \(scrollView.zoomScale)")
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }
    
    
    // refresh logic when view will appear
    func refresh() {
        //loadView()
        
        if (guestUserData != nil) {
//            print("populates without getting userdata")
            scrollView.zoomScale = 1
            let contentOffset = CGPoint(x: contentView.frame.width/2 - view.frame.width/2, y: contentView.frame.height/2 - view.frame.height/2)
            scrollView.contentOffset = contentOffset
            populateUserAvatar()
            createImageViews()
            return
        }
//        user = Auth.auth().currentUser
//        if (user != nil) {
//            db.collection("UserData1").whereField("email", isEqualTo: user!.email!).getDocuments(completion: { objects, error in
//                if (error == nil) {
//                    if (objects!.documents.capacity > 0) {
//                        let newData = UserData(dictionary: objects!.documents[0].data())
//                        if (self.guestUserData == nil || !NSDictionary(dictionary: newData.dictionary).isEqual(to: self.guestUserData!.dictionary)) {
//                            self.guestUserData = newData
//                            print("populates after getting userdata")
//                            self.populateUserAvatar()
//                            self.createImageViews()
//                            //                        print("created image views")
//                        }
//                        else {
//                            //                        print("nothing changed")
//                        }
//
//                    }
//                    else {
//                        print("getting userdata failed: no users by that email")
//                    }
//                }
//                else {
//                    print("error on getting userdata before adding image views")
//                }
//            })
//        }
    }
    
    var savedContentOffset: CGPoint?
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        savedContentOffset = scrollView.contentOffset
    }
    
    @IBAction func returnPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func createImageViews() {
        var newPostImageArray = [PostImageView]()
        db.collection("Hexagons2").whereField("postingUserID", isEqualTo: guestUserData!.publicID).getDocuments(completion: { objects, error in
            if error == nil {
                guard let docs = objects?.documents else {
                    print("get hex failed")
                    return
                }
                for doc in docs {
                    let hexData = HexagonStructData(dictionary: doc.data())
                    if (hexData.isArchived == true) {
                        continue
                    }
                    let hexImage = self.createPostImage(hexData: hexData)
                    newPostImageArray.append(hexImage)
                }
                self.updatePages(posts: newPostImageArray)
                self.resizeScrollView(numPosts: newPostImageArray.count) // clears out all content
                //                print("populates after resizescrollview")
                self.populateUserAvatar()
                //if newPostImageArray != self.imageViewArray {
                //for image in self.imageViewArray {
                //image.removeFromSuperview()
                //}
                self.imageViewArray = newPostImageArray
                self.changePostImageCoordinates()
                var imageIndex = 0
                
                let dateFormatter = DateFormatter()
               // dateFormatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ssZ"
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
                dateFormatter.locale = Locale.init(identifier: "en_GB")
                dateFormatter.timeZone = NSTimeZone(name: "GMT") as TimeZone?
                
                var prioritizedPosts: [PostImageView] = []
                for image in self.imageViewArray {
                    self.contentView.addSubview(image)
                    self.contentView.bringSubviewToFront(image)
                    image.isHidden = false
                    imageIndex = imageIndex + 1
                    
                    if image.hexData?.isPrioritized == true {
                        
                    prioritizedPosts.append(image)
                    image.pulse(withIntensity: 0.8, withDuration: 1.5, loop: true)
                    }
                    
                    
                    
                    let date = dateFormatter.date(from: image.hexData!.createdAt)
                    if date != nil && self.lastDateViewed?.compare(date!) == ComparisonResult.orderedDescending {
                        self.beenOnThisPageBefore = true
                        // @PAT do image change things here
                        // this means its seen
                  
                    }
                    else {
//                        image.setupHexagonMask(lineWidth: image.frame.width/15, color: .gray, cornerRadius: image.frame.width/15)
                        self.newPostArray.append(image)
                    }
                }
                if self.beenOnThisPageBefore == true {
                for newPost in self.newPostArray {
                    newPost.flash()
                }
                }
                //}
            }
        })
    }
    
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        toSettingsButton.isHidden = false
        toSearchButton.isHidden = false
        //followView.isHidden = false
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        toSearchButton.isHidden = false
        toSettingsButton.isHidden = false
       // followView.isHidden = false
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        toSettingsButton.isHidden = false
        toSearchButton.isHidden = false
       //followView.isHidden = false
    }
    
    func changePostImageCoordinates() {
        
        for image in imageViewArray {
//            var copyColor = myBlueGreen
//            let imageType = image.hexData?.type
//
//
//            if imageType == "photo"  {
//                copyColor = myOrange as UIColor
//            }
//            else if imageType!.contains("social") {
//                copyColor = myPink as UIColor
//            }
//            else if imageType == "music" {
//                copyColor = myBlueGreen as UIColor
//            }
//            else if imageType == "link" {
//                copyColor = myCoolBlue as UIColor
//            }
            
            image.frame = CGRect(x: self.reOrderedCoordinateArrayPoints[image.hexData!.location].x,
                                 y: self.reOrderedCoordinateArrayPoints[image.hexData!.location].y, width: hexaDiameter, height: hexaDiameter)
            
            //image.setupHexagonMask(lineWidth: 10.0, color: .darkGray, cornerRadius: 10.0)
        }
    }
    
    func createPostImage(hexData: HexagonStructData) -> PostImageView {
        let hexaDiameter : CGFloat = 150
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        let image = PostImageView(frame: CGRect(x: self.reOrderedCoordinateArrayPoints[hexData.location].x,
                                                y: self.reOrderedCoordinateArrayPoints[hexData.location].y, width: hexaDiameter, height: hexaDiameter))
        
        image.contentMode = .scaleAspectFill
        image.image = UIImage()
        image.hexData = hexData
        image.tag = hexData.location
        
        
        image.addGestureRecognizer(tapGesture)
        image.isUserInteractionEnabled = true
        let myType = hexData.type
        if myType.contains("pin") {
        if myType == "pin_country" {
            var ttext = hexData.text.lowercased()
            ttext = ttext.replacingOccurrences(of: " ", with: "-")
            image.image = UIImage(named: ttext)
            createHexagonMaskWithCorrespondingColor(imageView: image, type: myType)
        }
        else if myType == "pin_city" {
            let ttext = hexData.thumbResource
           // ttext = ttext.replacingOccurrences(of: " ", with: "-")
//            print("This is image name \(ttext)")
            image.image = UIImage(named: ttext)
            createHexagonMaskWithCorrespondingColor(imageView: image, type: myType)
        }
        else if myType == "pin_birthday" {
            let ttext = hexData.text
           // ttext = ttext.replacingOccurrences(of: " ", with: "-")
//            print("This is image name \(ttext)")
            image.image = UIImage(named: ttext)
            createHexagonMaskWithCorrespondingColor(imageView: image, type: myType)
        }
        else if myType == "pin_relationship" {
            let ttext = hexData.text.lowercased()
           // ttext = ttext.replacingOccurrences(of: " ", with: "-")
            print("This is image name \(ttext)")
            image.image = UIImage(named: ttext)
            createHexagonMaskWithCorrespondingColor(imageView: image, type: myType)
        }
        else if myType == "pin_phone" {
            image.backgroundColor = .white
            image.image = UIImage(named: "smartphone")
            createHexagonMaskWithCorrespondingColor(imageView: image, type: myType)
        }
        }
        else if myType.contains("socialmedia") {
         if myType == "socialmedia_instagram" {
            image.image = UIImage(named: "instagramLogo")
            createHexagonMaskWithCorrespondingColor(imageView: image, type: myType)
        }
        else if myType == "socialmedia_cameo" {
            image.image = UIImage(named: "cameo")
            image.setupHexagonMaskView(lineWidth: image.frame.width/15, color: .white, cornerRadius: image.frame.width/15)
        }
        else if myType == "socialmedia_cashapp" {
            image.image = UIImage(named: "cashapp")
            createHexagonMaskWithCorrespondingColor(imageView: image, type: myType)
        }
        else if myType == "socialmedia_etsy" {
            image.image = UIImage(named: "etsyLogoCircle")
            createHexagonMaskWithCorrespondingColor(imageView: image, type: myType)
        }
        else if myType == "socialmedia_hudl" {
            image.image = UIImage(named: "hudlapp")
            createHexagonMaskWithCorrespondingColor(imageView: image, type: myType)
        }
        else if myType == "socialmedia_linkedIn" {
            image.image = UIImage(named: "linkedIn7")
            createHexagonMaskWithCorrespondingColor(imageView: image, type: myType)
        }
        else if myType == "socialmedia_poshmark" {
            image.image = UIImage(named: "poshmarkLogo")
            createHexagonMaskWithCorrespondingColor(imageView: image, type: myType)
        }
        else if myType == "socialmedia_snapchat" {
            image.image = UIImage(named: "snapchatlogo")
            createHexagonMaskWithCorrespondingColor(imageView: image, type: myType)
        }
        else if myType == "socialmedia_tiktok" {
            image.image = UIImage(named: "tikTokLogo4")
            image.setupHexagonMaskView(lineWidth: image.frame.width/15, color: .white, cornerRadius: image.frame.width/15)
        }
        else if myType == "socialmedia_twitch" {
            image.image = UIImage(named: "twitchCircle")
            createHexagonMaskWithCorrespondingColor(imageView: image, type: myType)
        }
        else if myType == "socialmedia_twitter" {
            image.image = UIImage(named: "twitter")
            createHexagonMaskWithCorrespondingColor(imageView: image, type: myType)
        }
        else if myType == "socialmedia_venmo" {
            image.image = UIImage(named: "venmoCircle")
            createHexagonMaskWithCorrespondingColor(imageView: image, type: myType)
        }
        else if myType == "socialmedia_vsco" {
            image.image = UIImage(named: "vscologo1")
            createHexagonMaskWithCorrespondingColor(imageView: image, type: myType)
        }
        else if myType == "socialmedia_youtube" {
            image.image = UIImage(named: "youtube3")
            createHexagonMaskWithCorrespondingColor(imageView: image, type: myType)
        }
        
        }
        
        else {
        var placeHolderImage = UIImage(named: "linkCenter")
        createHexagonMaskWithCorrespondingColor(imageView: image, type: myType)
        switch myType {
        case "photo":
            placeHolderImage = UIImage(named: "cameraCenter")
        case "video":
            placeHolderImage = UIImage(named: "cameraCenter")
        case "link":
            placeHolderImage = UIImage(named: "linkCenter")
        case "music":
            placeHolderImage = UIImage(named: "musicCenter")
        case "social_media":
            placeHolderImage = UIImage(named: "soicalMediaCenter")
        default:
            placeHolderImage = UIImage(named: "socialMediaCenter")
        }
        
        
        //    var gold = #colorLiteral(red: 0.9882352941, green: 0.7607843137, blue: 0, alpha: 1)
        //        print("This is the type of hexagon: \(hexData.type)")
        
        // image.setupHexagonMask(lineWidth: 10.0, color: myBlueGreen, cornerRadius: 10.0)
        createHexagonMaskWithCorrespondingColor(imageView: image, type: myType)
        //let ref = storage.child(hexData.thumbResource)
        if hexData.thumbResource.contains("userFiles") || hexData.thumbResource.contains("icons/") {
            let cleanRef = hexData.thumbResource.replacingOccurrences(of: "/", with: "%2F")
            let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/bio-social-media.appspot.com/o/\(cleanRef)?alt=media")
            if url != nil {
                
                image.sd_setImage(with: url!, placeholderImage: placeHolderImage, options: .refreshCached) { (_, error, _, _) in
                    if (error != nil) {
                        print(error!.localizedDescription)
                        image.image = placeHolderImage
                    }
                }
            }
            else {
                image.image = placeHolderImage
            }
        }
        else {
            if let url = URL(string: hexData.thumbResource) {
                image.sd_setImage(with: url, placeholderImage: placeHolderImage, options: .refreshCached) { (_, error, _, _) in
                    if (error != nil) {
                        print(error!.localizedDescription)
                        image.image = placeHolderImage
                    }
                }
            }
            else {
                image.image = placeHolderImage
            }
        }
        
        }
        
        image.textOverlay.textAlignment = .center
        image.bringSubviewToFront(image.textOverlay)
        //self.contentView.addSubview(imageCopy)
        //image.textOverlay.frame = CGRect(x: 0, y: image.frame.height / 2 + 4, width: image.frame.width, height: 20)
        image.textOverlay.frame = CGRect(x: 0, y: image.frame.height*(6/10), width: image.frame.width, height: 20)
        image.textOverlay.text = image.hexData!.coverText
        image.textOverlay.numberOfLines = 1
        image.textOverlay.font = UIFont(name: "DINAternate-Bold", size: 10)
        image.textOverlay.textColor = white
        if image.hexData!.coverText != "" {
          //  image.textOverlay.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
            image.textOverlay.backgroundColor = UIColor(white: 0.25, alpha: 0.5)
        }
        
        return image
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //loadView()
        super.viewWillAppear(true) // No need for semicolon
        //        print("search button \(toSearchButton.frame)")
        returnButton.isHidden = false
        toSearchButton.isHidden = false
        toSettingsButton.isHidden = false
        followView.isHidden = true
      //  followView.isHidden = false
        refresh()
    }
    
    
    func createContextMenu() -> UIMenu {
        let shareAction = UIAction(title: "View Profile Picture", image: .none) { _ in
//    print("View Profile Picture")
        self.handleProfilePicTapView(UITapGestureRecognizer())
        
    }
        
        let followAction = UIAction(title: "Follow \(guestUserData!.displayName)", image: nil) { _ in
    print("follow User")
       // self.handleProfilePicTap(UITapGestureRecognizer())
            self.followTapped(UITapGestureRecognizer())
    }
        
        let unfollowAction = UIAction(title: "Unfollow \(guestUserData!.displayName)", image: nil) { _ in
    print("Unfollow User")
            let alert = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
                self.followTapped(UITapGestureRecognizer())
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
    }
        let guestFollowingList = UIAction(title: "View Who \(guestUserData!.displayName) Follows", image: nil) { _ in
    print("TODO: View their users")
            let guestFollowingTableView = self.storyboard?.instantiateViewController(identifier: "followingTableView") as! FollowingTableView
            guestFollowingTableView.userDataVM = self.userDataVM
            self.present(guestFollowingTableView, animated: false)
    }
        
     

    let cancelAction = UIAction(title: "Cancel", image: .none, attributes: .destructive) { action in
             // Delete this photo 😢
         }
        
        
        if isFollowing {
            return UIMenu(title: "", children: [shareAction, unfollowAction, guestFollowingList, cancelAction])
        }
        else {
            return UIMenu(title: "", children: [shareAction, followAction, guestFollowingList, cancelAction])
        }
        
   
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
    return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ -> UIMenu? in
    return self.createContextMenu()
        }
    }
    
    
    @IBAction func toSearchButtonClicked(_ sender: UIButton) {
        print("clicked search!")
        let userTableVC = storyboard?.instantiateViewController(identifier: "userTableView") as! UserTableView
        userTableVC.userDataVM = userDataVM
        present(userTableVC, animated: false)
        //        print("frame after pressed \(toSearchButton.frame)")
        
    }
    
    
    
    func setUpNavBarView() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
//        print("This is status bar height \(statusBarHeight)")
        self.view.addSubview(navBarView)
        self.navBarView.frame = CGRect(x: -5, y: -5, width: self.view.frame.width + 10, height: (self.view.frame.height/12)+5)
        let navBarHeightRemaining = navBarView.frame.maxY - statusBarHeight
        navBarView.backButton.isHidden = true
        navBarView.postButton.isHidden = true
        self.navBarView.addSubview(toSettingsButton)
        self.navBarView.addSubview(toSearchButton)
        self.navBarView.backgroundColor = .clear
        self.navBarView.layer.borderWidth = 0.0
        
        let settingsTap = UITapGestureRecognizer(target: self, action: #selector(self.toSettingsClicked))
        settingsTap.numberOfTapsRequired = 1
        toSettingsButton.isUserInteractionEnabled = true
        toSettingsButton.addGestureRecognizer(settingsTap)
        
        let searchTap = UITapGestureRecognizer(target: self, action: #selector(self.toSearchButtonClicked))
        searchTap.numberOfTapsRequired = 1
        toSearchButton.isUserInteractionEnabled = true
        toSearchButton.addGestureRecognizer(searchTap)
        

        self.toSettingsButton.setImage(UIImage(named: "lightGrayGearFinal"), for: .normal)
        self.toSearchButton.setImage(UIImage(named: "lightGrayMagnifyingGlassFinal"), for: .normal)
     
        self.toSettingsButton.frame = CGRect(x: 10, y: navBarView.frame.height - 30, width: 25, height: 25)
        self.toSettingsButton.frame = CGRect(x: 10, y: statusBarHeight + (navBarHeightRemaining - 25)/2, width: 25, height: 25)
        self.toSearchButton.frame = CGRect(x: navBarView.frame.width - 35, y: statusBarHeight + (navBarHeightRemaining - 25)/2, width: 25, height: 25)
      //  self.navBarView.addSubview(titleLabel1)
        self.navBarView.addBehavior()
        self.navBarView.titleLabel.isHidden = true
//        print("This is navBarView.")
        self.toSettingsButton.setImage(UIImage(named: "lightGrayGearFinal"), for: .normal)
        self.toSearchButton.setImage(UIImage(named: "lightGrayMagnifyingGlassFinal"), for: .normal)

        if guestUserData?.publicID != userDataVM?.userData.value?.publicID {
            self.navBarView.addSubview(followView)
        }
        self.followView.backgroundColor = .white
        self.followView.frame = CGRect(x: self.view.frame.midX - 45, y: toSettingsButton.frame.minY, width: 90, height: 30)
        self.followView.layer.cornerRadius = followView.frame.size.width / 20
        self.followView.addSubview(followImage)
        self.followView.addSubview(followLabel)
        
        //self.followView.isHidden = false
        self.followImage.frame = CGRect(x: 5, y: 0, width: followView.frame.height, height: followView.frame.height)
        self.followView.layer.cornerRadius = followView.frame.size.width/10
        //self.followView.clipsToBounds()
        
        if isFollowing {
            self.followView.isHidden = true
            self.followImage.image = UIImage(named: "friendCheck")
            self.followLabel.text = "Added"
        }
        else {
            self.followView.isHidden = false
            self.followImage.image = UIImage(named: "addFriend")
            self.followLabel.text = "Add"
        }
        
        //self.followImage.image = UIImage(named: "friendCheck")
        self.followLabel.frame = CGRect(x: followImage.frame.maxX + 5, y: 0.0, width: followView.frame.width - 10, height: followView.frame.height)
        //self.followLabel.text = "Added"
        self.followLabel.textColor = .black
        let tapped = UITapGestureRecognizer(target: self, action: #selector(followTapped))
        self.followView.addGestureRecognizer(tapped)
        
        

    }
    
    
    @objc func toSettingsClicked(_ recognizer: UITapGestureRecognizer) {
        let settingsVC = self.storyboard!.instantiateViewController(identifier: "settingsVC") as! ProfessionalSettingsVC
        settingsVC.userDataVM = userDataVM
        
        self.present(settingsVC, animated: false)
        settingsVC.modalPresentationStyle = .fullScreen
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
        //        print("This us username for openSnapchat \(username)")
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
    
    
    func populateUserAvatar() {
        // to for hexstruct array once algorithm done
        if avaImage != nil {
            avaImage?.removeFromSuperview()
        }
        avaImage = UIImageView(frame: CGRect(x: self.reOrderedCoordinateArrayPoints[0].x, y: self.reOrderedCoordinateArrayPoints[0].y, width: hexaDiameter, height: hexaDiameter))
        avaImage?.contentMode = .scaleAspectFill
        avaImage?.image = UIImage()
        avaImage?.tag = 0
        contentView.addSubview(avaImage!)
        avaImage?.isUserInteractionEnabled = true
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(handleProfilePicTap))
        avaImage?.addGestureRecognizer(tapGesture1)
        let interaction = UIContextMenuInteraction(delegate: self)
        avaImage?.addInteraction(interaction)
        avaImage?.isHidden = false
        contentView.bringSubviewToFront(avaImage!)
    //    avaImage!.setupHexagonMask(lineWidth: 10.0, color: .white, cornerRadius: 10.0)
        let scaleFactor = CGFloat(0.10)
        let widthShavedOff = scaleFactor*CGFloat((avaImage?.frame.width)!)
        let smallerFrame = CGRect(x: avaImage!.frame.minX, y: avaImage!.frame.minY, width: (avaImage!.frame.width)*CGFloat(0.90), height: (avaImage!.frame.height)*CGFloat(0.90))
        avaImage?.frame = smallerFrame
        avaImage?.frame = CGRect(x: smallerFrame.minX + (widthShavedOff/2), y: smallerFrame.minY + (widthShavedOff/2), width: smallerFrame.width, height: smallerFrame.height)
        avaImage?.layer.cornerRadius = ((avaImage?.frame.size.width)!)/2
        avaImage?.clipsToBounds = true
        avaImage?.layer.masksToBounds = true
        avaImage?.layer.borderColor = UIColor.white.cgColor
        avaImage?.layer.borderWidth = ((avaImage?.frame.width)!)/30
        let cleanRef = guestUserData!.avaRef.replacingOccurrences(of: "/", with: "%2F")
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/bio-social-media.appspot.com/o/\(cleanRef)?alt=media")
        if (url == nil) {
            avaImage?.image = UIImage(named: "user-2")
            return
        }
        avaImage?.sd_setImage(with: url!, completed: {_, error, _, _ in
            if error != nil {
                print(error!.localizedDescription)
                self.avaImage?.image = UIImage(named: "user-2")
            }
        })
    }
    

    
    func dismissFullscreenImage(view: UIView) {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        returnButton.isHidden = false
        view.removeFromSuperview()
    }
    

    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        
        
        let postImage = sender.view as! PostImageView
        let hexItem = postImage.hexData!
        
//        contentPages!.currentIndex = hexItem.location - 1
        if contentPages!.setPresentedViewControllers(vcIndex: hexItem.location - 1) {
            contentPages!.modalPresentationStyle = .fullScreen
            self.present(contentPages!, animated: false, completion: nil)
        }
        
        
        
//        //TO DO: Tap to Play Video
//        if hexItem.type.contains("video") {
//            //TO DO: play a video here!!
//            let videoVC = ContentVideoVC()
//            videoVC.videoHex = hexItem
//            present(videoVC, animated: false, completion: nil)
//
//        }
//
//
//
//        else if hexItem.type.contains("photo") {
//            //            let contentImageVC = ContentImageVC()
//            //            contentImageVC.photoHex = hexItem
//            //            present(contentImageVC, animated: false, completion: nil)
//            contentPages!.currentIndex = hexItem.location - 1
//            contentPages!.modalPresentationStyle = .fullScreen
//            self.present(contentPages!, animated: false, completion: nil)
//
//        }
//        else if hexItem.type.contains("link") {
//            //            openLinkVC(hex: hexItem)
//            contentPages!.currentIndex = hexItem.location - 1
//            contentPages!.modalPresentationStyle = .fullScreen
//            self.present(contentPages!, animated: false, completion: nil)
//        }
//        else if hexItem.type.contains("music") {
//            //            openLinkVC(hex: hexItem)
//            contentPages!.currentIndex = hexItem.location - 1
//            contentPages!.modalPresentationStyle = .fullScreen
//            self.present(contentPages!, animated: false, completion: nil)
//        }
//
//        else {
//            contentPages!.currentIndex = hexItem.location - 1
//            contentPages!.modalPresentationStyle = .fullScreen
//            self.present(contentPages!, animated: false, completion: nil)
//
//        }
        
    }
    
    @objc func dismissFullscreenImageHandler(_ sender: UITapGestureRecognizer) {
        dismissFullscreenImage(view: sender.view!)
        newImageView.removeFromSuperview()
        dismissFullscreenImage(view: newImageView)
    }
    
    func createHexagonMaskWithCorrespondingColor(imageView: UIImageView, type: String) {
        if type == "photo" {
            imageView.setupHexagonMask(lineWidth: imageView.frame.width/15, color: myOrange, cornerRadius: imageView.frame.width/15)
        }
        else if type == "video" {
            imageView.setupHexagonMask(lineWidth: imageView.frame.width/15, color: myOrange, cornerRadius: imageView.frame.width/15)
        }
        else if type == "tik" {
            imageView.setupHexagonMask(lineWidth: imageView.frame.width/15, color: .white, cornerRadius: imageView.frame.width/15)
        }
        else if type == "music" {
            imageView.setupHexagonMask(lineWidth: imageView.frame.width/15, color: myBlueGreen, cornerRadius: imageView.frame.width/15)
        }
        else if type == "link" {
            imageView.setupHexagonMask(lineWidth: imageView.frame.width/15, color: myCoolBlue, cornerRadius: imageView.frame.width/15)
        }
        else if type == "pin_phone" {
            imageView.backgroundColor = white
            imageView.setupHexagonMask(lineWidth: imageView.frame.width/15, color: .clear, cornerRadius: imageView.frame.width/15)
        }
        else if type == "pin_country" {
            imageView.setupHexagonMask(lineWidth: imageView.frame.width/15, color: .clear, cornerRadius: imageView.frame.width/15)
        }
        else if type == "pin_city" {
            imageView.setupHexagonMask(lineWidth: imageView.frame.width/15, color: .clear, cornerRadius: imageView.frame.width/15)
        }
        else if type == "pin_relationship" {
            imageView.setupHexagonMask(lineWidth: imageView.frame.width/15, color: .clear, cornerRadius: imageView.frame.width/15)
        }
        else if type == "pin_birthday" {
            imageView.setupHexagonMask(lineWidth: imageView.frame.width/15, color: .clear, cornerRadius: imageView.frame.width/15)
        }
        else if type.contains("social") {
            if type.contains("tik") {
                //white border for tik tok with black logo
                imageView.setupHexagonMask(lineWidth: imageView.frame.width/15, color: .white, cornerRadius: imageView.frame.width/15)
            }
            if type.contains("cameo") {
                //white border for tik tok with black logo
                imageView.setupHexagonMask(lineWidth: imageView.frame.width/15, color: .white, cornerRadius: imageView.frame.width/15)
            }
            
            else {
            //clear border
            imageView.setupHexagonMask(lineWidth: imageView.frame.width/15, color: .clear, cornerRadius: imageView.frame.width/15)
            }
        }
        else if type.contains("youtube") {
            // chooseSpecificSocialMedia(type: type, imageView: imageView)
            //clear border
            imageView.setupHexagonMask(lineWidth: imageView.frame.width/15, color: .clear, cornerRadius: imageView.frame.width/15)
            
        }
        else {
            imageView.setupHexagonMask(lineWidth: imageView.frame.width/15, color: white, cornerRadius: imageView.frame.width/15)
        }
        
    }
    
    @objc func handleProfilePicTap(_ sender: UITapGestureRecognizer) {
        let guestProfileVC = self.storyboard!.instantiateViewController(identifier: "guestProfileVC") as! GuestProfileVC
        guestProfileVC.guestUserData = guestUserData
        guestProfileVC.userDataVM = userDataVM
     //   guestProfileVC.isFollowing = sender.view?.tag == 1
        self.present(guestProfileVC, animated: false)
        self.modalPresentationStyle = .fullScreen

    }
    
    
    
    @objc func handleProfilePicTapView(_ sender: UITapGestureRecognizer) {
        //            print("Tried to click profile pic handle later")
        //  menuView.menuButton.isHidden = true
        newImageView = UIImageView(image: UIImage(named: "kbit"))
        let cleanRef = guestUserData!.avaRef.replacingOccurrences(of: "/", with: "%2F")
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/bio-social-media.appspot.com/o/\(cleanRef)?alt=media")
        newImageView.sd_setImage(with: url!, completed: {_, error, _, _ in
            if error != nil {
                print(error!.localizedDescription)
            }
        })
        
        self.view.addSubview(newImageView)
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        newImageView.frame = frame
        newImageView.backgroundColor = .black
        
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImageHandler))
        profilePicCancelButton.addGestureRecognizer(tap)
        profilePicCancelButton.isUserInteractionEnabled = true
        view.addSubview(profilePicCancelButton)
        profilePicCancelButton.frame = CGRect(x: view.frame.width/2-40, y: view.frame.height-112, width: 80, height: 80)
        profilePicCancelButton.setImage(UIImage(named: "cancel2"), for: .normal)
        view.bringSubviewToFront(profilePicCancelButton)
        profilePicCancelButton.layer.cornerRadius = profilePicCancelButton.frame.size.width / 2
        profilePicCancelButton.backgroundColor = .clear
        //profilePicCancelButton.backgroundColor = .black
        //returnButton.setBackgroundImage(UIImage(named: "cancel11"), for: .normal)
        profilePicCancelButton.clipsToBounds = true
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

