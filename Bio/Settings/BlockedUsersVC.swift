//
//  BlockedUsersVC.swift
//  Bio
//
//  Created by Andrew Williamson on 10/16/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class BlockedUsersVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    var navBarView = NavBarView()
    
    var backButton = UIButton()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "blockedCell", for: indexPath) as! BlockedCell
        cell.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.00)
        
        cell.contentView.frame = cell.bounds
        
        let cleanRef = searchArray[indexPath.row].avaRef.replacingOccurrences(of: "/", with: "%2F")
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/bio-social-media.appspot.com/o/\(cleanRef)?alt=media")
        if (url == nil) {
            cell.avaImage.image = UIImage(named: "user-2")
        }
        else {
            cell.avaImage.sd_setImage(with: url!, completed: {_, error, _, _ in
                if error != nil {
                    cell.avaImage.image = UIImage(named: "user-2")
                }
            })
        }
        cell.blockedUserData = searchArray[indexPath.row]
        cell.indexPath = indexPath
        
        cell.avaImage.addGrayCircleGradiendBorder(1.0)
        cell.avaImage.layer.borderColor = white.cgColor
        cell.usernameLabel.font = UIFont(name: "poppins-SemiBold", size: 14)
        cell.usernameLabel.text = searchArray[indexPath.row].publicID
        cell.usernameLabel.sizeToFit()

        let userData = userDataVM?.userData.value
        if (searchArray.readOnlyArray() == blockedArray.readOnlyArray()) {
            cell.deleteButton.setTitle("Unblock", for: .normal)
        }
        else if userData!.blockedUsers.contains(searchArray[indexPath.row].publicID){
            cell.deleteButton.setTitle("Unblock", for: .normal)
        }
        else {
            cell.deleteButton.setTitle("Block", for: .normal)
        }
        cell.deleteButton.setTitleColor(.black, for: .normal)
        cell.deleteButton.frame = CGRect(x: view.frame.width - 120, y: (cell.contentView.frame.height - 30)/2 , width: 100, height: 30)
        cell.avaImage.frame = CGRect(x: 10, y: (cell.contentView.frame.height - 30) / 2, width: 30, height: 30)
        cell.usernameLabel.frame = CGRect(x: cell.avaImage.frame.maxX + 16, y: cell.avaImage.frame.minY, width: cell.usernameLabel.frame.width, height: cell.avaImage.frame.height)
        cell.deleteButton.layer.cornerRadius = cell.deleteButton.frame.width/10
        cell.deleteButton.layer.borderColor = myTikTokBlack.cgColor
        cell.deleteButton.layer.borderWidth = CGFloat(2.0)
        
        let deleteTapped = UITapGestureRecognizer(target: self, action: #selector(deletePressed))
        cell.deleteButton.addGestureRecognizer(deleteTapped)
        
        
        
        return cell
    }
    
    
    
    
    
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "" && searchString != "" {
            var string = searchBar.text
            let _ = string?.popLast()
            searchString = string!
        }
        else {
            searchString = searchBar.text! + text
        }

        
        loadUsernames()
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchArray.removeAll()
            for i in blockedArray.readOnlyArray() {
                searchArray.append(newElement: i)
            }
            tableView.reloadData()
        }
    }
    
    
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchArray = blockedArray
        sortSearchArray()
        tableView.reloadData()
    }
    
    
    func loadUsernames() {
        searchArray.removeAll()
        //searchString = searchBar.text
        // find by username
        //var success = true
        searchString = searchString.lowercased()
        if (searchString == "") {
            searchArray.removeAll()
            for item in blockedArray.readOnlyArray() {
                searchArray.append(newElement: item)
            }
            tableView.reloadData()
            return
        }
        let usernameQuery = db.collection("UserData1").whereField("publicID", isGreaterThanOrEqualTo: searchString).whereField("publicID", isLessThan: searchString+"\u{F8FF}")
        usernameQuery.getDocuments(completion: { snapshots,error in
            if (error != nil) {
                print("god damnit")
                //success = false
                return
            }
            print("success, search bar pulled data")
            for doc in snapshots!.documents {
                //self.usernameArray.append(doc.value(forKey: "publicID") as! String)
                let userdata = UserData(dictionary: doc.data())
                if (!self.searchArray.readOnlyArray().contains(where: { u in
                    return u.publicID == userdata.publicID
                })) {
                    self.searchArray.append(newElement: userdata)
                }
            }
            self.sortSearchArray()
            self.tableView.reloadData()
        })
    }
    
    func sortSearchArray() {
        var sorted = self.searchArray.readOnlyArray()
        sorted.sort(by: { x, y in
            x.publicID < y.publicID
        })
        searchArray.removeAll()
        sorted.forEach({ item in
            self.searchArray.append(newElement: item)
        })
    }
    
    
    @objc func deletePressed(_ sender: UITapGestureRecognizer) {
        let userData = userDataVM?.userData.value
        let cell = sender.view?.superview?.superview as! BlockedCell
        let index = userData!.blockedUsers.firstIndex(of: cell.usernameLabel.text!)
        
        var isBlocking = true
        
        if (index == nil) {
            //block user
//            userData?.blockedUsers.append(cell.usernameLabel.text!)
//            blockedArray.append(newElement: cell.blockedUserData!)
//            cell.deleteButton.setImage(nil, for: .normal)
//            cell.deleteButton.setTitle("Unblock", for: .normal)
            
            let sureAlert = UIAlertController(title: "Are you sure you want to block \(cell.usernameLabel.text!)?", message: "", preferredStyle: .alert)
            
            sureAlert.addAction(UIKit.UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in
                userData?.blockedUsers.append(cell.usernameLabel.text!)
                self.userDataVM?.updateUserData(newUserData: userData!, completion: {_ in })
                self.blockedArray.append(newElement: cell.blockedUserData!)
                cell.deleteButton.setImage(nil, for: .normal)
                cell.deleteButton.setTitle("Unblock", for: .normal)
            }))
            
            sureAlert.addAction(UIKit.UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(sureAlert, animated: true, completion: nil)
            
            
        }
        else {
            let sureAlert = UIAlertController(title: "Are you sure you want to unblock \(cell.usernameLabel.text!)?", message: "", preferredStyle: .alert)
            
            sureAlert.addAction(UIKit.UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in
                isBlocking = false
                cell.deleteButton.setImage(UIImage(named: "block"), for: .normal)
               // cell.deleteButton.setTitle("Unblock", for: .normal)
                userData?.blockedUsers.remove(at: index!)
                self.userDataVM?.updateUserData(newUserData: userData!, completion: {_ in })
                var count = 0
                for i in self.searchArray.readOnlyArray() {
                    if i.publicID == cell.usernameLabel.text! {
                        self.searchArray.removeAtIndex(index: count)
                        break
                    }
                    count += 1
                }
                count = 0
                for i in self.blockedArray.readOnlyArray() {
                    if i.publicID == cell.usernameLabel.text! {
                        self.blockedArray.removeAtIndex(index: count)
                        break
                    }
                    count += 1
                }
                self.tableView.reloadData()
            }))
            
            sureAlert.addAction(UIKit.UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(sureAlert, animated: true, completion: nil)
            
            
           // tableView.reloadData()
            
       
            
        }
        
        var blockedUser: UserData?
        var blockedRef: DocumentReference?
        db.collection("UserData1").whereField("publicID", isEqualTo: cell.usernameLabel.text!).getDocuments(completion: {obj, error in
            guard let docs = obj?.documents else {
                return
            }
            if docs.count > 0 {
                blockedUser = UserData(dictionary: docs[0].data())
                blockedRef = docs[0].reference
                let blockedIndex = blockedUser?.isBlockedBy.firstIndex(of: userData!.publicID)
                if blockedIndex == nil  && isBlocking{
                    blockedUser?.isBlockedBy.append(userData!.publicID)
                }
                else if (!isBlocking && blockedIndex != nil) {
                    blockedUser?.isBlockedBy.remove(at: blockedIndex!)
                }
                blockedRef?.setData(blockedUser!.dictionary)
            }
        })
        
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    var userDataVM: UserDataVM?
    let db = Firestore.firestore()
    var searchString = ""
    var searchArray = ThreadSafeArray<UserData>()
    var blockedArray = ThreadSafeArray<UserData>()
    let searchBar = UISearchBar()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchBar)
        searchBar.sizeToFit()
        searchBar.tintColor = UIColor.black
       // view.backgroundColor = .black
       // view.backgroundColor = UIColor(cgColor: CGColor(gray: 2/3, alpha: 1.0))
        searchBar.backgroundColor = UIColor.black
        searchBar.barStyle = .blackOpaque
        searchBar.delegate = self
        setUpNavBarView()
       // searchBar.frame = CGRect(x: 10, y: self.navBarView.frame.maxY, width: view.frame.width - 20, height: searchBar.frame.height)
        searchBar.frame.size.width = self.view.frame.size.width
        searchBar.frame = CGRect(x: 0, y: navBarView.frame.maxY, width: searchBar.frame.width, height: searchBar.frame.height)
        
        tableView.frame = CGRect(x: 0, y: searchBar.frame.maxY, width: view.frame.width, height: view.frame.height - searchBar.frame.maxY)
        
        tableView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.00)
        tableView.rowHeight = 45
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadBlockedUserData()
        tableView.reloadData()
    }
    
    func setUpNavBarView() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
