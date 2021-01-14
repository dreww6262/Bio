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



class FriendsAndFeaturedVC: UIViewController, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIContextMenuInteractionDelegate {
  var isFollowing = false
    var interactiveUserData: UserData?
    
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

    var userDataVM: UserDataVM?
    
    var toSearchButton = UIButton()
    var toSettingsButton = UIButton()

    var customTabBar: TabNavigationMenu!
    
    var noFriendsLabel: UILabel?
        
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
            if followingUserDataArray.count == 0 {
                noFriendsLabel?.isHidden = false
            }
            else {
                noFriendsLabel?.isHidden = true
            }
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
            
            
            return cell
            
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "popCell", for: indexPath) as! PopularCell
        cell.contentView.backgroundColor = .white
        cell.applyshadowWithCorner(containerView: cell, cornerRadious: cell.frame.width/10)
        
        let popData = popList[indexPath.row]
        
        cell.userData = popData
        cell.usernameLabel.text = popData.publicID
        cell.displayNameLabel.text = popData.displayName
        var cellBio = cell.userData!.bio ?? ""
        cell.userDescriptionLabel.text = cellBio
        let interaction = UIContextMenuInteraction(delegate: self)
        cell.addInteraction(interaction)
        self.interactiveUserData = popData
        
        cell.image.contentMode = .scaleAspectFill
        let cleanRef = popData.avaRef.replacingOccurrences(of: "/", with: "%2F")
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/bio-social-media.appspot.com/o/\(cleanRef)?alt=media")
//        if (url != nil) {
//            cell.image.sd_setImage(with: url!, completed: {_, error, _, _ in
//                if error != nil {
//                    print(error!.localizedDescription)
//                    cell.image.image = UIImage(named: "boyprofile")
//                }
//            })
//        }
        var placeHolderImage = UIImage(named: "boyProfile")
        if url != nil {
            if cell.userData?.gender == "I am a man" {
                print("recognized man")
                placeHolderImage = UIImage(named: "boyProfile")
            }
           else if cell.userData?.gender == "I am a woman" {
                print("recognized woman")
            placeHolderImage = UIImage(named: "kbit1")
            }
           else {
            placeHolderImage = UIImage(named: "cameo")
           }
            
        
            cell.image.sd_setImage(with: url!, placeholderImage: placeHolderImage, options: .refreshCached) { (_, error, _, _) in
            if (error != nil) {
                print(error!.localizedDescription)
                cell.image.image = placeHolderImage
            }
        }
        }
        
        else {
            cell.image.image = UIImage(named: "boyprofile")
        }
        cell.image.tag = indexPath.row
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleProfileCellTap))
        
        cell.addGestureRecognizer(tapGesture)
     //   cell.displayNameLabel.frame = CGRect(x: 5, y: 5, width: 100, height: 30)
        cell.isUserInteractionEnabled = true
        
     //   cell.image.layer.borderWidth = 1.0
     //   cell.image.layer.borderColor = myTikTokBlack.cgColor
        
        //real frame
    //    cell.image.frame = CGRect(x: cell.frame.width/4, y: cell.frame.width/16, width: cell.frame.width/2, height: cell.frame.width/2)
        
        cell.image.frame = CGRect(x: 0.0, y: 0.0, width: cell.frame.width, height: cell.frame.height)

        cell.image.clipsToBounds = true
       // cell.image.layer.cornerRadius = cell.image.frame.width/2
    //    cell.image.add
        
        //set up gradient
      //  cell.image.addCircleGradiendBorder(10.0)
        
        cell.displayNameLabel.text = cell.userData?.displayName
        let spaceRemaining = cell.frame.height - cell.image.frame.maxY
        
        //set up display name frame
       // cell.displayNameLabel.frame = CGRect(x: 0, y: cell.image.frame.maxY + (spaceRemaining/16), width: cell.frame.width, height: spaceRemaining/2)
        if cellBio != "" {
            cell.displayNameLabel.isHidden = false
            cell.userDescriptionLabel.isHidden = false
        cell.displayNameLabel.frame = CGRect(x: 0, y: cell.frame.height*(6/10), width: cell.frame.width, height: cell.frame.height*(2/10))
        let spaceToBottom = cell.frame.height - cell.displayNameLabel.frame.maxY
        cell.userDescriptionLabel.frame = CGRect(x: 0, y: cell.displayNameLabel.frame.maxY, width: cell.frame.width, height: cell.frame.height*(2/10))
        }
        else {
            cell.displayNameLabel.isHidden = true
            cell.userDescriptionLabel.isHidden = true
            cell.displayNameLabel.frame = CGRect(x: 0, y: cell.frame.height*(6/10), width: cell.frame.width, height: cell.frame.height*(2/10))
            let spaceToBottom = cell.frame.height - cell.displayNameLabel.frame.maxY
            cell.userDescriptionLabel.frame = CGRect(x: 0, y: cell.displayNameLabel.frame.maxY, width: cell.frame.width, height: cell.frame.height*(2/10))
            cell.displayNameLabel.frame = cell.userDescriptionLabel.frame
            cell.displayNameLabel.isHidden = false
        }

        cell.displayNameLabel.textAlignment = .center
        cell.displayNameLabel.textColor = .black
        cell.displayNameLabel.font = UIFont(name: "DINAlternate-SemiBold", size: 28)
       cell.bringSubviewToFront(cell.displayNameLabel)
        //cell.bringSubviewToFront(cell.userDescriptionLabel)
        
        cell.followLabel.textColor = .black
        cell.followView.layer.cornerRadius = cell.followView.frame.size.width / 20
        
        //set up user Description label / bio label
      
        
        //cell.displayNameLabel.frame = CGRect(x: 0, y: cell.frame.height/2, width: cell.frame.width, height: spaceToBottom)
        
        var bioArray: [String] = ["Artist", "Activist", "Photographer", "Producer", "Musician", "Student-Athlete", "Entrepreneur", "Teacher", "Professional Athlete", "Just For Fun"]
        cell.userDescriptionLabel.font = UIFont.italicSystemFont(ofSize: 16)
        cell.userDescriptionLabel.textColor = .black
        cell.userDescriptionLabel.textAlignment = .center
        cell.sendSubviewToBack(cell.image)
      
        let strokeTextAttributes1 = [
            NSAttributedString.Key.strokeColor : UIColor.black,
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.strokeWidth : -2.0,
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)
        ] as! [NSAttributedString.Key : Any]
        
        let strokeTextAttributes2 = [
            NSAttributedString.Key.strokeColor : UIColor.black,
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.strokeWidth : -1.5,
            NSAttributedString.Key.font : UIFont.init(name: "DINAlternate-Bold", size: 20)
        ] as! [NSAttributedString.Key : Any]
        
