//
//  FollowersTableView.swift
//  Bio
//
//  Created by Ann McDonough on 10/16/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//


import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import SDWebImage
import FirebaseUI
import FirebaseStorage

class FollowersTableView: UIViewController, UISearchBarDelegate {
    
    var searchBar = UISearchBar()
    @IBOutlet weak var tableView: UITableView!
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    
    var currentUser: User?
    var loadUserDataArray = ThreadSafeArray<UserData>()
    var searchString: String = ""
    var userDataVM: UserDataVM?
    
    var followList = [String]()
    var followListener: ListenerRegistration?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchBar)
        view.addSubview(tableView)
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.tintColor = UIColor.black
        searchBar.backgroundColor = UIColor.black
  //      searchBar.isTranslucent = true
        searchBar.barStyle = .blackOpaque
        searchBar.frame.size.width = self.view.frame.size.width
        searchBar.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: searchBar.frame.width, height: searchBar.frame.height)
      //  searchBar.frame.size.width = self.view.frame.size.width
      //  searchBar.frame = CGRect(x: 0, y: 20, width: searchBar.frame.width, height: searchBar.frame.height)
//        let attributes:[NSAttributedString.Key: Any] = [
//            .foregroundColor: UIColor.black,
//            .font: UIFont.systemFont(ofSize: 17)
//        ]
//        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
        
//        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
//            cancelButton.setTitle("cancel", for: .normal)
//            cancelButton.setTitleColor(.white, for: .normal)
//            cancelButton.setAttributedTitle(NSAttributedString(), for: .normal)
//        }
        
        //change magnigying glass image
        let textField = searchBar.value(forKey: "searchField") as! UITextField
        let glassIconView = textField.leftView as! UIImageView
        glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
        glassIconView.tintColor = .white
        textField.textColor = .white
        let clearButton = textField.value(forKey: "clearButton") as! UIButton
        clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        clearButton.tintColor = .white
        
        //let textField2 = searchBar.value(forKey: "cancelButton") as! UITextField
//        let cancelButton = searchBar.value(forKey: "cancelButton") as! UIButton
//        cancelButton.titleLabel?.textColor = .white
//        clearButton.tintColor = .white
        
        //cancel button white
//        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
//            print("Cancel button exists!")
//            cancelButton.setTitle("Cancel", for: .normal)
//            cancelButton.setTitleColor(.white, for: .normal)
//           // cancelButton.setAttributedTitle(<your_nsattributedstring>, for: .normal)
//        }
        
        if let buttonItem = searchBar.subviews.first?.subviews.last as? UIButton {
            buttonItem.setTitleColor(UIColor.white, for: .normal)
        }
        
        
        let searchItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.leftBarButtonItem = searchItem
        searchBar.showsCancelButton = true
        //searchBar.becomeFirstResponder()
        //searchBar.resignFirstResponder()
        tableView.keyboardDismissMode = .onDrag
        searchBar.autocapitalizationType = UITextAutocapitalizationType.none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = CGRect(x: 0, y: searchBar.frame.maxY, width: view.frame.width, height: view.frame.height - searchBar.frame.maxY)
        tableView.reloadData()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (loadUserDataArray.isEmpty()) {
            startWithFollowers()
        }
        else {
            doneLoading()
        }
    }
    
    func startWithFollowers() {
        loadFollows(completion: {
            
            // loads follower list to start
            
            self.followListener?.remove()
            self.loadUserDataArray.removeAll()
            //self.loadUserDataArray.append(newElement: self.userData!)
            let chunks = self.followList.chunked(into: 5)
            let group = DispatchGroup()
            for chunk in chunks {
                group.enter()
                self.loadUpToTenUserDatas(usernames: chunk, completion: {
                    //print("loadFollowings: loaded followers \(self.followingUserDataArray)")
                    defer{group.leave()}
                })
            }
            group.notify(queue: .main) {
                //print("loadFollowings: done loading followers \(self.followingUserDataArray)")
                self.doneLoading()
            }
            self.tableView.reloadData()
        })
    }
    
    func loadUpToTenUserDatas(usernames: [String], completion: @escaping () -> ()) {
        let userDataCollection = self.db.collection("UserData1")
        let userDataQuery = userDataCollection.whereField("publicID", in: usernames)
        let listener = userDataQuery.addSnapshotListener( { (objects, error) -> Void in
            if error == nil {
                guard let documents = objects?.documents else {
                    print("could not get documents from objects?.documents")
                    print(error!.localizedDescription)
                    return
                }
                
                for object in documents {
                    let newUserData = UserData(dictionary: object.data())
                    let readOnlyArray = self.loadUserDataArray.readOnlyArray()
                    
                    // TODO: Very inefficient.  Use database operations to make sure data is clean.  Followers shouldnt be too many.  < 100 elements
                    let userData = self.userDataVM?.userData.value
                    if (userData == nil) {
                        return
                    }
                    if (!readOnlyArray.contains(where: { data in
                        data.publicID == newUserData.publicID
                    }) && !userData!.isBlockedBy.contains(newUserData.publicID) && !userData!.blockedUsers.contains(newUserData.publicID)) {
                        self.loadUserDataArray.append(newElement: newUserData)
                    }
                }
            } else {
                print("could not get userdata for followings")
                print(error!.localizedDescription)
            }
            completion()
            
        })
        listenerList?.append(listener)
    }
    
    var listenerList: [ListenerRegistration]?
    
    func doneLoading() {
        listenerList?.forEach({ listener in
            listener.remove()
        })
        listenerList = nil
        sortUserDataArray()
        self.tableView.reloadData()
    }
    
    func sortUserDataArray() {
        var sorted = self.loadUserDataArray.readOnlyArray()
        sorted.sort(by: { x, y in
            x.publicID < y.publicID
        })
        loadUserDataArray.removeAll()
        sorted.forEach({ item in
            self.loadUserDataArray.append(newElement: item)
        })
    }
    
    func loadFollows(completion: @escaping() -> ()) {
        let username = userDataVM?.userData.value?.publicID
        if (username == nil) {
            return
        }
        followListener = db.collection("Followings").whereField("following", isEqualTo: username).addSnapshotListener({ objects, error in
            if error == nil {
                self.followList.removeAll(keepingCapacity: true)
                guard let docs = objects?.documents else {
                    return
                }
                for doc in docs {
                    print("follow item \(doc.data())")
                    let following = doc["following"] as! String
                    if (!self.followList.contains(following)) {
                        self.followList.append(following)
                    }
                }
            }
            completion()
        })
    }
    
    // search updated
