
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


class NotificationsVC: UITableViewController {
    
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
        
        
//old Parse Stuff
//        let query = PFQuery(className: "news")
//        query.whereKey("to", equalTo: PFUser.current()!.username!)
//        query.limit = 30
//        query.findObjectsInBackground (block: { (objects, error) -> Void in
//            if error == nil {
//
//                // clean up
//                self.usernameArray.removeAll(keepingCapacity: false)
//                self.avaArray.removeAll(keepingCapacity: false)
//                self.typeArray.removeAll(keepingCapacity: false)
//                self.dateArray.removeAll(keepingCapacity: false)
//                self.uuidArray.removeAll(keepingCapacity: false)
//                self.ownerArray.removeAll(keepingCapacity: false)
//
//                // found related objects
//                for object in objects! {
//                    self.usernameArray.append(object.object(forKey: "by") as! String)
//                    self.avaArray.append(object.object(forKey: "ava") as! PFFile)
//                    self.typeArray.append(object.object(forKey: "type") as! String)
//                    self.dateArray.append(object.createdAt)
//                    self.uuidArray.append(object.object(forKey: "uuid") as! String)
//                    self.ownerArray.append(object.object(forKey: "owner") as! String)
//
//                    // save notifications as checked
//                    object["checked"] = "yes"
//                    object.saveEventually()
//                }
//
//                // reload tableView to show received data
//                self.tableView.reloadData()
//            }
//        })
        
    }
    
    
    
    
    func loadData(completed: @escaping () -> ()) {
        print("in load notifications funtion")
        let hexQuery = db.collection("News").whereField("currentUser", isEqualTo: userData?.publicID)
        hexQuery.addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("error loading home photos: \n \(error!.localizedDescription)")
                return completed()
            }
            self.notificationArray = []
            //there are querySnapshot!.documents.count docments in the spots snapshot
            
            for document in querySnapshot!.documents {
                print(document)
                let newNotification = NewsObject(dictionary: document.data())
                self.notificationArray.append(newNotification)
                print("Loaded: \(newNotification)")
            }
        
            
            
            completed()
            return
        }
        //completed()
    }
    

    
    
    
    
    
    // cell numb
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationArray.count
    }
    
    
    // cell config
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // declare cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell") as! newsCell

        // connect cell objects with received data from server
        cell.usernameBtn.setTitle(usernameArray[indexPath.row], for: UIControl.State())
        avaArray[indexPath.row].getDataInBackground { (data, error) -> Void in
            if error == nil {
                cell.avaImg.image = UIImage(data: data!)
            } else {
                print(error!.localizedDescription)
            }
        }
        
        // calculate post date
        let from = dateArray[indexPath.row]
        let now = Date()
        let components : NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfMonth]
        let difference = (Calendar.current as NSCalendar).components(components, from: from!, to: now, options: [])
        
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
        if typeArray[indexPath.row] == "mention" {
            cell.infoLbl.text = "has mentioned you."
        }
        if typeArray[indexPath.row] == "comment" {
            cell.infoLbl.text = "has commented your post."
        }
        if typeArray[indexPath.row] == "follow" {
            cell.infoLbl.text = "now following you."
        }
        if typeArray[indexPath.row] == "like" {
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
        if cell.usernameBtn.titleLabel?.text == PFUser.current()?.username {
            let home = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as! homeVC
            self.navigationController?.pushViewController(home, animated: true)
        } else {
            guestname.append(cell.usernameBtn.titleLabel!.text!)
            let guest = self.storyboard?.instantiateViewController(withIdentifier: "guestVC") as! guestVC
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
            commentuuid.append(uuidArray[indexPath.row])
            commentowner.append(ownerArray[indexPath.row])
            
            // go comments
            let comment = self.storyboard?.instantiateViewController(withIdentifier: "commentVC") as! commentVC
            self.navigationController?.pushViewController(comment, animated: true)
        }
        
        
        // going to own comments
        if cell.infoLbl.text == "has commented your post." {
            
            // send related data to gloval variable
            commentuuid.append(uuidArray[indexPath.row])
            commentowner.append(ownerArray[indexPath.row])
            
            // go comments
            let comment = self.storyboard?.instantiateViewController(withIdentifier: "commentVC") as! commentVC
            self.navigationController?.pushViewController(comment, animated: true)
        }
        
        
        // going to user followed current user
        if cell.infoLbl.text == "now following you." {
            
            // take guestname
            guestname.append(cell.usernameBtn.titleLabel!.text!)
            
            // go guest
            let guest = self.storyboard?.instantiateViewController(withIdentifier: "guestVC") as! guestVC
            self.navigationController?.pushViewController(guest, animated: true)
        }
        
        
        // going to liked post
        if cell.infoLbl.text == "likes your post." {
            
            // take post uuid
            postuuid.append(uuidArray[indexPath.row])
            
            // go post
            let post = self.storyboard?.instantiateViewController(withIdentifier: "postVC") as! postVC
            self.navigationController?.pushViewController(post, animated: true)
        }
        
    }

}

