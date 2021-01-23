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
    var userDataVM: UserDataVM?
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
 //   var country = Auth.auth().currentUser?.
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
    var bio = ""
    
    override func viewDidLoad() {
  
        super.viewDidLoad()
        let userData = userDataVM?.userData.value
        setUpNavBarView()
        navBarView.backgroundColor = .systemGray6
        var myBirthday = userData?.birthday
        //
        tableContents = [
            Section(title: "My Account", rows: [
                        NavigationRow(text: "Name", detailText: .value1(name)!, icon: .named("gear"), action: didToggleSelection()),
                        NavigationRow(text: "Username", detailText: .value1(email)!, icon: .named("globe")), NavigationRow(text: "Followers", detailText: .none, icon: .none, action: didToggleSelection()),
                        NavigationRow(text: "Following", detailText: .none, icon: .none, action: didToggleSelection()),
                        NavigationRow(text: "Birthday", detailText: .value1(myBirthday ?? ""), icon: .none, action: { _ in }),
                        NavigationRow(text: "Country", detailText: .value1(userData?.country ?? ""), action: didToggleSelection()), NavigationRow(text: "Bio", detailText: .value1(userData?.bio ?? ""), action: didToggleSelection()), NavigationRow(text: "Email", detailText: .value1(email)!, icon: .named("time"), action: didToggleSelection()),
                        NavigationRow(text: "Change Profile Picture", detailText: .none, icon: .none, action: didToggleSelection()), NavigationRow(text: "Change Password", detailText: .none, icon: .none, action: didToggleSelection())]),
            Section(title: "Support", rows: [NavigationRow(text: "Blocked Users", detailText: .none, icon: .named("gear"), action: didToggleSelection()),
                        NavigationRow(text: "FAQ's", detailText: .none, icon: .named("gear"), action: didToggleSelection()),
                        NavigationRow(text: "I Spotted a Bug", detailText: .none, icon: .named("globe"), action: didToggleSelection()),
                        NavigationRow(text: "I Have a Suggestion", detailText: .none, icon: .named("time"), action: didToggleSelection()),
                        NavigationRow(text: "Privacy Policy", detailText: .none, action: didToggleSelection()),
                        NavigationRow(text: "Terms of Service", detailText: .none, icon: .named("time"), action: didToggleSelection()), NavigationRow(text: "Acknowledgements", detailText: .none, icon: .named("time"), action: didToggleSelection())]),
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
        self.navBarView.backgroundColor = .clear//.systemGray6
//        self.navBarView.addSubview(toSettingsButton)
//        self.navBarView.addSubview(toSearchButton)
//
        let backTap = UITapGestureRecognizer(target: self, action: #selector(self.backButtonpressed))
        backTap.numberOfTapsRequired = 1
        navBarView.backButton.isUserInteractionEnabled = true
        navBarView.backButton.addGestureRecognizer(backTap)

        navBarView.backButton.frame = CGRect(x: 10, y: statusBarHeight + (navBarHeightRemaining - 34)/2, width: 34, height: 34)

        let yOffset = navBarView.frame.maxY
        self.tableView.frame = CGRect(x: 0, y: yOffset, width: self.view.frame.width, height: self.view.frame.height - yOffset)
      //  self.navBarView.addSubview(titleLabel1)
        self.navBarView.addBehavior()
        self.navBarView.titleLabel.text = "Settings"
        self.navBarView.titleLabel.textColor = .black
        print("This is navBarView.")
  //      self.navBarView.backButton.frame = CGRect(x: 10, y: statusBarHeight + (navBarHeightRemaining - 34)/2, width: 34, height: 34)
        self.navBarView.postButton.frame = CGRect(x: navBarView.frame.width - 50, y: statusBarHeight + (navBarHeightRemaining - 34)/2, width: 40, height: 34)
        self.navBarView.postButton.titleLabel?.sizeToFit()
        self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y: self.navBarView.postButton.frame.minY, width: 200, height: 25)
        
     //   self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y: self.navBarView.backButton.frame.minY, width: 200, height: 25)
        switch traitCollection.userInterfaceStyle {
        case .light, .unspecified:
            navBarView.backButton.setImage(UIImage(named: "blackChevron"), for: .normal)
            navBarView.titleLabel.textColor = .black
        case .dark:
            navBarView.backButton.setImage(UIImage(named: "whiteChevron"), for: .normal)
            navBarView.titleLabel.textColor = .white
        }

    }
    
    
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
            
            else if row.text == "Change Profile Picture" {
                let editProfilePhotoVC = self?.storyboard?.instantiateViewController(identifier: "editProfilePhotoVC2") as! EditProfilePhotoVC2
           //     editProfilePhotoVC.userData = self?.userData
                editProfilePhotoVC.userDataVM = self!.userDataVM
                self!.present(editProfilePhotoVC, animated: false)
            }
            
          else if row.text == "Email" {
                let editVC = self?.storyboard?.instantiateViewController(identifier: "editProfileVC") as! EditProfileVC
                editVC.userDataVM = self!.userDataVM
                self!.present(editVC, animated: false)
            }
            
            else if row.text == "Name" {
                let editVC = self?.storyboard?.instantiateViewController(identifier: "editProfileVC") as! EditProfileVC
                editVC.userDataVM = self!.userDataVM
                self!.present(editVC, animated: false)
            }
            
           else if row.text == "Username" {
                let editVC = self?.storyboard?.instantiateViewController(identifier: "editProfileVC") as! EditProfileVC
                editVC.userDataVM = self!.userDataVM
                self!.present(editVC, animated: false)
            }
            
           else if row.text == "Bio" {
                let editVC = self?.storyboard?.instantiateViewController(identifier: "editProfileVC") as! EditProfileVC
                editVC.userDataVM = self!.userDataVM
                self!.present(editVC, animated: false)
            }
            else if row.text == "Country" {
                let editVC = self?.storyboard?.instantiateViewController(identifier: "editProfileVC") as! EditProfileVC
                editVC.userDataVM = self!.userDataVM
                self!.present(editVC, animated: false)
            }
            
            else if row.text == "Followers" {
                let followersVC = self?.storyboard?.instantiateViewController(identifier: "followersTableView") as! FollowersTableView
                followersVC.userDataVM = self!.userDataVM
                self!.present(followersVC, animated: false)
            }

            else if row.text == "Following" {
                let followingVC = self?.storyboard?.instantiateViewController(identifier: "followingTableView") as! FollowingTableView
                followingVC.userDataVM = self!.userDataVM
                self!.present(followingVC, animated: false)
            }

            
           else if row.text == "Change Password" {
                let changePasswordVC = self?.storyboard?.instantiateViewController(identifier: "changePasswordVC") as! ChangePasswordVC
           //     editProfilePhotoVC.userData = self?.userData
                changePasswordVC.userDataVM = self!.userDataVM
                self!.present(changePasswordVC, animated: false)
            }
            
            else if row.text == "Delete Account" {
                let userData = self!.userDataVM?.userData.value
                if userData == nil {
                    return
                }
                let alert = UIAlertController(title: "Please, Baby", message: "It'll be different this time.  I promise, I can change.  Just don't delete me.", preferredStyle: UIAlertController.Style.alert)
                let ok = UIAlertAction(title: "It's Over", style: UIAlertAction.Style.cancel, handler: {_ in
                    self?.storage.child("userFiles/\(userData!.publicID)")
                    
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
                    self?.db.collection("Followings").whereField("following", isEqualTo: userData!.publicID).getDocuments(completion: { objects, error in
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
                    self?.db.collection("Followings").whereField("follower", isEqualTo: userData!.publicID).getDocuments(completion: { objects, error in
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
                    self?.db.collection("Hexagons2").whereField("postingUserID", isEqualTo: userData!.publicID).getDocuments(completion: { objects, error in
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
                    self?.db.collection("News2").whereField("notifyingUser", isEqualTo: userData!.publicID).getDocuments(completion: { objects, error in
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
                    self?.db.collection("News2").whereField("currentUser", isEqualTo: userData!.publicID).getDocuments(completion: { objects, error in
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
                    self?.db.collection("Tags").whereField("postingUserID", isEqualTo: userData!.publicID).getDocuments(completion: { objects, error in
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
                    self?.db.collection("Tags").whereField("taggedUser", isEqualTo: userData!.publicID).getDocuments(completion: { objects, error in
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
                    self?.db.collection("UserData1").whereField("publicID", isEqualTo: userData!.publicID).getDocuments(completion: { obj, error  in
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
                        self?.userDataVM?.kill()
                        self?.performSignout()
                    }
                    
                    
                })
                let nah = UIAlertAction(title: "Nah I Was Just Kidding", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(ok)
                alert.addAction(nah)
                self!.present(alert, animated: true, completion: nil)
            }
            
            else if row.text == "Blocked Users" {
                let blockedVC = self?.storyboard?.instantiateViewController(identifier: "blockedVC") as! BlockedUsersVC
                blockedVC.userDataVM = self?.userDataVM
                self?.present(blockedVC, animated: false, completion: nil)
                
            }
            
          else if row.text.contains("I Have") {
                print("Im submitted!!!!!!")
                let suggestionVC = self?.storyboard?.instantiateViewController(identifier: "submitSuggestionsVC") as! SubmitSuggestionsVC
                //suggestionVC.userData = userData
                suggestionVC.modalPresentationStyle = .fullScreen
                self!.present(suggestionVC, animated: false)
                
            }
            
           else if row.text == "I Spotted a Bug" {
                print("I reported a bug!!!!!!")
                let bugSpottedVC = self?.storyboard?.instantiateViewController(identifier: "bugSpottedVC") as! BugSpottedVC
                //suggestionVC.userData = userData
                bugSpottedVC.modalPresentationStyle = .fullScreen
                self!.present(bugSpottedVC, animated: false)
                
            }
          else if row.text == "Privacy Policy" {
                let pdfVC = self?.storyboard?.instantiateViewController(identifier: "pdfViewer") as! PDFViewer
            pdfVC.pdfString = "Bio Beta Privacy Policy"
            pdfVC.titleString = "Privacy Policy"
            pdfVC.navBarView.titleLabel.text = "Privacy Policy"
                pdfVC.modalPresentationStyle = .fullScreen
                self!.present(pdfVC, animated: false)
                
            }
          else if row.text.contains("Terms of") {
            print("tap terms of service ")
            let pdfVC = self?.storyboard?.instantiateViewController(identifier: "pdfViewer") as! PDFViewer
            pdfVC.pdfString = "Bio Beta Terms of Service"
            pdfVC.navBarView.titleLabel.text = "Terms of Service"
            pdfVC.titleString = "Terms of Service"
            pdfVC.modalPresentationStyle = .fullScreen
            self!.present(pdfVC, animated: false)
                
            }
          else if row.text == "Acknowledgements" {
            let pdfVC = self?.storyboard?.instantiateViewController(identifier: "acknowledgementsVC") as! AcknowledgementsVC
            pdfVC.navBarView.titleLabel.text = "Acknowledgements"
//            pdfVC.titleString = "Acknowledgements"
//            pdfVC.pdfString = "Bio Beta Terms of Service"
            pdfVC.modalPresentationStyle = .fullScreen
            self!.present(pdfVC, animated: false)
                
            }
          else if row.text == "FAQ's" {
            let pdfVC = self?.storyboard?.instantiateViewController(identifier: "pdfViewer") as! PDFViewer
            pdfVC.titleString = "FAQ's"
            pdfVC.pdfString = "Bio Beta Terms of Service"
            pdfVC.navBarView.titleLabel.text = "FAQ's"
            pdfVC.modalPresentationStyle = .fullScreen
            self!.present(pdfVC, animated: false)
                
            }
            
            
            // ...
        }
    }
    
    @objc func performSignout() {
        userDataVM?.kill()
        self.performSegue(withIdentifier: "rewindSignOut", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //empty for now.  Used for signout
    }
    
}
