//
//  ProfessionalSettingsVC.swift
//  Bio
//
//  Created by Ann McDonough on 9/2/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//
//
import UIKit
import Firebase
import QuickTableViewController
import FirebaseFirestore

class ProfessionalSettingsVC: QuickTableViewController {
    
    var navBarView = NavBarView()
    
    
    //var tabController = NavigationMenuBaseController()
    var userData: UserData? = nil
    //var menuView = MenuView()
    var myAccountArray = ["Name",
                          "Username",
                          "Birthday", "Followers", "Following",
                          "Country",
                          "Phone Number",
                          "Email",
                          "Password",
                          "Two-Factor Authentication"]
    var supportArray: [String] = ["FAQs",
                                  "I spotted a bug",
                                  "I have a Suggestion",
                                  "Privacy Policy",
                                  "Terms of Service",
                                  "Report User"]
    var accountActionsArray = ["Log Out"]
    
    var settingsTitleArray: [String] = ["Name",
                                        "Username",
                                        "Birthday",
                                        "Country",
                                        "Phone Number",
                                        "Email",
                                        "CHange Password",
                                        "Two-Factor Authentication", "FAQs",
                                        "I spotted a bug",
                                        "I have a Suggestion",
                                        "Privacy Policy",
                                        "Terms of Service",
                                        "Report User", "Log Out"]
    
    var user = "\(Auth.auth().currentUser?.email ?? "")"
    var name = "\(Auth.auth().currentUser?.displayName ?? "")"
    var birthday = "1/1/2020"
    var country = "USA"
    var phoneNumber = "xxx-xxx-xxxx"
    var email = "\(Auth.auth().currentUser?.email ?? "")"
    var password = "xxxxxxxxxxxxxx"
    var twoFactorAuth = "false"
    var myAccountUserData: [String] = []
    var myAccountArraySupportArrayCombined: [String] = []
    var userDataCombinedArray: [String] = []
    var backButton1 = UIButton()
    var titleLabel1 = UILabel()
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    
    override func viewDidLoad() {
        //        view.addSubview(navBarView)
        //        navBarView.addSubview(titleLabel1)
        //        navBarView.addSubview(backButton1)
        //        navBarView.addBehavior()
        //        backButton1.setTitle("Back", for: .normal)
        //        backButton1.setTitleColor(.systemBlue, for: .normal)
        //        titleLabel1.text = "Settings"
        super.viewDidLoad()
        setUpNavBarView()
        navBarView.backgroundColor = .systemGray6
        var myBirthday = userData?.birthday
        //
        tableContents = [
            Section(title: "My Account", rows: [
                        NavigationRow(text: "Name", detailText: .value1(name)!, icon: .named("gear")),
                        NavigationRow(text: "Username", detailText: .value1(email)!, icon: .named("globe")), NavigationRow(text: "Followers", detailText: .none, icon: .none, action: didToggleSelection()),
                        NavigationRow(text: "Following", detailText: .none, icon: .none, action: didToggleSelection()),
                        NavigationRow(text: "Birthday", detailText: .value1(myBirthday ?? ""), icon: .none, action: { _ in }),
                        NavigationRow(text: "Country", detailText: .value1(country)), NavigationRow(text: "Terms of Service", detailText: .none, icon: .named("time"), action: { _ in }),
                        NavigationRow(text: "Email", detailText: .value1(email)!, icon: .named("time"), action: { _ in }),
                        NavigationRow(text: "Change Profile Picture", detailText: .none, icon: .none, action: didToggleSelection()), NavigationRow(text: "Change Password", detailText: .none, icon: .none, action: didToggleSelection())]),
            Section(title: "Support", rows: [NavigationRow(text: "Blocked Users", detailText: .none, icon: .named("gear"), action: didToggleSelection()),
                        NavigationRow(text: "FAQ's", detailText: .none, icon: .named("gear")),
                        NavigationRow(text: "I Spotted a Bug", detailText: .none, icon: .named("globe"), action: didToggleSelection()),
                        NavigationRow(text: "I Have a Suggestion", detailText: .none, icon: .named("time"), action: didToggleSelection()),
                        NavigationRow(text: "Privacy Policy", detailText: .none),
                        NavigationRow(text: "Terms of Service", detailText: .none, icon: .named("time"), action: { _ in })]),
            Section(title: "Account Actions", rows: [NavigationRow(text: "Log Out", detailText: .none, icon: .named("gear"), action: didToggleSelection()),NavigationRow(text: "Delete Account", detailText: .none, icon: .none, action: didToggleSelection())])
        ]
        
        
    }
    
