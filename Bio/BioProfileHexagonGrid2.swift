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



class BioProfileHexagonGrid2: UIViewController, UISearchBarDelegate, UIScrollViewDelegate {
    
    
    //var user = PFUser.current()!.username!
    
    let menuView = MenuView()
    var searchBar = UISearchBar()
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
    var loadUserDataArray: [UserData] = []
    var tableView = UITableView()
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var toSearchButton: UIButton!
    
    
    
    var tabController: NavigationMenuBaseController?
    
    //var hexagonDataArray = [HexagonStructData]()
    
    //    var player = AVAudioPlayer()
    // var webView = WKWebView()
    
    @IBOutlet weak var scrollView: UIScrollView!
    var coordinateArray: [[CGFloat]] = []
    var coordinate: [CGFloat] = []
    var imageViewArray: [UIImageView] = []
    
    //@IBOutlet weak var expandedView: UIImageView!
    
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
        
        setUpScrollView()
        
        view.addSubview(searchBar)
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.tintColor = UIColor.black
        searchBar.frame.size.width = self.view.frame.size.width
        
        let searchItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.leftBarButtonItem = searchItem
        searchBar.isHidden = true
        
        
        
        //tabController = tabBarController! as! NavigationMenuBaseController
        hexaWidth = hexaDiameter * CGFloat(sqrt(3)) * CGFloat(0.5)
        hexaWidthDelta = (hexaWidth)*CGFloat(0.5)
        hexaHeightDelta = hexaDiameter * CGFloat(0.25)
        //   downloadFileFromURL(url: URL(string: "https://p.scdn.co/mp3-preview/18d3b87b0765cd6d8c0a418d6142b3b441c0f8b2?cid=476c620368f349cc8be5b2a29b596eaf")!)
        
        // background
        //        let bg = UIImageView(frame: CGRect(x: -400, y: -400, width: 3000, height: 3000))
        //        bg.image = UIImage(named: "outerspace1")
        //        bg.layer.zPosition = -1
        //        self.view.addSubview(bg)
        
        //        let bg = UIImageView(frame: CGRect(x: -400, y: -400, width: 3000, height: 3000))
        //               bg.image = UIImage(named: "outerspace1")
        //               bg.layer.zPosition = -1
        //               scrollView.addSubview(bg)
        
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
        // Do any additional setup after loading the view.
        let hexaDiameter : CGFloat = 150
        let hexaWidth = hexaDiameter * sqrt(3) * 0.5
        let hexaWidthDelta = (hexaDiameter - hexaWidth) * 0.5
        let hexaHeightDelta = hexaDiameter * 0.25
        let spacing : CGFloat = 5
        
        let rows = 15
        let firstRowColumns = 15
        //scroll view stuff 2
        print("Bounds of content view: \(contentView.bounds.size)")
        self.scrollView.contentSize = CGSize(width: spacing + CGFloat(firstRowColumns) * (hexaWidth + spacing), height: spacing + CGFloat(rows) * (hexaDiameter - hexaHeightDelta + spacing) + hexaHeightDelta)
        print("scrollview content size \(scrollView.contentSize)")
        
        
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
        let imageViewSize = contentView.bounds.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        
        print("width scale: \(widthScale)")
        print("height scale: \(heightScale)")
        // scrollView.minimumZoomScale = min(widthScale, heightScale)
        //scrollView.zoomScale = scrollView.minimumZoomScale
        scrollView.maximumZoomScale = 60
        scrollView.minimumZoomScale = 0.5
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
    
    
    
    
    
    
    
    
    @IBAction func toSearchButtonClicked(_ sender: UIButton) {
        let userTableVC = storyboard?.instantiateViewController(identifier: "userTableVC")
        present(userTableVC!, animated: false)
    }
    
    
    
