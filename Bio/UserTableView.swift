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

class UserTableView: UIViewController, UISearchBarDelegate {
    
    var searchBar = UISearchBar()
    @IBOutlet weak var tableView: UITableView!
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    
    var currentUser: User?
    var loadUserDataArray: [UserData] = []
    var searchString: String?
    var userData: UserData?
    
    var followList = [String]()
    var followListener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchBar)
        view.addSubview(tableView)
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.tintColor = UIColor.black
        searchBar.frame.size.width = self.view.frame.size.width
        searchBar.frame = CGRect(x: 0, y: 20, width: searchBar.frame.width, height: searchBar.frame.height)
        
        let searchItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.leftBarButtonItem = searchItem
        searchBar.showsCancelButton = true
        searchBar.becomeFirstResponder()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = CGRect(x: 0, y: searchBar.frame.height + 20, width: view.frame.width, height: view.frame.height - searchBar.frame.height)
        tableView.reloadData()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadFollows(completion: {
            self.followListener?.remove()
            self.tableView.reloadData()
        })
        
    }
    
    func loadFollows(completion: @escaping() -> ()) {
        followListener = db.collection("Followings").whereField("follower", isEqualTo: userData!.publicID).addSnapshotListener({ objects, error in
            if error == nil {
                self.followList.removeAll(keepingCapacity: true)
                guard let docs = objects?.documents else {
                    return
                }
                for doc in docs {
                    print("follow item \(doc.data())")
                    self.followList.append(doc["following"] as! String)
                }
            }
            completion()
        })
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
        //searchBar.showsCancelButton = true
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
        //searchBar.showsCancelButton = false
        
        // reset text
        searchBar.text = ""
        
        // reset shown users
        loadUserDataArray = []
        self.dismiss(animated: false, completion: nil)
        
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
    
    @objc func cellTapped(_ sender : UITapGestureRecognizer) {
        let cell  = sender.view as! UserCell
        let username = cell.usernameLbl.text!
        db.collection("UserData1").whereField("publicID", isEqualTo: username).addSnapshotListener({ objects, error in
            if error == nil {
                guard let docs = objects?.documents else{
                    print("no docs?")
                    return
                }
                if docs.count > 1 {
                    print("Too many docs \(docs)")
                }
                else if (docs.count == 0) {
                    print("no username")
                }
                else {
                    let userdata = UserData(dictionary: docs[0].data())
                    let guestVC = self.storyboard!.instantiateViewController(identifier: "guestGridVC") as! GuestHexagonGridVC
                    guestVC.userData = userdata
                    self.present(guestVC, animated: false)
                    self.modalPresentationStyle = .fullScreen
                }
            }
            else {
                print("pulling up guest vc userdata failed")
            }
        })
    }

    
    // MARK: - Table view data source
    
    
    
    
    
    
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

// MARK: - Table view data source
extension UserTableView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return loadUserDataArray.count
    }
    
    // cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("loadUserDataArray: \(loadUserDataArray.count)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserCell
        let cellTappedRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        cell.addGestureRecognizer(cellTappedRecognizer)
        cell.userData = userData
        //  Configure the cell...
        print("This is cell \(cell)")
        cell.avaImg.sd_setImage(with: storageRef.child(loadUserDataArray[indexPath.row].avaRef))
        cell.displayNameLabel.text = loadUserDataArray[indexPath.row].displayName
        cell.usernameLbl.text = loadUserDataArray[indexPath.row].publicID
        
        if (followList.contains(cell.usernameLbl.text!)) {
            cell.followBtn.imageView?.image = UIImage(named: "friendCheck")
            cell.followBtn.tag = 1
        }
        else {
            cell.followBtn.imageView?.image = UIImage(named: "addFriend")
            cell.followBtn.tag = 0
        }
        
        
        //cell = loadUserDataArray![indexPath.row]
        //print("This is cell image \(cell.avaImg.image)")
        //   cell.previewImage.setupHexagonMask(lineWidth: 10.0, color: .black, cornerRadius: 10.0)
        //     cellArray.append(cell)
        return cell
    }
}




