//
//  FriendsAndFeaturedVC.swift
//  Bio
//
//  Created by Ann McDonough on 11/9/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import AVKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseUI
import FirebaseStorage



class FriendsAndFeaturedVC: UIViewController, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    var featuredLabel = UILabel()
    var friendsLabel = UILabel()
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    var profileCellArray : [ProfileCell] = []
    var viewBellowCollectionView = UIView()
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Followinguserdataarray.count \(followingUserDataArray.count)")
        if collectionFollowing {
            return self.followingUserDataArray.count
        }
        return self.followerUserDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("This gets called! \(followingUserDataArray)")
        let array: ThreadSafeArray<UserData> = { () -> ThreadSafeArray<UserData> in
            if (collectionFollowing) {
                return followingUserDataArray
            }
            return followerUserDataArray
        }()
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileCircleCell", for: indexPath) as! ProfileCircleCell
        cell.label.text = array[indexPath.row].displayName
        cell.label.textColor = .white
        cell.label.font = UIFont(name: "DINAlternate-SemiBold", size: 12)
        cell.label.numberOfLines = 2
        cell.label.textAlignment = .center
        cell.label.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.imageView.frame = CGRect(x: cell.frame.width*(2/16), y: 0, width: cell.frame.width*(12/16), height: cell.frame.height*(12/16))
        //cell.label.sizeToFit()
        cell.label.frame = CGRect(x: 0, y: cell.imageView.frame.maxY, width: cell.frame.width, height: cell.frame.height - cell.imageView.frame.maxY)
        
        cell.tag = indexPath.row
        cell.imageView.tag = indexPath.row
        cell.label.tag = indexPath.row
        let tapCellGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCollectionViewTap))
        cell.addGestureRecognizer(tapCellGesture)
        cell.imageView.layer.cornerRadius = cell.imageView.frame.width/2
        // let ref = array[indexPath.row].avaRef as! StorageReference
        cell.imageView.sd_setImage(with: storageRef.child(array[indexPath.row].avaRef))
        //cell.imageView.sd_setImage(with: ref)
        
        
        return cell
    }
    
    var navBarY = CGFloat(39)

    var contentView = UIView()
    var profileCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    
    var navBarView = NavBarView()
    let menuView = MenuView()
    var user = Auth.auth().currentUser
    var storage = Storage.storage().reference()
    var contentViewer = UIView()
 
    var followArray = [String]()
    var followingUserDataArray = ThreadSafeArray<UserData>()
    var followerUserDataArray = ThreadSafeArray<UserData>()
    //let db = Firestore.firestore()
    var userData: UserData?
    //var loadUserDataArray: [UserData] = []
    var followersButton = UIButton()
    var followingButton = UIButton()
    var followersView = UIView()
    var followingView = UIView()
    
  //  var followLabel = UILabel()
    
    
    
    var toSearchButton = UIButton()
    var toSettingsButton = UIButton()
    
    //var hexagonDataArray = [HexagonStructData]()
    
    //    var player = AVAudioPlayer()
    // var webView = WKWebView()
    
    var scrollView = UIScrollView()
    var coordinateArray: [[CGFloat]] = []
    var coordinate: [CGFloat] = []
    var imageViewArray: [UIImageView] = []
    
    //@IBOutlet weak var expandedView: UIImageView!
    
    let hexaDiameter : CGFloat = 150
    
    
    var customTabBar: TabNavigationMenu!

    
    var firstLoad = true
    
    var collectionFollowing = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(profileCollectionView)
        contentView.bringSubviewToFront(profileCollectionView)
        profileCollectionView.backgroundColor = .red
       // scrollView.frame = view.bounds
       // contentView.frame = scrollView.bounds
        
        profileCollectionView.dataSource = self
        profileCollectionView.delegate = self
        setUpScrollView()
        setZoomScale()
        addMenuButtons()
        setUpNavBarView()
     //   setUpCollectionView()
        self.navBarView.backgroundColor = .clear
        self.navBarView.layer.borderWidth = 0.0
        // insertFollowView()
        
        toSettingsButton.isHidden = false
        toSearchButton.isHidden = false
       // followView.isHidden = false
        
        insertFollowersView()
        followersView.isHidden = true
        followingView.isHidden = true
   
       // setUpCollectionView()
        setUpProfileCells()
       loadPopularHexagons()
        print("This is view.frame \(view.frame)")
        print("This is navbarview.frame \(navBarView.frame)")
        print("This is scrollview.frame \(scrollView.frame)")
        print("This is contentview.frame \(contentView.frame)")
        print("This is profilecollectionview.frame \(profileCollectionView.frame)")
        //   print("This is total count \(reOrderedCoordinateArrayPoints.count)")
        // var unique = reOrderedCoordinateArrayPoints.removingDuplicates()
        //  print("This is the new unique one \(reOrderedCoordinateArrayPoints.count)")
        profileCollectionView.reloadData()
      //  populateUserAvatar()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setUpContentView() {
        
        
    }
    
    func addSearchButton() {
        self.view.addSubview(toSearchButton)
        toSearchButton.frame = CGRect(x: self.view.frame.width-40, y: navBarY, width: 25, height: 25)
        // round ava
        //   toSearchButton.layer.cornerRadius = toSearchButton.frame.size.width / 2
        toSearchButton.clipsToBounds = true
        toSearchButton.isHidden = false
   //     followView.isHidden = false
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
        
        followersButton.addTarget(self, action: #selector(followersButtonPressedToTable), for: .touchUpInside)
        followingButton.addTarget(self, action: #selector(followingButtonPressedToTable), for: .touchUpInside)
        
        
        
    }
    
    func setUpCollectionView() {
//        let layout1 = UICollectionViewFlowLayout()
//        layout1.scrollDirection = .horizontal
//        profileCollectionView.setCollectionViewLayout(layout1, animated: false)
        
        self.contentView.addSubview(profileCollectionView)
        self.contentView.backgroundColor = .black
      
        contentView.addSubview(self.friendsLabel)
        self.friendsLabel.text = "Friends"
        self.friendsLabel.font = UIFont(name: "Poppins-SemiBold", size: 20)
        self.friendsLabel.textColor = white
        self.friendsLabel.frame = CGRect(x: 7, y: self.navBarView.frame.maxY, width: 100, height: 20)
        print("This is friendsLabel.frame \(friendsLabel.frame)")
      
      
        profileCollectionView.alwaysBounceHorizontal = true
        //profileCollectionView.frame = CGRect(x: 0, y: self.navBarView.frame.maxY, width: self.view.frame.width, height: self.view.frame.height*(1/10))
        profileCollectionView.frame = CGRect(x: 0, y: friendsLabel.frame.maxY + 4, width: self.view.frame.width, height: self.view.frame.height*(1/8))
        print("This is profileCollection.frame after changing \(profileCollectionView.frame)")
        self.featuredLabel.frame = CGRect(x: 7, y: self.profileCollectionView.frame.maxY, width: 100, height: 20)
        print("This is featuredLabel.frame \(featuredLabel.frame)")
        let layout = (profileCollectionView.collectionViewLayout as! UICollectionViewFlowLayout)
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: profileCollectionView.frame.height, height: profileCollectionView.frame.height)
        profileCollectionView.collectionViewLayout = layout
        
        profileCollectionView.reloadData()
       // profileCollectionView.backgroundColor = .black
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
       // scrollView.frame = view.frame
        scrollView.frame = CGRect(x: 0, y: self.navBarView.frame.maxY, width: self.view.frame.width, height: self.view.frame.height - profileCollectionView.frame.maxY)
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
    //    followView.isHidden = false
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        toSearchButton.isHidden = false
        toSettingsButton.isHidden = false
    //    followView.isHidden = false
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        toSearchButton.isHidden = false
        toSettingsButton.isHidden = false
     //   followView.isHidden = false
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        toSearchButton.isHidden = false
        toSettingsButton.isHidden = false
  //      followView.isHidden = false
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
        
      
        contentView.frame = CGRect(x: 0,y: navBarView.frame.maxY, width: self.view.frame.width, height: height)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: height)
        
        //        print("contentviewframe: \(contentView.frame)")
    //    resetCoordinatePoints()
        let contentOffset = CGPoint(x: contentView.frame.width/2 - view.frame.width/2, y: contentView.frame.height/2 - view.frame.height/2)
        //        print(contentOffset)
        scrollView.contentOffset = contentOffset
        toSearchButton.isHidden = false
        toSettingsButton.isHidden = false
    //    followView.isHidden = false
        //populateUserAvatar()
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
        self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y: 0, width: 200, height: self.navBarView.frame.height)
        self.navBarView.titleLabel.text = "Discover"
        let yOffset = navBarView.frame.maxY
        //  self.navBarView.addSubview(titleLabel1)
        self.navBarView.addBehavior()
        self.navBarView.titleLabel.isHidden = false
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
                            self.loadFollowers()
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
                loadFollowers()
            }
          //  loadPopularHexagons()
