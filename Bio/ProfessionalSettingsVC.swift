//
//  ProfessionalSettingsVC.swift
//  Bio
//
//  Created by Ann McDonough on 9/2/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//
//
import UIKit
import FirebaseAuth
import QuickTableViewController

class ProfessionalSettingsVC: QuickTableViewController {
    
    var navBarView = NavBarView()
    
    
    //var tabController = NavigationMenuBaseController()
    var userData: UserData? = nil
    var menuView = MenuView()
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
 
 var user = "\(Auth.auth().currentUser?.email)"
 var name = "\(Auth.auth().currentUser?.displayName)"
 var birthday = "1/1/2020"
 var country = "USA"
 var phoneNumber = "xxx-xxx-xxxx"
 var email = "\(Auth.auth().currentUser?.email)"
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
//        navBarView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/12)
//        tableView.frame = CGRect(x: 0, y: self.view.frame.height/12, width: self.view.frame.width, height: self.view.frame.height)
//        titleLabel1.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/12)
//        backButton1.frame = CGRect(x: 0, y: 0, width: navBarView.frame.width/8, height: titleLabel1.frame.height)
//        titleLabel1.textAlignment = .center
//        backButton1.titleLabel?.textAlignment = .left
//        titleLabel1.font = UIFont(name: "DIN Alternate Bold", size: 40)
//        navBarView.backgroundColor = .systemGray6
        
       // navBaView.setTitleVerticalPositionAdjustment(-10, for: UIBarMetrics.default)
//        backButton.setBackButtonBackgroundVerticalPositionAdjustment(-10, for: UIBarMetrics.default)
        
       // backButton.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)
   //     navigationItem.leftBarButtonItem?.setBackgroundVerticalPositionAdjustment(-10, for: UIBarMetrics.default)
      
       
        
        
        // Do any additional setup after loading the view.
       
        menuView.isHidden = true
        tableContents = [
            Section(title: "My Account", rows: [
                                 NavigationRow(text: "Name", detailText: .value1(name)!, icon: .named("gear")),
                                 NavigationRow(text: "Username", detailText: .value1(email)!, icon: .named("globe")),
                                 NavigationRow(text: "Birthday", detailText: .value1(birthday), icon: .none, action: { _ in }),
                                 NavigationRow(text: "Country", detailText: .value1(country)), NavigationRow(text: "Terms of Service", detailText: .none, icon: .named("time"), action: { _ in }),
                                 NavigationRow(text: "Phone Number", detailText: .value1(phoneNumber)),
                                 NavigationRow(text: "Email", detailText: .value1(email)!, icon: .named("time"), action: { _ in }),
                                NavigationRow(text: "Password", detailText: .none),
                                NavigationRow(text: "Two-Factor Authentification", detailText: .none, icon: .named("time"), action: { _ in })]),
            Section(title: "Support", rows: [
                        NavigationRow(text: "FAQ's", detailText: .none, icon: .named("gear")),
                        NavigationRow(text: "I Spotted a Bug", detailText: .none, icon: .named("globe")),
                        NavigationRow(text: "I Have a Suggestion", detailText: .none, icon: .named("time"), action: { _ in }),
                        NavigationRow(text: "Privacy Policy", detailText: .none),
                        NavigationRow(text: "Terms of Service", detailText: .none, icon: .named("time"), action: { _ in }),
                        NavigationRow(text: "Report User", detailText: .none)]),
                Section(title: "Account Actions", rows: [
                    NavigationRow(text: "Log Out", detailText: .none, icon: .named("gear"))])
        ]
        
        
        }
    
    func setUpNavBarView() {
      
        self.view.addSubview(navBarView)
        self.navBarView.addSubview(titleLabel1)
        self.navBarView.addSubview(backButton1)
        self.navBarView.addBehavior()
        
        // tap to dismissSettings
let dismissTap = UITapGestureRecognizer(target: backButton1, action: #selector(self.backButtonpressed))
        dismissTap.numberOfTapsRequired = 1
        self.backButton1.isUserInteractionEnabled = true
        self.backButton1.addGestureRecognizer(dismissTap)

        
        self.backButton1.setTitle("Back", for: .normal)
        self.backButton1.setTitleColor(.systemBlue, for: .normal)
        self.titleLabel1.text = "Settings"
        self.navBarView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/12)
        self.tableView.frame = CGRect(x: 0, y: self.view.frame.height/12, width: self.view.frame.width, height: self.view.frame.height)
        self.titleLabel1.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/12)
        self.backButton1.frame = CGRect(x: 0, y: 0, width: navBarView.frame.width/8, height: titleLabel1.frame.height)
        self.titleLabel1.textAlignment = .center
        self.backButton1.titleLabel?.textAlignment = .left
        self.titleLabel1.font = UIFont(name: "DIN Alternate Bold", size: 40)
        self.navBarView.backgroundColor = .systemGray6
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
         // ...
       }
     }

   







}
