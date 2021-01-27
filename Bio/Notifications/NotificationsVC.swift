
//
//  NotificationsVC.swift
//  Bio
//
//  Created by Ann McDonough on 9/7/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//


import UIKit
import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
//import FirebaseFirestore

class NotificationsVC: UIViewController {
    var firstTime = true
    var isNotificationsEmpty = true
    var navBarY = CGFloat(39)
    var titleFontSize = CGFloat(20)
    let menuView = MenuView()
    let storage = Storage.storage().reference()
    var db = Firestore.firestore()
    var listener: ListenerRegistration?
    var unreadNotifications = 0
    var userDataVM: UserDataVM?
    @IBOutlet weak var tableView: UITableView!
    
    var navBarView = NavBarView()
    var titleLabel1 = UILabel()
    
    // arrays to hold data from server
    var toSearchButton = UIButton()
    
    var toSettingsButton = UIButton()
    
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
        
        loadData {
            //            print("Should be loading notifications!!")
        }
        self.tableView.reloadData()
    }
    
    
    
    // defualt func
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: view.frame.width * 3/10, right: 0)
        
        tableView.rowHeight = UITableView.automaticDimension
        
        addMenuButtons()
        
        setUpNavBarView()
        
        super.viewDidLoad()
        
        self.navigationItem.title = "NOTIFICATIONS"
        
        view.addSubview(myLabel)
        myLabel.numberOfLines = 0
        myLabel.font = UIFont(name: "DINAlternate-Bold", size: 20)
        myLabel.isHidden = true
        myLabel.frame = CGRect(x: 20, y: view.frame.height / 4 - 10, width: view.frame.width - 40, height: 100)
        myLabel.text = "No notfications yet. Follow people to make more connections."
        myLabel.textColor = .white
        myLabel.textAlignment = .center
        
        
        // request notifications
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    
    func loadData(completed: @escaping () -> ()) {
        //        print("in load notifications funtion")
        //le;t notificationsQuery = db.collection("News").whereField("currentUser", isEqualTo: userData?.publicID)
        let userData = userDataVM?.userData.value
        if userData == nil {
            return
        }
        let notificationsQuery = db.collection("News2").whereField("notifyingUser", isEqualTo: userData!.publicID)
        //        print("This is notification query \(notificationsQuery)")
        notificationsQuery.getDocuments(completion: { (querySnapshot, error) in
            guard error == nil else {
                print("error loading home photos: \n \(error!.localizedDescription)")
                return completed()
            }
            self.notificationArray = []
            //there are querySnapshot!.documents.count docments in the spots snapshot
            
            for document in querySnapshot!.documents {
                //                print("doc: \(document)")
                var newNotification = NewsObject(dictionary: document.data())
                newNotification.checked = true
                self.notificationArray.append(newNotification)
                document.reference.setData(newNotification.dictionary)
                
            }
            let dateFormatter = DateFormatter()
            // dateFormatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ssZ"
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            dateFormatter.locale = Locale.init(identifier: "en_GB")
            dateFormatter.timeZone = NSTimeZone(name: "GMT") as TimeZone?
            self.notificationArray.sort(by: { x, y in
                //var fromString1 = fromString.dropLast(6)
                //fromString = "\(fromString1)"
                let xDate = dateFormatter.date(from: x.createdAt)
                
                let yDate = dateFormatter.date(from: y.createdAt)
                
                return xDate!.compare(yDate!) == ComparisonResult.orderedDescending
            })
            
            self.tableView.reloadData()
            
            
            
            completed()
            return
        })
        //completed()
    }
    
    
    func addMenuButtons() {
        view.addSubview(menuView)
        menuView.currentTab = 0
        menuView.addBehavior()
    }
    
    func setUpNavBarView() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        //        print("This is status bar height \(statusBarHeight)")
        self.view.addSubview(navBarView)
        self.navBarView.frame = CGRect(x: -5, y: -5, width: self.view.frame.width + 10, height: (self.view.frame.height/12)+5)
        let navBarHeightRemaining = navBarView.frame.maxY - statusBarHeight
        navBarView.backButton.isHidden = true
        navBarView.postButton.isHidden = true
        self.navBarView.addSubview(toSettingsButton)
        self.navBarView.addSubview(toSearchButton)
        
        let settingsTap = UITapGestureRecognizer(target: self, action: #selector(self.toSettingsButtonClicked))
        settingsTap.numberOfTapsRequired = 1
        toSettingsButton.isUserInteractionEnabled = true
        toSettingsButton.addGestureRecognizer(settingsTap)
        
        let searchTap = UITapGestureRecognizer(target: self, action: #selector(self.toSearchButtonClicked))
        searchTap.numberOfTapsRequired = 1
        toSearchButton.isUserInteractionEnabled = true
        toSearchButton.addGestureRecognizer(searchTap)
        
        
        self.toSettingsButton.setImage(UIImage(named: "lightGrayGearFinal"), for: .normal)
        self.toSearchButton.setImage(UIImage(named: "lightGrayMagnifyingGlassFinal"), for: .normal)
        
        self.toSettingsButton.frame = CGRect(x: 10, y: navBarView.frame.height - 30, width: 25, height: 25)
        self.toSettingsButton.frame = CGRect(x: 10, y: statusBarHeight + (navBarHeightRemaining - 25)/2, width: 25, height: 25)
        self.toSearchButton.frame = CGRect(x: navBarView.frame.width - 35, y: statusBarHeight + (navBarHeightRemaining - 25)/2, width: 25, height: 25)
        let yOffset = navBarView.frame.maxY
        self.tableView.frame = CGRect(x: 0, y: yOffset, width: self.view.frame.width, height: self.view.frame.height - yOffset)
        //  self.navBarView.addSubview(titleLabel1)
        self.navBarView.addBehavior()
        self.navBarView.titleLabel.text = "Notifications"
        //self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y: navBarView.frame.maxY - 30, width: 200, height: 30)
        //        print("This is navBarView.")
        self.toSettingsButton.setImage(UIImage(named: "lightGrayGearFinal"), for: .normal)
        self.toSearchButton.setImage(UIImage(named: "lightGrayMagnifyingGlassFinal"), for: .normal)
        
        self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y: statusBarHeight + (navBarHeightRemaining - 34)/2, width: 200, height: 25)
        
        //self.titleLabel1.text = "Notifications"
        //  self.navBarView.frame = CGRect(x: -5, y: -5, width: self.view.frame.width + 10, height: (self.view.frame.height/12)+5)
        // let yOffset = navBarView.frame.maxY
        self.tableView.frame = CGRect(x: 0, y: yOffset, width: self.view.frame.width, height: self.view.frame.height - yOffset)
        
    }
    
    @objc func toSettingsButtonClicked(_ recognizer: UITapGestureRecognizer) {
        let settingsVC = storyboard?.instantiateViewController(identifier: "settingsVC") as! ProfessionalSettingsVC
        settingsVC.userDataVM = userDataVM
        present(settingsVC, animated: false)
    }
    
    
    func addSettingsButton() {
        self.view.addSubview(toSettingsButton)
        // toSettingsButton.frame = CGRect(x: 15, y: self.view.frame.height/48, width: 30, height: 30)
        toSettingsButton.frame = CGRect(x: self.view.frame.height*(1/48), y: (self.view.frame.height/48) + 2, width: self.view.frame.height/24, height: self.view.frame.height/24)
        // round ava
        toSettingsButton.clipsToBounds = true
        toSettingsButton.isHidden = false
    }
    
    @objc func toSearchButtonClicked(_ recognizer: UITapGestureRecognizer) {
        let userTableVC = storyboard?.instantiateViewController(identifier: "userTableView") as! UserTableView
        userTableVC.userDataVM = userDataVM
        present(userTableVC, animated: false)
    }
    
    func addSearchButton() {
        self.view.addSubview(toSearchButton)
        toSearchButton.frame = CGRect(x: self.view.frame.width - (self.view.frame.height*(3/48)), y: (self.view.frame.height/48) + 2, width: self.view.frame.height/24, height: self.view.frame.height/24)
        // round ava
        //    toSearchButton.layer.cornerRadius = toSearchButton.frame.size.width / 2
        toSearchButton.clipsToBounds = true
        toSearchButton.isHidden = false
        // followView.isHidden = false
        toSettingsButton.isHidden = false
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
                    guestVC.userDataVM = self.userDataVM
                    guestVC.guestUserData = userdata
                    self.present(guestVC, animated: false)
                    self.modalPresentationStyle = .fullScreen
                }
            }
            else {
                print("pulling up guest vc userdata failed")
            }
        })
    }
    
    @objc func buttonViewLinkAction(sender: UITapGestureRecognizer!) {
        let button = sender.view as! UIButton
        UIPasteboard.general.string = button.titleLabel?.text ?? "" //
        let alert = UIAlertController(title: "Copied \(UIPasteboard.general.string!)", message: "", preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
        
        // change to desired number of seconds (in this case 5 seconds)
        let when = DispatchTime.now() + 1.5
        DispatchQueue.main.asyncAfter(deadline: when){
            // your code with delay
            alert.dismiss(animated: true, completion: nil)
        }
        UIDevice.vibrate()
        
    }
    
    @objc func acceptTapped(_ sender: UITapGestureRecognizer) {
        let cell = sender.view?.superview?.superview as! newsCell
        print(notificationArray[cell.tag])
        let userData = userDataVM?.userData.value
        let document = db.collection("News2").document()
        let news = NewsObject(ava: userData?.phoneNumber ?? "", type: "approvePhoneNumber", currentUser: userData?.publicID ?? "", notifyingUser: cell.currentPostingUserID, thumbResource: userData?.avaRef ?? "", createdAt: NSDate.now.description, checked: false, notificationID: document.documentID)
        document.setData(news.dictionary)
        notificationArray[cell.tag].type = "requestCompleted"
        db.collection("News2").document(notificationArray[cell.tag].notificationID).setData(notificationArray[cell.tag].dictionary)
        tableView.reloadData()
    }
    
    @objc func rejectTapped(_ sender: UITapGestureRecognizer) {
        let cell = sender.view?.superview?.superview as! newsCell
        db.collection("News2").document(notificationArray[cell.tag].notificationID).delete()
        notificationArray.remove(at: cell.tag)
        tableView.reloadData()
    }
    
    
    
    @IBAction func photo_click(_ sender: UIImageView) {
        //        print("UserName Clicked")
        // call index of button
        let i = sender.layer.value(forKey: "index") as! IndexPath
        //        print("This is i: \(i)")
        
        // call cell to call further cell data
        let cell = tableView.cellForRow(at: i) as! newsCell
        let username = cell.usernameBtn.titleLabel!.text!
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
                    guestVC.guestUserData = userdata
                    guestVC.userDataVM = self.userDataVM
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
        let username = cell.usernameBtn.titleLabel!.text!
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
                    guestVC.guestUserData = userdata
                    guestVC.userDataVM = self.userDataVM
                    self.present(guestVC, animated: false)
                    self.modalPresentationStyle = .fullScreen
                }
            }
            else {
                print("pulling up guest vc userdata failed")
            }
        })
    }
    
    func format(phoneNumber sourcePhoneNumber: String) -> String? {
        // Remove any character that is not a number
        let numbersOnly = sourcePhoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let length = numbersOnly.count
        let hasLeadingOne = numbersOnly.hasPrefix("1")
        
        // Check for supported phone number length
        guard length == 7 || (length == 10 && !hasLeadingOne) || (length == 11 && hasLeadingOne) else {
            return nil
        }
        
        let hasAreaCode = (length >= 10)
        var sourceIndex = 0
        
        // Leading 1
        var leadingOne = ""
        if hasLeadingOne {
            leadingOne = "1 "
            sourceIndex += 1
        }
        
        // Area code
        var areaCode = ""
        if hasAreaCode {
            let areaCodeLength = 3
            guard let areaCodeSubstring = numbersOnly.substring(start: sourceIndex, offsetBy: areaCodeLength) else {
                return nil
            }
            areaCode = String(format: "(%@) ", areaCodeSubstring)
            sourceIndex += areaCodeLength
        }
        
        // Prefix, 3 characters
        let prefixLength = 3
        guard let prefix = numbersOnly.substring(start: sourceIndex, offsetBy: prefixLength) else {
            return nil
        }
        sourceIndex += prefixLength
        
        // Suffix, 4 characters
        let suffixLength = 4
        guard let suffix = numbersOnly.substring(start: sourceIndex, offsetBy: suffixLength) else {
            return nil
        }
        
        return leadingOne + areaCode + prefix + "-" + suffix
    }
    
    let myLabel = UILabel()
    
}

