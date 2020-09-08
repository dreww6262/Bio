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

class HomeHexagonGrid: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate, WKUIDelegate  {
    
    
    // Content presentation
    var player = AVAudioPlayer()
    var contentViewer = UIView()
    
    // Firebase stuff
    var loadDataListener: ListenerRegistration?
    var user = Auth.auth().currentUser
    var userData: UserData?
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    
    // UI stuff
    @objc var panGesture  = UIPanGestureRecognizer()
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var toSearchButton: UIButton!
    
    @IBOutlet weak var toSettingsButton: UIButton!
    let menuView = MenuView()
    var curvedRect = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
    var curvedLayer = UIImageView()
    
    // Flags and tags
    var firstLoad  = true
    
    // arrays
    var targetHexagons: [Int] = []
    //var hexagonStructArray: [HexagonStructData] = []
    var imageViewArray: [PostImageView] = []

    var reOrderedCoordinateArray: [[CGFloat]] = [[946.8266739736607, 902.5],[1081.7304845413264, 902.5], [1014.2785792574934, 1020.0],   [879.3747686898278,1020.0], [811.9228634059948,902.5], [879.3747686898278,785.0],[1014.2785792574934,785.0],[946.8266739736607, 667.5],[1081.7304845413264, 667.5], [1149.1823898251594, 785.0],  [1216.6342951089923, 902.5],[1149.1823898251594, 1020.0],   [1081.7304845413264, 1137.5], [1081.7304845413264, 1137.5],[946.8266739736607, 1137.5],[811.9228634059948, 1137.5],[744.4709581221618, 1020.0],[677.0190528383291, 902.5],[744.4709581221618, 785.0],  [811.9228634059948, 667.5],[879.3747686898278, 550.0],[1014.2785792574934, 550.0],[1149.1823898251594, 550.0],[1216.6342951089923, 667.5],[1284.0862003928253, 785.0],[1351.5381056766582, 902.5], [1284.0862003928253, 1020.0], [1216.6342951089923, 1137.5],[1149.1823898251594, 1255.0], [1014.2785792574934, 1255.0],[879.3747686898278, 1255.0],  [744.4709581221618, 1255.0],[677.0190528383291, 1137.5],[609.5671475544962, 1020.0],[542.1152422706632, 902.5],[609.5671475544962, 785.0],[677.0190528383291, 667.5],[744.4709581221618, 550.0]] // , /[811.9228634059948, 432.5], [946.8266739736607, 432.5], [1081.7304845413264, 432.5], [1216.6342951089923, 432.5],[1284.0862003928253, 550.0],[1351.5381056766582, 667.5], [1418.990010960491, 785.0],  [1486.441916244324, 902.5], [1418.990010960491, 1020.0],[1351.5381056766582, 1137.5],   [1284.0862003928253, 1255.0],[1216.6342951089923, 1372.5],   [1081.7304845413264, 1372.5],[946.8266739736607, 1372.5],[811.9228634059948, 1372.5],[677.0190528383291, 1372.5], [609.5671475544962, 1255.0],[542.1152422706632, 1137.5],[474.6633369868303, 1020.0],[407.2114317029974, 902.5],[474.6633369868303, 785.0],[542.1152422706632, 667.5],[609.5671475544962, 550.0],[677.0190528383291, 432.5]]
    