    func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt(xDist * xDist + yDist * yDist))
    }
    
    
    
    func refresh() {
        print("in refresh")
        if (tabController == nil) {
            tabController = tabBarController! as! NavigationMenuBaseController
            
        }
        //loadView()
        //print("in refresh after loadView")
        user = Auth.auth().currentUser
        print("current user: \(user)")
        if (user != nil) {
            if (userData == nil || userData?.email != user?.email) {
                db.collection("UserData1").document(user!.uid).getDocument(completion: {obj,error in
                    if (error == nil) {
                        self.userData = UserData(dictionary: obj!.data()!)
                        print("should load followings, userdata was found: \(self.userData?.email)")
                        self.loadFollowings()
                    }
                    else {
                        print("could not load userdata from \(self.user?.email)")
                        print(error?.localizedDescription)
                    }
                })
            }
            else {
                print("userData wasnt nil \(userData?.email)")
                loadFollowings()
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        menuView.tabController = (tabBarController! as! NavigationMenuBaseController)
        refresh()
    }
    
    
    
    
    
    
    
    // loading followings
    func loadFollowings() {
        print("starting load followings")
        print("This is user \(user)")
        // STEP 1. Find people followed by User
        let followCollection = db.collection("Followings")
        let usernameText:String = userData!.publicID
        
        print("usernameText \(usernameText)")
        
        //self.followArray.removeAll(keepingCapacity: false)
        
        var newFollowArray: [String] = []
        var newUserDataArray: [UserData] = [userData!]
        
        if (self.followingUserDataArray.isEmpty) {
            self.followingUserDataArray = newUserDataArray
            loadProfileHexagons()
        }
        
        
        //        self.followingUserDataArray.removeAll(keepingCapacity: false)
        //        self.followingUserDataArray.append(self.userData!)
        
        let followQuery = followCollection.whereField("follower", isEqualTo: usernameText).addSnapshotListener({ (objects, error) -> Void in
            if error == nil {
                print("no error")
                
                // STEP 2. Hold received data in followArray
                // find related objects in "follow" class of Parse
                for object in objects!.documents {
                    print (object.data())
                    let followerString = object.get("following")
                    if followerString != nil  && !newFollowArray.contains(followerString as! String){
                        newFollowArray.append(followerString as! String)
                    }
                    print("Now this is followArray \(self.followArray)")
                }
                
                // STEP 3. Basing on followArray information (inside users) show infromation from User class of Parse
                // find users followeb by user
                if (!newFollowArray.isEmpty && !newFollowArray.elementsEqual(self.followArray)) {
                    let userDataCollection = self.db.collection("UserData1")
                    let userDataQuery = userDataCollection.whereField("publicID", in: newFollowArray)
                    self.followArray = newFollowArray
                    userDataQuery.addSnapshotListener( { (objects, error) -> Void in
                        if error == nil {
                            guard let documents = objects?.documents else {
                                print("could not get documents from objects?.documents")
                                print(error?.localizedDescription)
                                return
                            }
                            
                            for object in documents {
                                newUserDataArray.append(UserData(dictionary: object.data()))
                            }
                            self.followingUserDataArray = newUserDataArray
                            newUserDataArray.forEach({ doc in
                                print("username: \(doc.publicID)")
                            })
                            print("new user data array: \(newUserDataArray)")
                            self.removeCurrentProfileHexagons()
                            self.loadProfileHexagons()
                            
                        } else {
                            print("could not get userdata for followings")
                            print(error!.localizedDescription)
                        }
                        
                    })
                }
                //                else {
                //                    self.removeCurrentProfileHexagons()
                //                    self.loadProfileHexagons()
                //                }
                
                
            } else {
                print("could not get followings")
                print(error!.localizedDescription)
            }
            
            
        })
    }
    
    func removeCurrentProfileHexagons() {
        imageViewArray.forEach({ image in
            image.removeFromSuperview()
        })
        imageViewArray = []
    }
    
    
    
    @objc func imageTapped(sender: UITapGestureRecognizer){
        print("🎯🎯🎯🎯🎯🎯🎯I tapped image with tag \(sender.view!.tag)")
        print("Line below is user that you tapped. send to page")
        let tappedUser = self.followArray[sender.view!.tag]
        print("tappedUser: \(tappedUser)")
        //        // let newImage.tag = sender.view!.tag
        //        let newImageView = UIImageView(image: fakeUserTotalProfileArray[sender.view!.tag])
        //        newImageView.frame = UIScreen.main.bounds
        //        newImageView.backgroundColor = .black
        //        newImageView.contentMode = .scaleAspectFit
        //        newImageView.isUserInteractionEnabled = true
        //        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        //        newImageView.addGestureRecognizer(tap)
        //        self.view.addSubview(newImageView)
        //        self.navigationController?.isNavigationBarHidden = true
        //        self.tabBarController?.tabBar.isHidden = true
        //
        
        
        
        
        
        
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
    
    
    // search updated
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let userTableVC = storyboard?.instantiateViewController(identifier: "userTableVC")
        present(userTableVC!, animated: false)
        return true
    }
    
    
    // tapped on the searchBar
    //        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    //            // hide collectionView when started search
    //           // collectionView.isHidden = true
    //            // show cancel button
    //            searchBar.showsCancelButton = true
    //        }
    //
    //
    //        // clicked cancel button
    //        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    //            // unhide collectionView when tapped cancel button
    //          //  collectionView.isHidden = false
    //            // dismiss keyboard
    //            searchBar.resignFirstResponder()
    //
    //            // hide cancel button
    //            searchBar.showsCancelButton = false
    //
    //            // reset text
    //            searchBar.text = ""
    //
    //            // reset shown users
    //            loadUserDataArray = []
    //
    //            //usernameArray = []
    //        }
    
    // SEARCHING CODE
    // load users function
    func loadUsers() {
        
        //            let usersQuery = PFQuery(className: "_User")
        //            usersQuery.addDescendingOrder("createdAt")
        //            usersQuery.limit = 20
        //            usersQuery.findObjectsInBackground (block: { (objects, error) -> Void in
        //                if error == nil {
        //
        //                    // clean up
        //                    self.usernameArray.removeAll(keepingCapacity: false)
        //                    self.avaArray.removeAll(keepingCapacity: false)
        //
        //                    // found related objects
        //                    for object in objects! {
        //                        self.usernameArray.append(object.value(forKey: "username") as! String)
        //                        self.avaArray.append(object.value(forKey: "ava") as! PFFileObject)
        //                    }
        //
        //                    // reload
        //                    self.tableView.reloadData()
        //
        //                } else {
        //                    print(error!.localizedDescription)
        //                }
        //            })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var userTableVC = segue.destination as! UserTableView
        userTableVC.currentUser = user
        userTableVC.loadUserDataArray = loadUserDataArray
        userTableVC.searchString = searchBar.text!
        userTableVC.searchBar.text = searchBar.text!
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
        print ("following data count \(followingUserDataArray.count)")
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
            contentView.addSubview(image)
            image.isHidden = false
            imageViewArray.append(image)
            imageViewArray[thisIndex].tag = thisIndex
            thisIndex = thisIndex+1
            print("added profile image")
            
        }
        
        //self.view.frame.origin = imageViewArray[0].frame.origin
        print("imageViewArray: \(imageViewArray)")
        
    }
    
    
}

