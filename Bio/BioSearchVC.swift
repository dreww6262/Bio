
//
//  BioSearchVC.swift
//  Bio
//
//  Created by Ann McDonough on 7/21/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
//import Parse
import Firebase
import FirebaseFirestore
import FirebaseAuth

class BioSearchVC: UITableViewController, UISearchBarDelegate {

    // declare search bar
    var searchBar = UISearchBar()

    // tableView arrays to hold information from server
//    var usernameArray = [String]()
     var loadUserDataArray: [UserData] = []
//    var avaArray: [UIImage] = []
    var guestname: [String] = []
    let db = Firestore.firestore()
   // var avaArray = [PFFileObject]()


    // collectionView UI
    //var collectionView : UICollectionView!

    // collectionView arrays to hold infromation from server
  //  var picArray = [PFFileObject]()
    var uuidArray = [String]()
    var page : Int = 15


    // default func
    override func viewDidLoad() {
        super.viewDidLoad()

        // implement search bar
        view.addSubview(searchBar)
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.tintColor = UIColor.secondarySystemGroupedBackground
        searchBar.frame.size.width = self.view.frame.size.width - 34
        let searchItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.leftBarButtonItem = searchItem
        self.tableView.reloadData()
        loadUsers()

        // call functions
  //      loadUsers()

        // call collectionView
        //collectionViewLaunch()
    }
//
//    func loadUsers(completed: @escaping () -> ()) {
//        let searchKey = "aew"
//        db.collection("UserData").whereField("publicID", in: searchKey.)
//          db.collection("UserData").addSnapshotListener { (querySnapshot, error) in
//              guard error == nil else {
//                  print("error: adding the snapshot listener \(error!.localizedDescription)")
//                  return completed()
//              }
//              self.usernameArray = []
//
//              //there are querySnapshot!.documents.count docments in the spots snapshot
//              for document in querySnapshot!.documents {
//                let newUserData = UserData(dictionary: document.data())
//                self.loadUserDataArray.append(newUserData)
//                self.usernameArray.append(newUserData.publicID)
//
//
////                  let spot = Spot(dictionary: document.data)
////                  spot.documentID = document.documentID
////                  self.spotArray.append(spot)
//              }
//              completed()
//          }
//         // completed()
//      }

    
    
    
    // SEARCHING CODE
    // load users function
    func loadUsers() {

//        let usersQuery = PFQuery(className: "_User")
//        usersQuery.addDescendingOrder("createdAt")
//        usersQuery.limit = 20
//        usersQuery.findObjectsInBackground (block: { (objects, error) -> Void in
//            if error == nil {
//
//                // clean up
//                self.usernameArray.removeAll(keepingCapacity: false)
//                self.avaArray.removeAll(keepingCapacity: false)
//
//                // found related objects
//                for object in objects! {
//                    self.usernameArray.append(object.value(forKey: "username") as! String)
//                    self.avaArray.append(object.value(forKey: "ava") as! PFFileObject)
//                }
//
//                // reload
//                self.tableView.reloadData()
//
//            } else {
//                print(error!.localizedDescription)
//            }
//        })

    }


    // search updated
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        // find by username
        var success = true
        let usernameQuery = db.collection("UserData")
        usernameQuery.addSnapshotListener({snapshots,error in
            if (error != nil) {
                print("god damnit")
                success = false
            }
            for doc in snapshots!.documents {
                //self.usernameArray.append(doc.value(forKey: "publicID") as! String)
                self.loadUserDataArray.append(UserData(dictionary: doc.data()))
                
            }
            
            
        })
        loadUsers()
        self.tableView.reloadData()
        
        
        
        
        //PFQuery(className: "_User")
//        usernameQuery.whereKey("username", matchesRegex: "(?i)" + searchBar.text!)
//        usernameQuery.findObjectsInBackground (block: { (objects, error) -> Void in
//            if error == nil {
//
//                // if no objects are found according to entered text in usernaem colomn, find by fullname
//                if objects!.isEmpty {
//
//                    let fullnameQuery = PFUser.query()
//                    fullnameQuery?.whereKey("fullname", matchesRegex: "(?i)" + self.searchBar.text!)
//                    fullnameQuery?.findObjectsInBackground(block: { (objects, error) -> Void in
//                        if error == nil {
//
//                            // clean up
//                            self.usernameArray.removeAll(keepingCapacity: false)
//                            self.avaArray.removeAll(keepingCapacity: false)
//
//                            // found related objects
//                            for object in objects! {
//                                self.usernameArray.append(object.object(forKey: "username") as! String)
//                                self.avaArray.append(object.object(forKey: "ava") as! PFFileObject)
//                            }
//
//                            // reload
//                            self.tableView.reloadData()
//
//                        }
//                    })
//                }

                // clean up
//                self.usernameArray.removeAll(keepingCapacity: false)
//                self.avaArray.removeAll(keepingCapacity: false)
//
//                // found related objects
//                for object in objects! {
//                    self.usernameArray.append(object.object(forKey: "username") as! String)
//                    self.avaArray.append(object.object(forKey: "ava") as! PFFileObject)
//                }
//
//                // reload
//                self.tableView.reloadData()
//
//            }
//        })

