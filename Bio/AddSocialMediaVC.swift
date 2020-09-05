//
//  AddSocialMediaVC.swift
//  Bio
//
//  Created by Ann McDonough on 6/30/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
//import Parse
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class AddSocialMediaVC: UIViewController {
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var subtitleText: UILabel!
    
    @IBOutlet weak var instagramLogo: UIImageView!
    
    @IBOutlet weak var snapchatLogo: UIImageView!
    
    @IBOutlet weak var twitterLogo: UIImageView!
    
    @IBOutlet weak var facebookLogo: UIImageView!
    
    @IBOutlet weak var appleMusicLogo: UIImageView!
    
    @IBOutlet weak var venmoLogo: UIImageView!
    
    @IBOutlet weak var tikTokLogo: UIImageView!
    
    @IBOutlet weak var poshmarkLogo: UIImageView!
    
    // scrollView
    @IBOutlet weak var scrollView: UIScrollView!
    
    // profile image
    
    // textfields
    @IBOutlet weak var instagramUsernameTxt: UITextField!
    @IBOutlet weak var snapchatUsernameTxt: UITextField!
    @IBOutlet weak var twitterHandleTxt: UITextField!
    @IBOutlet weak var facebookInfoTxt: UITextField!
    @IBOutlet weak var appleMusicTxt: UITextField!
    
    @IBOutlet weak var venmoTxt: UITextField!
    @IBOutlet weak var tikTokText: UITextField!
    @IBOutlet weak var poshmarkText: UITextField!
    // buttons
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    var currentUser: User? = Auth.auth().currentUser
    var userData: UserData?
    var userDataRef: DocumentReference? = nil
    let db = Firestore.firestore()
    var cancelLbl: String?
    
    
    // reset default size
    var scrollViewHeight : CGFloat = 0
    
    // keyboard frame size
    var keyboard = CGRect()
    
    
    // default func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (userData == nil) {
            print("userdata is nil")
        }
        else {
            print("loaded addVC with userdata: \(userData!.publicID) and user \(currentUser!.email)")
        }
        
        //poshmarkLogo.image = UIImage(named: "poshmarkLogo")
        let gold = #colorLiteral(red: 0.9882352941, green: 0.7607843137, blue: 0, alpha: 1)
        let gray = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        // scrollview frame size
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        scrollView.contentSize.height = self.view.frame.height
        scrollViewHeight = scrollView.frame.size.height
        
        // check notifications if keyboard is shown or not
        NotificationCenter.default.addObserver(self, selector: #selector(GoodBioSignUpVC.showKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GoodBioSignUpVC.hideKeybard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // declare hide kyboard tap
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(GoodBioSignUpVC.hideKeyboardTap(_:)))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // round ava
        //  avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        //hexagonAva
        
        //cancelBtn.frame = CGRect(x: 5, y: 15, width: 24, height: 24)
        cancelBtn.layer.cornerRadius = cancelBtn.frame.size.width / 20
        titleText.frame = CGRect(x: 0,y: 10, width: self.view.frame.size.width, height: 30)
        subtitleText.frame = CGRect(x:0, y: titleText.frame.maxY + 5, width: self.view.frame.size.width, height: 30)
        
        instagramUsernameTxt.frame = CGRect(x: 10, y: subtitleText.frame.maxY + 20, width: self.view.frame.size.width - 20, height: 35)
        snapchatUsernameTxt.frame = CGRect(x: 10, y: instagramUsernameTxt.frame.maxY + 15, width: self.view.frame.size.width - 20, height: 35)
        twitterHandleTxt.frame = CGRect(x: 10, y: snapchatUsernameTxt.frame.maxY + 15, width: self.view.frame.size.width - 20, height: 35)
        facebookInfoTxt.frame = CGRect(x: 10, y: twitterHandleTxt.frame.maxY + 15, width: self.view.frame.size.width - 20, height: 35)
        appleMusicTxt.frame = CGRect(x: 10, y: facebookInfoTxt.frame.maxY + 15, width: self.view.frame.size.width - 20, height: 35)
        venmoTxt.frame = CGRect(x: 10, y: appleMusicTxt.frame.maxY + 15, width: self.view.frame.size.width - 20, height: 35)
        tikTokText.frame = CGRect(x: 10, y: venmoTxt.frame.maxY + 15, width: self.view.frame.size.width - 20, height: 35)
        poshmarkText.frame = CGRect(x: 10, y: tikTokText.frame.maxY + 15, width: self.view.frame.size.width - 20, height: 35)
        instagramLogo.frame = CGRect(x: 11, y: instagramUsernameTxt.frame.minY + 2, width: 24, height: 33)
        snapchatLogo.frame =  CGRect(x: 11, y: snapchatUsernameTxt.frame.minY + 2, width: 24, height: 33)
        
        twitterLogo.frame = CGRect(x: 11, y: twitterHandleTxt.frame.minY + 2, width: 24, height: 33)
        
        facebookLogo.frame =  CGRect(x: 11, y: facebookInfoTxt.frame.minY + 2, width: 24, height: 33)
        
        appleMusicLogo.frame =  CGRect(x: 11, y: appleMusicTxt.frame.minY + 2, width: 24, height: 33)
        
        venmoLogo.frame =  CGRect(x: 11, y: venmoTxt.frame.minY + 2, width: 24, height: 33)
        
        tikTokLogo.frame =  CGRect(x: 11, y: tikTokText.frame.minY + 2, width: 24, height: 33)
        poshmarkLogo.frame =  CGRect(x: 11, y: poshmarkText.frame.minY + 2, width: 24, height: 33)
        
        continueBtn.frame =  CGRect(x: 10.0, y: poshmarkText.frame.maxY + 15, width: facebookInfoTxt.frame.width, height: 30)
       continueBtn.layer.cornerRadius = continueBtn.frame.size.width / 20
        cancelBtn.frame =  CGRect(x: 10.0, y: continueBtn.frame.maxY + 10, width: continueBtn.frame.width, height: 30)
       //cancelBtn.layer.cornerRadius = cancelBtn.frame.size.width / 20
        
        // background
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "manaloghourglass")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
    }
    
    //
    //    // call picker to select image
    //    @objc func loadImg(_ recognizer:UITapGestureRecognizer) {
    //        let picker = UIImagePickerController()
    //        picker.delegate = self
    //        picker.sourceType = .photoLibrary
    //        picker.allowsEditing = true
    //        present(picker, animated: true, completion: nil)
    //    }
    //
    //
    //    // connect selected image to our ImageView
    //    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    //        // Local variable inserted by Swift 4.2 migrator.
    //        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
    //
    //        //    avaImg.image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage
    //        self.dismiss(animated: true, completion: nil)
    //    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if (cancelLbl != nil) {
            cancelBtn.text(cancelLbl!)
        }
    }
    
    // hide keyboard if tapped
    @objc func hideKeyboardTap(_ recoginizer:UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    // show keyboard
    @objc func showKeyboard(_ notification:Notification) {
        
        // define keyboard size
        keyboard = ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue)!
        
        // move up UI
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.scrollView.frame.size.height = self.scrollViewHeight - self.keyboard.height
        })
    }
    
    
    // hide keyboard func
    @objc func hideKeybard(_ notification:Notification) {
        
        // move down UI
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.scrollView.frame.size.height = self.view.frame.height
        })
    }
    
    func addHex(hexData: HexagonStructData, completion: @escaping (Bool) -> Void) {
        let hexCollectionRef = db.collection("Hexagons2")
        let hexDoc = hexCollectionRef.document()
        var hexCopy = HexagonStructData(dictionary: hexData.dictionary)
        hexCopy.docID = hexDoc.documentID
        hexDoc.setData(hexCopy.dictionary){ error in
            if error == nil {
                completion(true)
            }
            else {
                completion(false)
            }
        }
        
    }
    
    
    // clicked sign up
    @IBAction func continueClicked(_ sender: AnyObject) {
        print("continue button pressed")
        
        // dismiss keyboard
        self.view.endEditing(true)
        
        // if fields are empty
        if (instagramUsernameTxt.text!.isEmpty && snapchatUsernameTxt.text!.isEmpty && twitterHandleTxt.text!.isEmpty && facebookInfoTxt.text!.isEmpty && appleMusicTxt.text!.isEmpty && venmoTxt.text!.isEmpty && tikTokText.text!.isEmpty && poshmarkText.text!.isEmpty) {
            
            // alert message
            let alert = UIAlertController(title: "Hold up", message: "Fill in a field or hit \(cancelBtn.titleLabel!.text!)", preferredStyle: UIAlertController.Style.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        let username = userData!.publicID
        var numPosts = userData!.numPosts
        var success = true
        
        
        
        //let group = DispatchGroup()
        if (!instagramUsernameTxt.text!.isEmpty) {
            numPosts += 1
            let instaHex = HexagonStructData(resource: "https://instagram.com/\(instagramUsernameTxt.text!)", type: "socialmedia_instagram", location: numPosts, thumbResource: "icons/instagramLogo.png", createdAt: TimeInterval.init(), postingUserID: username, text: "\(instagramUsernameTxt.text!)", views: 0, isArchived: false, docID: "WillBeSetLater")
            addHex(hexData: instaHex, completion: { bool in
                success = success && bool
                
            })
        }
        
        if (!snapchatUsernameTxt.text!.isEmpty) {
            numPosts += 1
            let snapHex = HexagonStructData(resource: "snapchat://add/\(snapchatUsernameTxt.text!)", type: "socialmedia_snapchat", location: numPosts, thumbResource: "icons/snapchatlogo.jpg", createdAt: TimeInterval.init(), postingUserID: username, text: "\(snapchatUsernameTxt.text!)", views: 0, isArchived: false, docID: "WillBeSetLater")
            addHex(hexData: snapHex, completion: {bool in
                success = success && bool
                
            })
        }
        
        if (!twitterHandleTxt.text!.isEmpty) {
            numPosts += 1
            let twitterHex = HexagonStructData(resource: "https://twitter.com/\(twitterHandleTxt.text!)", type: "socialmedia_twitter", location: numPosts, thumbResource: "icons/twitter.png", createdAt: TimeInterval.init(), postingUserID: username, text: "\(twitterHandleTxt.text!)", views: 0, isArchived: false, docID: "WillBeSetLater")
            addHex(hexData: twitterHex, completion: {bool in
                success = success && bool
                
            })
        }
        
        if (!facebookInfoTxt.text!.isEmpty) {
            numPosts += 1
            let facebookHex = HexagonStructData(resource: facebookInfoTxt.text!, type: "socialmedia_facebook", location: numPosts, thumbResource: "icons/facebooklogo.png", createdAt: TimeInterval.init(), postingUserID: username, text: "\(facebookInfoTxt.text!)", views: 0, isArchived: false, docID: "WillBeSetLater")
            addHex(hexData: facebookHex, completion: {bool in
                success = success && bool
                
            })
        }
        
        if (!appleMusicTxt.text!.isEmpty) {
            numPosts += 1
            let appleHex = HexagonStructData(resource: "https://applemusic.com/\(appleMusicTxt.text!)", type: "socialmedia_appleMusic", location: numPosts, thumbResource: "icons/appleMusicLogo.jpg", createdAt: TimeInterval.init(), postingUserID: username, text: "\(appleMusicTxt.text!)", views: 0,isArchived: false, docID: "WillBeSetLater")
            addHex(hexData: appleHex, completion: {bool in
                success = success && bool
                
            })
        }
        
        if (!venmoTxt.text!.isEmpty) {
            numPosts += 1
            let venmoHex = HexagonStructData(resource: "https://venmo.com/\(venmoTxt.text!)", type: "socialmedia_venmo", location: numPosts, thumbResource: "icons/venmologo.png", createdAt: TimeInterval.init(), postingUserID: username, text: "\(venmoTxt.text!)", views: 0, isArchived: false, docID: "WillBeSetLater")
            addHex(hexData: venmoHex, completion: {bool in
                success = success && bool
                
            })
        }
        
        if (!tikTokText.text!.isEmpty) {
            numPosts += 1
            let tikTokHex = HexagonStructData(resource: "https://www.tiktok.com/\(tikTokText.text!)/", type: "socialmedia_tiktok", location: numPosts, thumbResource: "icons/tiktokLogo.jpg", createdAt: TimeInterval.init(), postingUserID: username, text: "\(tikTokText.text!)", views: 0, isArchived: false, docID: "WillBeSetLater")
            addHex(hexData: tikTokHex, completion: {bool in
                success = success && bool
                
            })
        }
        
        if (!poshmarkText.text!.isEmpty) {
            numPosts += 1
            let poshmarkHex = HexagonStructData(resource: "https://poshmark.com/closet/\(poshmarkText.text!)", type: "socialmedia_poshmark", location: numPosts, thumbResource: "icons/poshmarkLogo.png", createdAt: TimeInterval.init(), postingUserID: username, text: "\(poshmarkText.text!)", views: 0, isArchived: false, docID: "WillBeSetLater")
            addHex(hexData: poshmarkHex, completion: {bool in
                success = success && bool
                
            })
        }
        
        print("passed wait for social media tiles")
        userData?.numPosts = numPosts
        db.collection("UserData1").document(currentUser!.uid).setData(self.userData!.dictionary, completion: { error in
            if error == nil {
                //present Home View Controller Segue
                print("present home hex grid")
                self.performSegue(withIdentifier: "rewindToFront", sender: nil)
            }
            else {
                print("userData not saved \(error?.localizedDescription)")
            }
            
        })
        
        
    }

    
    // clicked cancel
    @IBAction func cancelBtn_click(_ sender: AnyObject) {
        
        print("hit cancel button")
        // hide keyboard when pressed cancel
        self.view.endEditing(true)
        if (cancelBtn.titleLabel?.text! == "Skip") {
//            print("present home hex grid")
//            //self.performSegue(withIdentifier: "toHomeHexGrid", sender: nil)
//            let hexGrid = (storyboard?.instantiateViewController(identifier: "homeHexGrid420"))! as HomeHexagonGrid
//            hexGrid.userData = userData
//            show(hexGrid, sender: nil)
//            print("should have presented home hex grid")
//            let tabBar = tabBarController!
//            let homeHexGrid = (tabBar.viewControllers![2] as! HomeHexagonGrid)
//            homeHexGrid.userData = self.userData
//            tabBar.selectedViewController = homeHexGrid
            performSegue(withIdentifier: "rewindToFront", sender: nil)
        }
        else {
            print("should dismiss vc")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    
    
    func openInstagram(instagramHandle: String) {
        guard let url = URL(string: "https://instagram.com/\(instagramHandle)")  else { return }
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func openTikTok(tikTokHandle: String) {
        guard let url = URL(string: tikTokHandle)  else { return }
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func openSpotifySong() {
        //  UIApplication.shared.open(URL(string: "spotify:artist:4gzpq5DPGxSnKTe4SA8HAU")!, options: [:], completionHandler: nil)
        // UIApplication.shared.openURL(URL(string: "spotify:track:1dNIEtp7AY3oDAKCGg2XkH")!)
        //   UIApplication.shared.open(URL(string: "spotify:track:1dNIEtp7AY3oDAKCGg2XkH")!, options: [:], completionHandler: nil)
        UIApplication.shared.open(URL(string: "https://p.scdn.co/mp3-preview/18d3b87b0765cd6d8c0a418d6142b3b441c0f8b2?cid=476c620368f349cc8be5b2a29b596eaf" )!, options: [:], completionHandler: nil)
        
    }
    
    
    
    
    
    func openFacebook(facebookHandle: String) {
        let webURL: NSURL = NSURL(string: "https://www.facebook.com/ID")!
        let IdURL: NSURL = NSURL(string: "fb://profile/ID")!
        
        if(UIApplication.shared.canOpenURL(IdURL as URL)){
            // FB installed
            UIApplication.shared.open(webURL as URL, options: [:], completionHandler: nil)
        } else {
            // FB is not installed, open in safari
            UIApplication.shared.open(webURL as URL, options: [:], completionHandler: nil)
        }
        
    }
    
    func openTwitter(twitterHandle: String) {
        guard let url = URL(string: "https://twitter.com/\(twitterHandle)")  else { return }
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func openSnapchat(snapchatUsername: String) {
        let username = snapchatUsername
        let appURL = URL(string: "snapchat://add/\(username)")!
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL) {
            application.open(appURL)
            
        } else {
            // if Snapchat app is not installed, open URL inside Safari
            let webURL = URL(string: "https://www.snapchat.com/add/\(username)")!
            application.open(webURL)
            
        }
    }
 
}

