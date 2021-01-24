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

var myBlueGreen = #colorLiteral(red: 0, green: 0.8235294118, blue: 0.831372549, alpha: 1)
var myPink = #colorLiteral(red: 0.9756818414, green: 0.5529372692, blue: 0.920709908, alpha: 1)
var myOrange = #colorLiteral(red: 1, green: 0.8000468612, blue: 0.4002942443, alpha: 1)
var myCoolBlue = #colorLiteral(red: 0.2413757304, green: 0.5994680342, blue: 0.9716603538, alpha: 1)
var myDarkBlue = #colorLiteral(red: 0.07005525896, green: 0.2447893395, blue: 0.4398794416, alpha: 1)
var myVenmoBlue = #colorLiteral(red: 0.2392156863, green: 0.5843137255, blue: 0.8078431373, alpha: 1)
var myTwitterBlue = #colorLiteral(red: 0, green: 0.6745098039, blue: 0.9333333333, alpha: 1)
var myInstaPurple = #colorLiteral(red: 0.5411764706, green: 0.2274509804, blue: 0.7254901961, alpha: 1)
var mySnapChatYellow = #colorLiteral(red: 1, green: 0.9882352941, blue: 0, alpha: 1)
var mySoundCloudOrange = #colorLiteral(red: 1, green: 0.4666666667, blue: 0, alpha: 1)
var myYoutubeRed = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
var myPoshmarkMaroon = #colorLiteral(red: 0.5019607843, green: 0, blue: 0, alpha: 1)
var myHudlOrange = #colorLiteral(red: 1, green: 0.3882352941, blue: 0, alpha: 1)
var myTikTokWhite = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
var myTikTokBlack = #colorLiteral(red: 0.003921568627, green: 0.003921568627, blue: 0.003921568627, alpha: 1)
var myLinkedInBlue = #colorLiteral(red: 0, green: 0.4470588235, blue: 0.6941176471, alpha: 1)

var shakebleImages : [PostImageView] = []
var navBarY = CGFloat(39)


class HomeHexagonGrid: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate, WKUIDelegate, UIContextMenuInteractionDelegate  {
    var indexImageViewArray : [UIImageView] = []
    var profilePicCancelButton = UIButton()
    var newImageView = UIImageView()
var navBarView = NavBarView()
    // Firebase stuff
    var pageViewListener: ListenerRegistration?
    var user = Auth.auth().currentUser
    var userDataVM: UserDataVM?
    var currentPostingUserID = ""
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    var contentPages: CustomPageView?
    
    // UI stuff
    @objc var panGesture  = UIPanGestureRecognizer()
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var trashButton: UIButton!
    var toSearchButton = UIButton()
    var toSettingsButton = UIButton()
    let menuView = MenuView()
    var curvedRect = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
    var curvedLayer = UIImageView()
    
    var indexLabelArray: [UILabel] = []
    
    // Flags and tags
    
    var followView = UIView()
    var followImage = UIImageView()
    var followLabel = UILabel()
    var plusHexagon = PostImageView()
    
    // arrays
    var targetHexagons: [Int] = []
    //var hexagonStructArray: [HexagonStructData] = []
    var imageViewArray: [PostImageView] = []
    
