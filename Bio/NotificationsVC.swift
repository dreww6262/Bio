
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
//import FirebaseFirestore

class NotificationsVC: UITableViewController {
     let storage = Storage.storage().reference()
    var db = Firestore.firestore()
     var userData: UserData?
    
    // arrays to hold data from server
    var usernameArray = [String]()
    var avaArray = [String]()
    var typeArray = [String]()
    var dateArray = [Date?]()
    var uuidArray = [String]()
    var ownerArray = [String]()
    
    var notificationArray: [NewsObject] = []
    
    
    // defualt func
    override func viewDidLoad() {
        print("This is current user email \(Auth.auth().currentUser?.email)")
        super.viewDidLoad()
        
        // dynamic tableView height - dynamic cell
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        
        // title at the top
        self.navigationItem.title = "NOTIFICATIONS"
        
      // request notifications
        loadData {
            print("Should be loading notifications!!")
        }
        self.tableView.reloadData()
        
    }

    

       
    
    
    func loadData(completed: @escaping () -> ()) {
        print("in load notifications funtion")
        //let notificationsQuery = db.collection("News").whereField("currentUser", isEqualTo: userData?.publicID)
        let notificationsQuery = db.collection("News")
        print("This is notification query \(notificationsQuery)")
        notificationsQuery.addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("error loading home photos: \n \(error!.localizedDescription)")
                return completed()
            }
            self.notificationArray = []
            //there are querySnapshot!.documents.count docments in the spots snapshot
            
            for document in querySnapshot!.documents {
                print("doc: \(document)")
                var newNotification = NewsObject(dictionary: document.data())
                self.notificationArray.append(newNotification)
                print("Loaded: \(newNotification)")
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
    

    
    
    
    
    
    // cell numb
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("This is notificationArray count \(notificationArray.count)")
        return notificationArray.count
    }
    
    
    // cell config
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // declare cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell") as! newsCell
        // connect cell objects with received data from server
        cell.usernameBtn.setTitle(notificationArray[indexPath.row].notifyingUser, for: UIControl.State())
        
        let ref = storage.child(notificationArray[indexPath.row].thumbResource)
        cell.avaImg.sd_setImage(with: ref)
        
//        avaArray[indexPath.row].getDataInBackground { (data, error) -> Void in
//            if error == nil {
//                cell.avaImg.image = UIImage(data: data!)
//            } else {
//                print(error!.localizedDescription)
//            }
//        }
        
        // calculate post date
        let from = notificationArray[indexPath.row].createdAt
        let now = Date()
        let components : NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfMonth]
        let difference = (Calendar.current as NSCalendar).components(components, from: from, to: now, options: [])
        
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
            cell.infoLbl.text = "now following you."
            print("its a follow")
        }
        if notificationArray[indexPath.row].type == "like" {
            cell.infoLbl.text = "likes your post."
        }
        
        
        // asign index of button
        cell.usernameBtn.layer.setValue(indexPath, forKey: "index")

        return cell
    }

    
    // clicked username button
    @IBAction func usernameBtn_click(_ sender: AnyObject) {
        
        // call index of button
        let i = sender.layer.value(forKey: "index") as! IndexPath
        
        // call cell to call further cell data
        let cell = tableView.cellForRow(at: i) as! newsCell
        
        // if user tapped on himself go home, else go guest
        if cell.usernameBtn.titleLabel?.text == Auth.auth().currentUser?.displayName {
            let home = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as! HomeHexagonGrid
            self.navigationController?.pushViewController(home, animated: true)
        } else {
        //    guestname.append(cell.usernameBtn.titleLabel!.text!)
            let guest = self.storyboard?.instantiateViewController(withIdentifier: "guestVC") as! GuestHexagonGridVC
            self.navigationController?.pushViewController(guest, animated: true)
        }
    }
    
    
    // clicked cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // call cell for calling cell data
        let cell = tableView.cellForRow(at: indexPath) as! newsCell
        
        
        // going to @menionted comments
        if cell.infoLbl.text == "has mentioned you." {
            
            // send related data to gloval variable
//            commentuuid.append(uuidArray[indexPath.row])
//            commentowner.append(ownerArray[indexPath.row])
//
//            // go comments
//            let comment = self.storyboard?.instantiateViewController(withIdentifier: "commentVC") as! commentVC
//            self.navigationController?.pushViewController(comment, animated: true)
        }
        
        
        // going to own comments
        if cell.infoLbl.text == "has commented your post." {
            
            // send related data to gloval variable
//            commentuuid.append(uuidArray[indexPath.row])
//            commentowner.append(ownerArray[indexPath.row])
//
//            // go comments
//            let comment = self.storyboard?.instantiateViewController(withIdentifier: "commentVC") as! commentVC
//            self.navigationController?.pushViewController(comment, animated: true)
        }
        
        
        // going to user followed current user
        if cell.infoLbl.text == "now following you." {
            
            // take guestname
        //    guestname.append(cell.usernameBtn.titleLabel!.text!)
            
            // go guest
            let guest = self.storyboard?.instantiateViewController(withIdentifier: "guestVC") as! GuestHexagonGridVC
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

