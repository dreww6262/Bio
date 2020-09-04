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
    

    @IBOutlet weak var backButton: UIButton!
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addBackButton()
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

        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = super.tableView(tableView, cellForRowAt: indexPath)
          // Alter the cells created by QuickTableViewController
          return cell
        }

        
    @IBAction func backButtonClicked(_ sender: UIButton) {
        menuView.homeButtonClicked(sender)
    }
    
    func addBackButton() {
        self.view.addSubview(backButton)
        backButton.frame = CGRect(x: 10, y: 20, width: 50, height: 50)
        // round ava
        backButton.clipsToBounds = true
        backButton.isHidden = false
        backButton.titleLabel?.text = "Back"
    }
        
        
        
        
    

     private func showAlert(_ sender: Row) {
       // ...
     }

     private func didToggleSelection() -> (Row) -> Void {
       return { [weak self] row in
         // ...
       }
     }

   







}