    var reOrderedCoordinateArrayPoints: [CGPoint] = [CGPoint(x: 946.8266739736607,y: 902.5), CGPoint(x: 1081.7304845413264,y: 902.5), CGPoint(x: 1014.2785792574934,y: 1020.0), CGPoint(x: 879.3747686898278,y: 1020.0), CGPoint(x:811.9228634059948,y: 902.5), CGPoint(x: 879.3747686898278,y: 785.0), CGPoint(x: 1014.2785792574934,y: 785.0), CGPoint(x: 946.8266739736607, y: 1137.5), CGPoint(x: 744.4709581221618, y: 785.0), CGPoint(x:1149.1823898251594,y:785.0), CGPoint(x: 811.9228634059948, y: 667.5), CGPoint(x:946.8266739736607,y: 667.5), CGPoint(x:1081.7304845413264,y:667.5), CGPoint(x: 1216.6342951089923,y: 902.5), CGPoint(x:1149.1823898251594,y: 1020.0), CGPoint(x:1081.7304845413264, y: 1137.5), CGPoint(x: 811.9228634059948, y: 1137.5), CGPoint(x: 744.4709581221618, y: 1020.0), CGPoint(x: 677.0190528383291, y: 902.5), CGPoint(x: 879.3747686898278, y: 550.0), CGPoint(x: 1014.2785792574934, y: 550.0), CGPoint(x: 1149.1823898251594,y: 550.0), CGPoint(x:1216.6342951089923,y: 667.5), CGPoint(x:1284.0862003928253, y: 785.0), CGPoint(x:1351.5381056766582,y: 902.5), CGPoint(x:1284.0862003928253, y: 1020.0), CGPoint(x: 1216.6342951089923, y: 1137.5), CGPoint(x: 1149.1823898251594, y: 1255.0), CGPoint(x:1014.2785792574934,y:1255.0), CGPoint(x:879.3747686898278, y:1255.0), CGPoint(x:744.4709581221618, y:1255.0), CGPoint(x:677.0190528383291, y:1137.5), CGPoint(x:609.5671475544962,y: 1020.0), CGPoint(x:542.1152422706632, y: 902.5), CGPoint(x: 609.5671475544962, y: 785.0), CGPoint(x: 677.0190528383291, y: 667.5), CGPoint(x: 744.4709581221618, y: 550.0)]
    var fourthRowArray: [CGPoint] = [CGPoint(x: 744.4709581221618, y: 315.0), CGPoint(x: 879.3747686898278,y: 315.0), CGPoint(x: 1014.2785792574934,y: 315.0), CGPoint(x: 1149.1823898251594,y: 315.0), CGPoint(x:1284.0862003928253,y: 315.0),CGPoint(x: 1351.5381056766582, y: 432.5), CGPoint(x: 1418.990010960491, y: 550.0),CGPoint(x: 1486.441916244324, y: 667.5), CGPoint(x: 1553.8938215281566, y: 785.0),CGPoint(x: 1621.3457268119896, y: 902.5), CGPoint(x: 1553.8938215281566, y: 1020.0), CGPoint(x: 1486.441916244324, y: 1137.5), CGPoint(x: 1418.990010960491, y: 1255.0), CGPoint(x: 1351.5381056766582, y: 1372.5), CGPoint(x: 1284.0862003928253, y: 1490.0), CGPoint(x: 1149.1823898251594,y: 1490.0), CGPoint(x: 1014.2785792574934, y: 1490.0), CGPoint(x: 879.3747686898278,y: 1490.0), CGPoint(x: 744.4709581221618,y: 1490.0), CGPoint(x: 609.5671475544962, y: 1490.0),      CGPoint(x: 542.1152422706632, y: 1372.5), CGPoint(x: 474.6633369868303, y: 1255.0), CGPoint(x: 407.2114317029974, y: 1137.5), CGPoint(x: 339.7595264191645, y: 1020.0), CGPoint(x: 272.3076211353316, y: 902.5),CGPoint(x: 339.7595264191645, y: 785.0), CGPoint(x: 407.2114317029974, y: 667.5), CGPoint(x: 474.6633369868303, y: 550.0), CGPoint(x: 542.1152422706632,y: 432.5),CGPoint(x: 609.5671475544962,y: 315.0)]

    
    //,CGPoint(x:811.9228634059948,y: 432.5), CGPoint(x: 946.8266739736607,y: 432.5), CGPoint(x:1081.7304845413264, y: 432.5), CGPoint(x: 1216.6342951089923,y: 432.5),CGPoint(x: 1284.0862003928253,y: 550.0),CGPoint(x:1351.5381056766582, y: 667.5), CGPoint(x:1418.990010960491,y: 785.0),  CGPoint(x: 1486.441916244324,y:902.5), CGPoint(x:1418.990010960491, y: 1020.0),CGPoint(x: 1351.5381056766582, y: 1137.5), CGPoint(x:1284.0862003928253,y: 1255.0),CGPoint(x: 1216.6342951089923,y: 1372.5),   CGPoint(x: 1081.7304845413264,y: 1372.5),CGPoint(x: 946.8266739736607, y: 1372.5),CGPoint(x: 811.9228634059948, y: 1372.5),CGPoint(x: 677.0190528383291,y: 1372.5), CGPoint(x: 609.5671475544962,y: 1255.0),CGPoint(x: 542.1152422706632,y: 1137.5),CGPoint(x: 474.6633369868303,y: 1020.0),CGPoint(x: 407.2114317029974, y: 902.5),CGPoint(x: 474.6633369868303, y: 785.0),CGPoint(x: 542.1152422706632,y: 667.5),CGPoint(x: 609.5671475544962,y: 550.0),CGPoint(x: 677.0190528383291, y: 432.5)]
    var reOrderedCoordinateArrayPointsCentered: [CGPoint] = []
    let hexaDiameter : CGFloat = 150
    var avaImage: UIImageView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentPages = storyboard?.instantiateViewController(identifier: "customPageView")
        contentPages!.userDataVM = userDataVM
       // currentPostingUserID = (userDataVM!.userData.value!.publicID)
       // contentPages!.currentUserPostingID = currentPostingUserID
        plusHexagon.isUserInteractionEnabled = true
        let addTap = UITapGestureRecognizer(target: self, action: #selector(addHexagonTapped))
        plusHexagon.addGestureRecognizer(addTap)
        //print("This is reordered count before append \(reOrderedCoordinateArrayPoints.count)")
        reOrderedCoordinateArrayPoints.append(contentsOf: fourthRowArray)
        //print("This is reordered count after append \(reOrderedCoordinateArrayPoints.count)")
        setUpScrollView()
        setZoomScale()
        setUpNavBarView()
        self.navBarView.backgroundColor = .clear
        self.navBarView.layer.borderWidth = 0.0
        addMenuButtons()
        addTrashButton()
        
        followView.isHidden = false
        toSearchButton.isHidden = false
        toSettingsButton.isHidden = false
        
        
        
        observeUserData()
        refresh()
    }
    
