//
//  HomeHexagonGrid.swift
//  Bio
//
//  Created by Ann McDonough on 7/30/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//


import UIKit
import AVKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import FirebaseUI
import SDWebImage
import WebKit

import SwiftUI

class GuestHexagonGridVC: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate, WKUIDelegate  {
    
    var isFollowing = false
    var profileImage = UIImage()
    var followList = [String]()
    var followListener: ListenerRegistration?
    
    // Content presentation
    var player = AVAudioPlayer()
    var contentViewer = UIView()
    let menuView = MenuView()
    @IBOutlet weak var toSearchButton: UIButton!
    var followView = UIView()
    
    // Firebase stuff
    var loadDataListener: ListenerRegistration?
    var user = Auth.auth().currentUser
    var userData: UserData?
    var username: String?
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    
    // UI stuff
    @objc var panGesture  = UIPanGestureRecognizer()
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
   
    @IBOutlet weak var returnButton: UIButton!
    
    @IBOutlet weak var toSettingsButton: UIButton!
    
    var followImage = UIImageView()
    var followLabel = UILabel()

    var curvedRect = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
    var curvedLayer = UIImageView()
    
    // Flags and tags
    var firstLoad  = true
    
    // arrays
    var targetHexagons: [Int] = []
    //var hexagonStructArray: [HexagonStructData] = []
    var imageViewArray: [PostImageView] = []
    
    var reOrderedCoordinateArrayPoints: [CGPoint] = [CGPoint(x: 946.8266739736607,y: 902.5),CGPoint(x: 1081.7304845413264,y: 902.5),CGPoint(x: 1014.2785792574934,y: 1020.0), CGPoint(x: 879.3747686898278,y: 1020.0),CGPoint(x:811.9228634059948,y: 902.5), CGPoint(x: 879.3747686898278,y: 785.0),CGPoint(x: 1014.2785792574934,y: 785.0),CGPoint(x:946.8266739736607,y: 667.5),CGPoint(x:1081.7304845413264,y:667.5), CGPoint(x:1149.1823898251594,y:785.0),CGPoint(x: 1216.6342951089923,y: 902.5),CGPoint(x:1149.1823898251594,y: 1020.0),   CGPoint(x: 1081.7304845413264,y: 1137.5), CGPoint(x:1081.7304845413264, y: 1137.5),CGPoint(x:946.8266739736607,y: 1137.5),CGPoint(x: 811.9228634059948, y: 1137.5),CGPoint(x: 744.4709581221618, y: 1020.0), CGPoint(x: 677.0190528383291, y: 902.5),CGPoint(x: 744.4709581221618, y: 785.0), CGPoint(x: 811.9228634059948, y: 667.5),CGPoint(x: 879.3747686898278, y: 550.0),CGPoint(x: 1014.2785792574934, y: 550.0),CGPoint(x: 1149.1823898251594,y: 550.0),CGPoint(x:1216.6342951089923,y: 667.5),CGPoint(x:1284.0862003928253, y: 785.0),CGPoint(x:1351.5381056766582,y: 902.5), CGPoint(x:1284.0862003928253, y: 1020.0),CGPoint(x: 1216.6342951089923, y: 1137.5),CGPoint(x: 1149.1823898251594, y: 1255.0), CGPoint(x:1014.2785792574934,y:1255.0),CGPoint(x:879.3747686898278, y:1255.0),CGPoint(x:744.4709581221618, y:1255.0),CGPoint(x:677.0190528383291, y:1137.5),CGPoint(x:609.5671475544962,y: 1020.0),CGPoint(x:542.1152422706632, y: 902.5),CGPoint(x: 609.5671475544962, y: 785.0),CGPoint(x: 677.0190528383291, y: 667.5),CGPoint(x: 744.4709581221618, y: 550.0)]
    