//    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if text == "" && searchString != "" {
//            let _ = searchString.popLast()
//        }
//        else {
//            searchString += text
//        }
//        loadUserData()
//        return true
//    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        loadUserData()
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
        loadUserDataArray.removeAll()
        self.dismiss(animated: false, completion: nil)
        
        //usernameArray = []
    }
    
    
    
    func loadUserData() {
        loadUserDataArray.removeAll()
        searchString = searchBar.text ?? ""
        if searchString == "" {
            startWithFollowers()
            return
        }
        
        // right here we need to search within loaduserdataarray using searchString
        else {
            print("Present substring of following based on searchString Here")
            }
        self.tableView.reloadData()
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
                    guestVC.guestUserData = userdata
                    guestVC.userDataVM = self.userDataVM
                    guestVC.isFollowing = sender.view?.tag == 1
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
extension FollowersTableView: UITableViewDelegate, UITableViewDataSource {
    
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
     //   print("This is height for row at: \(self.view.frame.height/8)")
    //    return self.view.frame.height/8
    return 80
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserCell
       // cell.frame.height = self.view.frame.height/10
        cell.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/8)
        let cellTappedRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        cell.addGestureRecognizer(cellTappedRecognizer)
        cell.userDataVM = userDataVM
        //  Configure the cell...
        print("This is cell \(cell)")
        cell.avaImg.sd_setImage(with: storageRef.child(loadUserDataArray[indexPath.row].avaRef))
        cell.displayNameLabel.text = loadUserDataArray[indexPath.row].displayName
        cell.usernameLbl.text = loadUserDataArray[indexPath.row].publicID
        
        if (followList.contains(cell.usernameLbl.text!)) {
           // cell.followBtn.imageView?.image = UIImage(named: "friendCheck")
            cell.followView.isHidden = true
            cell.followView.tag = 1
            cell.tag = 1
        }
        else if (self.userDataVM?.userData.value?.publicID == loadUserDataArray[indexPath.row].publicID) {
            cell.followView.isHidden = true
        }
        else {
            cell.followView.isHidden = false
            cell.followImage?.image = UIImage(named: "addFriend")
            cell.followView.tag = 0
            cell.tag = 0
        }
        
        
        
        
        //cell = loadUserDataArray![indexPath.row]
        //print("This is cell image \(cell.avaImg.image)")
        //   cell.previewImage.setupHexagonMask(lineWidth: 10.0, color: .black, cornerRadius: 10.0)
        //     cellArray.append(cell)
        return cell
    }
}