    func observeUserData() {
        userDataVM?.userData.observe { userData in
            if (userData == nil) {
                self.observeUserData()
                return
            }
            
            
            // do changes? maybe refresh
            self.refresh()
            self.setUpPageViewListener()
            self.observeUserData()
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
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        resizeScrollView(numPosts: 0)
        scrollView.bouncesZoom = false
        scrollView.scrollsToTop = false
        
    }
    
    
    func setUpViewCounter() {
        self.navBarView.addSubview(followView)
        self.followView.backgroundColor = .white
        self.followView.frame = CGRect(x: navBarView.frame.midX - 45, y: toSettingsButton.frame.minY, width: 90, height: 30)
        
        self.followView.layer.cornerRadius = followView.frame.size.width / 20
        self.followView.layer.borderWidth = 3
        self.followView.layer.borderColor = UIColor(red: 0.61, green: 0.38, blue: 0.87, alpha: 1.00).cgColor
        self.followView.addSubview(followImage)
        self.followView.addSubview(followLabel)
        self.followImage.frame = CGRect(x: 5, y: 0, width: followView.frame.height, height: followView.frame.height)
        self.followView.layer.cornerRadius = followView.frame.size.width/10
        //self.followView.clipsToBounds()
        self.followImage.image = UIImage(named: "eyeFinal")
        self.followLabel.frame = CGRect(x: followImage.frame.maxX + 5, y: 0.0, width: followView.frame.width - 10, height: followView.frame.height)
//        self.followLabel.text = profileViews
        self.followLabel.textColor = .black
        setUpPageViewListener()
    }
    
    func setZoomScale() {

        scrollView.maximumZoomScale = 60
        scrollView.minimumZoomScale = 0.5
    }
    
    func addMenuButtons() {
        view.addSubview(menuView)
        menuView.currentTab = 2
        menuView.addBehavior()
        menuView.dmButton.isHidden = true
        menuView.homeProfileButton.isHidden = true
        menuView.friendsButton.isHidden = true
        menuView.notificationsButton.isHidden = true
        menuView.newPostButton.isHidden = true
    }
    
    func addSearchButton() {
        self.view.addSubview(toSearchButton)
        toSearchButton.frame = CGRect(x: self.view.frame.width-45, y: navBarY, width: 25, height: 25)
        // round ava
        //        toSearchButton.layer.cornerRadius = toSearchButton.frame.size.width / 2
        toSearchButton.clipsToBounds = true
        toSearchButton.isHidden = false
    }
    
    func addSettingsButton() {
        self.view.addSubview(toSettingsButton)
        toSettingsButton.frame = CGRect(x: 15, y: navBarY, width: 25, height: 25)
        // round ava
        toSettingsButton.clipsToBounds = true
        toSettingsButton.isHidden = false
    }
    
    func addTrashButton() {
        view.addSubview(trashButton)
        trashButton.frame = menuView.menuButton.frame
        trashButton.imageView?.image = UIImage(named: "trashCircle")
        // round ava
        trashButton.layer.cornerRadius = trashButton.frame.size.width / 2
        trashButton.clipsToBounds = true
        trashButton.isHidden = true
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
        
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
        
//        if (width == contentView.frame.width && height == contentView.frame.height) {
//            toSettingsButton.isHidden = false
//            toSearchButton.isHidden = false
//            followView.isHidden = false
//            return
//        }
        
        contentView.frame = CGRect(x: 0,y: 0,width: width, height: height)
        scrollView.contentSize = CGSize(width: width, height: height)
        resetCoordinatePoints()
        let contentOffset = CGPoint(x: contentView.frame.width/2 - view.frame.width/2, y: contentView.frame.height/2 - view.frame.height/2)
        scrollView.contentOffset = contentOffset
        scrollView.setZoomScale(zoomScale, animated: true)
        
        toSettingsButton.isHidden = false
        toSearchButton.isHidden = false
        followView.isHidden = false
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
    
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        toSearchButton.isHidden = true
//        toSettingsButton.isHidden = true
//        followView.isHidden = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        toSearchButton.isHidden = false
        toSettingsButton.isHidden = false
        followView.isHidden = false
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageViewSize = contentView.frame.size
        let scrollViewSize = scrollView.bounds.size
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height)/2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width)/2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
        
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        toSearchButton.isHidden = false
        toSettingsButton.isHidden = false
        followView.isHidden = false
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        toSearchButton.isHidden = false
        toSettingsButton.isHidden = false
        followView.isHidden = false
    }
    
    
    // refresh logic when view will appear
    func refresh() {
        //loadView()
        
        if (userDataVM?.userData.value != nil) {
            scrollView.zoomScale = 1
            let contentOffset = CGPoint(x: contentView.frame.width/2 - view.frame.width/2, y: contentView.frame.height/2 - view.frame.height/2)
            scrollView.contentOffset = contentOffset
            
            if self.userDataVM?.userData.value?.identityValues.isEmpty ?? false {
                let personalDetailTableViewVC = self.storyboard?.instantiateViewController(withIdentifier: "personalDetailTableViewVC") as! PersonalDetailTableViewVC
                personalDetailTableViewVC.modalPresentationStyle = .fullScreen
                personalDetailTableViewVC.userDataVM = self.userDataVM
                personalDetailTableViewVC.comingFromHome = true
                self.present(personalDetailTableViewVC, animated: false, completion: nil)
            }
            
//            print("populates without getting userdata")
            populateUserAvatar()
            //menuView.userData = userData
            createImageViews(completion: {
            })
            
            return
        }

    }
    
    // search button logic
    @objc func toSearchButtonClicked(_ recognizer: UITapGestureRecognizer) {
        let userTableVC = storyboard?.instantiateViewController(identifier: "userTableView") as! UserTableView
        userTableVC.userDataVM = userDataVM
        present(userTableVC, animated: false)
        //        print("frame after pressed \(toSearchButton.frame)")
        
    }
    
    @objc func toSettingsButtonClicked(_ recognizer: UITapGestureRecognizer) {
        
        let settingsVC = self.storyboard!.instantiateViewController(identifier: "settingsVC") as! ProfessionalSettingsVC
        settingsVC.userDataVM = userDataVM
    
        self.present(settingsVC, animated: false)
        settingsVC.modalPresentationStyle = .fullScreen
    }
    
    func createImageViews(completion: @escaping () -> ()) {
        var newPostImageArray = [PostImageView]()
        if userDataVM?.userData.value == nil {
            return
        }
        db.collection("Hexagons2").whereField("postingUserID", isEqualTo: userDataVM!.userData.value!.publicID).getDocuments(completion: { objects, error in
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
                    if (newPostImageArray.count < 37 && hexData.location > 0 && hexData.location < 37) {
                        let hexImage = self.createPostImage(hexData: hexData)
                        newPostImageArray.append(hexImage)
                    }
                }
                self.updatePages(posts: newPostImageArray)
                
                self.resizeScrollView(numPosts: newPostImageArray.count) // clears out all content
                
//                print("populates after resizescrollview")
                self.populateUserAvatar()
                self.imageViewArray = newPostImageArray
                self.changePostImageCoordinates()
                var imageIndex = 0
                var prioritizedPosts: [PostImageView] = []
                for image in self.imageViewArray {
                    self.contentView.addSubview(image)
                    shakebleImages.append(image)
                    self.contentView.bringSubviewToFront(image)
                    if image.hexData?.isPrioritized == true {
                    prioritizedPosts.append(image)
                    image.pulse(withIntensity: 0.8, withDuration: 1.5, loop: true)
                    }
                    self.contentView.bringSubviewToFront(self.indexLabelArray[imageIndex])
                    self.indexLabelArray[imageIndex].center = image.center
                    self.indexLabelArray[imageIndex].isHidden = true
                   // self.contentView.bringSubviewToFront(hexLocationLabel)
                    image.isHidden = false
                    imageIndex = imageIndex + 1
                
                }
                self.contentView.bringSubviewToFront(self.avaImage!)
               
                //add plusHexagon
                self.contentView.addSubview(self.plusHexagon)
           
                self.plusHexagon.image = UIImage(named: "whitehexplusbig")
                self.plusHexagon.backgroundColor = UIColor(cgColor: CGColor(gray: 0.10, alpha: 0.6))
                //self.plusHexagon.backgroundColor = UIColor(white: 0.25, alpha: 0.5)
               
                self.plusHexagon.frame = CGRect(x: self.reOrderedCoordinateArrayPoints[self.imageViewArray.count+1].x,
                                                y: self.reOrderedCoordinateArrayPoints[self.imageViewArray.count+1].y, width: self.hexaDiameter, height: self.hexaDiameter)
                
                self.plusHexagon.setupHexagonMask(lineWidth: self.plusHexagon.frame.width/15, color: .clear, cornerRadius: self.plusHexagon.frame.width/15)
               // shakebleImages.append(plusHexagon)
                self.contentView.bringSubviewToFront(self.plusHexagon)
                
            }
            completion()
        })
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
        contentPages!.userDataVM = userDataVM
        
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
                    let userData = self.userDataVM?.userData.value
                    userData?.numPosts = posts.count
                    if (userData != nil) {
                        self.userDataVM?.updateUserData(newUserData: userData!, completion: {_ in})
                    }
                }
            }
        }
    }
    
    func changePostImageCoordinates() {
  //      var imageIndex = 0
        self.indexLabelArray = []
        self.indexImageViewArray = []
        for image in imageViewArray {
            let imageType = image.hexData?.type
       var copyColor = myBlueGreen
            
            if imageType == "photo" {
            copyColor = myOrange as UIColor
            }
            else if imageType!.contains("social") {
            copyColor = myPink as UIColor
            }
            else if imageType == "music" {
            copyColor = myBlueGreen as UIColor
            }
            else if imageType == "link" {
            copyColor = myCoolBlue as UIColor
            }
        
            
            
            
            image.frame = CGRect(x: self.reOrderedCoordinateArrayPoints[image.hexData!.location].x,
                                 y: self.reOrderedCoordinateArrayPoints[image.hexData!.location].y, width: hexaDiameter, height: hexaDiameter)
            let imageCopyFrame = image.frame
            let imageCopy = UIImageView(frame: imageCopyFrame)
            imageCopy.backgroundColor = copyColor
            imageCopy.setupHexagonMask(lineWidth: imageCopy.frame.width/15, color: copyColor, cornerRadius: imageCopy.frame.width/15)
            self.indexImageViewArray.append(imageCopy)
            //print("Now this is indexImageviewarray count \(indexImageViewArray.count)")
    
      //      print("This is imageIndex \(imageIndex)")
        //    print("This is indexLabelaArray.count \(indexLabelArray.count)")
         //   indexLabelArray[imageIndex].center = image.center
        // imageIndex = imageIndex + 1
            let hexLocationLabel = UILabel()
            hexLocationLabel.textAlignment = .center
            self.contentView.addSubview(hexLocationLabel)
            self.contentView.addSubview(imageCopy)
            let LabelWidth = image.frame.width/3
            let LabelHeight = image.frame.height/3
            hexLocationLabel.frame = CGRect(x: (image.frame.midX-LabelWidth)/2, y: (image.frame.midY-LabelHeight)/2, width: LabelWidth, height: LabelHeight)
            hexLocationLabel.text = "\( image.hexData!.location)"
        //    hexLocationLabel.font.withSize(45)
            hexLocationLabel.font = UIFont(name: "DINAternate-SemiBold", size: 90)
            hexLocationLabel.textColor = white
            hexLocationLabel.center = image.center
            self.contentView.bringSubviewToFront(imageCopy)
            self.contentView.bringSubviewToFront(hexLocationLabel)
            self.indexLabelArray.append(hexLocationLabel)
            
            hexLocationLabel.isHidden = true
            imageCopy.isHidden = true
            
            
            
            
        }
        
        
    }
    
    
    func createContentView() {
        let interaction = UIContextMenuInteraction(delegate: self)
        self.imageViewArray[0].addInteraction(interaction)
        
    }
    
    
    
    func createPostImage(hexData: HexagonStructData) -> PostImageView {
        let hexaDiameter : CGFloat = 150
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longTap))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        
        let image = PostImageView(frame: CGRect(x: self.reOrderedCoordinateArrayPoints[hexData.location].x,
                                                y: self.reOrderedCoordinateArrayPoints[hexData.location].y, width: hexaDiameter, height: hexaDiameter))
        image.contentMode = .scaleAspectFill
        image.image = UIImage()
        image.hexData = hexData
        image.tag = hexData.location
        
        image.addGestureRecognizer(longGesture)
        image.addGestureRecognizer(tapGesture)
        image.isUserInteractionEnabled = true
        //    var gold = #colorLiteral(red: 0.9882352941, green: 0.7607843137, blue: 0, alpha: 1)