        return true
    }


    // tapped on the searchBar
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {

        // hide collectionView when started search
       // collectionView.isHidden = true

        // show cancel button
        searchBar.showsCancelButton = true
    }


    // clicked cancel button
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



    // TABLEVIEW CODE
    // cell numb
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("This is loadUserDataArray 1 \(loadUserDataArray)")
        return loadUserDataArray.count
    }

    // cell height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.width / 4
    }

    // cell config
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("This is loadUserdataarray 2 \(loadUserDataArray)")
        print("This is first public ID \(loadUserDataArray[0].publicID)")

        // define cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as! BioTableViewCell

        // hide follow button
        cell.followBtn.isHidden = true

        // connect cell's objects with received infromation from server
        cell.usernameLbl.text = loadUserDataArray[indexPath.row].publicID
//        avaArray[indexPath.row].getDataInBackground { (data, error) -> Void in
//            if error == nil {
//                cell.avaImg.image = UIImage(data: data!)
//            }
//        }
        
        let avaLink = URL(string: loadUserDataArray[indexPath.row].avaRef)
        cell.avaImg.load(url: avaLink!)

        return cell
    }


    // selected tableView cell - selected user
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // calling cell again to call cell data
        let cell = tableView.cellForRow(at: indexPath) as!  BioTableViewCell

        // if user tapped on his name go home, else go guest
//        if cell.usernameLbl.text! == PFUser.current()?.username {
        //let atIndex = FirebaseAuth.Auth.auth().currentUser?.email?.lastIndex(of: "@")
        let username = FirebaseAuth.Auth.auth().currentUser?.email?.split(separator: "@")[0]
        if cell.usernameLbl.text! ==  username! {
            let home = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as! DraggableHexagonGrid
            self.navigationController?.pushViewController(home, animated: true)
        } else {
            guestname.append(cell.usernameLbl.text!)
            let guest = self.storyboard?.instantiateViewController(withIdentifier: "guestVC") as! DraggableHexagonGrid
            self.navigationController?.pushViewController(guest, animated: true)
        }
    }



    // COLLECTION VIEW CODE
//    func collectionViewLaunch() {
//
//        // layout of collectionView
//        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//
//        // item size
//        layout.itemSize = CGSize(width: self.view.frame.size.width / 3, height: self.view.frame.size.width / 3)
//
//        // direction of scrolling
//        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
//
//        // define frame of collectionView
//        let frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - self.tabBarController!.tabBar.frame.size.height - self.navigationController!.navigationBar.frame.size.height - 20)
//
//        // declare collectionView
//        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.alwaysBounceVertical = true
//        collectionView.backgroundColor = .white
//        self.view.addSubview(collectionView)
//
//        // define cell for collectionView
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
//
//        // call function to load posts
//        loadPosts()
//    }
//
//
//    // cell line spasing
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//
//    // cell inter spasing
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//
//    // cell numb
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return picArray.count
//    }
//
//    // cell config
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        // define cell
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
//
//        // create picture imageView in cell to show loaded pictures
//        let picImg = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height))
//        cell.addSubview(picImg)
//
//        // get loaded images from array
//        picArray[indexPath.row].getDataInBackground { (data, error) -> Void in
//            if error == nil {
//                picImg.image = UIImage(data: data!)
//            } else {
//                print(error!.localizedDescription)
//            }
//        }
//
//        return cell
//    }
//
//    // cell's selected
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        // take relevant unique id of post to load post in postVC
//        postuuid.append(uuidArray[indexPath.row])
//
//        // present postVC programmaticaly
//        let post = self.storyboard?.instantiateViewController(withIdentifier: "postVC") as! postVC
//        self.navigationController?.pushViewController(post, animated: true)
//    }
//
//    // load posts
//    func loadPosts() {
//        let query = PFQuery(className: "posts")
//        query.limit = page
//        query.findObjectsInBackground { (objects, error) -> Void in
//            if error == nil {
//
//                // clean up
//                self.picArray.removeAll(keepingCapacity: false)
//                self.uuidArray.removeAll(keepingCapacity: false)
//
//                // found related objects
//                for object in objects! {
//                    self.picArray.append(object.object(forKey: "pic") as! PFFile)
//                    self.uuidArray.append(object.object(forKey: "uuid") as! String)
//                }
//
//                // reload collectionView to present images
//                self.collectionView.reloadData()
//
//            } else {
//                print(error!.localizedDescription)
//            }
//        }
//    }
//
//    // scrolled down
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        // scroll down for paging
//        if scrollView.contentOffset.y >= scrollView.contentSize.height / 6 {
//            self.loadMore()
//        }
//    }
//
//    // pagination
//    func loadMore() {
//
//        // if more posts are unloaded, we wanna load them
//        if page <= picArray.count {
//
//            // increase page size
//            page = page + 15
//
//            // load additional posts
//            let query = PFQuery(className: "posts")
//            query.limit = page
//            query.findObjectsInBackground(block: { (objects, error) -> Void in
//                if error == nil {
//
//                    // clean up
//                    self.picArray.removeAll(keepingCapacity: false)
//                    self.uuidArray.removeAll(keepingCapacity: false)
//
//                    // find related objects
//                    for object in objects! {
//                        self.picArray.append(object.object(forKey: "pic") as! PFFile)
//                        self.uuidArray.append(object.object(forKey: "uuid") as! String)
//                    }
//
//                    // reload collectionView to present loaded images
//                    self.collectionView.reloadData()
//
//                } else {
//                    print(error!.localizedDescription)
//                }
//            })
//
//        }
//
//    }


    
}
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
