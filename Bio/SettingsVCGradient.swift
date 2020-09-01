//
//  SettingsVCGradient.swift
//  Bio
//
//  Created by Ann McDonough on 8/20/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SettingsVCGradient: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var gradientImage: UIImageView!
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
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.frame = CGRect(x: 0, y: 10, width: self.view.frame.width, height: 44)
        var yPosition = titleLabel.frame.maxY
        tableView.frame = CGRect(x: 0, y: titleLabel.frame.maxY, width: self.view.frame.width, height: self.view.frame.height - yPosition)
userDataCombinedArray = [name,user,birthday, country,phoneNumber, email, password, twoFactorAuth,"",
  "",
  "",
  "",
  "",
  "", ""]
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        
        
    }



}



extension SettingsVCGradient: UITableViewDelegate, UITableViewDataSource {
       
       func numberOfSections(in tableView: UITableView) -> Int {
               // #warning Incomplete implementation, return the number of sections
               return 3
           }

       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
               // #warning Incomplete implementation, return the number of rows
        return settingsTitleArray.count
           }

             // cell height
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height/CGFloat(settingsTitleArray.count) - 3
               }

           
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
               let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsCell
        
              //  Configure the cell...
               print("This is cell \(cell)")
        for accountInfo in settingsTitleArray {
        cell.titleLabel.text = "\(settingsTitleArray[indexPath.row])"
        cell.userDataLabel.text = "\(userDataCombinedArray[indexPath.row])"
        }
  
             //  cell.avaImg.sd_setImage(with: storageRef.child(loadUserDataArray[indexPath.row].avaRef))
           //    cell.displayNameLabel.text = loadUserDataArray[indexPath.row].displayName
          //     cell.usernameLbl.text = loadUserDataArray[indexPath.row].publicID
               
               
               //cell = loadUserDataArray![indexPath.row]
               //print("This is cell image \(cell.avaImg.image)")
                   //   cell.previewImage.setupHexagonMask(lineWidth: 10.0, color: .black, cornerRadius: 10.0)
                 //     cellArray.append(cell)
               return cell
           }

           

       }
   
       
   
