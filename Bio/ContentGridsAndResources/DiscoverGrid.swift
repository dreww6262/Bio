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
       // refresh()
        loadFollowings()
        print("This is followingUserDataArray count \(self.followingUserDataArray.count): \(self.followingUserDataArray)")
        return self.followingUserDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       // refresh()
        loadFollowings()
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
    var loadUserDataArray: [UserData] = []
    var tableView = UITableView()
    var followImage = UIImageView()
    var followImage2 = UIImageView()
    var followImage3 = UIImageView()
//    var profileImage = UIImage()
    var myProfileImage = UIImage()
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
    //var hexaWidth : CGFloat = 0.0
    //var hexaWidthDelta : CGFloat = 0.0
    //var hexaHeightDelta : CGFloat = 0.0
    //let spacing : CGFloat = 5
    
    var customTabBar: TabNavigationMenu!
    
    // var tapGesture = UITapGestureRecognizer()
    //var fakeUserImageArray: [UIImage] = []
    var currentUserFollowingAvatarsArray: [UIImage] = []
    
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
        self.profileCollectionView.frame = CGRect(x: 0, y: self.navBarView.frame.maxY, width: self.view.frame.width, height: self.view.frame.height*(8/24))
        self.profileCollectionView.backgroundColor = .clear
    }
    
    func insertFollowView() {
        self.view.addSubview(followView)
        self.followView.backgroundColor = .white
        self.followView.frame = CGRect(x: self.view.frame.midX - 55, y: toSettingsButton.frame.minY, width: 110, height: 30)
        self.followView.layer.cornerRadius = followView.frame.size.width / 20
        self.followView.addSubview(followImage)
        self.followView.addSubview(followImage2)
        self.followView.addSubview(followImage3)
        self.followView.addSubview(followLabel)
        self.followView.isHidden = false
        var widthRemaining = self.followView.frame.width - (3*self.followView.frame.height)
        var spacingWidth = widthRemaining/4
        self.followImage.frame = CGRect(x: spacingWidth, y: 0, width: followView.frame.height, height: followView.frame.height)
       
        self.followImage2.frame = CGRect(x: (2*spacingWidth) + followView.frame.height, y: 0, width: followView.frame.height, height: followView.frame.height)
        self.followImage3.frame = CGRect(x:(2*followView.frame.height)+(3*spacingWidth), y: 0, width: followView.frame.height, height: followView.frame.height)
        self.followView.layer.cornerRadius = followView.frame.size.width/10
        //self.followView.clipsToBounds()
        
     //   let cleanRef = userData!.avaRef.replacingOccurrences(of: "/", with: "%2F")
       // let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/bio-social-media.appspot.com/o/\(cleanRef)?alt=media")
//        self.followImage.sd_setImage(with: url!, completed: {_, error, _, _ in
//            if error != nil {
//                print(error!.localizedDescription)
//            }
//        })
        self.followImage.image = myProfileImage
        
        self.followImage.setupHexagonMask(lineWidth: self.followImage.frame.width/15, color: .darkGray, cornerRadius: self.followImage.frame.width/15)
        //self.followImage.image = UIImage(named: "twoFriendsFlipped")
        self.followImage2.image = UIImage(named: "fire1")
        self.followImage3.image = UIImage(named: "earth")
        print("This is follow view frame \(self.followView.frame)")
        print("This is follow image1.frame \(self.followImage.frame)")
        print("This is follow image2.frame \(self.followImage2.frame)")
        print("This is follow image3.frame \(self.followImage3.frame)")
        self.followLabel.frame = CGRect(x: followImage.frame.maxX + 5, y: 0.0, width: followView.frame.width - 10, height: followView.frame.height)
        self.followLabel.isHidden = true
        self.followLabel.text = "Community"
        self.followLabel.textColor = .black
        
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

//        self.navBarView.addSubview(followView)
//        self.followView.backgroundColor = .white
//        self.followView.frame = CGRect(x: self.view.frame.midX - 80, y: toSettingsButton.frame.minY, width: 160, height: 30)
//        self.followView.layer.cornerRadius = followView.frame.size.width / 20
//        followersButton.setTitleColor(.black, for: .normal)
//        followingButton.setTitleColor(.black, for: .normal)
//        followersButton.setTitle("Followers", for: .normal)
//        followingButton.setTitle("Following", for: .normal)
//        let followersTap = UITapGestureRecognizer(target: self, action: #selector(followersTapped))
//        followersTap.numberOfTapsRequired = 1
//        followersButton.isUserInteractionEnabled = true
//        followersButton.addGestureRecognizer(followersTap)
//
//        let followingTap = UITapGestureRecognizer(target: self, action: #selector(followingTapped))
//        followingTap.numberOfTapsRequired = 1
//        followingButton.isUserInteractionEnabled = true
//        followingButton.addGestureRecognizer(followingTap)
//
//        self.followView.addSubview(followersButton)
//        self.followView.addSubview(followingButton)
//        self.followView.isHidden = false
//        var widthRemaining = self.followView.frame.width - (3*self.followView.frame.height)
//        var spacingWidth = widthRemaining/4
//        self.followersButton.frame = CGRect(x: 0, y: 0, width: followView.frame.width/2, height: followView.frame.height)
//        self.followingButton.frame = CGRect(x: followersButton.frame.maxX, y: 0, width: followView.frame.width/2, height: followView.frame.height)
//
//       // self.followingButton.frame = CGRect(x: (2*spacingWidth) + followView.frame.height, y: 0, width: followView.frame.height, height: followView.frame.height)
//        self.followersButton.setTitle("Followers", for: .normal)
//        self.followingButton.setTitle("Following", for: .normal)
//
//        //self.followImage3.frame = CGRect(x:(2*followView.frame.height)+(3*spacingWidth), y: 0, width: followView.frame.height, height: followView.frame.height)
//        self.followView.layer.cornerRadius = followView.frame.size.width/10
//        //self.followView.clipsToBounds()
//
//     //   let cleanRef = userData!.avaRef.replacingOccurrences(of: "/", with: "%2F")
//       // let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/bio-social-media.appspot.com/o/\(cleanRef)?alt=media")
////        self.followImage.sd_setImage(with: url!, completed: {_, error, _, _ in
////            if error != nil {
////                print(error!.localizedDescription)
////            }
////        })
//        self.followImage.image = myProfileImage//
//
//      //  self.followImage.setupHexagonMask(lineWidth: self.followImage.frame.width/15, color: .darkGray, cornerRadius: self.followImage.frame.width/15)
//        //self.followImage.image = UIImage(named: "twoFriendsFlipped")
//      //  self.followImage2.image = UIImage(named: "fire1")
//      //  self.followImage3.image = UIImage(named: "earth")
//        print("This is follow view frame \(self.followView.frame)")
//        print("This is follow image1.frame \(self.followImage.frame)")
//        print("This is follow image2.frame \(self.followImage2.frame)")
//        print("This is follow image3.frame \(self.followImage3.frame)")
//        self.followLabel.frame = CGRect(x: followImage.frame.maxX + 5, y: 0.0, width: followView.frame.width - 10, height: followView.frame.height)
//        self.followLabel.isHidden = true
//        self.followLabel.text = "Community"
//        self.followLabel.textColor = .black
//

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
        self.removeCurrentProfileHexagons()
        self.loadProfileHexagons()
    }
    
    // loading followings
    func loadFollowings() {
        if (self.followingUserDataArray.isEmpty()) {
            self.followingUserDataArray.append(newElement: userData!)
            loadProfileHexagons()
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
                        
                        defer {group.leave()}
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
    
    func removeCurrentProfileHexagons() {
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
        var userTableVC = segue.destination as! UserTableView
        userTableVC.currentUser = user
        userTableVC.loadUserDataArray.setArray(array: followingUserDataArray.readOnlyArray())
    }
    
    
    
    func loadProfileHexagons() {
        
        //adjust coordinates
        
//        for point in self.reOrderedCoordinateArrayPoints {
//            var newPointX = point.x - 104 //680
//            var newPointY = point.y - 493 //570
//            var newPoint = CGPoint(x: newPointX, y: newPointY)
//            reorderedCoordinateArrayPointsCentered.append(newPoint)
//
//        }
        resizeScrollView(numFollowers: followingUserDataArray.count)
        let contentTapGesture = UITapGestureRecognizer(target: self, action: #selector(DraggableHexagonGrid.handleContentViewerTap))
        self.contentViewer.addGestureRecognizer(contentTapGesture)
        
        //          // Do any additional setup after loading the view.
        
        var thisIndex = 0
//        print ("following data count \(followingUserDataArray.count)")
        for data in followingUserDataArray.readOnlyArray() {
            //print(coordinates)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
//            print("follower username \(data.publicID)")
            let defaultProfileImage = UIImage(named: "boyprofile")
            let image = UIImageView(frame: CGRect(x: reOrderedCoordinateArrayPoints[thisIndex].x,
                                                  y: reOrderedCoordinateArrayPoints[thisIndex].y,
                                                  width: hexaDiameter,
                                                  height: hexaDiameter))
            image.contentMode = .scaleAspectFill
            let cleanRef = data.avaRef.replacingOccurrences(of: "/", with: "%2F")
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
       
            if thisIndex == 0 {
//                image.layer.cornerRadius = image.frame.size.width / 2
//                image.layer.borderWidth = image.frame.width/30
//                image.layer.borderColor = white.cgColor
//                image.clipsToBounds = true
                var scaleFactor = CGFloat(0.10)
                var widthShavedOff = scaleFactor*CGFloat(image.frame.width)
                var smallerFrame = CGRect(x: image.frame.minX, y: image.frame.minY, width: image.frame.width*CGFloat(0.90), height: image.frame.height*CGFloat(0.90))
                image.frame = smallerFrame
                image.frame = CGRect(x: smallerFrame.minX + (widthShavedOff/2), y: smallerFrame.minY + (widthShavedOff/2), width: smallerFrame.width, height: smallerFrame.height)
                image.layer.cornerRadius = (image.frame.size.width)/2
                image.clipsToBounds = true
                image.layer.masksToBounds = true
                image.layer.borderColor = UIColor.white.cgColor
                image.layer.borderWidth = (image.frame.width)/30
                self.myProfileImage = image.image ?? UIImage()
                self.followImage.image = self.myProfileImage
            }
            else {
                image.setupHexagonMask(lineWidth: image.frame.width/15, color: .darkGray, cornerRadius: image.frame.width/15)
            }
            contentView.addSubview(image)
         //   image.startShimmering2()
            image.isHidden = false
            imageViewArray.append(image)
            imageViewArray[thisIndex].tag = thisIndex
            thisIndex = thisIndex+1
//            print("added profile image")
            
        }
        
        //self.view.frame.origin = imageViewArray[0].frame.origin
//        print("imageViewArray: \(imageViewArray)")
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