    var reOrderedCoordinateArrayPointsCentered: [CGPoint] = []
    let hexaDiameter : CGFloat = 150
    var avaImage: UIImageView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSettingsButton()
        addSearchButton()
        toSettingsButton.isHidden = false
        toSearchButton.isHidden = false
        setUpScrollView()
        setZoomScale()
        addReturnButton()
        insertFollowButton()
        followView.isHidden = false
        let contentTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleContentViewerTap))
        contentViewer.addGestureRecognizer(contentTapGesture)
        
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
        resizeScrollView(numPosts: 0)
    }
    
    func addSearchButton() {
       // self.view.addSubview(toSearchButton)
        toSearchButton.frame = CGRect(x: self.view.frame.width-45, y: 25, width: 30, height: 30)
        self.view.addSubview(toSearchButton)
        view.bringSubviewToFront(toSearchButton)
        // round ava
        //        toSearchButton.layer.cornerRadius = toSearchButton.frame.size.width / 2
        toSearchButton.clipsToBounds = true
        toSearchButton.isHidden = false
    }
    
    func setZoomScale() {
           scrollView.maximumZoomScale = 60
           scrollView.minimumZoomScale = 0.5
    }
    
    func addSettingsButton(){
      //  view.addSubview(followButton)
        toSettingsButton.frame = CGRect(x: 0, y: 25, width: 30, height: 30)
        view.addSubview(toSettingsButton)
        view.bringSubviewToFront(toSettingsButton)
        toSettingsButton.imageView?.image = UIImage(named: "addFriend")
        toSettingsButton.layer.cornerRadius =  toSettingsButton.frame.size.width / 2
        toSettingsButton.clipsToBounds = true
        toSettingsButton.imageView?.backgroundColor = .clear
        
//        let tapped = UITapGestureRecognizer(target: self, action: #selector(followTapped))
//        toSettingsButton.addGestureRecognizer(tapped)
        
    }
    
    func insertFollowButton() {
        self.view.addSubview(followView)
        self.followView.backgroundColor = .white
        self.followView.frame = CGRect(x: self.view.frame.midX - 45, y: 25, width: 90, height: 30)
        self.followView.layer.cornerRadius = followView.frame.size.width / 20
        self.followView.addSubview(followImage)
        self.followView.addSubview(followLabel)
        self.followView.isHidden = false
        self.followImage.frame = CGRect(x: 5, y: 0, width: followView.frame.height, height: followView.frame.height)
        self.followView.layer.cornerRadius = followView.frame.size.width/10
        //self.followView.clipsToBounds()
        
        if isFollowing {
            self.followImage.image = UIImage(named: "friendCheck")
            self.followLabel.text = "Added"
        }
        else {
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
    
    
    
    @objc func followTapped(_ sender: UITapGestureRecognizer) {
        if userData != nil {
            if toSettingsButton!.tag == 0 {
                let newFollow = ["follower": username, "following": userData!.publicID]
                db.collection("Followings").addDocument(data: newFollow as [String : Any])
                UIDevice.vibrate()
                
                let notificationObjectref = db.collection("News2")
                   let notificationDoc = notificationObjectref.document()
                let notificationObject = NewsObject(ava: userData!.avaRef, type: "follow", currentUser: userData!.publicID, notifyingUser: userData!.publicID, thumbResource: userData!.avaRef, createdAt: NSDate.now.description, checked: false, notificationID: notificationDoc.documentID)
                   notificationDoc.setData(notificationObject.dictionary){ error in
                       //     group.leave()
                       if error == nil {
//                           print("added notification: \(notificationObject)")
                           
                       }
                       else {
                           print("failed to add notification \(notificationObject)")
                           
                       }
                   }
            
                
            }
            else {
                db.collection("Followings").whereField("follower", isEqualTo: userData!.publicID).whereField("following", isEqualTo: username).addSnapshotListener({ objects, error in
                    if error == nil {
                        guard let docs = objects?.documents else {
                            return
                        }
                        for doc in docs {
                            doc.reference.delete()
                        }
                    }
                    })
//                button?.imageView?.image = UIImage(named: "addFriend")
//                button?.frame = CGRect(x: width - width / 3.5 + 20, y: usernameLbl.frame.height - 20, width: width / 3.5, height: width/3.5)
//                button?.imageView?.frame = CGRect(x: width - width / 3.5 + 20, y: usernameLbl.frame.height - 20, width: width / 3.5, height: width/3.5)
                toSettingsButton?.tag = 0
            }
//          button?.frame = CGRect(x: width - width / 3.5 + 20, y: usernameLbl.frame.height - 20, width: width / 3.5, height: width/3.5)
//                         button?.imageView?.frame = CGRect(x: width - width / 3.5 + 20, y: usernameLbl.frame.height - 20, width: width / 3.5, height: width/3.5)
        }
    }
    
    func addReturnButton() {
        returnButton.frame = CGRect(x: view.frame.width/2-40, y: view.frame.height-112, width: 80, height: 80)
        view.bringSubviewToFront(returnButton)
        returnButton.layer.cornerRadius = returnButton.frame.size.width / 2
        returnButton.clipsToBounds = true
    }
    
    // Zoom Logic
    func resizeScrollView(numPosts: Int) {
//        print("Contentviewframebeforeresize \(contentView.frame)")
        //var rows = 0
        var width = view.frame.width
        var height = view.frame.height
        let additionalRowWidth: CGFloat = 340.0
        //     let heightDifference = height - width
        if numPosts < 7 {
            //rows = 1
            //self.scrollView.frame.width =
        }
        else if numPosts < 19 {
            //rows = 2
            width += additionalRowWidth
            height += additionalRowWidth
        }
        else if numPosts  < 43 {
            //rows = 3
            width += (2*additionalRowWidth)
            height += (2*additionalRowWidth)
        }
        else if numPosts < 91 {
            //rows = 4
            width += (3*additionalRowWidth)
            height += (3*additionalRowWidth)
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
        print(contentOffset)
        scrollView.contentOffset = contentOffset
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
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }
    
    func checkIfFollow() {
        
        
    }
    
//    func loadFollows(completion: @escaping() -> ()) {
//        followListener = db.collection("Followings").whereField("follower", isEqualTo: userData!.publicID).addSnapshotListener({ objects, error in
//            if error == nil {
//                self.followList.removeAll(keepingCapacity: true)
//                guard let docs = objects?.documents else {
//                    return
//                }
//                for doc in docs {
//                    print("follow item \(doc.data())")
//                    self.followList.append(doc["following"] as! String)
//                }
//            }
//            completion()
//        })
//    }
    
    
    // refresh logic when view will appear
    func refresh() {
        //loadView()
        
        if (userData != nil) {
            print("populates without getting userdata")
            populateUserAvatar()
            createImageViews()
            return
        }
        user = Auth.auth().currentUser
        if (user != nil) {
            db.collection("UserData1").whereField("email", isEqualTo: user!.email!).addSnapshotListener({ objects, error in
                if (error == nil) {
                    if (objects!.documents.capacity > 0) {
                        let newData = UserData(dictionary: objects!.documents[0].data())
                        if (self.userData == nil || !NSDictionary(dictionary: newData.dictionary).isEqual(to: self.userData!.dictionary)) {
                            self.userData = newData
                            print("populates after getting userdata")
                            self.populateUserAvatar()
                            self.createImageViews()
    //                        print("created image views")
                        }
                        else {
    //                        print("nothing changed")
                        }
                        
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
    }
    
    @IBAction func returnPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func createImageViews() {
        var newPostImageArray = [PostImageView]()
        db.collection("Hexagons2").whereField("postingUserID", isEqualTo: userData!.publicID).addSnapshotListener({ objects, error in
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
                self.resizeScrollView(numPosts: newPostImageArray.count) // clears out all content
//                print("populates after resizescrollview")
                self.populateUserAvatar()
                //if newPostImageArray != self.imageViewArray {
                    //for image in self.imageViewArray {
                        //image.removeFromSuperview()
                    //}
                self.imageViewArray = newPostImageArray
                self.changePostImageCoordinates()
                for image in self.imageViewArray {
                    self.contentView.addSubview(image)
                    self.contentView.bringSubviewToFront(image)
                    image.isHidden = false
                }
                //}
            }
        })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        toSearchButton.isHidden = true
        toSettingsButton.isHidden = true
        followView.isHidden = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        toSettingsButton.isHidden = false
        toSearchButton.isHidden = false
        followView.isHidden = false
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        toSearchButton.isHidden = false
        toSettingsButton.isHidden = false
        followView.isHidden = false
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        toSettingsButton.isHidden = false
        toSearchButton.isHidden = false
        followView.isHidden = false
    }
        
    func changePostImageCoordinates() {
        for image in imageViewArray {
            image.frame = CGRect(x: self.reOrderedCoordinateArrayPoints[image.hexData!.location].x,
                                 y: self.reOrderedCoordinateArrayPoints[image.hexData!.location].y, width: hexaDiameter, height: hexaDiameter)
            image.setupHexagonMask(lineWidth: 10.0, color: .darkGray, cornerRadius: 10.0)
        }
    }
    
    func createPostImage(hexData: HexagonStructData) -> PostImageView {
        let hexaDiameter : CGFloat = 150
        
     
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        
        let image = PostImageView(frame: CGRect(x: self.reOrderedCoordinateArrayPoints[hexData.location].x,
                                                y: self.reOrderedCoordinateArrayPoints[hexData.location].y, width: hexaDiameter, height: hexaDiameter))
        //print("This is contentView.center \(contentView.center)")
        //print("This is profile Pic Center \(self.reOrderedCoordinateArrayPoints[0].x), \(self.reOrderedCoordinateArrayPoints[0].y)")
        image.contentMode = .scaleAspectFill
        image.image = UIImage()
        image.hexData = hexData
        image.tag = hexData.location ?? 0
        
        image.addGestureRecognizer(tapGesture)
        image.isUserInteractionEnabled = true
        //    var gold = #colorLiteral(red: 0.9882352941, green: 0.7607843137, blue: 0, alpha: 1)
//        print("This is the type of hexagon: \(hexData.type)")
        var myType = hexData.type
        // image.setupHexagonMask(lineWidth: 10.0, color: myBlueGreen, cornerRadius: 10.0)
        createHexagonMaskWithCorrespondingColor(imageView: image, type: myType)
        //let ref = storage.child(hexData.thumbResource)
        let cleanRef = hexData.thumbResource.replacingOccurrences(of: "/", with: "%2F")
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/bio-social-media.appspot.com/o/\(cleanRef)?alt=media")
        image.sd_setImage(with: url!, completed: {_, error, _, _ in
            if error != nil {
                print(error!.localizedDescription)
            }
        })
        return image
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //loadView()
        super.viewWillAppear(true) // No need for semicolon
//        print("search button \(toSearchButton.frame)")
      //  firstLoad = truefollowView.isHidden = true
        toSearchButton.isHidden = false
        toSettingsButton.isHidden = false
        followView.isHidden = false
        refresh()
    }
    
    @IBAction func toSearchButtonClicked(_ sender: UIButton) {
        let userTableVC = storyboard?.instantiateViewController(identifier: "userTableVC") as! UserTableView
        userTableVC.userData = userData
        present(userTableVC, animated: false)
        //        print("frame after pressed \(toSearchButton.frame)")
        
    }
    
    
    @IBAction func toSettingsClicked(_ sender: UIButton) {
        let userdata = self.userData
        let settingsVC = self.storyboard!.instantiateViewController(identifier: "settingsVC") as! ProfessionalSettingsVC
        settingsVC.userData = userdata
    
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
        avaImage?.isHidden = false
        contentView.bringSubviewToFront(avaImage!)
        avaImage!.setupHexagonMask(lineWidth: 10.0, color: .white, cornerRadius: 10.0)
        let cleanRef = userData!.avaRef.replacingOccurrences(of: "/", with: "%2F")
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/bio-social-media.appspot.com/o/\(cleanRef)?alt=media")
        avaImage!.sd_setImage(with: url!, completed: {_, error, _, _ in
            if error != nil {
                print(error!.localizedDescription)
                self.avaImage?.image = UIImage(named: "boyprofile")
            }
        })
    }
    
    @objc func dismissFullscreenImageHandler(_ sender: UITapGestureRecognizer) {
        dismissFullscreenImage(view: sender.view!)
    }
    
    func dismissFullscreenImage(view: UIView) {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        returnButton.isHidden = false
        view.removeFromSuperview()
    }
    
    
//    @objc func handleTap(_ sender: UITapGestureRecognizer) {
//        //        print("🎯🎯🎯🎯🎯Hello World")
//        print("🎯🎯🎯🎯🎯🎯🎯I tapped image with tag \(sender.view!.tag)")
//
//        let postImage = sender.view as! PostImageView
//        let hexItem = postImage.hexData!
//
////        if sender.view!.tag == 0 {
////            print("Tried to click profile pic handle later")
////
////        }
//
//            //TO DO: Tap to Play Video
//        if hexItem.type.contains("video") {
//            //TO DO: play a video here!!
//            let playString = hexItem.resource
//           // play(url: hexagonStructArray[sender.view!.tag].resource)
////            print("This is url string \(playString)")
//            loadVideo(urlString: playString)
//            returnButton.isHidden = true
//        }
//
//
//        else if hexItem.type.contains("photo") {
//            returnButton.isHidden = true
//            let newImageView = UIImageView(image: UIImage(named: "kbit"))
//            let cleanRef = hexItem.thumbResource.replacingOccurrences(of: "/", with: "%2F")
//            let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/bio-social-media.appspot.com/o/\(cleanRef)?alt=media")
//            newImageView.sd_setImage(with: url!, completed: {_, error, _, _ in
//                if error != nil {
//                    print(error!.localizedDescription)
//                }
//            })
//            self.view.addSubview(newImageView)
//
//            // let newImageView = UIImageView(image: imageViewArray[sender.view!.tag].image)
//            //    let frame = CGRect(x: scrollView.frame.minX + scrollView.contentOffset.x, y: scrollView.frame.minY + scrollView.contentOffset.y, width: scrollView.frame.width, height: scrollView.frame.height)
//            let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
//
//            newImageView.frame = frame
//            newImageView.backgroundColor = .black
//
//            newImageView.contentMode = .scaleAspectFit
//            newImageView.isUserInteractionEnabled = true
//            let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImageHandler))
//            newImageView.addGestureRecognizer(tap)
//
//            let textView = UITextView()
//            textView.text = "asdfkjlasdfjasdf"
//            textView.textColor = .red
//
//        }
//        else if hexItem.type.contains("link") {
//            openLink(link: hexItem.resource)
//        }
//
//        else if hexItem.type.contains("social") {
//            let theType = hexItem.type
//            if theType.contains("instagram") {
//                openInstagram(instagramHandle: hexItem.text)
//            }
//            if theType.contains("twitter") {
//                openTwitter(twitterHandle: hexItem.text)
//            }
//            if theType.contains("tik") {
//                openTikTok(tikTokHandle: hexItem.text)
//            }
//            if theType.contains("snapchat") {
//                openSnapchat(snapchatUsername: hexItem.text)
//            }
//
//        }
//
//        //        if sender.view!.tag == 1 {
//        //            dismissFullscreenImage(view: newImageView)
//        //            openFacebook(facebookHandle: "")
//        //        }
//        //
//        //        if sender.view!.tag == 2 {
//        //            dismissFullscreenImage(view: newImageView)
//        //            openInstagram(instagramHandle: "patmcdonough42")
//        //        }
//        //
//        //        if sender.view!.tag == 3 {
//        //            dismissFullscreenImage(view: newImageView)
//        //            openTwitter(twitterHandle: "kanyewest")
//        //        }
//        //
//        //        if sender.view!.tag == 4 {
//        //            dismissFullscreenImage(view: newImageView)
//        //            openSpotifySong()
//        //        }
//
//    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {

        
        let postImage = sender.view as! PostImageView
        let hexItem = postImage.hexData!
        
        
        
        //TO DO: Tap to Play Video
        if hexItem.type.contains("video") {
            //TO DO: play a video here!!
            let playString = hexItem.resource
            // play(url: hexagonStructArray[sender.view!.tag].resource)
//            print("This is url string \(playString)")
            loadVideo(urlString: playString)
            self.menuView.menuButton.isHidden = true
        }
        
        
        
        else if hexItem.type.contains("photo") {
            self.menuView.menuButton.isHidden = true
            let newImageView = UIImageView(image: UIImage(named: "kbit"))
            let cleanRef = hexItem.thumbResource.replacingOccurrences(of: "/", with: "%2F")
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
            newImageView.addGestureRecognizer(tap)
            
            let textView = UITextView()
            textView.text = "asdfkjlasdfjasdf"
            textView.textColor = .red
            
        }
        else if hexItem.type.contains("link") {
            openLink(link: hexItem.resource)
        }
        else if hexItem.type.contains("music") {
            openLink(link: hexItem.resource)
        }
        
        else if hexItem.type.contains("social") {
            let theType = hexItem.type
            if theType.contains("instagram") {
                openInstagram(instagramHandle: hexItem.text)
            }
            if theType.contains("twitter") {
                openTwitter(twitterHandle: hexItem.text)
            }
            if theType.contains("tik") {
                openTikTok(tikTokHandle: hexItem.text)
            }
            if theType.contains("snapchat") {
                openSnapchat(snapchatUsername: hexItem.text)
            }
            if theType.contains("youtube") {
                openLink(link: hexItem.text)
            }
            if theType.contains("hudl") {
                openLink(link: hexItem.text)
            }
            if theType.contains("venmo") {
                openLink(link: hexItem.text)
            }
            if theType.contains("sound") {
                openLink(link: hexItem.text)
            }
            if theType.contains("linked") {
                openLink(link: hexItem.text)
            }
            if theType.contains("posh") {
                openLink(link: hexItem.text)
            }
          
            
        }
        
    }
    
    
    
    
    
    
    var navBarView: NavBarView?
    var webView: WKWebView?
    
    
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
        else if type.contains("social") {
       // chooseSpecificSocialMedia(type: type, imageView: imageView)
            //clear border
            imageView.setupHexagonMask(lineWidth: imageView.frame.width/15, color: .clear, cornerRadius: imageView.frame.width/15)
        
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
    
    func chooseSpecificSocialMedia(type: String, imageView: UIImageView) {
        if type.contains("insta") {
            imageView.setupHexagonMask(lineWidth: imageView.frame.width/15, color: myInstaPurple, cornerRadius: imageView.frame.width/15)
        }
        else if type.contains("twitter") {
            imageView.setupHexagonMask(lineWidth: imageView.frame.width/15, color: myTwitterBlue, cornerRadius: imageView.frame.width/15)
        }
        else if type.contains("tik") {
            imageView.setupHexagonMask(lineWidth: imageView.frame.width/15, color: white, cornerRadius: imageView.frame.width/15)
        }
        else if type.contains("hudl") {
            imageView.setupHexagonMask(lineWidth: imageView.frame.width/15, color: myHudlOrange, cornerRadius: imageView.frame.width/15)
        }
        else if type.contains("sound") {
            imageView.setupHexagonMask(lineWidth: imageView.frame.width/15, color: mySoundCloudOrange, cornerRadius: imageView.frame.width/15)
        }
        else if type.contains("snap") {
            imageView.setupHexagonMask(lineWidth: imageView.frame.width/15, color: mySnapChatYellow, cornerRadius: imageView.frame.width/15)
        }
        else if type.contains("posh") {
            imageView.setupHexagonMask(lineWidth: imageView.frame.width/15, color: myPoshmarkMaroon, cornerRadius: imageView.frame.width/15)
        }
        else if type.contains("linked") {
            imageView.setupHexagonMask(lineWidth: imageView.frame.width/15, color: myLinkedInBlue, cornerRadius: imageView.frame.width/15)
        }
        else if type.contains("venmo") {
            imageView.setupHexagonMask(lineWidth: imageView.frame.width/15, color: myVenmoBlue, cornerRadius: imageView.frame.width/15)
        }
        else {
            imageView.setupHexagonMask(lineWidth: imageView.frame.width/15, color: myPink, cornerRadius: imageView.frame.width/15)
        }

    }
    
    
    func openLink(link: String) {
        let backButton1 = UIButton()
        let webLabel = UILabel()
        
        let webConfig = WKWebViewConfiguration()
        navBarView = NavBarView()
        navBarView?.titleLabel.text = "Link"
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(backWebHandler))
        navBarView?.frame = CGRect(x: -5, y: -5, width: self.view.frame.width + 10, height: (self.view.frame.height/12)+5)
        //navBarView?.backButton.addGestureRecognizer(tapBack)
        let rect = CGRect(x: 0, y: navBarView!.frame.maxY, width: view.frame.width, height: view.frame.height - navBarView!.frame.height)
        webView = WKWebView(frame: rect, configuration: webConfig)
        webView?.uiDelegate = self
        view.addSubview(navBarView!)
        navBarView?.addBehavior()
        navBarView?.backgroundColor = .systemGray6
        navBarView?.addSubview(backButton1)
        navBarView?.addSubview(webLabel)
        
        webLabel.text = "Link"
        webLabel.frame = CGRect(x: navBarView!.frame.midX - 50, y: navBarView!.frame.midY - 5, width: 100, height: 30)
        webLabel.textAlignment = .center
        webLabel.font = UIFont(name: "DINAlternate-Bold", size: 20)
        
        
        backButton1.isUserInteractionEnabled = true
        backButton1.addGestureRecognizer(tapBack)
        backButton1.setTitle("Back", for: .normal)
        backButton1.setTitleColor(.systemBlue, for: .normal)
        backButton1.frame = CGRect(x: 5, y: navBarView!.frame.midY - 20, width: navBarView!.frame.width/8, height: self.view.frame.height/12)
        
        
        view.addSubview(webView!)
        returnButton.isHidden = true
        let myUrl = URL(string: link)
        if (myUrl != nil) {
            let myRequest = URLRequest(url: myUrl!)
            webView?.load(myRequest)
        }
        
    }
    @objc func backWebHandler(_ sender: UITapGestureRecognizer) {
        webView?.removeFromSuperview()
        navBarView?.removeFromSuperview()
        webView = nil
        navBarView = nil
        returnButton.isHidden = false
    }
    
    var avPlayer: AVPlayer? = nil
    // loads video into new avplayer and overlays on current VC
    
    func loadVideo(urlString: String) {
//        print("im in loadVideo")
        let vidRef = storage.child(urlString)
        vidRef.downloadURL(completion: { url, error in
            if error == nil {
                let asset = AVAsset(url: url!)
                let item = AVPlayerItem(asset: asset)
                self.view.addSubview(self.contentViewer)
                let contentRect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                self.contentViewer.frame = contentRect
                self.contentViewer.backgroundColor = .black
                self.avPlayer = AVPlayer(playerItem: item)
                let playerLayer = AVPlayerLayer(player: self.avPlayer)
                playerLayer.frame = self.contentViewer.bounds //bounds of the view in which AVPlayer should be displayed
                playerLayer.videoGravity = .resizeAspect
                self.contentViewer.layer.addSublayer(playerLayer)
                self.playVideo()
            }
        })
                
    }
    
    @objc func handleProfilePicTap(_ sender: UITapGestureRecognizer) {
//            print("Tried to click profile pic handle later")
          //  menuView.menuButton.isHidden = true
            let newImageView = UIImageView(image: UIImage(named: "kbit"))
            let cleanRef = userData!.avaRef.replacingOccurrences(of: "/", with: "%2F")
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
            newImageView.addGestureRecognizer(tap)
            
            let textView = UITextView()
            textView.text = "asdfkjlasdfjasdf"
            textView.textColor = .red
    }
    
    
    @objc func handleContentViewerTap(sender: UITapGestureRecognizer) {
        dismissContent(view: sender.view!)
        
    }
    func dismissContent(view: UIView){
        //self.navigationController?.isNavigationBarHidden = false
       // self.tabBarController?.tabBar.isHidden = false
        pauseVideo()
        //        for v in view.subviews {
        //            v.removeFromSuperview()
        //        }
        //        for layer in view.layer.sublayers {
        //        }
        view.removeFromSuperview()
        returnButton.isHidden = false
        
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