    //with 3rd row
    //    var reOrderedCoordinateArrayPoints: [CGPoint] = [CGPoint(x: 946.8266739736607,y: 902.5),CGPoint(x: 1081.7304845413264,y: 902.5),CGPoint(x: 1014.2785792574934,y: 1020.0), CGPoint(x: 879.3747686898278,y: 1020.0),CGPoint(x:811.9228634059948,y: 902.5), CGPoint(x: 879.3747686898278,y: 785.0),CGPoint(x: 1014.2785792574934,y: 785.0),CGPoint(x:946.8266739736607,y: 667.5),CGPoint(x:1081.7304845413264,y:667.5), CGPoint(x:1149.1823898251594,y:785.0),CGPoint(x: 1216.6342951089923,y: 902.5),CGPoint(x:1149.1823898251594,y: 1020.0),   CGPoint(x: 1081.7304845413264,y: 1137.5), CGPoint(x:1081.7304845413264, y: 1137.5),CGPoint(x:946.8266739736607,y: 1137.5),CGPoint(x: 811.9228634059948, y: 1137.5),CGPoint(x: 744.4709581221618, y: 1020.0), CGPoint(x: 677.0190528383291, y: 902.5),CGPoint(x: 744.4709581221618, y: 785.0), CGPoint(x: 811.9228634059948, y: 667.5),CGPoint(x: 879.3747686898278, y: 550.0),CGPoint(x: 1014.2785792574934, y: 550.0),CGPoint(x: 1149.1823898251594,y: 550.0),CGPoint(x:1216.6342951089923,y: 667.5),CGPoint(x:1284.0862003928253, y: 785.0),CGPoint(x:1351.5381056766582,y: 902.5), CGPoint(x:1284.0862003928253, y: 1020.0),CGPoint(x: 1216.6342951089923, y: 1137.5),CGPoint(x: 1149.1823898251594, y: 1255.0), CGPoint(x:1014.2785792574934,y:1255.0),CGPoint(x:879.3747686898278, y:1255.0),CGPoint(x:744.4709581221618, y:1255.0),CGPoint(x:677.0190528383291, y:1137.5),CGPoint(x:609.5671475544962,y: 1020.0),CGPoint(x:542.1152422706632, y: 902.5),CGPoint(x: 609.5671475544962, y: 785.0),CGPoint(x: 677.0190528383291, y: 667.5),CGPoint(x: 744.4709581221618, y: 550.0),CGPoint(x:811.9228634059948,y: 432.5), CGPoint(x: 946.8266739736607,y: 432.5), CGPoint(x:1081.7304845413264, y: 432.5), CGPoint(x: 1216.6342951089923,y: 432.5),CGPoint(x: 1284.0862003928253,y: 550.0),CGPoint(x:1351.5381056766582, y: 667.5), CGPoint(x:1418.990010960491,y: 785.0),  CGPoint(x: 1486.441916244324,y:902.5), CGPoint(x:1418.990010960491, y: 1020.0),CGPoint(x: 1351.5381056766582, y: 1137.5), CGPoint(x:1284.0862003928253,y: 1255.0),CGPoint(x: 1216.6342951089923,y: 1372.5),   CGPoint(x: 1081.7304845413264,y: 1372.5),CGPoint(x: 946.8266739736607, y: 1372.5),CGPoint(x: 811.9228634059948, y: 1372.5),CGPoint(x: 677.0190528383291,y: 1372.5), CGPoint(x: 609.5671475544962,y: 1255.0),CGPoint(x: 542.1152422706632,y: 1137.5),CGPoint(x: 474.6633369868303,y: 1020.0),CGPoint(x: 407.2114317029974, y: 902.5),CGPoint(x: 474.6633369868303, y: 785.0),CGPoint(x: 542.1152422706632,y: 667.5),CGPoint(x: 609.5671475544962,y: 550.0),CGPoint(x: 677.0190528383291, y: 432.5)]
    
