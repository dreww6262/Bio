//
//  BlockedUsersVC.swift
//  Bio
//
//  Created by Andrew Williamson on 10/16/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import Firebase

class BlockedUsersVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "blockedCell", for: indexPath) as! BlockedCell
        
        let cleanRef = searchArray[indexPath.row].avaRef.replacingOccurrences(of: "/", with: "%2F")
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/bio-social-media.appspot.com/o/\(cleanRef)?alt=media")
        if (url == nil) {
            cell.avaImage.image = UIImage(named: "boyprofile")
        }
        else {
            cell.avaImage.sd_setImage(with: url!, completed: {_, error, _, _ in
                if error != nil {
                    cell.avaImage.image = UIImage(named: "boyprofile")
                }
            })
        }
        cell.blockedUserData = searchArray[indexPath.row]
        cell.indexPath = indexPath
        
        cell.avaImage.frame = CGRect(x: 10, y: (cell.contentView.frame.height - 15) / 2, width: 30, height: 30)
        cell.avaImage.setupHexagonMask(lineWidth: 1, color: .white, cornerRadius: 2)
        
        
        cell.usernameLabel.font = UIFont(name: "poppins-SemiBold", size: 14)
        cell.usernameLabel.text = searchArray[indexPath.row].publicID
        cell.usernameLabel.sizeToFit()
        cell.usernameLabel.frame = CGRect(x: cell.avaImage.frame.maxX + 16, y: cell.avaImage.frame.minY + cell.usernameLabel.frame.height/2, width: cell.usernameLabel.frame.width, height: cell.usernameLabel.frame.height)
        
        
        cell.deleteButton.setImage(UIImage(named: "cancel2"), for: .normal)
        cell.deleteButton.frame = CGRect(x: cell.contentView.frame.width - 40, y: (cell.contentView.frame.height - 30)/2 , width: 30, height: 30)
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
        usernameQuery.addSnapshotListener({snapshots,error in
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
        let cell = sender.view?.superview?.superview as! BlockedCell
        let index = userData!.blockedUsers.firstIndex(of: cell.usernameLabel.text!)
        if (index == nil) {
            userData?.blockedUsers.append(cell.usernameLabel.text!)
            blockedArray.append(newElement: cell.blockedUserData!)
        }
        else {
            userData?.blockedUsers.remove(at: index!)
            var count = 0
            for i in searchArray.readOnlyArray() {
                if i.publicID == cell.usernameLabel.text! {
                    searchArray.removeAtIndex(index: count)
                    break
                }
                count += 1
            }
            count = 0
            for i in blockedArray.readOnlyArray() {
                if i.publicID == cell.usernameLabel.text! {
                    blockedArray.removeAtIndex(index: count)
                    break
                }
                count += 1
            }
            tableView.reloadData()
            
        }
        db.collection("UserData1").document(userData!.privateID).setData(userData!.dictionary)
        
        
        
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    var userData: UserData?
    let db = Firestore.firestore()
    var searchString = ""
    var searchArray = ThreadSafeArray<UserData>()
    var blockedArray = ThreadSafeArray<UserData>()
    let searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchBar)
        searchBar.sizeToFit()
        searchBar.tintColor = UIColor.black
        searchBar.backgroundColor = UIColor.black
        searchBar.barStyle = .blackOpaque
        searchBar.delegate = self
        searchBar.frame = CGRect(x: 10, y: view.frame.height/4 - searchBar.frame.height, width: view.frame.width - 20, height: searchBar.frame.height)
        
        tableView.frame = CGRect(x: 10, y: view.frame.height/4, width: view.frame.width - 20, height: view.frame.height * 0.75)
        
        tableView.backgroundColor = .systemGray6
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
    
    func reloadBlockedUserData() {
        let chunks = self.userData!.blockedUsers.chunked(into: 5)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
