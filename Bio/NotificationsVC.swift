
//
//  NotificationsVC.swift
//  Bio
//
//  Created by Ann McDonough on 9/7/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//


import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
//import FirebaseFirestore

class NotificationsVC: UIViewController {
    let menuView = MenuView()
    let storage = Storage.storage().reference()
    var db = Firestore.firestore()
    var userData: UserData?
    @IBOutlet weak var tableView: UITableView!
    
    var navBarView = NavBarView()
    var titleLabel1 = UILabel()
    
    // arrays to hold data from server
    var usernameArray = [String]()
    var avaArray = [String]()
    var typeArray = [String]()
    var dateArray = [Date?]()
    var uuidArray = [String]()
    var ownerArray = [String]()
    
    var notificationArray: [NewsObject] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        menuView.tabController = (tabBarController! as! NavigationMenuBaseController)
        //        var navBarHeight = CGFloat(50)
        //        var navBarBounds = self.navBar.bounds
        //        navBar.frame = CGRect(x: 0, y: 0, width: navBarBounds.width, height: navBarBounds.height + navBarHeight)
        //tableView.frame = CGRect(x: 0, y: navBarHeight + 20, width: self.view.frame.width, height: self.view.frame.height - navBarHeight)
        
        loadData {
//            print("Should be loading notifications!!")
        }
        self.tableView.reloadData()
    }
    
    
    
    // defualt func
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        addMenuButtons()
        setUpNavBarView()
