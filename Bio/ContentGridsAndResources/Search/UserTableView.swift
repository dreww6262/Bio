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
    var loadUserDataArray = ThreadSafeArray<UserData>()
    var userDataVM: UserDataVM?
    
    var followList = [String]()
    
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

        
        //change magnigying glass image
        let textField = searchBar.value(forKey: "searchField") as! UITextField
        let glassIconView = textField.leftView as! UIImageView
        glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
        glassIconView.tintColor = .white
        textField.textColor = .white
        let clearButton = textField.value(forKey: "clearButton") as! UIButton
        clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        clearButton.tintColor = .white
        
        
        if let buttonItem = searchBar.subviews.first?.subviews.last as? UIButton {
            buttonItem.setTitleColor(UIColor.white, for: .normal)
        }
        
        
        let searchItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.leftBarButtonItem = searchItem
        searchBar.showsCancelButton = true
        searchBar.becomeFirstResponder()
        searchBar.autocapitalizationType = UITextAutocapitalizationType.none
        tableView.keyboardDismissMode = .onDrag
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = CGRect(x: 0, y: searchBar.frame.maxY, width: view.frame.width, height: view.frame.height - searchBar.frame.height)
        tableView.reloadData()

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (loadUserDataArray.isEmpty()) {
            startWithFollowers()
        }
        else {
            tableView.reloadData()
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
                    group.leave()
                })
            }
            group.notify(queue: .main) {
                self.tableView.reloadData()
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
                let userData = self.userDataVM?.userData.value
                
                for object in documents {
                    let newUserData = UserData(dictionary: object.data())
                    let readOnlyArray = self.loadUserDataArray.readOnlyArray()
                    
                    // TODO: Very inefficient.  Use database operations to make sure data is clean.  Followers shouldnt be too many.  < 100 elements
                    
                    if (!readOnlyArray.contains(where: { data in
                        data.publicID == newUserData.publicID
                    }) && !userData!.isBlockedBy.contains(newUserData.publicID) && !userData!.blockedUsers.contains(newUserData.publicID)) {
                        self.loadUserDataArray.append(newElement: newUserData)
                    }
                    else if userData!.isBlockedBy.contains(newUserData.publicID) && userData!.blockedUsers.contains(newUserData.publicID){
                        print("is blocking and is blocked by \(newUserData.publicID)")
                    }
                    else if userData!.isBlockedBy.contains(newUserData.publicID){
                        print("is blocked by \(newUserData.publicID)")
                    }
                    else {
                        print("is blocking \(newUserData.publicID)")
                    }
                }
            } else {
                print("could not get userdata for followings")
                print(error!.localizedDescription)
            }
            completion()
            
        })
    }

    func sortUserDataArray(userDataArray: inout [UserData], byPublicID: Bool) {
        
        if (byPublicID) {
            userDataArray.sort(by: { x, y in
                x.publicID < y.publicID
            })
//            userDataArray.forEach({ item in
//                self.loadUserDataArray.append(newElement: item)
//            })
        }
        else {
            userDataArray.sort(by: { x, y in
                x.displayNameQueryable < y.displayNameQueryable
            })
//            userDataArray.forEach({ item in
//                self.loadUserDataArray.append(newElement: item)
//            })
        }
    }
    
    func loadFollows(completion: @escaping() -> ()) {
        let username = userDataVM?.userData.value?.publicID
        if username == nil {
            return
        }
        db.collection("Followings").whereField("follower", isEqualTo: username!).getDocuments(completion: { objects, error in
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
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        loadUserData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        
        // reset shown users
        loadUserDataArray.removeAll()
        self.dismiss(animated: false, completion: nil)
        
        //usernameArray = []
    }
    
    
    
    func loadUserData() {
        loadUserDataArray.removeAll()
        //searchString = searchBar.text
        var searchString = searchBar.text ?? ""
        if searchString == "" {
            startWithFollowers()
            return
        }

        
        searchString = searchString.lowercased()
        
        let displayNameQuery = db.collection("UserData1").whereField("displayNameQueryable", isGreaterThanOrEqualTo: searchString).whereField("displayNameQueryable", isLessThan: searchString+"\u{F8FF}")
        displayNameQuery.getDocuments(completion: { snapshots, error in
            if error != nil {
                print("god damnit")
                return
            }
            let userData = self.userDataVM?.userData.value
            var userDataArray = [UserData]()
            self.loadUserDataArray.removeAll()
            for doc in snapshots!.documents {
                let newUD = UserData(dictionary: doc.data())
                if (!userDataArray.contains(where: { u in
                    return u.publicID == newUD.publicID
                })) {
                    if !userData!.blockedUsers.contains(newUD.publicID) && !userData!.isBlockedBy.contains(newUD.publicID) {
                        userDataArray.append(newUD)
                    }
                }
            }
            self.sortUserDataArray(userDataArray: &userDataArray, byPublicID: false)
            userDataArray.forEach({ data in
                if !self.loadUserDataArray.readOnlyArray().contains(where: { ud in
                    return ud.publicID == data.publicID
                }) {
//                    print("adding display: \(data.publicID)")
                    self.loadUserDataArray.append(newElement: data)
                }
            })
            
            let usernameQuery = self.db.collection("UserData1").whereField("publicID", isGreaterThanOrEqualTo: searchString).whereField("publicID", isLessThan: searchString+"\u{F8FF}")
            usernameQuery.getDocuments(completion: {snapshots,error in
                if (error != nil) {
                    print("god damnit")
                    //success = false
                    return
                }
                var usernameDataArray = [UserData]()
                for doc in snapshots!.documents {
                    //self.usernameArray.append(doc.value(forKey: "publicID") as! String)
                    let newUD = UserData(dictionary: doc.data())
                    if (!usernameDataArray.contains(where: { u in
                        return u.publicID == newUD.publicID
                    })) {
                        if !userData!.blockedUsers.contains(newUD.publicID) && !userData!.isBlockedBy.contains(newUD.publicID) {
                            usernameDataArray.append(newUD)
                        }
                    }
                }
                self.sortUserDataArray(userDataArray: &usernameDataArray, byPublicID: true)
                usernameDataArray.forEach({ data in
                    if !self.loadUserDataArray.readOnlyArray().contains(where: { ud in
                        return ud.publicID == data.publicID
                    }) {
//                        print("adding username: \(data.publicID)")
                        self.loadUserDataArray.append(newElement: data)
                    }
                })
                self.tableView.reloadData()
            })
        })
    }
    
    @objc func cellTapped(_ sender : UITapGestureRecognizer) {
        let cell  = sender.view as! UserCell
        let username = cell.usernameLbl.text!
        db.collection("UserData1").whereField("publicID", isEqualTo: username).getDocuments(completion: { objects, error in
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
     //   print("This is height for row at: \(self.view.frame.height/8)")
    //    return self.view.frame.height/8
    return 80
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("loadUserDataArray: \(loadUserDataArray.count)")
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
        else if (userDataVM?.userData.value?.publicID == loadUserDataArray[indexPath.row].publicID) {
            cell.followView.isHidden = true
        }
        else {
            cell.followView.isHidden = false
            cell.followImage?.image = UIImage(named: "addFriend")
            cell.followView.tag = 0
            cell.tag = 0
        }
        return cell
    }
}