//        print("This is status bar height \(statusBarHeight)")
        self.view.addSubview(navBarView)
        self.navBarView.addSubview(backButton)
       // self.navBarView.addSubview(postButton)
        self.navBarView.frame = CGRect(x: -5, y: -5, width: self.view.frame.width + 10, height: (self.view.frame.height/12)+5)
       
        let navBarHeightRemaining = navBarView.frame.maxY - statusBarHeight
        navBarView.backButton.isHidden = true
        navBarView.postButton.isHidden = true

        self.backButton.frame = CGRect(x: 10, y: statusBarHeight + (navBarHeightRemaining - 30)/2, width: 30, height: 30)
        

            let backTap = UITapGestureRecognizer(target: self, action: #selector(self.backButtonpressed))
            backTap.numberOfTapsRequired = 1
            backButton.isUserInteractionEnabled = true
            backButton.addGestureRecognizer(backTap)
            backButton.setImage(UIImage(named: "whiteChevron"), for: .normal)
        
        

        
        //navBarView.postButton.titleLabel?.sizeToFit()
        navBarView.postButton.titleLabel?.textAlignment = .right
  
        self.navBarView.addBehavior()
        self.navBarView.titleLabel.text = "Block Users"
     //   self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y: navBarView.frame.maxY - 30, width: 200, height: 30)
        self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y: self.backButton.frame.minY, width: 200, height: 25)