    func setUpNavBarView() {
        var statusBarHeight = UIApplication.shared.statusBarFrame.height
        print("This is status bar height \(statusBarHeight)")
        self.view.addSubview(navBarView)
        self.navBarView.frame = CGRect(x: -5, y: -5, width: self.view.frame.width + 10, height: (self.view.frame.height/12)+5)
        var navBarHeightRemaining = navBarView.frame.maxY - statusBarHeight
       // navBarView.backButton.isHidden = true
        navBarView.postButton.isHidden = true
        navBarView.backButton.setTitleColor(.black, for: .normal)
        self.navBarView.backgroundColor = .systemGray6
//        self.navBarView.addSubview(toSettingsButton)
//        self.navBarView.addSubview(toSearchButton)
//
        let backTap = UITapGestureRecognizer(target: self, action: #selector(self.backButtonpressed))
        backTap.numberOfTapsRequired = 1
        navBarView.backButton.isUserInteractionEnabled = true
        navBarView.backButton.addGestureRecognizer(backTap)
//
//        let searchTap = UITapGestureRecognizer(target: self, action: #selector(self.toSearchButtonClicked))
//        searchTap.numberOfTapsRequired = 1
//        toSearchButton.isUserInteractionEnabled = true
//        toSearchButton.addGestureRecognizer(searchTap)
        

//        self.toSettingsButton.setImage(UIImage(named: "lightGrayGearFinal"), for: .normal)
//        self.toSearchButton.setImage(UIImage(named: "lightGrayMagnifyingGlassFinal"), for: .normal)
//
//        self.toSettingsButton.frame = CGRect(x: 10, y: navBarView.frame.height - 30, width: 25, height: 25)
        navBarView.backButton.frame = CGRect(x: 10, y: statusBarHeight + (navBarHeightRemaining - 25)/2, width: 25, height: 25)
//        self.toSearchButton.frame = CGRect(x: navBarView.frame.width - 35, y: statusBarHeight + (navBarHeightRemaining - 25)/2, width: 25, height: 25)
        let yOffset = navBarView.frame.maxY
        self.tableView.frame = CGRect(x: 0, y: yOffset, width: self.view.frame.width, height: self.view.frame.height - yOffset)
      //  self.navBarView.addSubview(titleLabel1)
        self.navBarView.addBehavior()
        self.navBarView.titleLabel.text = "Settings"
        self.navBarView.titleLabel.textColor = .black
        print("This is navBarView.")
//        self.toSettingsButton.setImage(UIImage(named: "lightGrayGearFinal"), for: .normal)
//        self.toSearchButton.setImage(UIImage(named: "lightGrayMagnifyingGlassFinal"), for: .normal)
   //     self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y: navBarView.frame.maxY - 30, width: 200, height: 30)
        
        self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y: self.navBarView.backButton.frame.minY, width: 200, height: 25)

        //self.titleLabel1.text = "Notifications"
     //   self.navBarView.frame = CGRect(x: -5, y: -5, width: self.view.frame.width + 10, height: (self.view.frame.height/12)+5)
       // let yOffset = navBarView.frame.maxY
     //   self.tableView.frame = CGRect(x: 0, y: yOffset, width: self.view.frame.width, height: self.view.frame.height - yOffset)

    }
    
//    func setUpNavBarViewBad() {
//        self.view.addSubview(navBarView)
//        self.navBarView.addSubview(titleLabel1)
//        self.navBarView.addSubview(backButton1)
//        self.navBarView.addBehavior()
//        
//        // tap to dismissSettings
//        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(self.backButtonpressed))
//        dismissTap.numberOfTapsRequired = 1
//        self.backButton1.isUserInteractionEnabled = true
//        self.backButton1.addGestureRecognizer(dismissTap)
//        
//        
//        self.backButton1.setBackgroundImage(UIImage(named: "whiteChevron"), for: .normal)
//        self.backButton1.setTitleColor(.systemBlue, for: .normal)
//        self.titleLabel1.text = "Settings"
//        self.navBarView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/12)
//        self.tableView.frame = CGRect(x: 0, y: self.navBarView.frame.height, width: self.view.frame.width, height: self.view.frame.height-self.navBarView.frame.height)
//        self.titleLabel1.frame = CGRect(x: 0, y: navBarView.frame.maxY - 30, width: self.view.frame.width, height: 30)
//        self.backButton1.frame = CGRect(x: 5, y: navBarView.frame.maxY - 30, width: 25, height: 25)
//        self.titleLabel1.textAlignment = .center
//        self.backButton1.titleLabel?.textAlignment = .left
//        self.titleLabel1.font = UIFont(name: "DINAlternate-Bold", size: 20)
//        self.navBarView.backgroundColor = .systemGray6
//    }
    
