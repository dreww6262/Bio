//
//  TagUserTableView.swift
//  Bio
//
//  Created by Ann McDonough on 10/13/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import SDWebImage
import FirebaseUI
import FirebaseStorage

class TagUserTableView: UIViewController, UISearchBarDelegate {
    
    var searchBar = UISearchBar()
    @IBOutlet weak var tableView: UITableView!
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    
    var userDataVM: UserDataVM?
    var currentUser: User?
    var loadUserDataArray = ThreadSafeArray<UserData>()
    var searchString = ""
    
    var followList = [String]()
    var scaleCGPoint: CGPoint?
    var tagCGPoint: CGPoint?
    var percentWidthX: Double = 0.0
    var percentHeightY: Double = 0.0
    
    
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
        searchBar.frame = CGRect(x: 0, y: 20, width: searchBar.frame.width, height: searchBar.frame.height)
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
        tableView.keyboardDismissMode = .onDrag
        
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
        searchBar.becomeFirstResponder()
        searchBar.autocapitalizationType = UITextAutocapitalizationType.none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = CGRect(x: 0, y: searchBar.frame.height + 20, width: view.frame.width, height: view.frame.height - searchBar.frame.height)
        tableView.reloadData()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
            
            self.loadUserDataArray.removeAll()
            //self.loadUserDataArray.append(newElement: self.userData!)
            let chunks = self.followList.chunked(into: 5)
            let group = DispatchGroup()
            for chunk in chunks {
                group.enter()
                self.loadUpToTenUserDatas(usernames: chunk, completion: {
                    //print("loadFollowings: loaded followers \(self.followingUserDataArray)")
                    do{group.leave()}
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
        userDataQuery.getDocuments(completion: { (objects, error) -> Void in
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
                    
                    if (!readOnlyArray.contains(where: { data in
                        data.publicID == newUserData.publicID
                    })) {
                        self.loadUserDataArray.append(newElement: newUserData)
                    }
                }
            } else {
                print("could not get userdata for followings")
                print(error!.localizedDescription)
            }
            completion()
            
        })
    }
    
    
    func doneLoading() {
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
        let userData = userDataVM?.userData.value
        if userData == nil {
            return
        }
        
        db.collection("Followings").whereField("follower", isEqualTo: userData!.publicID).getDocuments(completion: { objects, error in
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
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "" && searchString != "" {
            let _ = searchString.popLast()
        }
        else {
            searchString += text
        }
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
        loadUserDataArray.removeAll()
        self.dismiss(animated: false, completion: nil)
        
        //usernameArray = []
    }
    
    
    
    func loadUserData() {
        loadUserDataArray.removeAll()
        //searchString = searchBar.text
        if searchString == "" {
            startWithFollowers()
            return
        }
        // find by username
        //var success = true
        searchString = searchString.lowercased()
        let usernameQuery = db.collection("UserData1").whereField("publicID", isGreaterThanOrEqualTo: searchString).whereField("publicID", isLessThan: searchString+"\u{F8FF}")
        usernameQuery.getDocuments(completion: {snapshots,error in
            if (error != nil) {
                print("god damnit")
                //success = false
                return
            }
            print("success, search bar pulled data")
            for doc in snapshots!.documents {
                //self.usernameArray.append(doc.value(forKey: "publicID") as! String)
                let userdata = UserData(dictionary: doc.data())
                if (!self.loadUserDataArray.readOnlyArray().contains(where: { u in
                    return u.publicID == userdata.publicID
                })) {
                    self.loadUserDataArray.append(newElement: userdata)
                }
            }
            self.sortUserDataArray()
            self.tableView.reloadData()
        })
    }
    
    @objc func cellTapped(_ sender : UITapGestureRecognizer) {
        let userData = userDataVM?.userData.value
        if userData == nil {
            return
        }
        let cell  = sender.view as! TagUserCell
        let username = cell.usernameLbl.text!
        let tagPoint =  self.tagCGPoint ?? CGPoint(x: 0, y: 0)
        let tagPointString = "CGPoint(x: \(tagPoint.x), y: \(tagPoint.y))"
        let scaleCGPoint = self.scaleCGPoint ?? CGPoint(x: 0, y: 0)
        let scaleCGPointString = "CGPoint(x: \(scaleCGPoint.x), y: \(scaleCGPoint.y))"
        print("tagPointstring \(tagPointString)")
        print("scaleCGPointString \(scaleCGPointString)")
        
        print("I tapped cell with username: \(username)")
        let tagObjectref = db.collection("Tags")
           let tagDoc = tagObjectref.document()
        //let tagObject1 = NewsObject(ava: userData!.avaRef, type: "follow", currentUser: userData!.publicID, notifyingUser: cell.usernameLbl.text!, thumbResource: userData!.avaRef, createdAt: NSDate.now.description, checked: false, notificationID: tagDoc.documentID)
        
        let tagObject = TagObject(postingUserID: userData!.publicID, type: "photo", taggedUser: username, thumbResource: "", createdAt: NSDate.now.description, notificationID: tagDoc.documentID, percentWidthX: percentWidthX, percentHeightY: percentHeightY)
        
        
           tagDoc.setData(tagObject.dictionary){ error in
               //     group.leave()
               if error == nil {
                   print("added notification: \(tagObject)")
                self.dismiss(animated: true, completion: nil)
                   
               }
               else {
                   print("failed to add notification \(tagObject)")
                   
               }
           }
        
        
        
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
extension TagUserTableView: UITableViewDelegate, UITableViewDataSource {
    
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
        print("loadUserDataArray: \(loadUserDataArray.count)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "tagUserCell", for: indexPath) as! TagUserCell
        let userData = userDataVM?.userData.value
       // cell.frame.height = self.view.frame.height/10
        cell.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/8)
        let cellTappedRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        cell.addGestureRecognizer(cellTappedRecognizer)
        cell.userDataVM = userDataVM
        cell.followView.isHidden = true
        //  Configure the cell...
        print("This is cell \(cell)")
        cell.avaImg.sd_setImage(with: storageRef.child(loadUserDataArray[indexPath.row].avaRef))
        cell.displayNameLabel.text = loadUserDataArray[indexPath.row].displayName
        cell.usernameLbl.text = loadUserDataArray[indexPath.row].publicID
        
        if (followList.contains(cell.usernameLbl.text!)) {
           // cell.followBtn.imageView?.image = UIImage(named: "friendCheck")
            cell.followView.isHidden = true
            cell.followView.tag = 1
        }
        else if (userData?.publicID == loadUserDataArray[indexPath.row].publicID) {
            cell.followView.isHidden = true
        }
        else {
            cell.followView.isHidden = false
            cell.followImage?.image = UIImage(named: "addFriend")
            cell.followView.tag = 0
        }
        
        
        
        
        //cell = loadUserDataArray![indexPath.row]
        //print("This is cell image \(cell.avaImg.image)")
        //   cell.previewImage.setupHexagonMask(lineWidth: 10.0, color: .black, cornerRadius: 10.0)
        //     cellArray.append(cell)
        return cell
    }
}