    var reOrderedCoordinateArrayPoints: [CGPoint] = [CGPoint(x: 946.8266739736607,y: 902.5),CGPoint(x: 1081.7304845413264,y: 902.5),CGPoint(x: 1014.2785792574934,y: 1020.0), CGPoint(x: 879.3747686898278,y: 1020.0),CGPoint(x:811.9228634059948,y: 902.5), CGPoint(x: 879.3747686898278,y: 785.0),CGPoint(x: 1014.2785792574934,y: 785.0),CGPoint(x:946.8266739736607,y: 667.5),CGPoint(x:1081.7304845413264,y:667.5), CGPoint(x:1149.1823898251594,y:785.0),CGPoint(x: 1216.6342951089923,y: 902.5),CGPoint(x:1149.1823898251594,y: 1020.0),   CGPoint(x: 1081.7304845413264,y: 1137.5), CGPoint(x:1081.7304845413264, y: 1137.5),CGPoint(x:946.8266739736607,y: 1137.5),CGPoint(x: 811.9228634059948, y: 1137.5),CGPoint(x: 744.4709581221618, y: 1020.0), CGPoint(x: 677.0190528383291, y: 902.5),CGPoint(x: 744.4709581221618, y: 785.0), CGPoint(x: 811.9228634059948, y: 667.5),CGPoint(x: 879.3747686898278, y: 550.0),CGPoint(x: 1014.2785792574934, y: 550.0),CGPoint(x: 1149.1823898251594,y: 550.0),CGPoint(x:1216.6342951089923,y: 667.5),CGPoint(x:1284.0862003928253, y: 785.0),CGPoint(x:1351.5381056766582,y: 902.5), CGPoint(x:1284.0862003928253, y: 1020.0),CGPoint(x: 1216.6342951089923, y: 1137.5),CGPoint(x: 1149.1823898251594, y: 1255.0), CGPoint(x:1014.2785792574934,y:1255.0),CGPoint(x:879.3747686898278, y:1255.0),CGPoint(x:744.4709581221618, y:1255.0),CGPoint(x:677.0190528383291, y:1137.5),CGPoint(x:609.5671475544962,y: 1020.0),CGPoint(x:542.1152422706632, y: 902.5),CGPoint(x: 609.5671475544962, y: 785.0),CGPoint(x: 677.0190528383291, y: 667.5),CGPoint(x: 744.4709581221618, y: 550.0)]
    
