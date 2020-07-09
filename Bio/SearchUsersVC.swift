//
//  SearchUsersVC.swift
//  
//
//  Cr

import UIKit
import Parse

class SearchUsersVC: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // declare search bar
   // var searchBar = UISearchBar(frame: CGRect(x: 0.0, y: 0.0, width: 500.0, height: 50.0))
    // tableView arrays to hold information from server
    var usernameArray = [String]()
    var avaArray = [PFFileObject]()
    var fullNameArray = [String]()
    var navigationVC: UINavigationController!
    
    // collectionView UI
    var collectionView : UICollectionView!
    
    // collectionView arrays to hold infromation from server
    var picArray = [PFFileObject]()
    var uuidArray = [String]()
    var page : Int = 15
    

    // default func
    override func viewDidLoad() {
        super.viewDidLoad()
        print("This is printing")
        // implement search bar
        searchBar.delegate = self
        searchBar.sizeToFit()
        //searchBar.tintColor = UIColor.secondarySystemGroupedBackground
        searchBar.tintColor = UIColor.red
       // searchBar.addConstraints()
      //  let topConstraint = NSLayoutConstraint(item: self.searchBar, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
        //   SearchUsersVC.searchBar.setTranslatesAutoresizingMaskIntoConstraints(false)
     //   print("!!!!!!!!!!!!!WHERE IS THE ERROR????????????/")
     //   searchBar.addConstraints([topConstraint])
        
        
        searchBar.frame.size.width = self.view.frame.size.width - 34
        let searchItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.leftBarButtonItem = searchItem
        //print("this is search bar frame")
       // print(searchBar.frame)
        
        // call functions
        loadUsers()
        
        // call collectionView
       // collectionViewLaunch()
    }
    
    
    
    // SEARCHING CODE
    // load users function
    func loadUsers() {
        
        let usersQuery = PFQuery(className: "_User")
    //    usersQuery.addDescendingOrder("createdAt")
      print("user query limit is 20 🚴🏻‍♀️🚴🏻‍♀️🚴🏻‍♀️🚴🏻‍♀️🚴🏻‍♀️")
        usersQuery.limit = 20
        usersQuery.findObjectsInBackground (block: { (objects, error) -> Void in
            if error == nil {
                
                // clean up
                self.usernameArray.removeAll(keepingCapacity: false)
                self.avaArray.removeAll(keepingCapacity: false)
                 self.fullNameArray.removeAll(keepingCapacity: false)
                
                // found related objects
                for object in objects! {
                    self.usernameArray.append(object.value(forKey: "username") as! String)
                    self.avaArray.append(object.value(forKey: "ava") as! PFFileObject)
                    self.fullNameArray.append(object.value(forKey: "fullname") as! String)
                }
                
                // reload
                self.tableView.reloadData()
                
            } else {
                print(error!.localizedDescription)
            }
        })
        
    }
    
    
    // search updated
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // find by username
        let usernameQuery = PFQuery(className: "_User")
        usernameQuery.whereKey("username", matchesRegex: "(?i)" + searchBar.text!)
        usernameQuery.findObjectsInBackground (block: { (objects, error) -> Void in
            if error == nil {
                
                // if no objects are found according to entered text in usernaem colomn, find by fullname
                if objects!.isEmpty {

                    let fullnameQuery = PFUser.query()
                    fullnameQuery?.whereKey("fullname", matchesRegex: "(?i)" + self.searchBar.text!)
                    fullnameQuery?.whereKey("fullname", matchesRegex: "(?i)" + self.searchBar.text!)
                    fullnameQuery?.findObjectsInBackground(block: { (objects, error) -> Void in
                        if error == nil {
                            
                            // clean up
                            self.usernameArray.removeAll(keepingCapacity: false)
                            self.avaArray.removeAll(keepingCapacity: false)
                            self.fullNameArray.removeAll(keepingCapacity: false)
                            // found related objects
                            for object in objects! {
                                self.usernameArray.append(object.object(forKey: "username") as! String)
                                self.avaArray.append(object.object(forKey: "ava") as! PFFileObject)
                                   self.fullNameArray.append(object.object(forKey: "fullname") as! String)
                            }
                            
                            // reload
                            self.tableView.reloadData()
                            
                        }
                    })
                }
                
                // clean up
                self.usernameArray.removeAll(keepingCapacity: false)
                self.avaArray.removeAll(keepingCapacity: false)
                
                // found related objects
                for object in objects! {
                    self.usernameArray.append(object.object(forKey: "username") as! String)
                    self.avaArray.append(object.object(forKey: "ava") as! PFFileObject)
                      self.fullNameArray.append(object.object(forKey: "fullname") as! String)
                }
                
                // reload
                self.tableView.reloadData()
                
            }
        })
        
        return true
    }
    
    
    // tapped on the searchBar
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        // hide collectionView when started search
        //collectionView.isHidden = true
        
        // show cancel button
        searchBar.showsCancelButton = true
    }
    
    
    // clicked cancel button
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        // unhide collectionView when tapped cancel button
     //   collectionView.isHidden = false
        
        // dismiss keyboard
        searchBar.resignFirstResponder()
        
        // hide cancel button
        searchBar.showsCancelButton = false
        
        // reset text
        searchBar.text = ""
        
        // reset shown users
        loadUsers()
    }
    
    
    
    // TABLEVIEW CODE
    // cell numb
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernameArray.count
    }
    
    // cell height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.width / 4
    }

    // cell config
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("usernameArray: \(usernameArray)")
        //print()
        
        
        // define cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SubscribersCell
        
        // hide follow button
        //cell.followBtn.isHidden = true
        
        // connect cell's objects with received infromation from server
        cell.usernameLbl.text = usernameArray[indexPath.row]
        cell.fullnameLbl.text = fullNameArray[indexPath.row]
        avaArray[indexPath.row].getDataInBackground { (data, error) -> Void in
            if error == nil {
                cell.avaImg.image = UIImage(data: data!)
            }
        }
        
        // Determine Title of Follow Button
        print("Title = \(title)")
                  let query = PFQuery(className: "Follow")
                 //  print("At first you were subscribed, but now you should NOT be")
                  query.whereKey("follower", equalTo: PFUser.current()!.username!)
        query.whereKey("following", equalTo: usernameArray[indexPath.row])
        query.findObjectsInBackground(block: { (objects, error) -> Void in
                      if error == nil {
                          
                          for object in objects! {
                              object.deleteInBackground(block: { (success, error) -> Void in
                                  if success {
                                      cell.followBtn.setTitle("SUBSCRIBED", for: UIControl.State())
                                   // cell.followBtn.text = "SUBSCRIBED"
                                     // print("The follow button should be changed to SUBSCRIBE")
                                      cell.followBtn.backgroundColor = .red
                                  } else {
                                      print(error?.localizedDescription as Any)
                                  }
                              })
                          }
                        if objects!.isEmpty {
                                            cell.followBtn.setTitle("SUBSCRIBE", for: UIControl.State())
                        
                                                                               // print("The follow button should be changed to SUBSCRIBE")
                                            cell.followBtn.backgroundColor = .blue
                                             // print(error?.localizedDescription as Any)
                                          }
                          
                      }
                  })
        
        
        
        
        
        
        

        return cell
    }

    
    // selected tableView cell - selected user
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // calling cell again to call cell data
        let cell = tableView.cellForRow(at: indexPath) as! SubscribersCell
        
        // if user tapped on his name go home, else go guest
        if cell.usernameLbl.text! == PFUser.current()?.username {
        //    let home = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
             let home = self.storyboard?.instantiateViewController(withIdentifier: "hexgrid3") as! HexagonGrid3
           // self.navigationController?.pushViewController(home, animated: true)
          self.present(HexagonGrid3(), animated:true, completion:nil)
        } else {
            guestname.append(cell.usernameLbl.text!)
            //let guest = self.storyboard?.instantiateViewController(withIdentifier: "guestVC") as! guestVC
            print("🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣🟣")
          //    let guest = self.storyboard?.instantiateViewController(withIdentifier: "HexagonGrid3") as! HexagonGrid3
          // self.navigationController?.pushViewController(guest, animated: true)
          // self.present(HexagonGrid3(), animated:true, completion:nil)
          //  self.show()
            
            let guestView = self.storyboard?.instantiateViewController(withIdentifier: "hexgrid3") as! HexagonGrid3
            self.navigationVC?.pushViewController(guestView, animated: true)
            //self.navVC?.pushViewController(guestView, animated: true )
            
            
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
//      //  let frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - self.tabBarController!.tabBar.frame.size.height - self.navigationController!.navigationBar.frame.size.height - 20)
//
////        // declare collectionView
////        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
////        collectionView.delegate = self
////        collectionView.dataSource = self
////        collectionView.alwaysBounceVertical = true
////        collectionView.backgroundColor = .white
////        self.view.addSubview(collectionView)
//
//        // define cell for collectionView
//     //   collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
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
//                    self.picArray.append(object.object(forKey: "pic") as! PFFileObject)
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
//
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
//                        self.picArray.append(object.object(forKey: "pic") as! PFFileObject)
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