extension String {
    /// This method makes it easier extract a substring by character index where a character is viewed as a human-readable character (grapheme cluster).
    internal func substring(start: Int, offsetBy: Int) -> String? {
        guard let substringStartIndex = self.index(startIndex, offsetBy: start, limitedBy: endIndex) else {
            return nil
        }
        
        guard let substringEndIndex = self.index(startIndex, offsetBy: start + offsetBy, limitedBy: endIndex) else {
            return nil
        }
        
        return String(self[substringStartIndex ..< substringEndIndex])
    }
}

extension NotificationsVC: UITableViewDelegate, UITableViewDataSource {
    
    // cell numb
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        print("This is notificationArray count \(notificationArray.count)")
        if notificationArray.count == 0 {
            myLabel.isHidden = false
        }
        else {
            myLabel.isHidden = true
        }
        return notificationArray.count
    }
    
    
    
    // cell config
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell") as! newsCell
        if notificationArray.isEmpty == false {
            cell.tag = indexPath.row
            cell.frame = CGRect(x: cell.frame.minX, y: cell.frame.minY, width: view.frame.width, height: 43.5)
            // connect cell objects with received data from server
            cell.currentPostingUserID = notificationArray[indexPath.row].currentUser
            cell.usernameBtn.setTitle(notificationArray[indexPath.row].currentUser, for: UIControl.State())
            //print("cell frame: \(cell.frame)")
            let ref = storage.child(notificationArray[indexPath.row].thumbResource)
            cell.avaImg.sd_setImage(with: ref)
            cell.avaImg.frame = CGRect(x: 5, y: 2, width: cell.frame.height-15, height: cell.frame.height-15)
            cell.avaImg.clipsToBounds = true
            //  cell.avaImg.setupHexagonMask(lineWidth: cell.avaImg.frame.width/15, color: gold, cornerRadius: cell.avaImg.frame.width/15)
            cell.avaImg.layer.cornerRadius = cell.avaImg.frame.width/2
            cell.infoLbl.frame = CGRect(x: cell.avaImg.frame.maxX + 5, y: 5, width: 140, height: 30)
            cell.dateLbl.frame = CGRect(x: cell.infoLbl.frame.maxX + 5, y: 5, width: 50
                                        , height: 30)
            
            cell.acceptButton.frame = CGRect(x: cell.frame.width - 35, y: (cell.frame.height - 30)/2, width: 30, height: 30)
            cell.rejectButton.frame = CGRect(x: cell.acceptButton.frame.minX - 35, y: (cell.frame.height - 30)/2, width: 30, height: 30)
            
            // calculate post date
            //        let times = ["now", "now", "5m", "7m", "21m", "30m", "1hr", "1hr", "1hr", "1hr", "2hr", "2hr", "2hr", "2hr", "4hr", "4hr", "4hr", "4hr", "5hr", "5hr", "6hr", "7hr", "12hr", "1d", "1d", "1d", "1d", "1d", "1d", "1d", "1d", "2d", "2d", "2d", "2d", "2d", "2d", "2d", "2d", "2d", "2d", "3d", "3d", "3d", "3d", "3d", "3d", "3d", "3d", "3d", "3d", "3d", "3d", "3d", "3d", "3d", "3d", "4d", "4d", "4d", "4d", "4d", "4d", "4d", "4d", "4d", "4d", "4d", "4d", "4d", "4d", "4d", "4d", "4d", "4d", "4d", "5d", "5d", "5d", "5d", "5d", "5d", "5d", "5d", "5d", "5d", "5d", "5d", "5d", "5d", "5d", "5d", "5d", "5d", "5d", "5d"]
            
            
            let dateFormatter = DateFormatter()
            // dateFormatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ssZ"
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            dateFormatter.locale = Locale.init(identifier: "en_GB")
            dateFormatter.timeZone = NSTimeZone(name: "GMT") as TimeZone?
            cell.phoneButton.isHidden = true
            
            //"yyyy-MM-dd HH:mm:ss.SSSZ" // "yyyy-MM-dd HH:mm:ss"
            
            let fromString = notificationArray[indexPath.row].createdAt
            //var fromString1 = fromString.dropLast(6)
            //fromString = "\(fromString1)"
            let from = dateFormatter.date(from: fromString)
            //    let from = dateFormatter.date(from: fromString)
            //        print("from: \(from)")
            let now = Date()
            //        print("now: \(now)")
            let components : NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfMonth]
            let difference = (Calendar.current as NSCalendar).components(components, from: from ?? Date(), to: now, options: [])
            print("This is difference: \(difference)")
            
            // logic what to show: seconds, minuts, hours, days or weeks
            if difference.second! <= 0 {
                cell.dateLbl.text = "now"
            }
            else if difference.second! > 0 && difference.minute! == 0 {
                cell.dateLbl.text = "\(String(describing: difference.second!))s."
            }
            else if difference.minute! > 0 && difference.hour! == 0 {
                cell.dateLbl.text = "\(String(describing: difference.minute!))m."
            }
            else if difference.hour! > 0 && difference.day! == 0 {
                cell.dateLbl.text = "\(String(describing: difference.hour!))h."
            }
            else if difference.day! > 0 && difference.weekOfMonth! == 0 {
                cell.dateLbl.text = "\(String(describing: difference.day!))d."
            }
            else if difference.weekOfMonth! > 0 {
                cell.dateLbl.text = "\(String(describing: difference.weekOfMonth!))w."
            }
            
            //cell.dateLbl.text = times[indexPath.row]
            
            // define info text
            if notificationArray[indexPath.row].type == "requestPhoneNumber" {
                cell.infoLbl.text = "asked for your phone number."
                
                cell.rejectButton.isHidden = false
                cell.acceptButton.isHidden = false
                
                let rejectTap = UITapGestureRecognizer(target: self, action: #selector(rejectTapped))
                let acceptTap = UITapGestureRecognizer(target: self, action: #selector(acceptTapped))
                cell.rejectButton.addGestureRecognizer(rejectTap)
                cell.acceptButton.addGestureRecognizer(acceptTap)
            }
            else if notificationArray[indexPath.row].type == "requestCompleted" {
                cell.infoLbl.text = "has been sent your number"
                cell.rejectButton.isHidden = true
                cell.acceptButton.isHidden = true
            }
            
            else if notificationArray[indexPath.row].type == "approvePhoneNumber" {
                cell.infoLbl.text = "gave you their phone number."
                cell.phoneButton.isHidden = false
                cell.phoneButton.titleLabel?.font = UIFont(name: cell.phoneButton.titleLabel!.font.fontName, size: 18)
                let phoneNumberButton = cell.phoneButton
                phoneNumberButton.isHidden = false
                let unformattedPhoneNumber = notificationArray[indexPath.row].ava
                let formattedPhoneNumber = format(phoneNumber: unformattedPhoneNumber)
                phoneNumberButton.setTitle(formattedPhoneNumber, for: .normal)
                //phoneNumberButton.titleLabel?.textColor = .blue
                phoneNumberButton.setTitleColor(UIColor(red: 0.25, green: 0.59, blue: 0.97, alpha: 1.00), for: .normal)
                phoneNumberButton.tintColor = .blue
                let copyTap = UITapGestureRecognizer(target: self, action: #selector(buttonViewLinkAction))
                cell.phoneButton.addGestureRecognizer(copyTap)
                //            cell.addSubview(phoneNumberButton)
                phoneNumberButton.frame = CGRect(x: 0, y: cell.infoLbl.frame.maxY, width: cell.frame.width, height: 30)
                phoneNumberButton.titleLabel?.textAlignment = .center
                //phoneNumberButton.sizeToFit()
            }
            
            
            
            
            else if notificationArray[indexPath.row].type == "mention" {
                cell.infoLbl.text = "has mentioned you."
            }
            else if notificationArray[indexPath.row].type == "comment" {
                cell.infoLbl.text = "has commented your post."
            }
            else if notificationArray[indexPath.row].type == "follow" {
                cell.infoLbl.text = "is now following you."
                //print("its a follow")
            }
            else if notificationArray[indexPath.row].type == "like" {
                cell.infoLbl.text = "likes your post."
            }
            
            
            // asign index of button
            cell.usernameBtn.layer.setValue(indexPath, forKey: "index")
            
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if notificationArray.isEmpty {
            isNotificationsEmpty = true
        }
        if isNotificationsEmpty {
            return self.view.frame.size.height/14
        }
        
        if notificationArray[indexPath.row].type == "approvePhoneNumber" {
        return (self.view.frame.size.height/14) + CGFloat(20)
    }
        else {
            return self.view.frame.size.height/14
        }
        
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
            guest.userDataVM = userDataVM
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
