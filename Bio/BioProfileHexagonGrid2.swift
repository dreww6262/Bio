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

class BioProfileHexagonGrid2: UIViewController, UIScrollViewDelegate {
    
    
    //var user = PFUser.current()!.username!
    
    let menuView = MenuView()
    var user = Auth.auth().currentUser
    var storage = Storage.storage().reference()
    var contentViewer = UIView()
    //    var usernameArray = [String]()
    //     var avaArray = [PFFileObject]()
    // array showing who we follow
    var followArray = [String]()
    var followingUserDataArray = ThreadSafeArray<UserData>()
    let db = Firestore.firestore()
    var userData: UserData?
    var loadUserDataArray: [UserData] = []
    var tableView = UITableView()
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var toSearchButton: UIButton!
    
    
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
    var reOrderedCoordinateArrayPoints: [CGPoint] = [CGPoint(x: 946.8266739736607,y: 902.5),CGPoint(x: 1081.7304845413264,y: 902.5),CGPoint(x: 1014.2785792574934,y: 1020.0), CGPoint(x: 879.3747686898278,y: 1020.0),CGPoint(x:811.9228634059948,y: 902.5), CGPoint(x: 879.3747686898278,y: 785.0),CGPoint(x: 1014.2785792574934,y: 785.0),CGPoint(x:946.8266739736607,y: 667.5),CGPoint(x:1081.7304845413264,y:667.5), CGPoint(x:1149.1823898251594,y:785.0),CGPoint(x: 1216.6342951089923,y: 902.5),CGPoint(x:1149.1823898251594,y: 1020.0),   CGPoint(x: 1081.7304845413264,y: 1137.5), CGPoint(x:1081.7304845413264, y: 1137.5),CGPoint(x:946.8266739736607,y: 1137.5),CGPoint(x: 811.9228634059948, y: 1137.5),CGPoint(x: 744.4709581221618, y: 1020.0), CGPoint(x: 677.0190528383291, y: 902.5),CGPoint(x: 744.4709581221618, y: 785.0), CGPoint(x: 811.9228634059948, y: 667.5),CGPoint(x: 879.3747686898278, y: 550.0),CGPoint(x: 1014.2785792574934, y: 550.0),CGPoint(x: 1149.1823898251594,y: 550.0),CGPoint(x:1216.6342951089923,y: 667.5),CGPoint(x:1284.0862003928253, y: 785.0),CGPoint(x:1351.5381056766582,y: 902.5), CGPoint(x:1284.0862003928253, y: 1020.0),CGPoint(x: 1216.6342951089923, y: 1137.5),CGPoint(x: 1149.1823898251594, y: 1255.0), CGPoint(x:1014.2785792574934,y:1255.0),CGPoint(x:879.3747686898278, y:1255.0),CGPoint(x:744.4709581221618, y:1255.0),CGPoint(x:677.0190528383291, y:1137.5),CGPoint(x:609.5671475544962,y: 1020.0),CGPoint(x:542.1152422706632, y: 902.5),CGPoint(x: 609.5671475544962, y: 785.0),CGPoint(x: 677.0190528383291, y: 667.5),CGPoint(x: 744.4709581221618, y: 550.0)]
    
    
    let rows = 15
    let firstRowColumns = 15
    