//        print("This is navBarView.")
      
      
    }
    
    @objc func backButtonpressed() {
        print("It should dismiss here")
        self.dismiss(animated: true)
     }
    

    
    func reloadBlockedUserData() {
        let userData = userDataVM?.userData.value
        if userData == nil {
            return
        }
        let chunks = userData!.blockedUsers.chunked(into: 5)
        let group = DispatchGroup()
        for chunk in chunks {
            group.enter()
            self.loadUpToTenUserDatas(usernames: chunk, completion: {
                //print("loadFollowings: loaded followers \(self.followingUserDataArray)")
                do{group.leave()}
            })
        }
        group.notify(queue: .main) {
            self.searchArray.removeAll()
            for item in self.blockedArray.readOnlyArray() {
                self.searchArray.append(newElement: item)
            }
            //print("loadFollowings: done loading followers \(self.followingUserDataArray)")
            self.tableView.reloadData()
        }
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
                    let readOnlyArray = self.blockedArray.readOnlyArray()
                    
                    // TODO: Very inefficient.  Use database operations to make sure data is clean.  Followers shouldnt be too many.  < 100 elements
                    
                    if (!readOnlyArray.contains(where: { data in
                        data.publicID == newUserData.publicID
                    })) {
                        self.blockedArray.append(newElement: newUserData)
                    }
                }
            } else {
                print("could not get userdata for followings")
                print(error!.localizedDescription)
            }
            completion()
            
        })
    }


}