//        let strokeTextAttributes2 = [
//            NSAttributedString.Key.strokeColor : UIColor.black,
//            NSAttributedString.Key.foregroundColor : UIColor.white,
//            NSAttributedString.Key.strokeWidth : -4.0,
//            NSAttributedString.Key.font : UIFont.(descriptor: "DINAlternate-Bold", size: 18)
//        ] as! [NSAttributedString.Key : Any]

        cell.displayNameLabel.attributedText = NSMutableAttributedString(string: cell.userData!.displayName, attributes: strokeTextAttributes1)
        
        cell.userDescriptionLabel.attributedText = NSMutableAttributedString(string: cell.userData!.bio, attributes: strokeTextAttributes2)
       // cell.userDescriptionLabel.attributedText = NSMutableAttributedString(string: cell.userData?.bio, attributes: strokeTextAttributes)
        
        
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
            headerView.friendsLabel.font = UIFont(name: "DINAlternate-Bold", size: 25)
            headerView.friendsLabel.sizeToFit()
            headerView.friendsLabel.frame = CGRect(x: 8, y: 10, width: headerView.friendsLabel.frame.width, height: headerView.friendsLabel.frame.height)
            headerView.friendsLabel.textColor = .white
            
            headerView.collectionView.frame = CGRect(x: 0, y: headerView.friendsLabel.frame.maxY + 10, width: view.frame.width, height: view.frame.height / 8)
            
            headerView.featuredLabel.text = "Featured"
            headerView.featuredLabel.font = UIFont(name: "DINAlternate-Bold", size: 25)
            headerView.featuredLabel.sizeToFit()
            headerView.featuredLabel.frame = CGRect(x: 8, y: headerView.collectionView.frame.maxY + 10, width: headerView.featuredLabel.frame.width, height: headerView.featuredLabel.frame.height)
            headerView.featuredLabel.textColor = .white
            
            headerView.noFriendsLabel.text = "You don't follow anybody yet. Lets change that!"
            headerView.noFriendsLabel.numberOfLines = 0
            headerView.noFriendsLabel.font = UIFont(name: "Poppins-SemiBold", size: 24)
            headerView.noFriendsLabel.textAlignment = .center
            headerView.noFriendsLabel.frame = headerView.frame
            headerView.noFriendsLabel.textColor = .white
            noFriendsLabel = headerView.noFriendsLabel
            
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
        

        firstLoad = true
        observeUserData()
        loadPopularHexagons()
        
        
    }
    
    var firstLoad = false
    
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
        layout.itemSize = CGSize(width: view.frame.width * 4/10, height: view.frame.width * 4/10)