    //,CGPoint(x:811.9228634059948,y: 432.5), CGPoint(x: 946.8266739736607,y: 432.5), CGPoint(x:1081.7304845413264, y: 432.5), CGPoint(x: 1216.6342951089923,y: 432.5),CGPoint(x: 1284.0862003928253,y: 550.0),CGPoint(x:1351.5381056766582, y: 667.5), CGPoint(x:1418.990010960491,y: 785.0),  CGPoint(x: 1486.441916244324,y:902.5), CGPoint(x:1418.990010960491, y: 1020.0),CGPoint(x: 1351.5381056766582, y: 1137.5), CGPoint(x:1284.0862003928253,y: 1255.0),CGPoint(x: 1216.6342951089923,y: 1372.5),   CGPoint(x: 1081.7304845413264,y: 1372.5),CGPoint(x: 946.8266739736607, y: 1372.5),CGPoint(x: 811.9228634059948, y: 1372.5),CGPoint(x: 677.0190528383291,y: 1372.5), CGPoint(x: 609.5671475544962,y: 1255.0),CGPoint(x: 542.1152422706632,y: 1137.5),CGPoint(x: 474.6633369868303,y: 1020.0),CGPoint(x: 407.2114317029974, y: 902.5),CGPoint(x: 474.6633369868303, y: 785.0),CGPoint(x: 542.1152422706632,y: 667.5),CGPoint(x: 609.5671475544962,y: 550.0),CGPoint(x: 677.0190528383291, y: 432.5)]
    var reOrderedCoordinateArrayPointsCentered: [CGPoint] = []
    let hexaDiameter : CGFloat = 150
    var avaImage: UIImageView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpScrollView()
        setZoomScale()
        addMenuButtons()
        addSearchButton()
        addSettingsButton()
        addTrashButton()
        for point in reOrderedCoordinateArrayPoints {
            let newPointX = point.x - 604 //680
            let newPointY = point.y - 493 //570
            let newPoint = CGPoint(x: newPointX, y: newPointY)
            reOrderedCoordinateArrayPointsCentered.append(newPoint)
        }
        let contentTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleContentViewerTap))
        contentViewer.addGestureRecognizer(contentTapGesture)
        
        if userData == nil {
            user = Auth.auth().currentUser
            if (user != nil) {
                db.collection("UserData1").whereField("email", isEqualTo: user!.email!).addSnapshotListener({ objects, error in
                    if error == nil {
                        guard let docs = objects?.documents
                            else{
                                print("bad docs")
                                return
                        }
                        
                        if docs.count == 0 {
                            print("no userdata found.... fix this")
                        }
                        else if docs.count > 1 {
                            print("multiple user data.... fix this")
                        }
                        else {
                            self.userData = UserData(dictionary: docs[0].data())
                        }
                    }
                    
                })
            }
        }
    }
    
    // viewdidload helper functions
    func setUpScrollView() {
        // Do any additional setup after loading the view.
        let hexaDiameter : CGFloat = 150
        let hexaWidth = hexaDiameter * sqrt(3) * 0.5
        //let hexaWidthDelta = (hexaDiameter - hexaWidth) * 0.5
        let hexaHeightDelta = hexaDiameter * 0.25
        let spacing : CGFloat = 5
        
        let rows = 15
        let firstRowColumns = 15
        //scroll view stuff 2
//        print("Bounds of zoomview: \(contentView.bounds.size)")
        self.scrollView.contentSize = CGSize(width: spacing + CGFloat(firstRowColumns) * (hexaWidth + spacing), height: spacing + CGFloat(rows) * (hexaDiameter - hexaHeightDelta + spacing) + hexaHeightDelta)
//        print("scrollview content size \(scrollView.contentSize)")
        
        
        //scrollViewStuff1
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let location = CGPoint(x: reOrderedCoordinateArrayPoints[0].x - self.view.frame.width*2.125, y: reOrderedCoordinateArrayPoints[0].y - self.view.frame.height*1.2)
        self.scrollView.contentOffset = location
        
        //        let bg = UIImageView(frame: CGRect(x: -400, y: -400, width: 3000, height: 3000))
        //        bg.backgroundColor = .black
        //        bg.layer.zPosition = -1
        scrollView.backgroundColor = .black
        
        
        contentView.backgroundColor = .black
        contentView.isHidden = false
        
        scrollView.addSubview(contentView)
        contentView.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
        scrollView.bringSubviewToFront(contentView)
        
        view.addSubview(scrollView)
        scrollView.delegate = self
    }
    
    func setZoomScale() {
           //let imageViewSize = contentView.bounds.size
           //let scrollViewSize = scrollView.bounds.size
           //let widthScale = scrollViewSize.width / imageViewSize.width
           //let heightScale = scrollViewSize.height / imageViewSize.height
           
//           print("width scale: \(widthScale)")
//           print("height scale: \(heightScale)")
           // scrollView.minimumZoomScale = min(widthScale, heightScale)
           //scrollView.zoomScale = scrollView.minimumZoomScale
           scrollView.maximumZoomScale = 60
           scrollView.minimumZoomScale = 0.5
    }
    
    func addMenuButtons() {
        view.addSubview(menuView)
        menuView.currentTab = 2
        menuView.addBehavior()
    }
    
    func addSearchButton() {
        self.view.addSubview(toSearchButton)
        toSearchButton.frame = CGRect(x: self.view.frame.width-60, y: 20, width: 50, height: 50)
        // round ava
        toSearchButton.layer.cornerRadius = toSearchButton.frame.size.width / 2
        toSearchButton.clipsToBounds = true
        toSearchButton.isHidden = false
    }
    
    func addSettingsButton() {
           self.view.addSubview(toSettingsButton)
           toSettingsButton.frame = CGRect(x: 10, y: 20, width: 50, height: 50)
           // round ava
           toSettingsButton.layer.cornerRadius = toSettingsButton.frame.size.width / 2
           toSettingsButton.clipsToBounds = true
           toSettingsButton.isHidden = false
       }
    
    func addTrashButton() {
        trashButton.frame = CGRect(x: self.view.frame.width/2-40, y: self.view.frame.height - 83, width: 80, height: 80)
        // round ava
        trashButton.layer.cornerRadius = trashButton.frame.size.width / 2
        trashButton.clipsToBounds = true
        trashButton.isHidden = true
    }
    
    // Zoom Logic
    func resizeScrollView(numPosts: Int) {
        var rows = 0
        var width = view.frame.width
        var height = view.frame.height
        let additionalRowWidth = ((view.frame.width/3) - 10)*2
        //     let heightDifference = height - width
        if numPosts < 7 {
            rows = 1
            //self.scrollView.frame.width =
        }
        else if numPosts < 19 {
            rows = 2
            width = width + additionalRowWidth
        }
        else if numPosts  < 43 {
            rows = 3
            width = width + (2*additionalRowWidth)
            height = height + (additionalRowWidth)
        }
        else if numPosts < 91 {
            rows = 4
            width = width + (3*additionalRowWidth)
            height = height + (2*additionalRowWidth)
        }
        //  var addedWidth = 2*(rows-1)*160
        // var addedHeight =  2 * (rows-1)*160
        self.scrollView.frame = CGRect(x: 0, y: 0, width: width, height:  height)
        self.contentView.frame = CGRect(x: 0, y: 0, width: width, height:  height)
        self.scrollView.contentSize = scrollView.frame.size
        
        
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
    
    
    // refresh logic when view will appear
    func refresh() {
        //loadView()
        
        if (userData != nil) {
            populateUserAvatar()
            menuView.userData = userData
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
                            self.populateUserAvatar()
                            self.menuView.userData = newData
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
    
    // search button logic
    @IBAction func toSearchButtonClicked(_ sender: UIButton) {
        let userTableVC = storyboard?.instantiateViewController(identifier: "userTableVC") as! UserTableView
        userTableVC.myUsername = userData?.publicID
        present(userTableVC, animated: false)
//        print("frame after pressed \(toSearchButton.frame)")
        
    }
    
    @IBAction func toSettingsButtonClicked(_ sender: UIButton) {
        let currentTab = 2
        menuView.currentTab = currentTab
        menuView.settingsButtonClicked(sender)
//        let viewControllers = tabController!.customizableViewControllers!
//             let settingsVC = (viewControllers[0] as! ProfessionalSettingsVC)
//        //     settingsVC.userData = userData
//             tabController!.viewControllers![0] = settingsVC
//             tabController!.customTabBar.switchTab(from: currentTab, to: 0)
//
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
                if newPostImageArray != self.imageViewArray {
                    for image in self.imageViewArray {
                        image.removeFromSuperview()
                    }
                    self.imageViewArray = newPostImageArray
                    for image in self.imageViewArray {
                        self.contentView.addSubview(image)
                        self.contentView.bringSubviewToFront(image)
                        image.isHidden = false
                    }
                }
            }
        })
    }
        
    
    
    func createPostImage(hexData: HexagonStructData) -> PostImageView {
        let hexaDiameter : CGFloat = 150
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longTap))
        //            let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(dragItem(_:)))
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        
        let image = PostImageView(frame: CGRect(x: self.reOrderedCoordinateArray[hexData.location][0]-680,
                                              y: self.reOrderedCoordinateArray[hexData.location][1]-570, width: hexaDiameter, height: hexaDiameter))
        image.contentMode = .scaleAspectFill
        image.image = UIImage()
        image.hexData = hexData
        image.tag = hexData.location
        
        image.addGestureRecognizer(longGesture)
        image.addGestureRecognizer(tapGesture)
        image.isUserInteractionEnabled = true
        //    var gold = #colorLiteral(red: 0.9882352941, green: 0.7607843137, blue: 0, alpha: 1)
        image.setupHexagonMask(lineWidth: 10.0, color: .darkGray, cornerRadius: 10.0)
        let ref = storage.child(hexData.thumbResource)
        image.sd_setImage(with: ref)
        return image
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //loadView()
        super.viewWillAppear(true) // No need for semicolon