    var firstLoad = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpScrollView()
        setZoomScale()
        addMenuButtons()
        addSearchButton()
        
        
    }
    
    func addSearchButton() {
        self.view.addSubview(toSearchButton)
        toSearchButton.frame = CGRect(x: self.view.frame.width-60, y: 20, width: 50, height: 50)
        // round ava
        toSearchButton.layer.cornerRadius = toSearchButton.frame.size.width / 2
        toSearchButton.clipsToBounds = true
        toSearchButton.isHidden = false
    }
    
    func addMenuButtons() {
        view.addSubview(menuView)
        menuView.currentTab = 3
        menuView.addBehavior()
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
        resizeScrollView(numFollowers: 0)
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (firstLoad) {
            firstLoad = false
            return
        }
        toSearchButton.isHidden = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        toSearchButton.isHidden = false
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        toSearchButton.isHidden = false
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        toSearchButton.isHidden = false
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        toSearchButton.isHidden = false
    }
    
    // Zoom Logic
    func resizeScrollView(numFollowers: Int) {
//        print("Contentviewframebeforeresize \(contentView.frame)")
        var rows = 0
        var width = view.frame.width
        var height = view.frame.height
        let additionalRowWidth: CGFloat = 340.0
        //     let heightDifference = height - width
        if numFollowers < 7 {
            rows = 1
            //self.scrollView.frame.width =
        }
        else if numFollowers < 19 {
            rows = 2
            height += additionalRowWidth
            width += additionalRowWidth
        }
        else if numFollowers  < 43 {
            rows = 3
            width += (2*additionalRowWidth)
            height = (2*additionalRowWidth)
        }
        else if numFollowers < 91 {
            rows = 4
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
//        print("contentviewframe: \(contentView.frame)")
        resetCoordinatePoints()
        let contentOffset = CGPoint(x: contentView.frame.width/2 - view.frame.width/2, y: contentView.frame.height/2 - view.frame.height/2)
//        print(contentOffset)
        scrollView.contentOffset = contentOffset
        toSearchButton.isHidden = false
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
        let imageViewSize = contentView.bounds.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        
//        print("width scale: \(widthScale)")
//        print("height scale: \(heightScale)")
         scrollView.minimumZoomScale = min(widthScale, heightScale)
        //scrollView.zoomScale = scrollView.minimumZoomScale
        scrollView.maximumZoomScale = 60
        //scrollView.minimumZoomScale = 0.5
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
        scrollView.isHidden = true
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }
    
    @IBAction func toSearchButtonClicked(_ sender: UIButton) {
        let userTableVC = storyboard?.instantiateViewController(identifier: "userTableVC") as! UserTableView
        userTableVC.userData = userData
        present(userTableVC, animated: false)
    }
    
    func refresh() {
        //print("in refresh")
        user = Auth.auth().currentUser
//        print("current user: \(user)")
        if (user != nil) {
            if (userData == nil || userData?.email != user?.email) {
                db.collection("UserData1").document(user!.uid).getDocument(completion: {obj,error in
                    if (error == nil) {
                        self.userData = UserData(dictionary: obj!.data()!)
                        self.menuView.userData = self.userData
//                        print("should load followings, userdata was found: \(self.userData?.email)")
                        self.loadFollowings()
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
        menuView.tabController = (tabBarController! as! NavigationMenuBaseController)
        menuView.userData = userData
        refresh()
        toSearchButton.isHidden = false
    }
    
    var listenerList: [ListenerRegistration]?
    
    func loadUpToTenFollowers(followers: [String], completion: @escaping () -> ()) {
        let userDataCollection = self.db.collection("UserData1")
        let userDataQuery = userDataCollection.whereField("publicID", in: followers)
        let listener = userDataQuery.addSnapshotListener( { (objects, error) -> Void in
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
                    })) {
                        self.followingUserDataArray.append(newElement: newUserData)
                    }
                }
            } else {
                print("could not get userdata for followings")
                print(error!.localizedDescription)
            }
            completion()
            
        })
        listenerList?.append(listener)
    }
    
    
    func doneLoading() {
        listenerList?.forEach({ listener in
            listener.remove()
        })
        listenerList = nil
        self.removeCurrentProfileHexagons()
        self.loadProfileHexagons()
    }
    
    // loading followings
    func loadFollowings() {
        if (self.followingUserDataArray.isEmpty()) {
            self.followingUserDataArray.append(newElement: userData!)
            loadProfileHexagons()
        }
        createFollowArray(completion: { newFollowArray in
//            print("loadFollowings: new follow array: \(newFollowArray)")
            if newFollowArray.count > 0 {
                // using 5 for efficiency and less possibility of timeout
                self.followingUserDataArray.removeAll()
                self.followingUserDataArray.append(newElement: self.userData!)
                let chunks = newFollowArray.chunked(into: 5)
                let group = DispatchGroup()
                self.listenerList = [ListenerRegistration]()
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
    
    func createFollowArray(completion: @escaping ([String]) -> ()) {
        let followCollection = db.collection("Followings")
        let usernameText:String = userData!.publicID
        var newFollowArray: [String] = []
        let _ = followCollection.whereField("follower", isEqualTo: usernameText).addSnapshotListener({ (objects, error) -> Void in
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
                completion(newFollowArray)
            }
            else {
                print(error!.localizedDescription)
                completion([String]())
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

    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
//        print("🎯🎯🎯🎯🎯Hello World")
//        print("🎯🎯🎯🎯🎯🎯🎯I tapped image with tag \(sender.view!.tag)")
        let username = followingUserDataArray[sender.view!.tag].publicID
//        print("🎯🎯🎯🎯🎯🎯🎯 I tapped image with associated username: \(username)")
        let guestVC = storyboard?.instantiateViewController(identifier: "guestGridVC") as! GuestHexagonGridVC
        //guestVC.user = user
        guestVC.username = userData!.publicID
        guestVC.userData = followingUserDataArray[sender.view!.tag]
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
            image.setupHexagonMask(lineWidth: 10.0, color: .darkGray, cornerRadius: 10.0)
            if thisIndex == 0 {
                image.setupHexagonMask(lineWidth: 10.0, color: white, cornerRadius: 10.0)
            }
            contentView.addSubview(image)
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

