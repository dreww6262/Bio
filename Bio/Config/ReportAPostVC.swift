//
//  ReportAPostVC.swift
//  Bio
//
//  Created by Ann McDonough on 10/8/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import FirebaseAuth
import QuickTableViewController
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import FirebaseUI

class ReportAPostVC: QuickTableViewController {
    let db = Firestore.firestore()
    var navBarView = NavBarView()
    
    var hexData: HexagonStructData?
    //var tabController = NavigationMenuBaseController()
    var userDataVM: UserDataVM? = nil
    //var menuView = MenuView()
 var myAccountArray = ["Name",
 "Username",
 "Birthday",
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
 "Password",
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
//

        tableContents = [
            Section(title: "Report Post", rows: [
                                 NavigationRow(text: "Nudity or sexual activity", detailText: .none, icon: .none, action: didToggleSelection()), NavigationRow(text: "Hate speech or symbols", detailText: .none, icon: .none, action: didToggleSelection()),
                                 NavigationRow(text: "Violence or dangerous organizations", detailText: .none, action: didToggleSelection()), NavigationRow(text: "Sale of illegal or regulated goods", detailText: .none, icon: .none, action: didToggleSelection()),
                                 NavigationRow(text: "Bullying or harassment", detailText: .none, action: didToggleSelection()),
                                 NavigationRow(text: "Intellectual property violation", detailText: .none, icon: .none, action: didToggleSelection()),
                                NavigationRow(text: "Suicide, self-injury or, eating disorders", detailText: .none, action: didToggleSelection()),
                                NavigationRow(text: "Scam or Fraud", detailText: .none, icon: .none, action: didToggleSelection()), NavigationRow(text: "False information", detailText: .none, action: didToggleSelection()),
                        NavigationRow(text: "Other", detailText: .none, icon: .none, action: didToggleSelection())])
            //,
//            Section(title: "Support", rows: [
//                        NavigationRow(text: "FAQ's", detailText: .none, icon: .named("gear")),
//                        NavigationRow(text: "I Spotted a Bug", detailText: .none, icon: .named("globe"), action: didToggleSelection()),
//                        NavigationRow(text: "I Have a Suggestion", detailText: .none, icon: .named("time"), action: didToggleSelection()),
//                        NavigationRow(text: "Privacy Policy", detailText: .none),
//                        NavigationRow(text: "Terms of Service", detailText: .none, icon: .named("time"), action: { _ in }),
//                        NavigationRow(text: "Report User", detailText: .none)]),
//                Section(title: "Account Actions", rows: [
//                    NavigationRow(text: "Log Out", detailText: .none, icon: .named("gear"), action: didToggleSelection())])
        ]
        
        
        }
    
    func setUpNavBarView() {
        self.view.addSubview(navBarView)
        self.navBarView.addBehavior()
        
        // tap to dismissSettings
let dismissTap = UITapGestureRecognizer(target: self, action: #selector(self.backButtonpressed))
        dismissTap.numberOfTapsRequired = 1
        navBarView.backButton.isUserInteractionEnabled = true
        navBarView.backButton.addGestureRecognizer(dismissTap)

        
      
       // self.backButton1.setTitleColor(.systemBlue, for: .normal)
        navBarView.titleLabel.text = "Report Post"
        navBarView.postButton.isHidden = true
        navBarView.titleLabel.textColor = .black
    
        self.navBarView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/12)
        self.tableView.frame = CGRect(x: 0, y: self.navBarView.frame.height, width: self.view.frame.width, height: self.view.frame.height-self.navBarView.frame.height)
      //  navBarView.titleLabel.frame = CGRect(x: 0, y: navBarView.frame.height/4, width: self.view.frame.width, height: navBarView.frame.height/2)
        self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y: navBarView.postButton.frame.minY, width: 200, height: 25)
       // self.backButton1.frame = CGRect(x: 0, y: 0, width: navBarView.frame.width/8, height: titleLabel1.frame.height)
        //self.titleLabel1.textAlignment = .center
        //self.backButton1.titleLabel?.textAlignment = .left
        navBarView.titleLabel.font = UIFont(name: "DINAlternate-Bold", size: 20)
        self.navBarView.backgroundColor = .systemGray6
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
            print("This is cell \(cell)")
          return cell
        }

        
//    @IBAction func backButtonClicked(_ sender: UIBarButtonItem) {
////        menuView.homeButtonClicked(sender)
//    dismiss(animated: false, completion: nil)
//    }
    
        
        
    

     private func showAlert(_ sender: Row) {
       // ...
     }

     private func didToggleSelection() -> (Row) -> Void {
       return { [weak self] row in
        var reason = row.text
        print("toggled row: \(row.text)")
        
        if row.text == "Other" {
            let otherReasonVC = self?.storyboard!.instantiateViewController(identifier: "otherReasonVC") as! OtherReasonVC
     //       otherReasonVC.userDataVM = userDataVM
         
            otherReasonVC.modalPresentationStyle = .fullScreen
            otherReasonVC.hexData = self!.hexData
            otherReasonVC.userDataVM = self!.userDataVM!
            self!.present(otherReasonVC, animated: false,completion: nil)
        }
        
     else if row.text != "" {
            let alert = UIAlertController(title: "Are You Sure?", message: "Click Yes to report this user for \(row.text)", preferredStyle: UIAlertController.Style.alert)
            let ok = UIAlertAction(title: "Yes", style: UIAlertAction.Style.cancel, handler: {_ in
                print("Send report to backend for \(row.text)")
                print("This is the reason: \(reason)")
                let reportObjectref = self!.db.collection("ReportedPosts")
                   let reportDoc = reportObjectref.document()
                let reportObject = ReportedPostObject(reason: reason,post: (self?.hexData?.thumbResource)!, userReporting: self!.userDataVM?.userData.value?.publicID ?? "unable to find userData.publicID", userWhoWasReported: (self?.hexData!.postingUserID)!)
                   reportDoc.setData(reportObject.dictionary){ error in
                       if error == nil {
                        UIDevice.vibrate()
                           print("reported bug: \(reportObject)")
                        self!.dismiss(animated: true)
                       }
                       else {
                           print("failed to add bug \(reportObject)")

                       }
                   }
                
                
                
                
            })
            let nah = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(ok)
            alert.addAction(nah)
            self!.present(alert, animated: true, completion: nil)
            
        }
        
        
        
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
        self.performSegue(withIdentifier: "rewindSignOut", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //empty for now.  Used for signout
    }
   
}