//        layout.itemSize = CGSize(width: view.frame.width * 4.5 / 10, height: view.frame.width * 4.5/10)
   //     layout.itemSize = CGSize(width: view.frame.width * 4.5 / 10, height: view.frame.width * 4.5/12)
//        layout.sectionInset = UIEdgeInsets(top: 40, left: 10, bottom: 85, right: 10)
        layout.sectionInset = UIEdgeInsets(top: 40, left: view.frame.width*1.5/20, bottom: view.frame.width * 4/10, right: view.frame.width*1.5/20)
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
        userTableVC.userDataVM = userDataVM
        present(userTableVC, animated: false)
    }
    
    @objc func toSettingsButtonClicked(_ recognizer: UITapGestureRecognizer) {
        let settingsVC = storyboard?.instantiateViewController(identifier: "settingsVC") as! ProfessionalSettingsVC
        settingsVC.userDataVM = userDataVM
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
      //  self.tableView.frame = CGRect(x: 0, y: yOffset, width: self.view.frame.width, height: self.view.frame.height - yOffset)
      //  self.navBarView.addSubview(titleLabel1)
        self.navBarView.addBehavior()
        self.navBarView.titleLabel.text = "Discover"
        //self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y: navBarView.frame.maxY - 30, width: 200, height: 30)
        print("This is navBarView.")
        self.toSettingsButton.setImage(UIImage(named: "lightGrayGearFinal"), for: .normal)
        self.toSearchButton.setImage(UIImage(named: "lightGrayMagnifyingGlassFinal"), for: .normal)

        self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y: self.toSearchButton.frame.minY, width: 200, height: 25)
    }
    

    
    
    func refresh() {
        loadFollowings()
    }
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        menuView.tabController = (tabBarController! as! NavigationMenuBaseController)
//        observeUserData()
        toSearchButton.isHidden = false
        toSettingsButton.isHidden = false
        
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
            self.observeUserData()
        }
    }

    
    func loadUpToTenUserDatas(followers: [String], completion: @escaping () -> (), following: Bool) {
        let userData = userDataVM?.userData.value
        if userData == nil {
            observeUserData()
            return
        }
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
                    }) && !userData!.isBlockedBy.contains(newUserData.publicID) && !userData!.blockedUsers.contains(newUserData.publicID)) {
                        
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
    
    
    @objc func followTapped(_ sender: UITapGestureRecognizer) {
        print("Follow tapped")
//        if guestUserData != nil {
//            if !isFollowing {
//                let newFollow = ["follower": myUserData!.publicID, "following": guestUserData!.publicID]
//                db.collection("Followings").addDocument(data: newFollow as [String : Any])
//                UIDevice.vibrate()
//
//                let notificationObjectref = db.collection("News2")
//                let notificationDoc = notificationObjectref.document()
//                let notificationObject = NewsObject(ava: myUserData!.avaRef, type: "follow", currentUser: myUserData!.publicID, notifyingUser: guestUserData!.publicID, thumbResource: myUserData!.avaRef, createdAt: NSDate.now.description, checked: false, notificationID: notificationDoc.documentID)
//                notificationDoc.setData(notificationObject.dictionary){ error in
//                    //     group.leave()
//                    if error == nil {
//                        //                           print("added notification: \(notificationObject)")
//
//                    }
//                    else {
//                        print("failed to add notification \(notificationObject)")
//
//                    }
//                }
//            }
//            else {
//                db.collection("Followings").whereField("follower", isEqualTo: myUserData!.publicID).whereField("following", isEqualTo: guestUserData!.publicID).getDocuments(completion: { objects, error in
//                    if error == nil {
//                        guard let docs = objects?.documents else {
//                            return
//                        }
//                        for doc in docs {
//                            doc.reference.delete()
//                        }
//                    }
//                })
//
//            }
//        }
    }
    
    
    func createContextMenu(userData: UserData) -> UIMenu {
        let followAction = UIAction(title: "Follow \(userData.publicID)", image: nil) { _ in
            print("follow \(userData.publicID)")
       // self.handleProfilePicTap(UITapGestureRecognizer())
            self.followTapped(UITapGestureRecognizer())
    }
        
        let unfollowAction = UIAction(title: "Unfollow \(userData)", image: nil) { _ in
            print("Unfollow \(userData.publicID)")
            let alert = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
                self.followTapped(UITapGestureRecognizer())
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
    }
        let featuredFollowingList = UIAction(title: "View Who \(userData.publicID) Follows", image: nil) { _ in
    print("TODO: View their users")
            let featuredUserFollowingTableView = self.storyboard?.instantiateViewController(identifier: "followingTableView") as! FollowingTableView
            featuredUserFollowingTableView.userDataVM = self.userDataVM
            self.present(featuredUserFollowingTableView, animated: false)
    }
        
     

    let cancelAction = UIAction(title: "Cancel", image: .none, attributes: .destructive) { action in
             // Delete this photo 😢
         }
        
        
        if followArray.contains(userData.publicID) {
            return UIMenu(title: "", children: [unfollowAction, featuredFollowingList, cancelAction])
        }
        else {
            return UIMenu(title: "", children: [followAction, featuredFollowingList, cancelAction])
        }
        
   
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let popCell = interaction.view as! PopularCell
        self.interactiveUserData = popCell.userData
    return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ -> UIMenu? in
        return self.createContextMenu(userData: popCell.userData!)
        }
    }
    
    
    func doneLoading() {
        //self.removeCurrentProfileHexagons()
        //self.loadProfileHexagons()
        var array = followingUserDataArray.readOnlyArray()
        
        let dateFormatter = DateFormatter()
       // dateFormatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ssZ"
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        dateFormatter.locale = Locale.init(identifier: "en_GB")
        dateFormatter.timeZone = NSTimeZone(name: "GMT") as TimeZone?
        array.sort(by: { x, y in
            let xDate = dateFormatter.date(from: x.lastTimePosted)
            
            let yDate = dateFormatter.date(from: y.lastTimePosted)
            
            return xDate!.compare(yDate!) == ComparisonResult.orderedDescending
        })
        followingUserDataArray.setArray(array: array)
        profileCollectionView?.reloadData()
    }
    
    // loading followings
    func loadFollowings() {
        let userData = userDataVM?.userData.value
        if userData == nil {
            observeUserData()
            return
        }

        createFollowingArray(completion: { newFollowArray, success in
            //            print("loadFollowings: new follow array: \(newFollowArray)")
            if success {
                // using 5 for efficiency and less possibility of timeout
                self.followingUserDataArray.removeAll()
                //self.followingUserDataArray.append(newElement: userData!)
                let chunks = newFollowArray.chunked(into: 5)
                let group = DispatchGroup()
                for chunk in chunks {
                    group.enter()
                    self.loadUpToTenUserDatas(followers: chunk, completion: {
                        // print("loadFollowings: loaded followers \(self.followingUserDataArray)")
                        
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
        let userData = userDataVM?.userData.value
        if userData == nil {
            return
        }
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
    
    
    @objc func handleProfileCellTap(_ sender: UITapGestureRecognizer) {
        print("Profile Cell Tap sender \(sender)")
        //        print("🎯🎯🎯🎯🎯Hello World")
        //        print("🎯🎯🎯🎯🎯🎯🎯I tapped image with tag \(sender.view!.tag)")
        //let username = popularUserDataArray[sender.view!.tag].publicID
        //        print("🎯🎯🎯🎯🎯🎯🎯 I tapped image with associated username: \(username)")
        let profCell = sender.view as! PopularCell
     //   sender.view?.layer = CALayer()
        let guestVC = storyboard?.instantiateViewController(identifier: "guestGridVC") as! GuestHexagonGridVC
        //guestVC.user = user
        guestVC.userDataVM = userDataVM
        //guestVC.profileImage = self.
        guestVC.guestUserData = profCell.userData
        //guestVC.isFollowing = true
        show(guestVC, sender: nil)
        // TODO: use tag to get index of userdata to go to new hex grid as guest.
        
    }
    
    @objc func handleCollectionViewTap(_ sender: UITapGestureRecognizer) {
        //        print("🎯🎯🎯🎯🎯Hello World")
        //        print("🎯🎯🎯🎯🎯🎯🎯I tapped image with tag \(sender.view!.tag)")
        //        print("🎯🎯🎯🎯🎯🎯🎯 I tapped image with associated username: \(username)")
        let profCell = sender.view as! ProfileCircleCell
        
        profCell.imageView.addGrayCircleGradiendBorder(10.0)
   
        
        let guestVC = storyboard?.instantiateViewController(identifier: "guestGridVC") as! GuestHexagonGridVC
        //guestVC.user = user
        guestVC.userDataVM = userDataVM
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
                let fakeImage = UIImageView()
                for doc in docs {
                    let popData = UserData(dictionary: doc.data())
                    popList.append(newElement: popData)
                    let cleanRef = popData.avaRef.replacingOccurrences(of: "/", with: "%2F")
                    let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/bio-social-media.appspot.com/o/\(cleanRef)?alt=media")
                    if (url != nil) {
                        DispatchQueue.main.async {
                            fakeImage.sd_setImage(with: url, completed: nil)
                        }
                        
                    }
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
        let colors: [CGColor] = [myPink.cgColor, myBlueGreen.cgColor]
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
    
    func addGrayCircleGradiendBorder(_ width: CGFloat) {
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: CGPoint.zero, size: bounds.size)
        let colors: [CGColor] = [ UIColor.lightGray.cgColor]
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
    
    func addHexagonGradiendBorder(_ width: CGFloat) {
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: CGPoint.zero, size: bounds.size)
        let colors: [CGColor] = [myPink.cgColor, myBlueGreen.cgColor]
        gradient.colors = colors
        gradient.startPoint = CGPoint(x: 1, y: 0.5)
        gradient.endPoint = CGPoint(x: 0, y: 0.5)

        clipsToBounds = true
        
        let mask = CAShapeLayer()
      // let path = UIBezierPath(ovalIn: bounds)
        let path = UIBezierPath(roundedPolygonPathInRect: bounds, lineWidth: 10.0, sides: 6, cornerRadius: 10.0, rotationOffset: CGFloat.pi / 2.0).cgPath
        
        mask.lineWidth = 10.0
        mask.path = path
        mask.strokeColor = UIColor.clear.cgColor
        mask.fillColor = UIColor.white.cgColor // clear
        gradient.mask = mask
        
        layer.insertSublayer(gradient, below: layer)
    }
}