//        print("search button \(toSearchButton.frame)")
        firstLoad = true
        menuView.tabController = (tabBarController! as! NavigationMenuBaseController)
        
        if (userData == nil) {
            user = Auth.auth().currentUser
            if (user != nil) {
                db.collection("UserData1").whereField("email", isEqualTo: user!.email!).addSnapshotListener({ objects, error in
                    if (error == nil) {
                        if (objects!.documents.capacity > 0) {
                            let newData = UserData(dictionary: objects!.documents[0].data())
                            self.menuView.userData = newData
                            self.userData = newData
                            self.refresh()
                        }
                    }
                })
            }
        }
        else {
            menuView.userData = userData
            refresh()
        }
    }
    
    
    var dragView : PostImageView? = nil
    @objc func longTap(_ sender: UIGestureRecognizer){
        print("Long tap")
        print("🎹🎹🎹🎹🎹🎹🎹🎹🎹")
        var currentHexagonCenter = CGPoint(x:0.0, y:0.0)
        let hexImage = sender.view! as! PostImageView
        if (sender.state == .ended) {
            
            currentHexagonCenter = (sender.view?.center)!
            let hexCenterInView = scrollView.convert(currentHexagonCenter, to: view)
            if (distance(hexCenterInView, trashButton.center) < 70) {
                // trash current hexagon
                hexImage.hexData!.isArchived = true
                // push update to server
                let docRef = db.collection("Hexagons2").document(hexImage.hexData!.docID)
                docRef.setData(hexImage.hexData!.dictionary) { error in
                    if error == nil {
                        self.userData!.numPosts -= 1
                        self.db.collection("UserData1").document(self.userData!.privateID).setData(self.userData!.dictionary)
                    }
                }
                for hex in imageViewArray {
                    if (hex.hexData!.location > hexImage.hexData!.location) {
                        hex.hexData!.location -= 1
                        db.collection("Hexagons2").document(hex.hexData!.docID).setData(hex.hexData!.dictionary)
                    }
                }
                refresh()
            }
            else {
                let intersectingHex = findIntersectingHexagon(hexView: dragView!)
                if (intersectingHex != nil) {
                    let tempLoc = intersectingHex!.hexData!.location
                    intersectingHex!.hexData!.location = dragView!.hexData!.location
                    dragView!.hexData!.location = tempLoc
                    print(dragView!.hexData!)
                    print(intersectingHex!.hexData!)
                    db.collection("Hexagons2").document(intersectingHex!.hexData!.docID).setData(intersectingHex!.hexData!.dictionary) { error in
                        if error == nil {
                            self.db.collection("Hexagons2").document(self.dragView!.hexData!.docID).setData(self.dragView!.hexData!.dictionary) { error in
                                self.refresh()
                            }
                        }
                    }
                }
                intersectingHex?.frame = CGRect(x: self.reOrderedCoordinateArray[intersectingHex!.hexData!.location][0]-680,
                                                y: self.reOrderedCoordinateArray[intersectingHex!.hexData!.location][1]-570, width: hexaDiameter, height: hexaDiameter)
                dragView?.frame = CGRect(x: self.reOrderedCoordinateArray[dragView!.hexData!.location][0]-680,
                                         y: self.reOrderedCoordinateArray[dragView!.hexData!.location][1]-570, width: hexaDiameter, height: hexaDiameter)
            }
            for hex in imageViewArray {
                hex.setupHexagonMask(lineWidth: 10.0, color: .darkGray, cornerRadius: 10.0)
            }
            trashButton.isHidden = true
            menuView.menuButton.isHidden = false

        }
        else if sender.state == .began {
            print("UIGestureRecognizerStateBegan.")
            let tappedImage = sender.view as! PostImageView
            currentHexagonCenter = tappedImage.center
            tappedImage.setupHexagonMask(lineWidth: 10.0, color: .red, cornerRadius: 10.0)
            //dragItem(sender as! UIPanGestureRecognizer)
            dragView = (sender.view as! PostImageView)
            dragView?.center = sender.location(in: scrollView)
            contentView.bringSubviewToFront(dragView!)
            trashButton.isHidden = false
        }
        else if (sender.state == .changed) {
            let xDelta = dragView!.center.x - sender.location(in: scrollView).x
            let yDelta = dragView!.center.y - sender.location(in: scrollView).y
            dragView?.center = sender.location(in: scrollView)
            
            self.scrollIfNeeded(location: sender.location(in: scrollView.superview), xDelta: xDelta, yDelta: yDelta)
            //                print("This is newIndex before \(newIndex)")
            currentHexagonCenter = (sender.view?.center)!
            let hexCenterInView = contentView.convert(currentHexagonCenter, to: view)
            let _ = findIntersectingHexagon(hexView: dragView!)
            
            print(distance(hexCenterInView, trashButton.center))
            if (distance(hexCenterInView, trashButton.center) < 70) {
                trashButton.imageView!.makeRoundedGold()
                print("It should be gold")
            } else {
                trashButton.imageView!.makeRounded()
                print("This is outside 70")
            }
        }
    }
    
    func findIntersectingHexagon(hexView: PostImageView) -> PostImageView? {
        //find coordinates of final location for hexagon
        let hexCenter = hexView.center
        let red = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        let gold = #colorLiteral(red: 0.9882352941, green: 0.7607843137, blue: 0, alpha: 1)
        for hex in self.imageViewArray {
            if (hex.hexData!.isArchived) {
                continue
            }
            else if hexView == hex {
                continue
            }
            else if distance(hexCenter, reOrderedCoordinateArrayPointsCentered[hex.hexData!.location]) < 110.0 {
                hex.setupHexagonMask(lineWidth: 10.0, color: red, cornerRadius: 10.0)
                return hex
            }
            else {
                hex.setupHexagonMask(lineWidth: 10.0, color: gold, cornerRadius: 10.0)
            }
        }
        return nil
    }
    
    func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt(xDist * xDist + yDist * yDist))
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
        print("This us username for openSnapchat \(username)")
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
        avaImage = UIImageView(frame: CGRect(x: self.reOrderedCoordinateArray[0][0]-680, y: self.reOrderedCoordinateArray[0][1]-570, width: hexaDiameter, height: hexaDiameter))
        avaImage?.contentMode = .scaleAspectFill
        avaImage?.image = UIImage()
        avaImage?.tag = 0
        contentView.addSubview(avaImage!)
        avaImage?.isHidden = false
        contentView.bringSubviewToFront(avaImage!)
        let ref = self.storage.child(userData!.avaRef)
        avaImage!.setupHexagonMask(lineWidth: 10.0, color: .white, cornerRadius: 10.0)
        avaImage!.sd_setImage(with: ref)
    }
    
    func scrollIfNeeded(location: CGPoint, xDelta: CGFloat, yDelta: CGFloat) {
        //        print("im in scrollifneeded")
        let scrollSuperview: UIView = scrollView.superview!
        let bounds: CGRect = scrollSuperview.bounds
        var scrollOffset: CGPoint = scrollView.contentOffset
        var xOfs: CGFloat = 0
        var yOfs: CGFloat = 0
        let speed: CGFloat = 10.0
        
        if ((location.x > bounds.size.width * 0.7) && (xDelta < 0)) {
            //            print("should be panning right")
            xOfs = CGFloat(CGFloat(speed) * location.x/bounds.size.width)
        }
        if ((location.y > bounds.size.height * 0.7) && (yDelta < 0)) {
            //            print("should be panning down")
            yOfs = CGFloat(CGFloat(speed) * location.y/bounds.size.height)
        }
        if ((location.x < bounds.size.width * 0.3) && (xDelta > 0))
        {
            //            print("should be panning left")
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
            //            print("should be panning up")
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
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        menuView.menuButton.isHidden = false
        view.removeFromSuperview()
    }
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        //        print("🎯🎯🎯🎯🎯Hello World")
        print("🎯🎯🎯🎯🎯🎯🎯I tapped image with tag \(sender.view!.tag)")
        
        let postImage = sender.view as! PostImageView
        let hexItem = postImage.hexData!
        
        if sender.view!.tag == 0 {
            print("Tried to click profile pic handle later")
            
        }
            
            //TO DO: Tap to Play Video
        else if hexItem.type.contains("video") {
            //TO DO: play a video here!!
            let playString = hexItem.resource
           // play(url: hexagonStructArray[sender.view!.tag].resource)
            print("This is url string \(playString)")
            loadVideo(urlString: playString)
            menuView.menuButton.isHidden = true
        }
            
            
        else if hexItem.type.contains("photo") {
            menuView.menuButton.isHidden = true
            let newImageView = UIImageView(image: UIImage(named: "kbit"))
            let ref = storage.child(hexItem.thumbResource)
            newImageView.sd_setImage(with: ref)
            self.view.addSubview(newImageView)
            
            // let newImageView = UIImageView(image: imageViewArray[sender.view!.tag].image)
            //    let frame = CGRect(x: scrollView.frame.minX + scrollView.contentOffset.x, y: scrollView.frame.minY + scrollView.contentOffset.y, width: scrollView.frame.width, height: scrollView.frame.height)
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
            
        }
        
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

    }
    
    
    var webView: WKWebView?
    func openLink(link: String) {
        let webConfig = WKWebViewConfiguration()
        let rect = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        webView = WKWebView(frame: rect, configuration: webConfig)
        webView?.uiDelegate = self
        view.addSubview(webView!)
        menuView.menuButton.isHidden = true
        let myUrl = URL(string: link)
        if (myUrl != nil) {
            let myRequest = URLRequest(url: myUrl!)
            webView?.load(myRequest)
        }
    }
    
    var avPlayer: AVPlayer? = nil
    // loads video into new avplayer and overlays on current VC
    
    func loadVideo(urlString: String) {
        print("im in loadVideo")
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
        menuView.menuButton.isHidden = false
        
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

extension UIImageView {
    
    func makeRounded() {
        
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
    
    func makeRoundedRed() {
        
        self.layer.borderWidth = 4
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
    
    func makeRoundedGold() {
        
        self.layer.borderWidth = 4
        self.layer.masksToBounds = false
        self.layer.borderColor = #colorLiteral(red: 0.9882352941, green: 0.7607843137, blue: 0, alpha: 1)
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
    
}

extension UIView {
    
    func startShimmering(){
        let light = UIColor.white.cgColor
        let alpha = UIColor.white.withAlphaComponent(0.7).cgColor
        
        let gradient = CAGradientLayer()
        gradient.colors = [alpha, light, alpha, alpha, light, alpha]
        gradient.frame = CGRect(x: -self.bounds.size.width, y: 0, width: 3 * self.bounds.size.width, height: self.bounds.size.height)
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.525)
        gradient.locations = [0.4, 0.5, 0.6]
        self.layer.mask = gradient
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue = [0.8, 0.9, 1.0]
        animation.duration = 1.5
        animation.repeatCount = HUGE
        gradient.add(animation, forKey: "shimmer")
    }
    
    func stopShimmering(){
        self.layer.mask = nil
    }
}
