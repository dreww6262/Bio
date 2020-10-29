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



class DiscoverGrid: UIViewController, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.followingUserDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileCircleCell", for: indexPath) as! ProfileCircleCell
        cell.imageView.frame = CGRect(x: cell.frame.width/16, y: 0, width: cell.frame.width*(14/16), height: cell.frame.height*(14/16))
        cell.label.frame = CGRect(x: 0, y: cell.imageView.frame.maxY, width: cell.frame.width, height: cell.frame.height - cell.imageView.frame.maxY)
        cell.tag = indexPath.row
        cell.imageView.tag = indexPath.row
        cell.label.tag = indexPath.row
        let tapCellGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCollectionViewTap))
        cell.addGestureRecognizer(tapCellGesture)
        cell.imageView.layer.cornerRadius = cell.imageView.frame.width/2
        // let ref = self.followingUserDataArray[indexPath.row].avaRef as! StorageReference
        cell.imageView.sd_setImage(with: storageRef.child(followingUserDataArray[indexPath.row].avaRef))
        //cell.imageView.sd_setImage(with: ref)
        cell.label.text = self.followingUserDataArray[indexPath.row].displayName
        cell.label.textColor = .white
        cell.label.font = UIFont(name: "DINAlternate-SemiBold", size: 12)
        return cell
    }
    
    var navBarY = CGFloat(39)
    var followView = UIView()
    var newFollowArray: [String] = []
    //var user = PFUser.current()!.username!
    @IBOutlet weak var profileCollectionView: UICollectionView!
    
    var navBarView = NavBarView()
    let menuView = MenuView()
    var user = Auth.auth().currentUser
    var storage = Storage.storage().reference()
    var contentViewer = UIView()
    //    var usernameArray = [String]()
    //     var avaArray = [PFFileObject]()
    // array showing who we follow
    var followArray = [String]()
    var followingUserDataArray = ThreadSafeArray<UserData>()
    //let db = Firestore.firestore()
    var userData: UserData?
    //var loadUserDataArray: [UserData] = []
    var followersButton = UIButton()
    var followingButton = UIButton()
    var followersView = UIView()
    var followingView = UIView()
    
    var followLabel = UILabel()
    
    @IBOutlet weak var contentView: UIView!
    
    var toSearchButton = UIButton()
    var toSettingsButton = UIButton()
    
    //var hexagonDataArray = [HexagonStructData]()
    
    //    var player = AVAudioPlayer()
    // var webView = WKWebView()
    
    @IBOutlet weak var scrollView: UIScrollView!
    var coordinateArray: [[CGFloat]] = []
    var coordinate: [CGFloat] = []
    var imageViewArray: [UIImageView] = []
    
    //@IBOutlet weak var expandedView: UIImageView!
    
    let hexaDiameter : CGFloat = 150
    
    
    var customTabBar: TabNavigationMenu!
    
    
    var reorderedCoordinateArrayPointsCentered: [CGPoint] = []
    var reOrderedCoordinateArrayPoints: [CGPoint] = [CGPoint(x: 946.8266739736607,y: 902.5),CGPoint(x: 1081.7304845413264,y: 902.5),CGPoint(x: 1014.2785792574934,y: 1020.0), CGPoint(x: 879.3747686898278,y: 1020.0),CGPoint(x:811.9228634059948,y: 902.5), CGPoint(x: 879.3747686898278,y: 785.0),CGPoint(x: 1014.2785792574934,y: 785.0),CGPoint(x:946.8266739736607,y: 667.5),CGPoint(x:1081.7304845413264,y:667.5), CGPoint(x:1149.1823898251594,y:785.0),CGPoint(x: 1216.6342951089923,y: 902.5),CGPoint(x:1149.1823898251594,y: 1020.0), CGPoint(x:1081.7304845413264, y: 1137.5),CGPoint(x:946.8266739736607,y: 1137.5),CGPoint(x: 811.9228634059948, y: 1137.5),CGPoint(x: 744.4709581221618, y: 1020.0), CGPoint(x: 677.0190528383291, y: 902.5),CGPoint(x: 744.4709581221618, y: 785.0), CGPoint(x: 811.9228634059948, y: 667.5),CGPoint(x: 879.3747686898278, y: 550.0),CGPoint(x: 1014.2785792574934, y: 550.0),CGPoint(x: 1149.1823898251594,y: 550.0),CGPoint(x:1216.6342951089923,y: 667.5),CGPoint(x:1284.0862003928253, y: 785.0),CGPoint(x:1351.5381056766582,y: 902.5), CGPoint(x:1284.0862003928253, y: 1020.0),CGPoint(x: 1216.6342951089923, y: 1137.5),CGPoint(x: 1149.1823898251594, y: 1255.0), CGPoint(x:1014.2785792574934,y:1255.0),CGPoint(x:879.3747686898278, y:1255.0),CGPoint(x:744.4709581221618, y:1255.0),CGPoint(x:677.0190528383291, y:1137.5),CGPoint(x:609.5671475544962,y: 1020.0),CGPoint(x:542.1152422706632, y: 902.5),CGPoint(x: 609.5671475544962, y: 785.0),CGPoint(x: 677.0190528383291, y: 667.5),CGPoint(x: 744.4709581221618, y: 550.0)]
    
    
    let rows = 15
    let firstRowColumns = 15
    
    var firstLoad = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileCollectionView.dataSource = self
        profileCollectionView.delegate = self
        setUpScrollView()
        setZoomScale()
        addMenuButtons()
        setUpNavBarView()
        self.navBarView.backgroundColor = .clear
        self.navBarView.layer.borderWidth = 0.0
        // insertFollowView()
        
        toSettingsButton.isHidden = false
        toSearchButton.isHidden = false
        followView.isHidden = false
        
        insertFollowersView()
        setUpCollectionView()
        
        //   print("This is total count \(reOrderedCoordinateArrayPoints.count)")
        // var unique = reOrderedCoordinateArrayPoints.removingDuplicates()
        //  print("This is the new unique one \(reOrderedCoordinateArrayPoints.count)")
        
        populateUserAvatar()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    func addSearchButton() {
        self.view.addSubview(toSearchButton)
        toSearchButton.frame = CGRect(x: self.view.frame.width-40, y: navBarY, width: 25, height: 25)
        // round ava
        //   toSearchButton.layer.cornerRadius = toSearchButton.frame.size.width / 2
        toSearchButton.clipsToBounds = true
        toSearchButton.isHidden = false
        followView.isHidden = false
        toSettingsButton.isHidden = false
    }
    
    func insertFollowersView() {
        self.navBarView.addSubview(followersView)
        self.followersView.backgroundColor = .white
        self.followersView.frame = CGRect(x: self.view.frame.midX - 80, y: toSettingsButton.frame.minY, width: 80, height: 30)
        self.followersView.layer.cornerRadius = followersView.frame.size.width / 20
        self.navBarView.addSubview(followingView)
        self.followersView.addSubview(followersButton)
        self.followingView.addSubview(followingButton)
        self.followingView.backgroundColor = .white
        self.followingView.frame = CGRect(x: self.followersView.frame.maxX + 5, y: toSettingsButton.frame.minY, width: 80, height: 30)
        self.followersView.layer.cornerRadius = followersView.frame.size.width / 20
        self.followingView.layer.cornerRadius = followingView.frame.size.width / 20
        self.followersButton.setTitleColor(.black, for: .normal)
        self.followingButton.setTitleColor(.black, for: .normal)
        self.followersButton.setTitle("Followers", for: .normal)
        self.followingButton.setTitle("Following", for: .normal)
        self.followersButton.frame = CGRect(x: 0, y: 0, width: followersView.frame.width, height: followersView.frame.height)
        self.followingButton.frame = CGRect(x: 0, y: 0, width: followingView.frame.width, height: followingView.frame.height)
        let followersTap = UITapGestureRecognizer(target: self, action: #selector(followersTapped))
        followersTap.numberOfTapsRequired = 1
        self.followersView.isUserInteractionEnabled = true
        self.followersView.addGestureRecognizer(followersTap)
        
        let followingTap = UITapGestureRecognizer(target: self, action: #selector(followingTapped))
        followingTap.numberOfTapsRequired = 1
        self.followingView.isUserInteractionEnabled = true
        self.followingView.addGestureRecognizer(followingTap)
        
        self.followersButton.setTitle("Followers", for: .normal)
        self.followingButton.setTitle("Following", for: .normal)
        
        
        
    }
    
    func setUpCollectionView() {
        self.view.addSubview(profileCollectionView)
        
        profileCollectionView.alwaysBounceHorizontal = true
        profileCollectionView.frame = CGRect(x: 0, y: self.navBarView.frame.maxY, width: self.view.frame.width, height: self.view.frame.height*(1/12))
        let layout = (profileCollectionView.collectionViewLayout as! UICollectionViewFlowLayout)
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: profileCollectionView.frame.height, height: profileCollectionView.frame.height)
        profileCollectionView.collectionViewLayout = layout
        profileCollectionView.backgroundColor = .clear
    }
    
    
    func addMenuButtons() {
        view.addSubview(menuView)
        menuView.currentTab = 3
        menuView.addBehavior()
    }
    
    func addSettingsButton() {
        self.view.addSubview(toSettingsButton)
        toSettingsButton.frame = CGRect(x: 15, y: self.navBarY, width: 25, height: 25)
        // round ava
        toSettingsButton.clipsToBounds = true
        toSettingsButton.isHidden = false
    }
    
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
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        resizeScrollView(numFollowers: 0)
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        if (firstLoad) {
        //            firstLoad = false
        //            return
        //        }
        //        toSearchButton.isHidden = true
        //        toSettingsButton.isHidden = true
        //        followView.isHidden = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        toSearchButton.isHidden = false
        toSettingsButton.isHidden = false
        followView.isHidden = false
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        toSearchButton.isHidden = false
        toSettingsButton.isHidden = false
        followView.isHidden = false
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        toSearchButton.isHidden = false
        toSettingsButton.isHidden = false
        followView.isHidden = false
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        toSearchButton.isHidden = false
        toSettingsButton.isHidden = false
        followView.isHidden = false
    }
    
    // Zoom Logic
    func resizeScrollView(numFollowers: Int) {
        //        print("Contentviewframebeforeresize \(contentView.frame)")
        //var rows = 0
        var width = view.frame.width
        var height = view.frame.height
        let additionalRowWidth: CGFloat = 340.0
        //     let heightDifference = height - width
        if numFollowers < 7 {
            //rows = 1
            //self.scrollView.frame.width =
        }
        else if numFollowers < 19 {
            //rows = 2
            height += additionalRowWidth
            width += additionalRowWidth
        }
        else if numFollowers  < 43 {
            //rows = 3
            width += (2*additionalRowWidth)
            height = (2*additionalRowWidth)
        }
        else if numFollowers < 91 {
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
        scrollView.contentSize = CGSize(width: width, height: height)
        //        print("contentviewframe: \(contentView.frame)")
        resetCoordinatePoints()
        let contentOffset = CGPoint(x: contentView.frame.width/2 - view.frame.width/2, y: contentView.frame.height/2 - view.frame.height/2)
        //        print(contentOffset)
        scrollView.contentOffset = contentOffset
        toSearchButton.isHidden = false
        toSettingsButton.isHidden = false
        followView.isHidden = false
        populateUserAvatar()
    }
    
    func resetCoordinatePoints() {
        let offsetX = reOrderedCoordinateArrayPoints[0].x - contentView.frame.midX + hexaDiameter/2
        let offsetY = reOrderedCoordinateArrayPoints[0].y - contentView.frame.midY + hexaDiameter/2
        reorderedCoordinateArrayPointsCentered = []
        
        var count = 0
        for var coordinate in reOrderedCoordinateArrayPoints {
            coordinate.x -= offsetX
            coordinate.y -= offsetY
            
            reOrderedCoordinateArrayPoints[count] = coordinate
            
            reorderedCoordinateArrayPointsCentered.append(CGPoint(x: coordinate.x + 0.5 * hexaDiameter, y: coordinate.y + 0.5 * hexaDiameter))
            
            count += 1
        }
    }
    
    func setZoomScale() {
        //        let imageViewSize = contentView.bounds.size
        //        let scrollViewSize = scrollView.bounds.size
        //        let widthScale = scrollViewSize.width / imageViewSize.width
        //        let heightScale = scrollViewSize.height / imageViewSize.height
        //
        //        print("width scale: \(widthScale)")
        //        print("height scale: \(heightScale)")
        //         scrollView.minimumZoomScale = min(widthScale, heightScale)
        //scrollView.zoomScale = scrollView.minimumZoomScale
        scrollView.maximumZoomScale = 60
        scrollView.minimumZoomScale = 1
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
    
    @objc func toSearchButtonClicked(_ recognizer: UITapGestureRecognizer) {
        let userTableVC = storyboard?.instantiateViewController(identifier: "userTableView") as! UserTableView
        userTableVC.userData = userData
        present(userTableVC, animated: false)
    }
    
    @objc func toSettingsButtonClicked(_ recognizer: UITapGestureRecognizer) {
        let settingsVC = storyboard?.instantiateViewController(identifier: "settingsVC") as! ProfessionalSettingsVC
        settingsVC.userData = userData
        present(settingsVC, animated: false)
    }
    
    
    func setUpNavBarView() {
        var statusBarHeight = UIApplication.shared.statusBarFrame.height
        print("This is status bar height \(statusBarHeight)")
        self.view.addSubview(navBarView)
        self.navBarView.frame = CGRect(x: -5, y: -5, width: self.view.frame.width + 10, height: (self.view.frame.height/12)+5)
        var navBarHeightRemaining = navBarView.frame.maxY - statusBarHeight
        navBarView.backButton.isHidden = true
        navBarView.postButton.isHidden = true
        self.navBarView.addSubview(toSettingsButton)
        self.navBarView.addSubview(toSearchButton)
        self.navBarView.backgroundColor = .clear
        self.navBarView.layer.borderWidth = 0.0
        
        let settingsTap = UITapGestureRecognizer(target: self, action: #selector(self.toSettingsButtonClicked))
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
        let yOffset = navBarView.frame.maxY
        //  self.navBarView.addSubview(titleLabel1)
        self.navBarView.addBehavior()
        self.navBarView.titleLabel.isHidden = true
        print("This is navBarView.")
        self.toSettingsButton.setImage(UIImage(named: "lightGrayGearFinal"), for: .normal)
        self.toSearchButton.setImage(UIImage(named: "lightGrayMagnifyingGlassFinal"), for: .normal)
        
    }
    
    
    func refresh() {
        //print("in refresh")
        user = Auth.auth().currentUser
        //        print("current user: \(user)")
        if (user != nil) {
            if (userData == nil || userData?.email != user?.email) {
                db.collection("UserData1").document(user!.uid).getDocument(completion: {obj,error in
                    if (error == nil) {
                        let data = obj?.data()
                        if data != nil {
                            self.userData = UserData(dictionary: obj!.data()!)
                            self.menuView.userData = self.userData
                            //                        print("should load followings, userdata was found: \(self.userData?.email)")
                            self.loadFollowings()
                        }
                        else {
                            print("Userdata data was nil")
                        }
                    }
                    else {
                        print("could not load userdata from \(self.user?.email)")
                        print(error?.localizedDescription)
                    }
                })
            }
            else {
                //                print("userData wasnt nil \(userData?.email)")
                loadFollowings()
            }
            loadPopularHexagons()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        scrollView.zoomScale = 1
        menuView.tabController = (tabBarController! as! NavigationMenuBaseController)
        menuView.userData = userData
        refresh()
        toSearchButton.isHidden = false
        toSettingsButton.isHidden = false
        followView.isHidden = false
    }
    
    
    func loadUpToTenFollowers(followers: [String], completion: @escaping () -> ()) {
        let userDataCollection = self.db.collection("UserData1")
        let userDataQuery = userDataCollection.whereField("publicID", in: followers)
        userDataQuery.getDocuments(completion: { (objects, error) -> Void in
            if error == nil {
                guard let documents = objects?.documents else {
                    print("could not get documents from objects?.documents")
                    print(error!.localizedDescription)
                    return
                }
                
                for object in documents {
                    let newUserData = UserData(dictionary: object.data())
                    let readOnlyArray = self.followingUserDataArray.readOnlyArray()
                    
                    // TODO: Very inefficient.  Use database operations to make sure data is clean.  Followers shouldnt be too many.  < 100 elements
                    
                    if (!readOnlyArray.contains(where: { data in
                        data.publicID == newUserData.publicID
                    }) && !self.userData!.isBlockedBy.contains(newUserData.publicID) && !self.userData!.blockedUsers.contains(newUserData.publicID)) {
                        self.followingUserDataArray.append(newElement: newUserData)
                    }
                }
            } else {
                print("could not get userdata for followings")
                print(error!.localizedDescription)
            }
            completion()
            
        })
    }
    
    
    func doneLoading() {
        //self.removeCurrentProfileHexagons()
        //self.loadProfileHexagons()
        profileCollectionView.reloadData()
    }
    
    // loading followings
    func loadFollowings() {
        if (self.followingUserDataArray.isEmpty()) {
            self.followingUserDataArray.append(newElement: userData!)
            profileCollectionView.reloadData()
        }
        createFollowArray(completion: { newFollowArray, success in
            //            print("loadFollowings: new follow array: \(newFollowArray)")
            if success {
                // using 5 for efficiency and less possibility of timeout
                self.followingUserDataArray.removeAll()
                self.followingUserDataArray.append(newElement: self.userData!)
                let chunks = newFollowArray.chunked(into: 5)
                let group = DispatchGroup()
                for chunk in chunks {
                    group.enter()
                    self.loadUpToTenFollowers(followers: chunk, completion: {
                        //                        print("loadFollowings: loaded followers \(self.followingUserDataArray)")
                        
                        group.leave()
                    })
                }
                group.notify(queue: .main) {
                    //                    print("loadFollowings: done loading followers \(self.followingUserDataArray)")
                    self.doneLoading()
                }
            }
        })
    }
    
    func createFollowArray(completion: @escaping ([String], Bool) -> ()) {
        let followCollection = db.collection("Followings")
        let usernameText:String = userData!.publicID
        newFollowArray = []
        followCollection.whereField("follower", isEqualTo: usernameText).getDocuments(completion: { (objects, error) -> Void in
            if error == nil {
                //                print("no error")
                
                // STEP 2. Hold received data in followArray
                // find related objects in "follow" class of Parse
                for object in objects!.documents {
                    print (object.data())
                    let followerString = object.get("following")
                    if followerString != nil  && !self.newFollowArray.contains(followerString as! String){
                        self.newFollowArray.append(followerString as! String)
                    }
                    //                    print("Now this is followArray \(self.followArray)")
                }
                completion(self.newFollowArray, true)
            }
            else {
                print(error!.localizedDescription)
                completion([String](), false)
            }
        })
    }
    
    func removeCurrentPopHexagons() {
        imageViewArray.forEach({ image in
            image.removeFromSuperview()
        })
        imageViewArray = []
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    @objc func followersTapped(_ recognizer: UITapGestureRecognizer) {
        print("followers tapped")
        let followersTableVC = storyboard?.instantiateViewController(identifier: "followersTableView") as! FollowersTableView
        followersTableVC.userData = self.userData
        present(followersTableVC, animated: false)
    }
    
    @objc func followingTapped(_ recognizer: UITapGestureRecognizer) {
        print("following tapped")
        let followingTableVC = storyboard?.instantiateViewController(identifier: "followingTableView") as! FollowingTableView
        followingTableVC.userData = self.userData
        present(followingTableVC, animated: false)
        // print("frame after pressed \(toSearchButton.frame)")
        
        
    }
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        //        print("🎯🎯🎯🎯🎯Hello World")
        //        print("🎯🎯🎯🎯🎯🎯🎯I tapped image with tag \(sender.view!.tag)")
        let username = followingUserDataArray[sender.view!.tag].publicID
        //        print("🎯🎯🎯🎯🎯🎯🎯 I tapped image with associated username: \(username)")
        let guestVC = storyboard?.instantiateViewController(identifier: "guestGridVC") as! GuestHexagonGridVC
        //guestVC.user = user
        guestVC.myUserData = userData
        guestVC.followList = self.newFollowArray
        //guestVC.profileImage = self.
        guestVC.guestUserData = followingUserDataArray[sender.view!.tag]
        guestVC.isFollowing = true
        show(guestVC, sender: nil)
        // TODO: use tag to get index of userdata to go to new hex grid as guest.
        
    }
    
    @objc func handleCollectionViewTap(_ sender: UITapGestureRecognizer) {
        //        print("🎯🎯🎯🎯🎯Hello World")
        //        print("🎯🎯🎯🎯🎯🎯🎯I tapped image with tag \(sender.view!.tag)")
        let username = followingUserDataArray[sender.view!.tag].publicID
        //        print("🎯🎯🎯🎯🎯🎯🎯 I tapped image with associated username: \(username)")
        let guestVC = storyboard?.instantiateViewController(identifier: "guestGridVC") as! GuestHexagonGridVC
        //guestVC.user = user
        guestVC.myUserData = userData
        guestVC.followList = self.newFollowArray
        //guestVC.profileImage = self.
        guestVC.guestUserData = followingUserDataArray[sender.view!.tag]
        guestVC.isFollowing = true
        show(guestVC, sender: nil)
        // TODO: use tag to get index of userdata to go to new hex grid as guest.
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let userTableVC = segue.destination as! UserTableView
        userTableVC.currentUser = user
        userTableVC.loadUserDataArray.setArray(array: followingUserDataArray.readOnlyArray())
    }
    
    
    
    func loadPopularHexagons() {
        db.collection("PopularUserData").getDocuments(completion: { obj, error in
            if error == nil {
                self.removeCurrentPopHexagons()
                self.resizeScrollView(numFollowers: obj!.documents.count)
                let contentTapGesture = UITapGestureRecognizer(target: self, action: #selector(DraggableHexagonGrid.handleContentViewerTap))
                self.contentViewer.addGestureRecognizer(contentTapGesture)
                
                //          // Do any additional setup after loading the view.
                
                let docs = obj!.documents
                var thisIndex = 1
                //        print ("following data count \(followingUserDataArray.count)")
                for doc in docs {
                    //print(coordinates)
                    let popData = UserData(dictionary: doc.data())
                    
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
                    //            print("follower username \(data.publicID)")
                    let defaultProfileImage = UIImage(named: "boyprofile")
                    let image = UIImageView(frame: CGRect(x: self.reOrderedCoordinateArrayPoints[thisIndex].x,
                                                          y: self.reOrderedCoordinateArrayPoints[thisIndex].y,
                                                          width: self.hexaDiameter,
                                                          height: self.hexaDiameter))
                    image.contentMode = .scaleAspectFill
                    let cleanRef = popData.avaRef.replacingOccurrences(of: "/", with: "%2F")
                    let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/bio-social-media.appspot.com/o/\(cleanRef)?alt=media")
                    if (url != nil) {
                        image.sd_setImage(with: url!, completed: {_, error, _, _ in
                            if error != nil {
                                print(error!.localizedDescription)
                                image.image = defaultProfileImage
                            }
                        })
                    }
                    else {
                        image.image = UIImage(named: "boyprofile")
                    }
                    image.tag = thisIndex
                    
                    
                    // image.addGestureRecognizer(longGesture)
                    image.addGestureRecognizer(tapGesture)
                    image.isUserInteractionEnabled = true
                    //   image.addGestureRecognizer(dragGesture)
                    //    var gold = #colorLiteral(red: 0.9882352941, green: 0.7607843137, blue: 0, alpha: 1)
                    
                    image.setupHexagonMask(lineWidth: image.frame.width/15, color: .darkGray, cornerRadius: image.frame.width/15)
                    self.contentView.addSubview(image)
                    //   image.startShimmering2()
                    image.isHidden = false
                    self.imageViewArray.append(image)
                    self.imageViewArray[thisIndex - 1].tag = thisIndex
                    thisIndex = thisIndex+1
                    //            print("added profile image")
                    
                }
            }
        })
    }
    var avaImage: UIImageView?
    func populateUserAvatar() {
        // to for hexstruct array once algorithm done
        if avaImage != nil {
            avaImage?.removeFromSuperview()
        }
        avaImage = UIImageView(frame: CGRect(x: self.reOrderedCoordinateArrayPoints[0].x + ((1/30)*hexaDiameter), y: self.reOrderedCoordinateArrayPoints[0].y + ((1/30)*hexaDiameter), width: (14/15)*hexaDiameter, height: (14/15)*hexaDiameter))
        avaImage?.contentMode = .scaleAspectFill
        avaImage?.image = UIImage()
        avaImage?.tag = 0
        avaImage?.isUserInteractionEnabled = true
        contentView.addSubview(avaImage!)
        //let interaction = UIContextMenuInteraction(delegate: self)
        //avaImage?.addInteraction(interaction)
        avaImage?.isHidden = false
        //let avaTap = UITapGestureRecognizer(target: self, action: #selector(self.handleProfilePicTap))
        //avaTap.numberOfTapsRequired = 1
        avaImage?.isUserInteractionEnabled = true
        // avaImage?.addGestureRecognizer(avaTap)
        
        contentView.bringSubviewToFront(avaImage!)
        avaImage!.layer.cornerRadius = (avaImage!.frame.size.width)/2
        avaImage?.clipsToBounds = true
        avaImage?.layer.masksToBounds = true
        avaImage?.layer.borderColor = UIColor.white.cgColor
        avaImage?.layer.borderWidth = (avaImage?.frame.width)!/30
        //        var myCenter = avaImage?.center
        //        shrinkImage(imageView: avaImage!)
        // var mySize = avaImage?.bounds*
        
        if (userData == nil) {
            return
        }
        let cleanRef = userData!.avaRef.replacingOccurrences(of: "/", with: "%2F")
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/bio-social-media.appspot.com/o/\(cleanRef)?alt=media")
        
        avaImage!.sd_setImage(with: url!, completed: {_, error, _, _ in
            if error != nil {
                print(error!.localizedDescription)
            }
        })
        
    }
    
    
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

extension UIImageView {
    
    func startShimmering2() {
        let light = UIColor.white.cgColor
        let alpha = UIColor.white.withAlphaComponent(0.6).cgColor
        let gradient = CAGradientLayer()
        gradient.colors = [alpha, light, alpha]
        gradient.frame = CGRect(x: -self.bounds.size.width, y: 0, width: 3 * self.bounds.size.width, height: self.bounds.size.height)
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.8)
        gradient.locations = [0.4, 0.5, 0.6]
        self.setupHexagonMask(lineWidth: self.frame.width/15, color: .darkGray, cornerRadius: self.frame.width/15)
        self.layer.mask = gradient
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue = [0.8, 0.9, 1.0]
        animation.duration = 1.5
        animation.repeatCount = HUGE
        gradient.add(animation, forKey: "shimmer")
    }
    
    func stopShimmering2(){
        self.layer.mask = nil
    }
    
}