//        print("This is current user email \(Auth.auth().currentUser?.email)")
        super.viewDidLoad()
        //        var navBarHeight = CGFloat(66.0)
        //        navBar.backgroundColor = .black
        //        navBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: navBarHeight)
        
        
        
        // dynamic tableView height - dynamic cell
        //        tableView.rowHeight = UITableView.automaticDimension
        //        tableView.estimatedRowHeight = 60
        
        // title at the top
        self.navigationItem.title = "NOTIFICATIONS"
        
        // request notifications
        
    }
    
    
    
    
    
    
    func loadData(completed: @escaping () -> ()) {
//        print("in load notifications funtion")
        //let notificationsQuery = db.collection("News").whereField("currentUser", isEqualTo: userData?.publicID)
        let notificationsQuery = db.collection("News2").whereField("currentUser", isEqualTo: userData!.publicID)
//        print("This is notification query \(notificationsQuery)")
        notificationsQuery.addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("error loading home photos: \n \(error!.localizedDescription)")
                return completed()
            }
            self.notificationArray = []
            //there are querySnapshot!.documents.count docments in the spots snapshot
            
            for document in querySnapshot!.documents {
//                print("doc: \(document)")
                var newNotification = NewsObject(dictionary: document.data())
                self.notificationArray.append(newNotification)
//                print("Loaded: \(newNotification)")
                //                var success = true
                //                 self.addNotificationObject(notificationObject: newNotification, completion: {    bool in
                //                                           success = success && bool
                //                                           if (bool) {
                //                                               print("notification successfully added!")
                //                                           }
                //                                           else {
                //                                               print("notificatoin failed to add :(")
                //                                           }
                //                                       })
            }
            
            self.tableView.reloadData()
            
            
            
            completed()
            return
        }
        //completed()
    }
    
    
    
    
    
    //    extension NotificationsVC: UITableViewDelegate, UITableViewDataSource {
    //    // cell numb
    //    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        print("This is notificationArray count \(notificationArray.count)")
    //        return notificationArray.count
    //    }
    //
    //
    //    // cell config
    // func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        // declare cell
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell") as! newsCell
    //        // connect cell objects with received data from server
    //        cell.usernameBtn.setTitle(notificationArray[indexPath.row].notifyingUser, for: UIControl.State())
    //
    //        let ref = storage.child(notificationArray[indexPath.row].thumbResource)
    //        cell.avaImg.sd_setImage(with: ref)
    //        cell.avaImg.frame = CGRect(x: 5, y: 2, width: cell.frame.height-15, height: cell.frame.height-15)
    //        cell.avaImg.setupHexagonMask(lineWidth: cell.avaImg.frame.width/15, color: gold, cornerRadius: cell.avaImg.frame.width/15)
    //        cell.infoLbl.frame = CGRect(x: cell.avaImg.frame.maxX + 5, y: 5, width: 140, height: 30)
    //         cell.dateLbl.frame = CGRect(x: cell.infoLbl.frame.maxX + 5, y: 5, width: 50
    //            , height: 30)
    //
    //
    ////        avaArray[indexPath.row].getDataInBackground { (data, error) -> Void in
    ////            if error == nil {
    ////                cell.avaImg.image = UIImage(data: data!)
    ////            } else {
    ////                print(error!.localizedDescription)
    ////            }
    ////        }
    //
    //        // calculate post date
    //        let fromString = notificationArray[indexPath.row].createdAt
    //        let from = DateFormatter.init().date(from: fromString)
    //        let now = Date()
    //        let components : NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfMonth]
    //        let difference = (Calendar.current as NSCalendar).components(components, from: from ?? Date(), to: now, options: [])
    //
    //        // logic what to show: seconds, minuts, hours, days or weeks
    //        if difference.second! <= 0 {
    //            cell.dateLbl.text = "now"
    //        }
    //        if difference.second! > 0 && difference.minute! == 0 {
    //            cell.dateLbl.text = "\(String(describing: difference.second))s."
    //        }
    //        if difference.minute! > 0 && difference.hour! == 0 {
    //            cell.dateLbl.text = "\(String(describing: difference.minute))m."
    //        }
    //        if difference.hour! > 0 && difference.day! == 0 {
    //            cell.dateLbl.text = "\(String(describing: difference.hour))h."
    //        }
    //        if difference.day! > 0 && difference.weekOfMonth! == 0 {
    //            cell.dateLbl.text = "\(String(describing: difference.day))d."
    //        }
    //        if difference.weekOfMonth! > 0 {
    //            cell.dateLbl.text = "\(String(describing: difference.weekOfMonth))w."
    //        }
    //
    //        // define info text
    //        if notificationArray[indexPath.row].type == "mention" {
    //            cell.infoLbl.text = "has mentioned you."
    //        }
    //        if notificationArray[indexPath.row].type == "comment" {
    //            cell.infoLbl.text = "has commented your post."
    //        }
    //        if notificationArray[indexPath.row].type == "follow" {
    //            cell.infoLbl.text = "is now following you."
    //            print("its a follow")
    //        }
    //        if notificationArray[indexPath.row].type == "like" {
    //            cell.infoLbl.text = "likes your post."
    //        }
    //
    //
    //        // asign index of button
    //        cell.usernameBtn.layer.setValue(indexPath, forKey: "index")
    //
    //        return cell
    //    }
    //
    //    }
    
    func addMenuButtons() {
        view.addSubview(menuView)
        menuView.currentTab = 0
        menuView.addBehavior()
    }
    
    func setUpNavBarView() {
        self.view.addSubview(navBarView)
        self.navBarView.addSubview(titleLabel1)
        self.navBarView.addBehavior()
        
        
        
        self.titleLabel1.text = "Notifications"
        self.navBarView.frame = CGRect(x: -5, y: -5, width: self.view.frame.width + 10, height: (self.view.frame.height/12)+5)
        let yOffset = navBarView.frame.maxY
        self.tableView.frame = CGRect(x: 0, y: yOffset, width: self.view.frame.width, height: self.view.frame.height - yOffset)
//        print("notifications, navBarHeight: \(navBarView.frame)")
//        print("notifications, tableViewHeight: \(tableView.frame)")
        self.titleLabel1.frame = CGRect(x: 0, y: 5, width: self.view.frame.width, height: self.view.frame.height/12)
        self.titleLabel1.textAlignment = .center
        
        self.titleLabel1.font = UIFont(name: "DINAlternate-Bold", size: 20)
        self.titleLabel1.textColor = .white
        self.navBarView.backgroundColor = UIColor(cgColor: CGColor(gray: 0.05, alpha: 1.0))
        self.navBarView.layer.borderWidth = 0.25
        self.navBarView.layer.borderColor = CGColor(gray: 2/3, alpha: 1.0)
    }
    
    
    
    @objc func cellTapped(_ sender : UITapGestureRecognizer) {
//        print("I am within cellTapped")
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
                    guestVC.username = self.userData!.publicID
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
    
    
    // clicked username button
    @IBAction func usernameBtn_click(_ sender: AnyObject) {
//        print("UserName Clicked")
        // call index of button
        let i = sender.layer.value(forKey: "index") as! IndexPath
//        print("This is i: \(i)")
        
        // call cell to call further cell data
        let cell = tableView.cellForRow(at: i) as! newsCell
        let username = cell.usernameBtn.titleLabel?.text!
//        print("This is cell.usernabeButton.title \(username)")
        
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
                    guestVC.username = self.userData!.publicID
                    self.present(guestVC, animated: false)
                    self.modalPresentationStyle = .fullScreen
                }
            }
            else {
                print("pulling up guest vc userdata failed")
            }
        })
    }
    
    //        override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //            return self.view.frame.size.height/10
    //        }
    //
    //
    //    // clicked cell
    //    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //
    //        // call cell for calling cell data
    //        let cell = tableView.cellForRow(at: indexPath) as! newsCell
    //
    //
    //        // going to @menionted comments
    //        if cell.infoLbl.text == "has mentioned you." {
    //
    //        }
    //
    //
    //        // going to own comments
    //        if cell.infoLbl.text == "has commented your post." {
    //
    //        }
    //
    //
    //        // going to user followed current user
    //        if cell.infoLbl.text == "now following you." {
    //            // take guestname
    //        //    guestname.append(cell.usernameBtn.titleLabel!.text!)
    //
    //            // go guest
    //            let guest = self.storyboard?.instantiateViewController(withIdentifier: "guestVC") as! GuestHexagonGridVC
    //            self.navigationController?.pushViewController(guest, animated: true)
    //        }
    //
    //
    //        // going to liked post
    //        if cell.infoLbl.text == "likes your post." {
    //
    //            // take post uuid
    ////            postuuid.append(uuidArray[indexPath.row])
    ////
    ////            // go post
    ////            let post = self.storyboard?.instantiateViewController(withIdentifier: "postVC") as! postVC
    ////            self.navigationController?.pushViewController(post, animated: true)
    //        }
    //
    //    }
    
}

