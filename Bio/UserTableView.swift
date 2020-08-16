//
//  UserTableView.swift
//  Bio
//
//  Created by Ann McDonough on 8/16/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import SDWebImage
import FirebaseUI
import FirebaseStorage

class UserTableView: UITableViewController, UISearchBarDelegate {

    var searchBar = UISearchBar()
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    
    var currentUser: User?
    var loadUserDataArray: [UserData] = []
    var searchString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchBar)
                   searchBar.delegate = self
                      searchBar.sizeToFit()
                      searchBar.tintColor = UIColor.black
                      searchBar.frame.size.width = self.view.frame.size.width
               
                      let searchItem = UIBarButtonItem(customView: searchBar)
                      self.navigationItem.leftBarButtonItem = searchItem
        
        
        tableView.reloadData()
        
    
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

     // search updated
            func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        loadUserData()
                return true
            }


            // tapped on the searchBar
            func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
                // hide collectionView when started search
               // collectionView.isHidden = true
                // show cancel button
                searchBar.showsCancelButton = true
            }
    //
    //
    //        // clicked cancel button
            func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
                // unhide collectionView when tapped cancel button
              //  collectionView.isHidden = false
                // dismiss keyboard
                searchBar.resignFirstResponder()
    
                // hide cancel button
                searchBar.showsCancelButton = false
    
                // reset text
                searchBar.text = ""
    
                // reset shown users
                loadUserDataArray = []
    
                //usernameArray = []
            }
    
    
    
    func loadUserData() {
        loadUserDataArray = []
                   // find by username
                   var success = true
                   let usernameQuery = db.collection("UserData1")
                   usernameQuery.addSnapshotListener({snapshots,error in
                       if (error != nil) {
                           print("god damnit")
                           success = false
                           return
                       }
                       print("success, search bar pulled data")
                       for doc in snapshots!.documents {
                           //self.usernameArray.append(doc.value(forKey: "publicID") as! String)
                           print(doc.data())
                           self.loadUserDataArray.append(UserData(dictionary: doc.data()))
                           
                       }
                       //self.loadUsers()
                       self.tableView.reloadData()
    })
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return loadUserDataArray.count
    }

      // cell height
        override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 150
        }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserCell

       //  Configure the cell...
        print("This is cell \(cell)")
        cell.avaImg.sd_setImage(with: storageRef.child(loadUserDataArray[indexPath.row].avaRef))
        cell.displayNameLabel.text = loadUserDataArray[indexPath.row].displayName
        cell.usernameLbl.text = loadUserDataArray[indexPath.row].publicID
        
        
        //cell = loadUserDataArray![indexPath.row]
        //print("This is cell image \(cell.avaImg.image)")
            //   cell.previewImage.setupHexagonMask(lineWidth: 10.0, color: .black, cornerRadius: 10.0)
          //     cellArray.append(cell)
               return cell
        return cell
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
