//
//  ProfessionalSettingsVC.swift
//  Bio
//
//  Created by Ann McDonough on 9/2/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import QuickTableViewController
import FirebaseAuth

class ProfessionalSettingsVC: QuickTableViewController {
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
 var userData: UserData? = nil
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
        
        tableContents = [
            Section(title: "My Account", rows: [
                                 NavigationRow(text: "Name", detailText: .none, icon: .named("gear")),
                                 NavigationRow(text: "Username", detailText: .subtitle(".subtitle"), icon: .named("globe")),
                                 NavigationRow(text: "Birthday", detailText: .value1(".value1"), icon: .named("time"), action: { _ in }),
                                 NavigationRow(text: "Country", detailText: .value2(".value2")), NavigationRow(text: "Terms of Service", detailText: .value1(".value1"), icon: .named("time"), action: { _ in }),
                                 NavigationRow(text: "Phone Number", detailText: .value2(".value2")),
                                 NavigationRow(text: "Email", detailText: .value1(".value1"), icon: .named("time"), action: { _ in }),
                                NavigationRow(text: "Password", detailText: .value2(".value2")),
                                NavigationRow(text: "Two-Factor Authentification", detailText: .value1(".value1"), icon: .named("time"), action: { _ in })]),
            Section(title: "Support", rows: [
                        NavigationRow(text: "FAQ's", detailText: .none, icon: .named("gear")),
                        NavigationRow(text: "I Spotted a Bug", detailText: .subtitle(".subtitle"), icon: .named("globe")),
                        NavigationRow(text: "I Have a Suggestion", detailText: .value1(".value1"), icon: .named("time"), action: { _ in }),
                        NavigationRow(text: "Privacy Policy", detailText: .value2(".value2")),
                        NavigationRow(text: "Terms of Service", detailText: .value1(".value1"), icon: .named("time"), action: { _ in }),
                        NavigationRow(text: "Report User", detailText: .value2(".value2"))]),
                Section(title: "Account Actions", rows: [
                    NavigationRow(text: "Log Out", detailText: .none, icon: .named("gear"))])
        ]
        
        
        }

        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = super.tableView(tableView, cellForRowAt: indexPath)
          // Alter the cells created by QuickTableViewController
          return cell
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