    @objc func backButtonpressed() {
        print("It should dismiss here")
        self.dismiss(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // tap to dismissSettings
        //        let dismissTap = UITapGestureRecognizer(target: backButton1, action: #selector(self.backButtonpressed))
        //                dismissTap.numberOfTapsRequired = 1
        //                self.backButton1.isUserInteractionEnabled = true
        //                self.backButton1.addGestureRecognizer(dismissTap)
        
        
        
        //        menuView.tabController = tabBarController as! NavigationMenuBaseController
        //        menuView.userData = userData
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        // Alter the cells created by QuickTableViewController
//        print("This is cell \(cell)")
        return cell
    }
    
    
    //    @IBAction func backButtonClicked(_ sender: UIBarButtonItem) {
    ////        menuView.homeButtonClicked(sender)
    //    dismiss(animated: false, completion: nil)
    //    }
    
    
    
    
    
    private func showAlert(_ sender: Row) {
        // ...
    }
    
    var blurEffectView: UIVisualEffectView?
    
    private func didToggleSelection() -> (Row) -> Void {
        return { [weak self] row in
            print("toggled row: \(row.text)")
            
            if row.text == "Log Out" {
                let alert = UIAlertController(title: "Are You Sure?", message: "We will miss you <3", preferredStyle: UIAlertController.Style.alert)
                let ok = UIAlertAction(title: "Yeah :/", style: UIAlertAction.Style.cancel, handler: {_ in
                    self?.performSignout()
                })
                let nah = UIAlertAction(title: "I'll Stay", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(ok)
                alert.addAction(nah)
                self!.present(alert, animated: true, completion: nil)
            }
            
            if row.text == "Change Profile Picture" {
                let editProfilePhotoVC = self?.storyboard?.instantiateViewController(identifier: "editProfilePhotoVC2") as! EditProfilePhotoVC2
           //     editProfilePhotoVC.userData = self?.userData
                editProfilePhotoVC.userData = self!.userData
                self!.present(editProfilePhotoVC, animated: false)
            }
            
            if row.text == "Followers" {
                let followersVC = self?.storyboard?.instantiateViewController(identifier: "followersTableView") as! FollowersTableView
                followersVC.userData = self!.userData
                self!.present(followersVC, animated: false)
            }

            if row.text == "Following" {
                let followingVC = self?.storyboard?.instantiateViewController(identifier: "followingTableView") as! FollowingTableView
                followingVC.userData = self!.userData
                self!.present(followingVC, animated: false)
            }

            
            if row.text == "Change Password" {
                let changePasswordVC = self?.storyboard?.instantiateViewController(identifier: "changePasswordVC") as! ChangePasswordVC
           //     editProfilePhotoVC.userData = self?.userData
                changePasswordVC.userData = self!.userData
                self!.present(changePasswordVC, animated: false)
            }
            
            if row.text == "Delete Account" {
                let alert = UIAlertController(title: "Please, Baby", message: "It'll be different this time.  I promise, I can change.  Just don't delete me.", preferredStyle: UIAlertController.Style.alert)
                let ok = UIAlertAction(title: "It's Over", style: UIAlertAction.Style.cancel, handler: {_ in
                    self?.storage.child("userFiles/\(self!.userData!.publicID)")
                    
                    let loadingIndicator = self?.storyboard?.instantiateViewController(withIdentifier: "loading")
                    
                    self?.blurEffectView = {
                        let blurEffect = UIBlurEffect(style: .dark)
                        let blurEffectView = UIVisualEffectView(effect: blurEffect)
                        
                        blurEffectView.alpha = 0.8
                        
                        // Setting the autoresizing mask to flexible for
                        // width and height will ensure the blurEffectView
                        // is the same size as its parent view.
                        blurEffectView.autoresizingMask = [
                            .flexibleWidth, .flexibleHeight
                        ]
                        blurEffectView.frame = self!.view.bounds
                        
                        return blurEffectView
                    }()
                    self?.view.addSubview(self!.blurEffectView!)
                    
                    self?.addChild(loadingIndicator!)
                    self?.view.addSubview(loadingIndicator!.view)
                    
                    let group = DispatchGroup()
                    group.enter()
                    group.enter()
                    group.enter()
                    group.enter()
                    group.enter()
                    group.enter()
                    group.enter()
                    group.enter()
                    group.enter()
                    group.enter()
                    self?.storage.delete(completion: {_ in
                        print("left storage")
                        group.leave()
                        // idk if we need to handle anything specifically
                    })
                    self?.db.collection("Followings").whereField("following", isEqualTo: self!.userData!.publicID).getDocuments(completion: { objects, error in
                        guard let docs = objects?.documents else {
                            print("left following")
                            group.leave()
                            return
                        }
                        for doc in docs {
                            doc.reference.delete()
                        }
                        print("left following")
                        group.leave()
                    })
                    self?.db.collection("Followings").whereField("follower", isEqualTo: self!.userData!.publicID).getDocuments(completion: { objects, error in
                        guard let docs = objects?.documents else {
                            group.leave()
                            print("left follower")

                            return
                        }
                        for doc in docs {
                            doc.reference.delete()
                        }
                        print("left follower")

                        group.leave()
                    })
                    self?.db.collection("Hexagons2").whereField("postingUserID", isEqualTo: self!.userData!.publicID).getDocuments(completion: { objects, error in
                        guard let docs = objects?.documents else {
                            group.leave()
                            print("left hex")

                            return
                        }
                        for doc in docs {
                            doc.reference.delete()
                        }
                        print("left hex")

                        group.leave()
                    })
                    self?.db.collection("News2").whereField("notifyingUser", isEqualTo: self!.userData!.publicID).getDocuments(completion: { objects, error in
                        guard let docs = objects?.documents else {
                            print("left news notifying")

                            group.leave()
                            return
                        }
                        for doc in docs {
                            doc.reference.delete()
                        }
                        print("left news notifying")

                        group.leave()
                    })
                    self?.db.collection("News2").whereField("currentUser", isEqualTo: self!.userData!.publicID).getDocuments(completion: { objects, error in
                        guard let docs = objects?.documents else {
                            group.leave()
                            print("left news current")

                            return
                        }
                        for doc in docs {
                            doc.reference.delete()
                        }
                        print("left news current")

                        group.leave()
                    })
                    self?.db.collection("Tags").whereField("postingUserID", isEqualTo: self!.userData!.publicID).getDocuments(completion: { objects, error in
                        guard let docs = objects?.documents else {
                            group.leave()
                            print("left tags posting")

                            return
                        }
                        for doc in docs {
                            doc.reference.delete()
                        }
                        print("left tags posting")

                        group.leave()
                    })
                    self?.db.collection("Tags").whereField("taggedUser", isEqualTo: self!.userData!.publicID).getDocuments(completion: { objects, error in
                        guard let docs = objects?.documents else {
                            print("left tags tagged")

                            group.leave()
                            return
                        }
                        for doc in docs {
                            doc.reference.delete()
                        }
                        print("left tags tagged")

                        group.leave()
                    })
                    self?.db.collection("UserData1").whereField("publicID", isEqualTo: self!.userData!.publicID).getDocuments(completion: { obj, error  in
                        guard let docs = obj?.documents else {
                            print("left userdata")
                            group.leave()
                            return
                        }
                        for doc in docs {
                            doc.reference.delete()
                        }
                        group.leave()
                    })
                    
                    Auth.auth().currentUser?.delete(completion: { _ in
                        print("left user")

                        group.leave()
                    })
                    print("waiting to notify")
                    group.notify(queue: .main) {
                        print("should sign out")
                        self?.performSignout()
                    }
                    
                    
                })
                let nah = UIAlertAction(title: "Nah I Was Just Kidding", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(ok)
                alert.addAction(nah)
                self!.present(alert, animated: true, completion: nil)
            }
            
            if row.text == "Blocked Users" {
                let blockedVC = self?.storyboard?.instantiateViewController(identifier: "blockedVC") as! BlockedUsersVC
                blockedVC.userData = self?.userData
                self?.present(blockedVC, animated: false, completion: nil)
                
            }
            
            if row.text.contains("I Have") {
                print("Im submitted!!!!!!")
                let suggestionVC = self?.storyboard?.instantiateViewController(identifier: "submitSuggestionsVC") as! SubmitSuggestionsVC
                //suggestionVC.userData = userData
                suggestionVC.modalPresentationStyle = .fullScreen
                self!.present(suggestionVC, animated: false)
                
            }
            
            if row.text == "I Spotted a Bug" {
                print("I reported a bug!!!!!!")
                let bugSpottedVC = self?.storyboard?.instantiateViewController(identifier: "bugSpottedVC") as! BugSpottedVC
                //suggestionVC.userData = userData
                bugSpottedVC.modalPresentationStyle = .fullScreen
                self!.present(bugSpottedVC, animated: false)
                
            }
            
            
            // ...
        }
    }
    
    @objc func performSignout() {
        let presenter = presentingViewController
        if (presenter is HomeHexagonGrid) {
            let home = presenter as! HomeHexagonGrid
            home.menuView.userData = nil
        }
        else if (presenter is DiscoverGrid) {
            let prof = presenter as! DiscoverGrid
            prof.menuView.userData = nil
        }
        else if (presenter is NotificationsVC) {
            let noti = presenter as! NotificationsVC
            noti.menuView.userData = nil
        }
        else if (presenter is NewPostColorfulVC) {
            let new = presenter as! NewPostColorfulVC
            new.menuView.userData = nil
        }
        self.performSegue(withIdentifier: "rewindSignOut", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //empty for now.  Used for signout
    }
    
}
