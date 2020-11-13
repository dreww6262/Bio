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
    
    
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    
    var profileCollectionView: UICollectionView?
    var popularCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    
    var navBarView = NavBarView()
    let menuView = MenuView()
    var user = Auth.auth().currentUser
    var storage = Storage.storage().reference()
    
    var followArray = [String]()
    var followingUserDataArray = ThreadSafeArray<UserData>()
    var popList = ThreadSafeArray<UserData>()

    var userData: UserData?
    
    var toSearchButton = UIButton()
    var toSettingsButton = UIButton()

    var customTabBar: TabNavigationMenu!
        
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if collectionView == profileCollectionView {
            return CGSize(width: profileCollectionView!.frame.height, height: profileCollectionView!.frame.height)
        }

       let padding: CGFloat =  50
       let collectionViewSize = collectionView.frame.size.width - padding

        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == profileCollectionView {
            return followingUserDataArray.count
        }
        return popList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == profileCollectionView {
            let array: ThreadSafeArray<UserData> = followingUserDataArray
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileCircleCell", for: indexPath) as! ProfileCircleCell
            cell.label.text = array[indexPath.row].displayName
            cell.label.textColor = .white
            cell.label.font = UIFont(name: "DINAlternate-SemiBold", size: 12)
            cell.label.numberOfLines = 2
            cell.label.textAlignment = .center
            cell.label.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.imageView.frame = CGRect(x: cell.frame.width*(2/16), y: 0, width: cell.frame.width*(12/16), height: cell.frame.height*(12/16))
            //cell.label.sizeToFit()
            cell.imageView.clipsToBounds = true
            cell.imageView.layer.borderWidth = 2.0
          //  cell.imageView.layer.borderColor = myBlueGreen.cgColor
            cell.label.frame = CGRect(x: 0, y: cell.imageView.frame.maxY, width: cell.frame.width, height: cell.frame.height - cell.imageView.frame.maxY)
            //cell.imageView.layer.cornerRadius = cell.imageView.frame.width/2
            cell.imageView.addCircleGradiendBorder(10.0)
            cell.tag = indexPath.row
            cell.imageView.tag = indexPath.row
            cell.label.tag = indexPath.row
            let tapCellGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCollectionViewTap))
            cell.addGestureRecognizer(tapCellGesture)
          //  cell.imageView.layer.cornerRadius = cell.imageView.frame.width/2
            // let ref = array[indexPath.row].avaRef as! StorageReference
            cell.imageView.sd_setImage(with: storageRef.child(array[indexPath.row].avaRef))
            //cell.imageView.sd_setImage(with: ref)
            
            
            return cell
            
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "popCell", for: indexPath) as! PopularCell
        cell.contentView.backgroundColor = .white
        cell.applyshadowWithCorner(containerView: cell, cornerRadious: cell.frame.width/10)
        
        let popData = popList[indexPath.row]
        
        cell.userData = popData
        cell.usernameLabel.text = popData.publicID
        cell.displayNameLabel.text = popData.displayName
        
        cell.image.contentMode = .scaleAspectFill
        let cleanRef = popData.avaRef.replacingOccurrences(of: "/", with: "%2F")
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/bio-social-media.appspot.com/o/\(cleanRef)?alt=media")
        if (url != nil) {
            cell.image.sd_setImage(with: url!, completed: {_, error, _, _ in
                if error != nil {
                    print(error!.localizedDescription)
                    cell.image.image = UIImage(named: "boyprofile")
                }
            })
        }
        else {
            cell.image.image = UIImage(named: "boyprofile")
        }
        cell.image.tag = indexPath.row
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleProfileCellTap))
        
        cell.addGestureRecognizer(tapGesture)
        cell.displayNameLabel.frame = CGRect(x: 5, y: 5, width: 100, height: 30)
        cell.isUserInteractionEnabled = true
        
     //   cell.image.layer.borderWidth = 1.0
     //   cell.image.layer.borderColor = myTikTokBlack.cgColor
        
        cell.image.frame = CGRect(x: cell.frame.width/4, y: cell.frame.width/16, width: cell.frame.width/2, height: cell.frame.width/2)

        cell.image.clipsToBounds = true
       // cell.image.layer.cornerRadius = cell.image.frame.width/2
    //    cell.image.add
        cell.image.addCircleGradiendBorder(10.0)
        cell.displayNameLabel.text = cell.userData?.displayName
        let spaceRemaining = cell.frame.height - cell.image.frame.maxY
        //set up display name frame
        cell.displayNameLabel.frame = CGRect(x: 0, y: cell.image.frame.maxY + (spaceRemaining/16), width: cell.frame.width, height: spaceRemaining/2)
        let spaceToBottom = cell.frame.height - cell.displayNameLabel.frame.maxY
        cell.displayNameLabel.textAlignment = .center
        cell.displayNameLabel.textColor = .black
        cell.displayNameLabel.font = UIFont(name: "DINAlternate", size: 28)
        
        cell.followLabel.textColor = .black
        cell.followView.layer.cornerRadius = cell.followView.frame.size.width / 20
        
        cell.userDescriptionLabel.frame = CGRect(x: 0, y: cell.displayNameLabel.frame.maxY, width: cell.frame.width, height: spaceToBottom)
        
        var bioArray: [String] = ["Artist", "Activist", "Photographer", "Producer", "Musician", "Student-Athlete", "Entrepreneur", "Teacher", "Professional Athlete", "Just For Fun"]
        cell.userDescriptionLabel.font = UIFont.italicSystemFont(ofSize: 16)
        cell.userDescriptionLabel.text = "\(bioArray.randomElement()!)"
        cell.userDescriptionLabel.textColor = .black
        cell.userDescriptionLabel.textAlignment = .center
        
        var isFollowing = false
        
        if followingUserDataArray.readOnlyArray().contains(where: {data in
            return data.publicID == popData.publicID
        }) {
            isFollowing = true
        }
        
        if isFollowing {
            cell.followView.isHidden = true
            cell.followImage.image = UIImage(named: "friendCheck")
            cell.followLabel.text = "Added"
        }
        else {
            cell.followView.isHidden = false
            // followImage.image = UIImage(named: "addFriend")
            // followLabel.text = "Add"
            cell.followLabel.text = ""
        }
        
        //self.followImage.image = UIImage(named: "friendCheck")
        cell.followLabel.frame = CGRect(x: cell.followImage.frame.maxX + 5, y: 0.0, width: cell.followView.frame.width - 10, height: cell.followView.frame.height)
        //self.followLabel.text = "Added"
        cell.followLabel.textColor = .black
        
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionHeader) {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! HorizontalCircleCollectionViewHeader
            headerView.friendsLabel.text = "Friends"
            headerView.friendsLabel.font = UIFont(name: "Poppins-SemiBold", size: 20)
            headerView.friendsLabel.sizeToFit()
            headerView.friendsLabel.frame = CGRect(x: 8, y: 10, width: headerView.friendsLabel.frame.width, height: headerView.friendsLabel.frame.height)
            headerView.friendsLabel.textColor = .white
            
            headerView.collectionView.frame = CGRect(x: 0, y: headerView.friendsLabel.frame.maxY + 10, width: view.frame.width, height: view.frame.height / 8)
            
            headerView.featuredLabel.text = "Featured"
            headerView.featuredLabel.font = UIFont(name: "Poppins-SemiBold", size: 20)
            headerView.featuredLabel.sizeToFit()
            headerView.featuredLabel.frame = CGRect(x: 8, y: headerView.collectionView.frame.maxY + 10, width: headerView.featuredLabel.frame.width, height: headerView.featuredLabel.frame.height)
            headerView.featuredLabel.textColor = .white
            
            headerView.collectionView.dataSource = self
            headerView.collectionView.delegate = self
            headerView.collectionView.register(ProfileCircleCell.self, forCellWithReuseIdentifier: "profileCircleCell")
            headerView.collectionView.alwaysBounceHorizontal = true
            let layout = (headerView.collectionView.collectionViewLayout as! UICollectionViewFlowLayout)
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: headerView.collectionView.frame.height, height: headerView.collectionView.frame.height)
            headerView.collectionView.collectionViewLayout = layout
            profileCollectionView = headerView.collectionView
            profileCollectionView!.reloadData()
            
                // Customize headerView here
            return headerView
        }
        else {
            fatalError()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popularCollectionView.register(PopularCell.self, forCellWithReuseIdentifier: "popCell")
        popularCollectionView.register(HorizontalCircleCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        setUpNavBarView()
        setUpPopCollectionView()
        
        popularCollectionView.dataSource = self
        popularCollectionView.delegate = self

        addMenuButtons()
        
        navBarView.backgroundColor = .black
        navBarView.layer.borderWidth = 0.0
        
       
        
        toSettingsButton.isHidden = false
        toSearchButton.isHidden = false
        

        loadPopularHexagons()
        
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
        //     followView.isHidden = false
        toSettingsButton.isHidden = false
    }
    

    
    func setUpPopCollectionView() {
        view.addSubview(popularCollectionView)
        view.sendSubviewToBack(popularCollectionView)
        
        popularCollectionView.frame = CGRect(x: 0, y: navBarView.frame.maxY, width: view.frame.width, height: view.frame.height - navBarView.frame.maxY)
        
        let layout = (popularCollectionView.collectionViewLayout as! UICollectionViewFlowLayout)
        layout.headerReferenceSize = CGSize(width: view.frame.width, height: self.view.frame.height*(1/8) + 60)
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width * 4.5 / 10, height: view.frame.width * 4.5/12)
        layout.sectionInset = UIEdgeInsets(top: 40, left: 10, bottom: 85, right: 10)
        popularCollectionView.collectionViewLayout = layout
        
        
        popularCollectionView.reloadData()
        
        
    }
    
    
    func addMenuButtons() {
        view.addSubview(menuView)
        menuView.currentTab = 3
        menuView.addBehavior()
    }
    
    func addSettingsButton() {
        self.view.addSubview(toSettingsButton)
        toSettingsButton.frame = CGRect(x: 15, y: navBarView.frame.maxY, width: 25, height: 25)
        // round ava
        toSettingsButton.clipsToBounds = true
        toSettingsButton.isHidden = false
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
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        print("This is status bar height \(statusBarHeight)")
        self.view.addSubview(navBarView)
        self.navBarView.frame = CGRect(x: -5, y: -5, width: self.view.frame.width + 10, height: (self.view.frame.height/12)+5)
        let navBarHeightRemaining = navBarView.frame.maxY - statusBarHeight
        navBarView.backButton.isHidden = true
        navBarView.postButton.isHidden = true
        self.navBarView.addSubview(toSettingsButton)
        self.navBarView.addSubview(toSearchButton)
        self.navBarView.backgroundColor = .black
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
                            //self.loadFollowers()
                        }
                        else {
                            print("Userdata data was nil")
                        }
                    }
                    else {
                        print("could not load userdata from \(self.user?.email ?? "")")
                        print(error!.localizedDescription)
                    }
                })
            }
            else {
                //                print("userData wasnt nil \(userData?.email)")
                loadFollowings()
                //loadFollowers()
            }

        }
    }
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        menuView.tabController = (tabBarController! as! NavigationMenuBaseController)
        menuView.userData = userData
        refresh()
        toSearchButton.isHidden = false
        toSettingsButton.isHidden = false
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
                        //if (following) {
                            return self.followingUserDataArray.readOnlyArray()
                        //}
                        //return self.followerUserDataArray.readOnlyArray()
                    }()
                    
                    // TODO: Very inefficient.  Use database operations to make sure data is clean.  Followers shouldnt be too many.  < 100 elements
                    
                    if (!readOnlyArray.contains(where: { data in
                        data.publicID == newUserData.publicID
                    }) && !self.userData!.isBlockedBy.contains(newUserData.publicID) && !self.userData!.blockedUsers.contains(newUserData.publicID)) {
                        
                        //if (following) {
                            self.followingUserDataArray.append(newElement: newUserData)
                        //}
                        //else {
                            //self.followerUserDataArray.append(newElement: newUserData)
                        //}
                        
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
        profileCollectionView?.reloadData()
    }
    
    // loading followings
    func loadFollowings() {
        print("I got here loadfollowings")
        if (self.followingUserDataArray.isEmpty()) {
            self.followingUserDataArray.append(newElement: userData!)
            //            if (profileCollectionView == nil) {
            //                return
            //            }
            profileCollectionView?.reloadData()
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
//    func loadFollowers() {
//        if (self.followerUserDataArray.isEmpty()) {
//            self.followerUserDataArray.append(newElement: userData!)
//            //            if (profileCollectionView == nil) {
//            //                return
//            //            }
//            print("I get here load followers")
//            profileCollectionView.reloadData()
//        }
//        createFollowerArray(completion: { newFollowArray, success in
//            if success {
//                // using 5 for efficiency and less possibility of timeout
//                self.followerUserDataArray.removeAll()
//                self.followerUserDataArray.append(newElement: self.userData!)
//                let chunks = newFollowArray.chunked(into: 5)
//                let group = DispatchGroup()
//                for chunk in chunks {
//                    group.enter()
//                    self.loadUpToTenUserDatas(followers: chunk, completion: {
//                        group.leave()
//                    }, following: false)
//                }
//                group.notify(queue: .main) {
//                    self.doneLoading()
//                }
//            }
//        })
//    }
//
//    func createFollowerArray(completion: @escaping ([String], Bool) -> ()) {
//        let followCollection = db.collection("Followings")
//        let usernameText:String = userData!.publicID
//        var newFollowArray = [String]()
//        followCollection.whereField("following", isEqualTo: usernameText).getDocuments(completion: { (objects, error) -> Void in
//            if error == nil {
//                //                print("no error")
//
//                // STEP 2. Hold received data in followArray
//                // find related objects in "follow" class of Parse
//                for object in objects!.documents {
//                    print (object.data())
//                    let followerString = object.get("follower")
//                    if followerString != nil  && !newFollowArray.contains(followerString as! String){
//                        newFollowArray.append(followerString as! String)
//                    }
//                    //                    print("Now this is followArray \(self.followArray)")
//                }
//                completion(newFollowArray, true)
//            }
//            else {
//                print(error!.localizedDescription)
//                completion([String](), false)
//            }
//        })
//    }
 
    
//    @objc func followersTapped(_ recognizer: UITapGestureRecognizer) {
//        print("followers tapped")
//        let followersTableVC = storyboard?.instantiateViewController(identifier: "followersTableView") as! FollowersTableView
//        followersTableVC.userData = self.userData
//        present(followersTableVC, animated: false)
//    }
//
//    @objc func followingTapped(_ recognizer: UITapGestureRecognizer) {
//        print("following tapped")
//        let followingTableVC = storyboard?.instantiateViewController(identifier: "followingTableView") as! FollowingTableView
//        followingTableVC.userData = self.userData
//        present(followingTableVC, animated: false)
//        // print("frame after pressed \(toSearchButton.frame)")
//
//
//    }
    
    @objc func handleProfileCellTap(_ sender: UITapGestureRecognizer) {
        print("Profile Cell Tap sender \(sender)")
        //        print("🎯🎯🎯🎯🎯Hello World")
        //        print("🎯🎯🎯🎯🎯🎯🎯I tapped image with tag \(sender.view!.tag)")
        //let username = popularUserDataArray[sender.view!.tag].publicID
        //        print("🎯🎯🎯🎯🎯🎯🎯 I tapped image with associated username: \(username)")
        let profCell = sender.view as! PopularCell
        let guestVC = storyboard?.instantiateViewController(identifier: "guestGridVC") as! GuestHexagonGridVC
        //guestVC.user = user
        guestVC.myUserData = userData
        //guestVC.profileImage = self.
        guestVC.guestUserData = profCell.userData
        guestVC.isFollowing = true
        show(guestVC, sender: nil)
        // TODO: use tag to get index of userdata to go to new hex grid as guest.
        
    }
    
    @objc func handleCollectionViewTap(_ sender: UITapGestureRecognizer) {
        //        print("🎯🎯🎯🎯🎯Hello World")
        //        print("🎯🎯🎯🎯🎯🎯🎯I tapped image with tag \(sender.view!.tag)")
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
    
    func loadPopularHexagons() {
        db.collection("PopularUserData").getDocuments(completion: { [self] obj, error in
            if error == nil {
                let docs = obj!.documents
                popList.removeAll()
                for doc in docs {
                    let popData = UserData(dictionary: doc.data())
                    popList.append(newElement: popData)
                }
                var list = popList.readOnlyArray()
                list.sort(by: { x, y in
                    return x.pageViews > y.pageViews
                })
                popList.setArray(array: list)
                popularCollectionView.reloadData()
            }
        })
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

extension UIImageView {
    
    func addCircleGradiendBorder(_ width: CGFloat) {
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: CGPoint.zero, size: bounds.size)
        let colors: [CGColor] = [myCoolBlue.cgColor, myPink.cgColor, myBlueGreen.cgColor]
        gradient.colors = colors
        gradient.startPoint = CGPoint(x: 1, y: 0.5)
        gradient.endPoint = CGPoint(x: 0, y: 0.5)
        
        let cornerRadius = frame.size.width / 2
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        
        let shape = CAShapeLayer()
        let path = UIBezierPath(ovalIn: bounds)
        
        shape.lineWidth = width
        shape.path = path.cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor // clear
        gradient.mask = shape
        
        layer.insertSublayer(gradient, below: layer)
    }
    
}
