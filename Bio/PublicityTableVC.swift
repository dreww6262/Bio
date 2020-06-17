//
//  PublicityTableVC.swift
//  Bio
//
//  Created by Ann McDonough on 6/14/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit

var selectedPublicity = "Public"

class PublicityTableVC: UITableViewController {

  //  var selectedPublicity = ""
    var publicityArray: [String] = ["Public -- Everyone can view your page", "Friends Only -- Only friends can view your page", "Private -- Nobody can view your page"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         var selectedLocationIndex = tableView.indexPathForSelectedRow!.row
        print("Im in prepare")
        print("This is selected index: \(selectedLocationIndex)")
        selectedPublicity = publicityArray[selectedLocationIndex]
        print("This is what selectedPublicity is \(selectedPublicity)")
      //  SettingsVC.publicityLabel.text = selectedPublicity
     }
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let cell = sender as! PrivacyCell
//        let index = cell.convert(CGPoint.zero, to:self.tableView)
//        let indexPath = self.tableView.indexPathForRow(at: index)
//
//        // Now that I have the indexPath, I can do my stuff
//      //  let myData = PublicityTableVC.object(at: indexPath!)
//      //  selectedPublicity =
////        MyID1InModalVC = myData.ID1!
////        MyID2InModalVC = myData.ID2!
////        MyID3InModalVC = myData.ID3!
//    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrivacyCell", for: indexPath) as! PrivacyCell
        cell.txtLabel?.text = publicityArray[indexPath.row]
        return cell
    }

     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("I am in didSelect")
//        let indexPath = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example
//
//        let currentCell = tableView.cellForRow(at: indexPath ?? IndexPath()) as! PrivacyCell

//    print(currentCell.txtLabel!.text)
        
        let cellPicked = publicityArray[indexPath.row]
        print(cellPicked)
    
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