//            setUpProfileCells()
//            loadPopularHexagons()
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
   //     followView.isHidden = false
    }
    
    
    func loadUpToTenUserDatas(followers: [String], completion: @escaping () -> (), following: Bool) {
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
                    let readOnlyArray: [UserData] = { () -> [UserData] in
                        if (following) {
                            return self.followingUserDataArray.readOnlyArray()
                        }
                        return self.followerUserDataArray.readOnlyArray()
                    }()
                    
                    // TODO: Very inefficient.  Use database operations to make sure data is clean.  Followers shouldnt be too many.  < 100 elements
                    
                    if (!readOnlyArray.contains(where: { data in
                        data.publicID == newUserData.publicID
                    }) && !self.userData!.isBlockedBy.contains(newUserData.publicID) && !self.userData!.blockedUsers.contains(newUserData.publicID)) {
                        
                        if (following) {
                            self.followingUserDataArray.append(newElement: newUserData)
                        }
                        else {
                            self.followerUserDataArray.append(newElement: newUserData)
                        }
                        
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
        print("I got here loadfollowings")
        if (self.followingUserDataArray.isEmpty()) {
            self.followingUserDataArray.append(newElement: userData!)
//            if (profileCollectionView == nil) {
//                return
//            }
            profileCollectionView.reloadData()
        }
        createFollowingArray(completion: { newFollowArray, success in
            //            print("loadFollowings: new follow array: \(newFollowArray)")
            if success {
                // using 5 for efficiency and less possibility of timeout
                self.followingUserDataArray.removeAll()
                self.followingUserDataArray.append(newElement: self.userData!)
                let chunks = newFollowArray.chunked(into: 5)
                let group = DispatchGroup()
                for chunk in chunks {
                    group.enter()
                    self.loadUpToTenUserDatas(followers: chunk, completion: {
                        //                        print("loadFollowings: loaded followers \(self.followingUserDataArray)")
                        
                        group.leave()
                    }, following: true)
                }
                group.notify(queue: .main) {
                    //                    print("loadFollowings: done loading followers \(self.followingUserDataArray)")
                    self.doneLoading()
                }
            }
        })
    }
    
    func createFollowingArray(completion: @escaping ([String], Bool) -> ()) {
        let followCollection = db.collection("Followings")
        let usernameText:String = userData!.publicID
        var newFollowArray = [String]()
        followCollection.whereField("follower", isEqualTo: usernameText).getDocuments(completion: { (objects, error) -> Void in
            if error == nil {
                //                print("no error")
                
                // STEP 2. Hold received data in followArray
                // find related objects in "follow" class of Parse
                for object in objects!.documents {
                    print (object.data())
                    let followerString = object.get("following")
                    if followerString != nil  && !newFollowArray.contains(followerString as! String){
                        newFollowArray.append(followerString as! String)
                    }
                    //                    print("Now this is followArray \(self.followArray)")
                }
                completion(newFollowArray, true)
            }
            else {
                print(error!.localizedDescription)
                completion([String](), false)
            }
        })
    }
    
    
    
    
    // loading followings
    func loadFollowers() {
        if (self.followerUserDataArray.isEmpty()) {
            self.followerUserDataArray.append(newElement: userData!)
//            if (profileCollectionView == nil) {
//                return
//            }
            print("I get here load followers")
            profileCollectionView.reloadData()
        }
        createFollowerArray(completion: { newFollowArray, success in
            if success {
                // using 5 for efficiency and less possibility of timeout
                self.followerUserDataArray.removeAll()
                self.followerUserDataArray.append(newElement: self.userData!)
                let chunks = newFollowArray.chunked(into: 5)
                let group = DispatchGroup()
                for chunk in chunks {
                    group.enter()
                    self.loadUpToTenUserDatas(followers: chunk, completion: {
                        group.leave()
                    }, following: false)
                }
                group.notify(queue: .main) {
                    self.doneLoading()
                }
            }
        })
    }
    
    func createFollowerArray(completion: @escaping ([String], Bool) -> ()) {
        let followCollection = db.collection("Followings")
        let usernameText:String = userData!.publicID
        var newFollowArray = [String]()
        followCollection.whereField("following", isEqualTo: usernameText).getDocuments(completion: { (objects, error) -> Void in
            if error == nil {
                //                print("no error")
                
                // STEP 2. Hold received data in followArray
                // find related objects in "follow" class of Parse
                for object in objects!.documents {
                    print (object.data())
                    let followerString = object.get("follower")
                    if followerString != nil  && !newFollowArray.contains(followerString as! String){
                        newFollowArray.append(followerString as! String)
                    }
                    //                    print("Now this is followArray \(self.followArray)")
                }
                completion(newFollowArray, true)
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
   
    @objc func handleProfileCellTap(_ sender: UITapGestureRecognizer) {
        print("Profile Cell Tap sender \(sender)")
        //        print("🎯🎯🎯🎯🎯Hello World")
        //        print("🎯🎯🎯🎯🎯🎯🎯I tapped image with tag \(sender.view!.tag)")
        //let username = popularUserDataArray[sender.view!.tag].publicID
        //        print("🎯🎯🎯🎯🎯🎯🎯 I tapped image with associated username: \(username)")
        let profCell = sender.view as! ProfileCell
        let guestVC = storyboard?.instantiateViewController(identifier: "guestGridVC") as! GuestHexagonGridVC
        //guestVC.user = user
        guestVC.myUserData = userData
        //guestVC.profileImage = self.
        guestVC.guestUserData = profCell.userData
        guestVC.isFollowing = true
        show(guestVC, sender: nil)
        // TODO: use tag to get index of userdata to go to new hex grid as guest.
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        //        print("🎯🎯🎯🎯🎯Hello World")
        //        print("🎯🎯🎯🎯🎯🎯🎯I tapped image with tag \(sender.view!.tag)")
        //let username = popularUserDataArray[sender.view!.tag].publicID
        //        print("🎯🎯🎯🎯🎯🎯🎯 I tapped image with associated username: \(username)")
        let profImage = sender.view as! ProfileImageView
        let guestVC = storyboard?.instantiateViewController(identifier: "guestGridVC") as! GuestHexagonGridVC
        //guestVC.user = user
        guestVC.myUserData = userData
        //guestVC.profileImage = self.
        guestVC.guestUserData = profImage.userData
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
    
    func setUpProfileCells() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleProfileCellTap))
       // var featuredLabel = UILabel()
        var heightSpacing = CGFloat(25.0)
      var profileHeight = CGFloat(self.view.frame.width*(4.5/12))
      //  var profileHeight = CGFloat(self.view.frame.width*(2.25/12))
        var profileWidth = self.view.frame.width*(4.5/12)
//        self.contentView.addSubview(featuredLabel)
//        featuredLabel.text = "Featured"
//        featuredLabel.frame = CGRect(x: 7, y:0, width: 100, height: 20)
//        featuredLabel.font = UIFont(name: "Poppins-SemiBold", size: 20)
//        featuredLabel.textColor = white
        self.contentView.backgroundColor = .black
        var profile1 = ProfileCell()
        profile1.backgroundColor = white
        self.contentView.addSubview(profile1)
        profile1.frame = CGRect(x: self.view.frame.width/12, y: self.featuredLabel.frame.maxY + 5, width: profileWidth, height: profileHeight)
        var profile2 = ProfileCell()
        profile2.backgroundColor = white
        self.contentView.addSubview(profile2)
        profile2.frame = CGRect(x: self.view.frame.width*(6.5/12), y: self.featuredLabel.frame.maxY, width: profileWidth, height: profileHeight)
        
        var profile3 = ProfileCell()
        profile3.backgroundColor = white
        self.contentView.addSubview(profile3)
        profile3.frame = CGRect(x: self.view.frame.width/12, y: profile1.frame.maxY + heightSpacing, width: profileWidth, height: profileHeight)
        var profile4 = ProfileCell()
        profile4.backgroundColor = white
        self.contentView.addSubview(profile4)
        profile4.frame = CGRect(x: self.view.frame.width*(6.5/12), y: profile2.frame.maxY + heightSpacing, width: profileWidth, height: profileHeight)
        
        var profile5 = ProfileCell()
        profile5.backgroundColor = white
        self.contentView.addSubview(profile5)
        profile5.frame = CGRect(x: self.view.frame.width/12, y: profile3.frame.maxY + heightSpacing, width: profileWidth, height: profileHeight)
        var profile6 = ProfileCell()
        profile6.backgroundColor = white
        self.contentView.addSubview(profile6)
        profile6.frame = CGRect(x: self.view.frame.width*(6.5/12), y: profile4.frame.maxY + heightSpacing, width: profileWidth, height: profileHeight)
        
        var profile7 = ProfileCell()
        profile7.backgroundColor = white
        self.contentView.addSubview(profile7)
        profile7.frame = CGRect(x: self.view.frame.width/12, y: profile5.frame.maxY + heightSpacing, width: profileWidth, height: profileHeight)
        var profile8 = ProfileCell()
        profile8.backgroundColor = white
        self.contentView.addSubview(profile8)
        profile8.frame = CGRect(x: self.view.frame.width*(6.5/12), y: profile6.frame.maxY + heightSpacing, width: profileWidth, height: profileHeight)
        
        var profile9 = ProfileCell()
        profile9.backgroundColor = white
        self.contentView.addSubview(profile9)
        profile9.frame = CGRect(x: self.view.frame.width/12, y: profile7.frame.maxY + heightSpacing, width: profileWidth, height: profileHeight)
        var profile10 = ProfileCell()
        profile10.backgroundColor = white
        self.contentView.addSubview(profile10)
        profile10.frame = CGRect(x: self.view.frame.width*(6.5/12), y: profile8.frame.maxY + heightSpacing, width: profileWidth, height: profileHeight)
        
        var profile11 = ProfileCell()
        profile11.backgroundColor = white
        self.contentView.addSubview(profile11)
        profile11.frame = CGRect(x: self.view.frame.width/12, y: profile9.frame.maxY + heightSpacing, width: profileWidth, height: profileHeight)
        var profile12 = ProfileCell()
        profile12.backgroundColor = white
        self.contentView.addSubview(profile12)
        profile12.frame = CGRect(x: self.view.frame.width*(6.5/12), y: profile10.frame.maxY + heightSpacing, width: profileWidth, height: profileHeight)
        
        var profile13 = ProfileCell()
        profile13.backgroundColor = white
        self.contentView.addSubview(profile13)
        profile13.frame = CGRect(x: self.view.frame.width/12, y: profile11.frame.maxY + heightSpacing, width: profileWidth, height: profileHeight)
        var profile14 = ProfileCell()
        profile14.backgroundColor = white
        self.contentView.addSubview(profile14)
        profile14.frame = CGRect(x: self.view.frame.width*(6.5/12), y: profile12.frame.maxY + heightSpacing, width: profileWidth, height: profileHeight)
        
        var profile15 = ProfileCell()
        profile15.backgroundColor = white
        self.contentView.addSubview(profile15)
        profile15.frame = CGRect(x: self.view.frame.width/12, y: profile13.frame.maxY + heightSpacing, width: profileWidth, height: profileHeight)
        var profile16 = ProfileCell()
        profile16.backgroundColor = white
        self.contentView.addSubview(profile16)
        profile16.frame = CGRect(x: self.view.frame.width*(6.5/12), y: profile14.frame.maxY + heightSpacing, width: profileWidth, height: profileHeight)
        
        var profile17 = ProfileCell()
        profile17.backgroundColor = white
        self.contentView.addSubview(profile17)
        profile17.frame = CGRect(x: self.view.frame.width/12, y: profile15.frame.maxY + heightSpacing, width: profileWidth, height: profileHeight)
        var profile18 = ProfileCell()
        profile18.backgroundColor = white
        self.contentView.addSubview(profile18)
        profile18.frame = CGRect(x: self.view.frame.width*(6.5/12), y: profile16.frame.maxY + heightSpacing, width: profileWidth, height: profileHeight)
        
        profile1.applyshadowWithCorner(containerView: profile1, cornerRadious: profile1.frame.width/10)
        profile2.applyshadowWithCorner(containerView: profile2, cornerRadious: profile1.frame.width/10)
        profile3.applyshadowWithCorner(containerView: profile3, cornerRadious: profile1.frame.width/10)
        profile4.applyshadowWithCorner(containerView: profile4, cornerRadious: profile1.frame.width/10)
        profile5.applyshadowWithCorner(containerView: profile5, cornerRadious: profile1.frame.width/10)
        profile6.applyshadowWithCorner(containerView: profile6, cornerRadious: profile1.frame.width/10)
        profile7.applyshadowWithCorner(containerView: profile7, cornerRadious: profile1.frame.width/10)
        profile8.applyshadowWithCorner(containerView: profile8, cornerRadious: profile1.frame.width/10)
        profile9.applyshadowWithCorner(containerView: profile9, cornerRadious: profile1.frame.width/10)
        profile10.applyshadowWithCorner(containerView: profile10, cornerRadious: profile1.frame.width/10)
        profile11.applyshadowWithCorner(containerView: profile11, cornerRadious: profile1.frame.width/10)
        profile12.applyshadowWithCorner(containerView: profile12, cornerRadious: profile1.frame.width/10)
        profile13.applyshadowWithCorner(containerView: profile13, cornerRadious: profile1.frame.width/10)
        profile14.applyshadowWithCorner(containerView: profile14, cornerRadious: profile1.frame.width/10)
        profile15.applyshadowWithCorner(containerView: profile15, cornerRadious: profile1.frame.width/10)
        profile16.applyshadowWithCorner(containerView: profile16, cornerRadious: profile1.frame.width/10)
        profile17.applyshadowWithCorner(containerView: profile17, cornerRadious: profile1.frame.width/10)
        profile18.applyshadowWithCorner(containerView: profile18, cornerRadious: profile1.frame.width/10)
        
        self.profileCellArray = [profile1, profile2, profile3, profile4, profile5, profile6, profile7, profile8, profile9, profile10 ,profile11, profile12, profile13, profile14, profile15, profile16, profile17, profile18]
        
        
        
        
    }
    
    func loadPopularHexagons() {
//        var featuredLabel = UILabel()
//        self.contentView.addSubview(featuredLabel)
//        featuredLabel.text = "Featured"
//        featuredLabel.frame = CGRect(x: 7, y:0, width: self.view.frame.width - 7, height: 22)
//        featuredLabel.font = UIFont(name: "Poppins-SemiBold", size: 20)
//        featuredLabel.textColor = white
//        featuredLabel.backgroundColor = .red
        
        db.collection("PopularUserData").getDocuments(completion: { [self] obj, error in
            if error == nil {
                self.removeCurrentPopHexagons()
                self.resizeScrollView(numFollowers: obj!.documents.count)
                let contentTapGesture = UITapGestureRecognizer(target: self, action: #selector(DraggableHexagonGrid.handleContentViewerTap))
                self.contentViewer.addGestureRecognizer(contentTapGesture)
                
                //          // Do any additional setup after loading the view.
                
                let docs = obj!.documents
                var thisIndex = 1
                //        print ("following data count \(followingUserDataArray.count)")
                
                //do design stuff here!
                setUpCollectionView()
                
                
                
                self.contentView.addSubview(self.featuredLabel)
                self.featuredLabel.text = "Featured"
                self.featuredLabel.frame = CGRect(x: 7, y: self.profileCollectionView.frame.maxY, width: 100, height: 20)
             //   print("This is featuredLabel.frame \(featuredLabel.frame)")
                self.featuredLabel.font = UIFont(name: "Poppins-SemiBold", size: 20)
                self.featuredLabel.textColor = white
                
                
                
                
                for doc in docs {
                    //print(coordinates)
                    let popData = UserData(dictionary: doc.data())
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleProfileCellTap))
                    //            print("follower username \(data.publicID)")
                    let defaultProfileImage = UIImage(named: "boyprofile")
                    var image = UIImageView()
                    let profileView = self.profileCellArray[thisIndex-1]
                    contentView.addSubview(profileView)
                    profileView.frame = self.profileCellArray[thisIndex-1].frame
                    profileView.userData = popData
                  // image = UIImageView(frame: self.profileCellArray[thisIndex-1].frame)
                    profileView.usernameLabel?.text = popData.publicID
                    profileView.displayNameLabel?.text = popData.displayName
                 
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
                    image.tag = thisIndex - 1
                    
                
                    profileView.addGestureRecognizer(tapGesture)
                    profileView.displayNameLabel?.frame = CGRect(x: 5, y: 5, width: 100, height: 30)
                    profileView.isUserInteractionEnabled = true
               // ge.frame.width/15, color: .darkGray, cornerRadius: image.frame.width/15)
               
                    image.layer.borderWidth = 1.0
                   // image.layer.borderColor = white.cgColor
                    image.layer.borderColor = myTikTokBlack.cgColor
                    profileView.addSubview(image)
                    var profileViewWidth = profileView.frame.width
                    var profileViewHeight = profileView.frame.height
                    //set up image view frame
                image.frame = CGRect(x: profileViewWidth/4, y: profileViewWidth/16, width: profileViewWidth/2, height: profileViewWidth/2)
                 //  image.frame = CGRect(x: 5, y: 5, width: profileViewHeight/2, height: profileViewHeight/2)
                    image.clipsToBounds = true
                    image.layer.cornerRadius = image.frame.width/2
                    image.isHidden = false
                    
                    var displayNameLabel = UILabel()
                    profileView.addSubview(displayNameLabel)
                    //profileView.displayNameLabel = UILabel()
                    displayNameLabel.text = profileView.userData?.displayName
                    var spaceRemaining = profileView.frame.height - image.frame.maxY
                    //set up display name frame
            displayNameLabel.frame = CGRect(x: 0, y: image.frame.maxY + (spaceRemaining/16), width: profileView.frame.width, height: spaceRemaining/2)
                    var spaceToBottom = profileView.frame.height - displayNameLabel.frame.maxY
              //    displayNameLabel.frame = CGRect(x: image.frame.maxX, y: profileView.frame.height/4, width: profileView.frame.width - image.frame.width, height: profileView.frame.height/2)
                    displayNameLabel.textAlignment = .center
                    displayNameLabel.textColor = .black
                    
                    
                    self.imageViewArray.append(image)
                    self.imageViewArray[thisIndex - 1].tag = thisIndex
                    thisIndex = thisIndex+1
                    //            print("added profile image")
                    profileView.profileImageView = image
                    //profileView.backgroundColor = .systemGray6
                    profileView.backgroundColor = .white
                    profileView.applyshadowWithCorner(containerView: profileView, cornerRadious: profileView.frame.width/10)
                    print("This is profileView info: \(profileView.usernameLabel) \(profileView.displayNameLabel) frame: \(profileView.frame) index: \(thisIndex-1)")
                    var followView = UIView()
                    profileView.addSubview(followView)
                    var followLabel = UILabel()
                    //followView.backgroundColor = .systemGray6
                    followView.backgroundColor = .clear
                    //followView.frame = CGRect(x: self.view.frame.midX - 45, y: displayNameLabel.frame.maxY + 5, width: 90, height: 30)
                    var followViewHeight = displayNameLabel.frame.maxY
                    var heightRemaining = profileView.frame.height - followViewHeight
                   //set up FollowView Frame
                 //  followView.frame = CGRect(x: (profileView.frame.width/2) - 44, y: followViewHeight, width: 88, height: heightRemaining)
                    var followViewWidth = CGFloat(60.0)
                 //   followView.frame = CGRect(x: profileView.frame.width - followViewWidth - 5, y: 5, width: followViewWidth, height: heightRemaining)
                    followLabel.textColor = .black
                    followView.layer.cornerRadius = followView.frame.size.width / 20
                    var followImage = UIImageView()
                    followView.addSubview(followImage)
                    followView.addSubview(followLabel)
                   // self.followView.isHidden = false
                 //   followImage.frame = CGRect(x: 0, y: 0, width: followView.frame.height, height: followView.frame.height)
                    followView.layer.cornerRadius = followView.frame.size.width/10
                    //self.followView.clipsToBounds()
                    
                    var userDescriptionLabel = UILabel()
                    profileView.addSubview(userDescriptionLabel)
                   // userDescriptionLabel.frame = CGRect(x: 0, y: profileView.frame.maxY - spaceToBottom, width: self.view.frame.width, height: spaceToBottom)
                    userDescriptionLabel.frame = CGRect(x: 0, y: displayNameLabel.frame.maxY, width: profileView.frame.width, height: spaceToBottom)
                    userDescriptionLabel.text = "Artist, Activist"
                    userDescriptionLabel.textColor = .black
                    userDescriptionLabel.textAlignment = .center
                    
                    var isFollowing = false
                    if isFollowing {
                        followView.isHidden = true
                        followImage.image = UIImage(named: "friendCheck")
                        followLabel.text = "Added"
                    }
                    else {
                        followView.isHidden = false
                       // followImage.image = UIImage(named: "addFriend")
                       // followLabel.text = "Add"
                        followLabel.text = ""
                      //  followView.frame = CGRect(x: profileView.frame.width - image.frame.width - 5, y: 5, width: image.frame.width, height: image.frame.height)
                       // followView.layer.cornerRadius = followView.frame.width/2
                      //  followImage.frame = CGRect(x: followView.frame.width/4, y: followView.frame.width/4, width: followView.frame.height/2, height: followView.frame.height/2)
                       // followImage.frame = followView.frame
                      //  followImage.image = UIImage(named: "plus")
                      
                        
                    }
                    
                    //self.followImage.image = UIImage(named: "friendCheck")
                    followLabel.frame = CGRect(x: followImage.frame.maxX + 5, y: 0.0, width: followView.frame.width - 10, height: followView.frame.height)
                    //self.followLabel.text = "Added"
                    followLabel.textColor = .black
                   // let tapped = UITapGestureRecognizer(target: self, action: #selector(GuestVC.followTapped))
                //    followView.addGestureRecognizer(tapped)
                    
                    
                    
                    
                    
                }
            }
        })
    }
    var avaImage: UIImageView?
    
//    func populateUserAvatar() {
//        // to for hexstruct array once algorithm done
//        if avaImage != nil {
//            avaImage?.removeFromSuperview()
//        }
//        avaImage = UIImageView(frame: CGRect(x: self.reOrderedCoordinateArrayPoints[0].x + ((1/30)*hexaDiameter), y: self.reOrderedCoordinateArrayPoints[0].y + ((1/30)*hexaDiameter), width: (14/15)*hexaDiameter, height: (14/15)*hexaDiameter))
//        avaImage?.contentMode = .scaleAspectFill
//        avaImage?.image = UIImage()
//        avaImage?.tag = 0
//        avaImage?.isUserInteractionEnabled = true
//        contentView.addSubview(avaImage!)
//        //let interaction = UIContextMenuInteraction(delegate: self)
//        //avaImage?.addInteraction(interaction)
//        avaImage?.isHidden = false
//        //let avaTap = UITapGestureRecognizer(target: self, action: #selector(self.handleProfilePicTap))
//        //avaTap.numberOfTapsRequired = 1
//        avaImage?.isUserInteractionEnabled = true
//        // avaImage?.addGestureRecognizer(avaTap)
//
//        contentView.bringSubviewToFront(avaImage!)
//        avaImage!.layer.cornerRadius = (avaImage!.frame.size.width)/2
//        avaImage?.clipsToBounds = true
//        avaImage?.layer.masksToBounds = true
//        avaImage?.layer.borderColor = UIColor.white.cgColor
//        avaImage?.layer.borderWidth = (avaImage?.frame.width)!/30
//        //        var myCenter = avaImage?.center
//        //        shrinkImage(imageView: avaImage!)
//        // var mySize = avaImage?.bounds*
//
//        if (userData == nil) {
//            return
//        }
//        let cleanRef = userData!.avaRef.replacingOccurrences(of: "/", with: "%2F")
//        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/bio-social-media.appspot.com/o/\(cleanRef)?alt=media")
//
//        avaImage!.sd_setImage(with: url!, completed: {_, error, _, _ in
//            if error != nil {
//                print(error!.localizedDescription)
//            }
//        })
//
//    }
    
    
    func insertFollowButton() {
//        profileView.addSubview(followView)
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
//            self.followLabel.text = "Added"
//        }
//        else {
//            self.followView.isHidden = false
//            self.followImage.image = UIImage(named: "addFriend")
//            self.followLabel.text = "Add"
//        }
//
//        //self.followImage.image = UIImage(named: "friendCheck")
//        self.followLabel.frame = CGRect(x: followImage.frame.maxX + 5, y: 0.0, width: followView.frame.width - 10, height: followView.frame.height)
//        //self.followLabel.text = "Added"
//        self.followLabel.textColor = .black
//        let tapped = UITapGestureRecognizer(target: self, action: #selector(followTapped))
//        self.followView.addGestureRecognizer(tapped)
        
        
    }
    
    @objc func followersButtonPressed(_ sender: UITapGestureRecognizer) {
        collectionFollowing = false
        profileCollectionView.reloadData()
        
    }
    
    @objc func followersButtonPressedToTable(_ sender: UITapGestureRecognizer) {
        let followersTableView = storyboard?.instantiateViewController(identifier: "followersTableView") as! FollowersTableView
        followersTableView.userData = userData
        present(followersTableView, animated: false)
    }
    
    
    @objc func followingButtonPressed(_ sender: UITapGestureRecognizer) {
        collectionFollowing = true
        profileCollectionView.reloadData()
    }
    
    
    @objc func followingButtonPressedToTable(_ sender: UITapGestureRecognizer) {
        let followingTableView = storyboard?.instantiateViewController(identifier: "followingTableView") as! FollowingTableView
        followingTableView.userData = userData
        present(followingTableView, animated: false)
    }
    
    
}



extension UIView {
    func applyshadowWithCorner(containerView : UIView, cornerRadious : CGFloat){
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = 10
        containerView.layer.cornerRadius = cornerRadious
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: cornerRadious).cgPath
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadious
    }
}