//        print("This is the type of hexagon: \(hexData.type)")
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
            var ttext = hexData.text.lowercased()
           // ttext = ttext.replacingOccurrences(of: " ", with: "-")
            print("This is image name \(ttext)")
            image.image = UIImage(named: ttext)
            createHexagonMaskWithCorrespondingColor(imageView: image, type: myType)
        }
        else if myType == "pin_phone" {
//            let ttext = hexData.text
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
            //change this to photo one when we make that
            var placeHolderImage = UIImage(named: "linkCenter")
            
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
                placeHolderImage = UIImage(named: "socialMediaCenter")
            default:
                placeHolderImage = UIImage(named: "socialMediaCenter")
            }
            
            
            // image.setupHexagonMask(lineWidth: 10.0, color: myBlueGreen, cornerRadius: 10.0)
            createHexagonMaskWithCorrespondingColor(imageView: image, type: myType)
            //let ref = storage.child(hexData.thumbResource)
            
            if hexData.thumbResource.contains("userFiles/") || hexData.thumbResource.contains("icons/") {
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
    //    image.textOverlay.frame = CGRect(x: 0, y: image.frame.height*(5/10) + 4, width: image.frame.width, height: 20)
        image.textOverlay.frame = CGRect(x: 0, y: image.frame.height*(6/10), width: image.frame.width, height: 20)
        image.textOverlay.text = image.hexData!.coverText
        image.textOverlay.numberOfLines = 1
        image.textOverlay.font = UIFont(name: "DINAternate-Bold", size: 10)
        image.textOverlay.textColor = white
        
      
        
        
        
        if image.hexData!.coverText != "" {
            image.textOverlay.backgroundColor = UIColor(white: 0.25, alpha: 0.5)
        }
        
        
        return image
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if tabBarController != nil {
            menuView.tabController = (tabBarController! as! NavigationMenuBaseController)
        }
        //scrollView.zoomScale = 1
        observeUserData()
        toSearchButton.isHidden = false
        toSettingsButton.isHidden = false
        followView.isHidden = false
        setUpPageViewListener()
        refresh()
        
    }
    
    
    var dragView : PostImageView? = nil
    var draggedcounter = 0
    
    
    @objc func longTap(_ sender: UIGestureRecognizer){
//        print("Long tap")
//        print("🎹🎹🎹🎹🎹🎹🎹🎹🎹")
        //scrollView.zoomScale = 1
        var currentHexagonCenter = CGPoint(x:0.0, y:0.0)
        let hexImage = sender.view! as! PostImageView
       
        var removedImageView = PostImageView()
        var removedImageLocation = Int()
         if sender.state == .began {
            for hexLabel in indexLabelArray {
                hexLabel.isHidden = false
            }
            for imageCopy in indexImageViewArray {
                imageCopy.isHidden = false
            }
            
            
            let tappedImage = sender.view as! PostImageView
            currentHexagonCenter = tappedImage.center
//            print("yo: This is tapped image.center \(tappedImage.center)")
            tappedImage.setupHexagonMask(lineWidth: 10.0, color: .red, cornerRadius: 10.0)
            removedImageView = shakebleImages[sender.view!.tag - 1]
            removedImageLocation = sender.view!.tag - 1
            shakebleImages.remove(at: sender.view!.tag - 1)
//            for shakeyImage in shakebleImages {
//                shakeyImage.shake()
//            }
            
            //dragItem(sender as! UIPanGestureRecognizer)
            dragView = (sender.view as! PostImageView)
            dragView?.center = sender.location(in: contentView)
//            print("yo: this is dragView.center before \(dragView!.center)")
            contentView.bringSubviewToFront(dragView!)
            trashButton.isHidden = false
            menuView.menuButton.isHidden = true
            
            for image in imageViewArray {
                image.setupHexagonMask(lineWidth: 10.0, color: .darkGray, cornerRadius: 10.0)
            }
            
        }
        else if (sender.state == .changed) {
            draggedcounter += 1
            let xDelta = dragView!.center.x - sender.location(in: contentView).x
            let yDelta = dragView!.center.y - sender.location(in: contentView).y
            dragView?.center = sender.location(in: contentView)

            currentHexagonCenter = (sender.view?.center)!

            
            let hexCenterInView = contentView.convert(currentHexagonCenter, to: view)
            if (draggedcounter > 25 || xDelta > 2 || yDelta > 2) {
                draggedcounter = 0
                let _ = self.findIntersectingHexagon(hexView: self.dragView!)
            }
            
            if (distance(hexCenterInView, trashButton.center) < 70) {
                trashButton.imageView!.makeRoundedRed()
            } else {
                trashButton.imageView!.makeRoundedBlack()
            }
        }
       else if (sender.state == .ended) {
        for hexLabel in indexLabelArray {
            hexLabel.isHidden = true
        }
        for imageCopy in indexImageViewArray {
            imageCopy.isHidden = true
        }
            shakebleImages.insert(removedImageView, at: removedImageLocation)
            currentHexagonCenter = (sender.view?.center)!
            let hexCenterInView = contentView.convert(currentHexagonCenter, to: view)
            if (distance(hexCenterInView, trashButton.center) < 70) {
                // trash current hexagon
                
                // give alert
                let refreshAlert = UIAlertController(title: "Delete This Post?", message: "All data will be lost.", preferredStyle: UIAlertController.Style.alert)

                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [self] (action: UIAlertAction!) in
//                      print("Handle Deleting Hexagon!")
                    self.handleDeleting(hexImage: hexImage)
                    
                }))

                refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
