//
//  SettingsVCGradient.swift
//  Bio
//
//  Created by Ann McDonough on 8/20/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit

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
    var supportArray = ["FAQs",
    "I spotted a bug",
    "I have a Suggestion",
    "Privacy Policy",
    "Terms of Service",
    "Report User"]
    var accountActionsArray = ["Log Out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        return myAccountArray.count
           }

             // cell height
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height/10
               }

           
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
               let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsCell
        
              //  Configure the cell...
               print("This is cell \(cell)")
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
   
       
   