extension NotificationsVC: UITableViewDelegate, UITableViewDataSource {
    // cell numb
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("This is notificationArray count \(notificationArray.count)")
        return notificationArray.count
    }
    
    
    // cell config
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // declare cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell") as! newsCell
        cell.frame = CGRect(x: cell.frame.minX, y: cell.frame.minY, width: view.frame.width, height: 43.5)
        // connect cell objects with received data from server
        cell.usernameBtn.setTitle(notificationArray[indexPath.row].notifyingUser, for: UIControl.State())
        //print("cell frame: \(cell.frame)")
        let ref = storage.child(notificationArray[indexPath.row].thumbResource)
        cell.avaImg.sd_setImage(with: ref)
        cell.avaImg.frame = CGRect(x: 5, y: 2, width: cell.frame.height-15, height: cell.frame.height-15)
        cell.avaImg.clipsToBounds = true
        cell.avaImg.setupHexagonMask(lineWidth: cell.avaImg.frame.width/15, color: gold, cornerRadius: cell.avaImg.frame.width/15)
        cell.infoLbl.frame = CGRect(x: cell.avaImg.frame.maxX + 5, y: 5, width: 140, height: 30)
        cell.dateLbl.frame = CGRect(x: cell.infoLbl.frame.maxX + 5, y: 5, width: 50
                                    , height: 30)
        
        
        //        avaArray[indexPath.row].getDataInBackground { (data, error) -> Void in
        //            if error == nil {
        //                cell.avaImg.image = UIImage(data: data!)
        //            } else {
        //                print(error!.localizedDescription)
        //            }
        //        }
        
        // calculate post date
        let fromString = notificationArray[indexPath.row].createdAt
        let from = DateFormatter.init().date(from: fromString)
        print("from: \(from)")
        let now = Date()
        print("now: \(now)")
        let components : NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfMonth]
        let difference = (Calendar.current as NSCalendar).components(components, from: from ?? Date(), to: now, options: [])
        
        // logic what to show: seconds, minuts, hours, days or weeks
        if difference.second! <= 0 {
            cell.dateLbl.text = "now"
        }
        if difference.second! > 0 && difference.minute! == 0 {
            cell.dateLbl.text = "\(String(describing: difference.second))s."
        }
        if difference.minute! > 0 && difference.hour! == 0 {
            cell.dateLbl.text = "\(String(describing: difference.minute))m."
        }
        if difference.hour! > 0 && difference.day! == 0 {
            cell.dateLbl.text = "\(String(describing: difference.hour))h."
        }
        if difference.day! > 0 && difference.weekOfMonth! == 0 {
            cell.dateLbl.text = "\(String(describing: difference.day))d."
        }
        if difference.weekOfMonth! > 0 {
            cell.dateLbl.text = "\(String(describing: difference.weekOfMonth))w."
        }
        
        // define info text
        if notificationArray[indexPath.row].type == "mention" {
            cell.infoLbl.text = "has mentioned you."
        }
        if notificationArray[indexPath.row].type == "comment" {
            cell.infoLbl.text = "has commented your post."
        }
        if notificationArray[indexPath.row].type == "follow" {
            cell.infoLbl.text = "is now following you."
            //print("its a follow")
        }
        if notificationArray[indexPath.row].type == "like" {
            cell.infoLbl.text = "likes your post."
        }
        
        
        // asign index of button
        cell.usernameBtn.layer.setValue(indexPath, forKey: "index")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.height/14
    }
    
    
    // clicked cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // call cell for calling cell data
        let cell = tableView.cellForRow(at: indexPath) as! newsCell
        
        
        // going to @menionted comments
        if cell.infoLbl.text == "has mentioned you." {
            
        }
        
        
        // going to own comments
        if cell.infoLbl.text == "has commented your post." {
            
        }
        
        
        // going to user followed current user
        if cell.infoLbl.text == "now following you." {
            // take guestname
            //    guestname.append(cell.usernameBtn.titleLabel!.text!)
            
            // go guest
            let guest = self.storyboard?.instantiateViewController(withIdentifier: "guestVC") as! GuestHexagonGridVC
            // SET USERDATA
            guest.username = userData!.publicID
            self.navigationController?.pushViewController(guest, animated: true)
        }
        
        
        // going to liked post
        if cell.infoLbl.text == "likes your post." {
            
            // take post uuid
            //            postuuid.append(uuidArray[indexPath.row])
            //
            //            // go post
            //            let post = self.storyboard?.instantiateViewController(withIdentifier: "postVC") as! postVC
            //            self.navigationController?.pushViewController(post, animated: true)
        }
        
    }
    
    
    
    
    
}