//                      print("Handle Cancel Logic here")
                    self.refresh()
                }))

                present(refreshAlert, animated: true, completion: nil)
            
            }
            else {
                let intersectingHex = findIntersectingHexagon(hexView: dragView!)
                if (intersectingHex != nil && intersectingHex?.hexData?.location != dragView?.hexData?.location) {
                    let tempLoc = intersectingHex!.hexData!.location
                    intersectingHex!.hexData!.location = dragView!.hexData!.location
                    dragView!.hexData!.location = tempLoc
                    db.collection("Hexagons2").document(intersectingHex!.hexData!.docID).setData(intersectingHex!.hexData!.dictionary) { error in
                        if error == nil {
                            self.db.collection("Hexagons2").document(self.dragView!.hexData!.docID).setData(self.dragView!.hexData!.dictionary) { error in
                                self.refresh()
                            }
                        }
                    }
                }

                else {
                    refresh()
                }
            }
            
            trashButton.isHidden = true
            menuView.menuButton.isHidden = false
            
        }
    }
    
    func setUpNavBarView() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        self.view.addSubview(navBarView)
        self.navBarView.frame = CGRect(x: -5, y: -5, width: self.view.frame.width + 10, height: (self.view.frame.height/12)+5)
        let navBarHeightRemaining = navBarView.frame.maxY - statusBarHeight
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
      //  self.navBarView.addSubview(titleLabel1)
        self.navBarView.addBehavior()
        self.navBarView.titleLabel.isHidden = true
