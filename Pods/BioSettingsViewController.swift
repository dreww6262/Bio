//
//  BioSettingsViewController.swift
//  abseil
//
//  Created by Ann McDonough on 8/11/20.
//

import UIKit

class BioSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var settingsArray: [String] = ["Invite Friends", "Notifications", "Security", "About", "Log Out"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        
    }
    


}



extension BioSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          // put the number of photos that you have selected in here for count
          print("This is settings.count \(settingsArray.count)")
          return settingsArray.count ?? 0
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          //put the right photo in the right index here
         let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! UITableViewCell
          print("This is cell \(cell)")
       //   cell.previewImage.image = photos![indexPath.row]
          //print("This is cell image \(cell.previewImage.image)")
      //  cell.previewImage.setupHexagonMask(lineWidth: 10.0, color: .black, cornerRadius: 10.0)
        cellArray.append(cell)
               return cell
          
      }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    
    
}