//        print("This is navBarView.")
        self.toSettingsButton.setImage(UIImage(named: "lightGrayGearFinal"), for: .normal)
        self.toSearchButton.setImage(UIImage(named: "lightGrayMagnifyingGlassFinal"), for: .normal)

        setUpViewCounter()
        

    }
    
    
    func handleDeleting(hexImage: PostImageView) {
        hexImage.hexData!.isArchived = true
        // push update to server
        let docRef = db.collection("Hexagons2").document(hexImage.hexData!.docID)
        docRef.setData(hexImage.hexData!.dictionary) { error in
            if error == nil {
                let userData = self.userDataVM?.userData.value
                userData?.numPosts -= 1
                if userData != nil {
                    self.userDataVM?.updateUserData(newUserData: userData!, completion: {_ in})
                }
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
    
    
    func createHexagonMaskWithCorrespondingColor(imageView: UIImageView, type: String) {
        if type == "photo" {
          //  imageView.addHexagonGradiendBorder(10.0)
            //imageView.bringSubviewToFront(imageView.image)
            imageView.setupHexagonMask(lineWidth: imageView.frame.width/15, color: myOrange, cornerRadius: imageView.frame.width/15)
        }
        else if type == "video" {
            imageView.setupHexagonMask(lineWidth: imageView.frame.width/15, color: myOrange, cornerRadius: imageView.frame.width/15)
        }
        else if type == "tik" {
            imageView.setupHexagonMask(lineWidth: imageView.frame.width/15, color: white, cornerRadius: imageView.frame.width/15)
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
        else if type == "music" {
            imageView.setupHexagonMask(lineWidth: imageView.frame.width/15, color: myBlueGreen, cornerRadius: imageView.frame.width/15)
        }
        else if type == "link" {
            imageView.setupHexagonMask(lineWidth: imageView.frame.width/15, color: myCoolBlue, cornerRadius: imageView.frame.width/15)
        }
        else if type.contains("social") {
            if type.contains("tik") {
                //example label
//                let nameLabel = UILabel()
//                self.contentView.addSubview(nameLabel)
//                nameLabel.text = "@username"
//                nameLabel.frame = CGRect(x: imageView.frame.minX + 15, y: imageView.frame.midY - 10, width: 120, height: 20)
//                nameLabel.textAlignment = .center
                //white border for tik tok with black logo
                imageView.setupHexagonMask(lineWidth: imageView.frame.width/15, color: .white, cornerRadius: imageView.frame.width/15)
         
            //    nameLabel.textColor = .white
             
       
            }
            if type.contains("cameo") {
                    imageView.setupHexagonMask(lineWidth: imageView.frame.width/15, color: white, cornerRadius: imageView.frame.width/15)
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

    func findIntersectingHexagon(hexView: PostImageView) -> PostImageView? {
        //find coordinates of final location for hexagon
        let hexCenter = hexView.center
        let red = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        //var closeHexagons = [PostImageView]()
        //let gold = #colorLiteral(red: 0.9882352941, green: 0.7607843137, blue: 0, alpha: 1)
        
        var hexToReturn = hexView
        for hex in self.imageViewArray {
            if (hex.hexData!.isArchived) {
                continue
            }
            else if hexView == hex {
                continue
            }
            else if distance(hexCenter, reOrderedCoordinateArrayPointsCentered[hex.hexData!.location]) < hexaDiameter/2 {
                hex.setupHexagonMask(lineWidth: 10.0, color: red, cornerRadius: 10.0)
                //closeHexagons.append(hex)
                hexToReturn = hex
            }
            else {
                hex.setupHexagonMask(lineWidth: 10.0, color: .darkGray, cornerRadius: 10.0)
            }
        }
        return hexToReturn
        
    }
    
    func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt(xDist * xDist + yDist * yDist))
    }
    
    
    @objc func addHexagonTapped() {
        print("I recognized this")
        let viewControllers = menuView.tabController!.customizableViewControllers!
        let newPostVC = (viewControllers[4] as! NewPost5OptionsVC)
        newPostVC.menuView.dmButton.isHidden = true
        newPostVC.menuView.newPostButton.isHidden = true
        newPostVC.menuView.friendsButton.isHidden = true
        newPostVC.menuView.notificationsButton.isHidden = true
        newPostVC.menuView.homeProfileButton.isHidden = true
        newPostVC.menuView.notificationLabel.isHidden = true
        menuView.tabController!.viewControllers![4] = newPostVC
        menuView.tabController!.customTabBar.switchTab(from: menuView.currentTab, to: 4)
    }
 
    
    func textToImage(drawText text: String, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
       let textColor = UIColor.white
       let textFont = UIFont(name: "DINAternate-Bold", size: 12)

       let scale = UIScreen.main.scale
       UIGraphicsBeginImageContextWithOptions(image.size, false, scale)

       let textFontAttributes = [
        NSAttributedString.Key.font: textFont as Any,
        NSAttributedString.Key.foregroundColor: textColor,
       ] as [NSAttributedString.Key : Any]
       image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))

       let rect = CGRect(origin: point, size: image.size)
       text.draw(in: rect, withAttributes: textFontAttributes)

       let newImage = UIGraphicsGetImageFromCurrentImageContext()
       UIGraphicsEndImageContext()

       return newImage!
    }
    
    func createContextMenu() -> UIMenu {
        let shareAction = UIAction(title: "View Profile Picture", image: .none) { _ in
//    print("View Profile Picture")
        self.handleProfilePicTapView(UITapGestureRecognizer())
        
    }
        let copy = UIAction(title: "Change Profile Picture", image: .none) { _ in
        let editProfilePhotoVC = self.storyboard?.instantiateViewController(identifier: "editProfilePhotoVC2") as! EditProfilePhotoVC2
            editProfilePhotoVC.userDataVM = self.userDataVM
        self.present(editProfilePhotoVC, animated: false)
    }
        let followers = UIAction(title: "Followers", image: .none) { _ in
            let followersTableView = self.storyboard?.instantiateViewController(identifier: "followersTableView") as! FollowersTableView
            followersTableView.userDataVM = self.userDataVM
            self.present(followersTableView, animated: false)
        }
        let following = UIAction(title: "Following", image: .none) { _ in
            let followingTableView = self.storyboard?.instantiateViewController(identifier: "followingTableView") as! FollowingTableView
            followingTableView.userDataVM = self.userDataVM
            self.present(followingTableView, animated: false)
        }
        
        
    let cancelAction = UIAction(title: "Cancel", image: .none, attributes: .destructive) { action in
             // Delete this photo 😢
         }
        
    return UIMenu(title: "", children: [shareAction, copy, followers,following, cancelAction])
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
    return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ -> UIMenu? in
    return self.createContextMenu()
        }
    }
    
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
        let interaction = UIContextMenuInteraction(delegate: self)
        avaImage?.addInteraction(interaction)
        avaImage?.isHidden = false
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(self.handleProfilePicTap))
        avaTap.numberOfTapsRequired = 1
        avaImage?.isUserInteractionEnabled = true
        avaImage?.addGestureRecognizer(avaTap)
        
        contentView.bringSubviewToFront(avaImage!)
        avaImage!.layer.cornerRadius = (avaImage!.frame.size.width)/2
        avaImage?.clipsToBounds = true
        avaImage?.layer.masksToBounds = true
        avaImage?.layer.borderColor = UIColor.white.cgColor
        avaImage?.layer.borderWidth = (avaImage?.frame.width)!/30
//        var myCenter = avaImage?.center
       // var mySize = avaImage?.bounds*
        
        if (userDataVM?.userData.value == nil) {
            return
        }
        let cleanRef = userDataVM?.userData.value?.avaRef.replacingOccurrences(of: "/", with: "%2F")
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/bio-social-media.appspot.com/o/\(cleanRef ?? "")?alt=media")
        if cleanRef != nil && url != nil {
        avaImage!.sd_setImage(with: url!, placeholderImage: UIImage(named: "user-2"), completed: {_, error, _, _ in
            if error != nil {
                print(error!.localizedDescription)
            }
        })
        }
        else {
            avaImage?.image = UIImage(named: "user-2")
        }
    }
    
    func scrollIfNeeded(location: CGPoint, xDelta: CGFloat, yDelta: CGFloat) {
        //        print("im in scrollifneeded")
        let scrollSuperview: UIView = scrollView.superview!
        let bounds: CGRect = scrollSuperview.bounds
        var scrollOffset: CGPoint = scrollView.contentOffset
        var xOfs: CGFloat = 0
        var yOfs: CGFloat = 0
        let speed: CGFloat = 5.0
        
        if ((location.x > bounds.size.width * 0.85) && (xDelta < 0)) {
            //            print("should be panning right")
            xOfs = CGFloat(CGFloat(speed) * location.x/bounds.size.width)
        }
        if ((location.y > bounds.size.height * 0.90) && (yDelta < 0)) {
            //            print("should be panning down")
            yOfs = CGFloat(CGFloat(speed) * location.y/bounds.size.height)
        }
        if ((location.x < bounds.size.width * 0.15) && (xDelta > 0))
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
        
        if ((location.y < bounds.size.height * 0.15) && (yDelta > 0))
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
    
    
    func dismissFullscreenImage(view: UIView) {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        menuView.menuButton.isHidden = false
        view.removeFromSuperview()
    }
    
    @objc func handleProfilePicTap(_ sender: UITapGestureRecognizer) {
        let guestProfileVC = self.storyboard!.instantiateViewController(identifier: "guestProfileVC") as! GuestProfileVC
        guestProfileVC.guestUserData = userDataVM?.userData.value
        guestProfileVC.userDataVM = userDataVM
     //   guestProfileVC.isFollowing = sender.view?.tag == 1
        self.present(guestProfileVC, animated: false)
        self.modalPresentationStyle = .fullScreen

    }
    
    
    
    @objc func handleProfilePicTapView(_ sender: UITapGestureRecognizer) {
//        print("Tried to click profile pic handle later")
        menuView.menuButton.isHidden = true
        newImageView = UIImageView(image: UIImage(named: "kbit"))
        let cleanRef = userDataVM?.userData.value?.avaRef.replacingOccurrences(of: "/", with: "%2F")
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/bio-social-media.appspot.com/o/\(cleanRef ?? "")?alt=media")
        if cleanRef != nil && url != nil {
            newImageView.sd_setImage(with: url!, completed: {_, error, _, _ in
                if error != nil {
                    print(error!.localizedDescription)
                }
            })
        }
        else {
            newImageView.image = UIImage(named: "user-2")
        }
        
        self.view.addSubview(newImageView)
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        newImageView.frame = frame
        newImageView.backgroundColor = .black
        
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImageHandler))
        profilePicCancelButton.addGestureRecognizer(tap)
        
        let textView = UITextView()
        textView.text = "asdfkjlasdfjasdf"
        textView.textColor = .red
        profilePicCancelButton.addGestureRecognizer(tap)
        profilePicCancelButton.isUserInteractionEnabled = true
        view.addSubview(profilePicCancelButton)
        profilePicCancelButton.frame = CGRect(x: view.frame.width/2-40, y: view.frame.height-112, width: 80, height: 80)
        profilePicCancelButton.setImage(UIImage(named: "cancel2"), for: .normal)
        view.bringSubviewToFront(profilePicCancelButton)
        profilePicCancelButton.layer.cornerRadius = profilePicCancelButton.frame.size.width / 2
        profilePicCancelButton.backgroundColor = .black
        //returnButton.setBackgroundImage(UIImage(named: "cancel11"), for: .normal)
        profilePicCancelButton.clipsToBounds = true
        
        
        
    }
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        //        print("🎯🎯🎯🎯🎯Hello World")
    print("🎯🎯🎯🎯🎯🎯🎯I tapped image with tag \(sender.view!.tag)")
        
        let postImage = sender.view as! PostImageView
        let hexItem = postImage.hexData!
        
        if contentPages!.setPresentedViewControllers(vcIndex: hexItem.location - 1) {
            contentPages!.modalPresentationStyle = .fullScreen
            self.present(contentPages!, animated: false, completion: nil)
        }
        
        
    }
    

    @objc func dismissFullscreenImageHandler(_ sender: UITapGestureRecognizer) {
        dismissFullscreenImage(view: sender.view!)
        newImageView.removeFromSuperview()
        dismissFullscreenImage(view: newImageView)
    }
    
        
        
    @IBAction func unvindSegueSignOut(segue: UIStoryboardSegue) {
        do {
            try Auth.auth().signOut()
        }
        catch {
            print("could not sign out")
        }
        
        
        self.dismiss(animated: false, completion: nil)
    }
    
    
    func setUpPageViewListener() {
        pageViewListener?.remove()
        let userData = userDataVM?.userData.value
        if (userData == nil) {
            return
        }
        pageViewListener = db.collection("PageViews").whereField("viewed", isEqualTo: userData!.publicID).addSnapshotListener({ objects, error in
            if error == nil {
                self.followLabel.text = "\(objects?.documents.count ?? 0)"
            }
            else {
                self.followLabel.text = "0"
            }
            self.followLabel.sizeToFit()
            let xOffset = (self.followView.frame.width + self.followImage.frame.maxX - self.followLabel.frame.width)/2
            self.followLabel.frame = CGRect(x: xOffset, y: self.followLabel.frame.minY, width: self.followLabel.frame.width, height: self.followView.frame.height)
        })
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
    
    func makeRoundedBlack() {
        
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
    
    func makeSquareClear() {
        
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.cornerRadius = 0.0
        self.clipsToBounds = true
    }
    
    
    
    func makeRoundedPurple() {
        
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.purple.cgColor
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
    
    func makeRoundedMyCoolBlue() {
        
        self.layer.borderWidth = 4
        self.layer.masksToBounds = false
        self.layer.borderColor = myCoolBlue.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
    
    func makeRoundedMyBlueGreen() {
        
        self.layer.borderWidth = 4
        self.layer.masksToBounds = false
        self.layer.borderColor = myBlueGreen.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
    
    func makeRoundedMyPink() {
        self.layer.borderWidth = 4
        self.layer.masksToBounds = false
        self.layer.borderColor = myPink.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
    
    func makeRoundedMyOrange() {
        
        self.layer.borderWidth = 4
        self.layer.masksToBounds = false
        self.layer.borderColor = myOrange.cgColor
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
    
  
  func shake() {
    let animation = CABasicAnimation(keyPath: "position")
    animation.duration = 0.07
    animation.repeatCount = 3
    animation.autoreverses = true
    animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
    animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
    self.layer.add(animation, forKey: "position")
  }

}

extension PostImageView {

    func flash() {
        // Take as snapshot of the button and render as a template
        let snapshot = self.snapshot?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: snapshot)
        // Add it image view and render close to white
        imageView.tintColor = UIColor(white: 0.9, alpha: 1.0)
        guard let image = imageView.snapshot  else { return }
        let width = image.size.width
        let height = image.size.height
        // Create CALayer and add light content to it
        let shineLayer = CALayer()
        shineLayer.contents = image.cgImage
        shineLayer.frame = bounds
        // create CAGradientLayer that will act as mask clear = not shown, opaque = rendered
        // Adjust gradient to increase width and angle of highlight
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor,
                                UIColor.clear.cgColor,
                                UIColor.black.cgColor,
                                UIColor.clear.cgColor,
                                UIColor.clear.cgColor]
        gradientLayer.locations = [0.0, 0.35, 0.50, 0.65, 0.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)

        gradientLayer.frame = CGRect(x: -width, y: 0, width: width, height: height)
        // Create CA animation that will move mask from outside bounds left to outside bounds right
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.byValue = width * 2
        // How long it takes for glare to move across button
        animation.duration = 3
        // Repeat forever
        animation.repeatCount = Float.greatestFiniteMagnitude
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)

        layer.addSublayer(shineLayer)
        shineLayer.mask = gradientLayer

        // Add animation
        gradientLayer.add(animation, forKey: "shine")
    }

    func stopFlash() {
        // Search all sublayer masks for "shine" animation and remove
        layer.sublayers?.forEach {
            $0.mask?.removeAnimation(forKey: "shine")
        }
    }
}
extension UIView {
    // Helper to snapshot a view
    var snapshot: UIImage? {
        let renderer = UIGraphicsImageRenderer(size: bounds.size)

        let image = renderer.image { context in
            layer.render(in: context.cgContext)
        }
        return image
    }
}
