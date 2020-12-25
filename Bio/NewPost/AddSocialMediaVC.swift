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
    
    @IBOutlet weak var soundCloudLogo: UIImageView!
    
    @IBOutlet weak var linkedInLogo: UIImageView!
    
    @IBOutlet weak var venmoLogo: UIImageView!
    
    @IBOutlet weak var tikTokLogo: UIImageView!
    
    @IBOutlet weak var poshmarkLogo: UIImageView!
    
    // scrollView
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var hudlLogo: UIImageView!
    // profile image
    @IBOutlet var hudlText: UITextField!
    
    @IBOutlet weak var interactiveHudlText: UITextField!
    // textfields
    @IBOutlet weak var instagramUsernameTxt: UITextField!
    @IBOutlet weak var snapchatUsernameTxt: UITextField!
    @IBOutlet weak var twitterHandleTxt: UITextField!
    @IBOutlet weak var soundCloudText: UITextField!
    @IBOutlet weak var linkedInText: UITextField!
    
    @IBOutlet weak var venmoTxt: UITextField!
    @IBOutlet weak var tikTokText: UITextField!
    @IBOutlet weak var poshmarkText: UITextField!
    // buttons
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet var twitchLogo: UIImageView!
    
    @IBOutlet var interactiveTwitchText: UITextField!
    @IBOutlet var twitchText: UITextField!
    
    
    //interactive TextFields
    
    @IBOutlet weak var interactiveInstagramTxt: UITextField!
    
    @IBOutlet weak var interactiveSnapchatUsernameTxt: UITextField!
    @IBOutlet weak var interactiveTwitterHandleTxt: UITextField!
    
    @IBOutlet weak var interactiveSoundCloudText: UITextField!
    
    @IBOutlet weak var interactiveLinkedInText: UITextField!

    
    @IBOutlet weak var interactiveVenmoTxt: UITextField!
    
    @IBOutlet weak var interactiveTikTokText: UITextField!

    @IBOutlet weak var interactivePoshmarkTxt: UITextField!
    
    var currentUser: User? = Auth.auth().currentUser
    var userDataVM: UserDataVM?
    let db = Firestore.firestore()
    var cancelLbl: String?
    
    
    // reset default size
    var scrollViewHeight : CGFloat = 0
    
    // keyboard frame size
    var keyboard = CGRect()
    
    
    // default func
    override func viewDidLoad() {
        tikTokText.borderStyle = .roundedRect
        venmoTxt.borderStyle = .roundedRect
        linkedInText.borderStyle = .roundedRect
        soundCloudText.borderStyle = .roundedRect
        instagramUsernameTxt.borderStyle = .roundedRect
        poshmarkText.borderStyle = .roundedRect
        snapchatUsernameTxt.borderStyle = .roundedRect
        twitterHandleTxt.borderStyle = .roundedRect
        hudlText.borderStyle = .roundedRect
        twitchText.borderStyle = .roundedRect
        
        tikTokText.layer.borderWidth = 1.0
        instagramUsernameTxt.layer.borderWidth = 1.0
        snapchatUsernameTxt.layer.borderWidth = 1.0
        twitterHandleTxt.layer.borderWidth = 1.0
        linkedInText.layer.borderWidth = 1.0
        venmoTxt.layer.borderWidth = 1.0
        poshmarkText.layer.borderWidth = 1.0
        soundCloudText.layer.borderWidth = 1.0
        hudlText.layer.borderWidth = 1.0
        twitchText.layer.borderWidth = 1.0
        
        tikTokText.layer.borderColor = CGColor(gray: 2/3, alpha: 1.0)
        venmoTxt.layer.borderColor = CGColor(gray: 2/3, alpha: 1.0)
        linkedInText.layer.borderColor = CGColor(gray: 2/3, alpha: 1.0)
        soundCloudText.layer.borderColor = CGColor(gray: 2/3, alpha: 1.0)
        instagramUsernameTxt.layer.borderColor = CGColor(gray: 2/3, alpha: 1.0)
        poshmarkText.layer.borderColor = CGColor(gray: 2/3, alpha: 1.0)
        snapchatUsernameTxt.layer.borderColor = CGColor(gray: 2/3, alpha: 1.0)
        twitterHandleTxt.layer.borderColor = CGColor(gray: 2/3, alpha: 1.0)
        hudlText.layer.borderColor = CGColor(gray: 2/3, alpha: 1.0)
        twitchText.layer.borderColor = CGColor(gray: 2/3, alpha: 1.0)
        
        tikTokText.backgroundColor = .black
        venmoTxt.backgroundColor = .black
        linkedInText.backgroundColor = .black
        soundCloudText.backgroundColor = .black
        instagramUsernameTxt.backgroundColor = .black
        poshmarkText.backgroundColor = .black
        snapchatUsernameTxt.backgroundColor = .black
        twitterHandleTxt.backgroundColor = .black
        hudlText.backgroundColor = .black
        twitchText.backgroundColor = .black
        
        
        interactiveVenmoTxt.attributedPlaceholder = NSAttributedString(string: "Venmo Username",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray4])
        interactivePoshmarkTxt.attributedPlaceholder = NSAttributedString(string: "Poshmark Username",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray4])
        
        interactiveInstagramTxt.attributedPlaceholder = NSAttributedString(string: "Instagram Username",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray4])
        
        interactiveTikTokText.attributedPlaceholder = NSAttributedString(string: "Tik Tok Username",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray4])
        
        interactiveLinkedInText.attributedPlaceholder = NSAttributedString(string: "LinkedIn Link",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray4])
        
        interactiveSoundCloudText.attributedPlaceholder = NSAttributedString(string: "SoundCloud Link",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray4])
        
        interactiveTwitterHandleTxt.attributedPlaceholder = NSAttributedString(string: "Twitter Handle",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray4])
        interactiveSnapchatUsernameTxt.attributedPlaceholder = NSAttributedString(string: "Snapchat Username",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray4])
        interactiveHudlText.attributedPlaceholder = NSAttributedString(string: "Hudl Link",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray4])
        
        interactiveTwitchText.attributedPlaceholder = NSAttributedString(string: "Twitch Username",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray4])
        
        
        super.viewDidLoad()
        
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
        soundCloudText.frame = CGRect(x: 10, y: twitterHandleTxt.frame.maxY + 15, width: self.view.frame.size.width - 20, height: 35)
        linkedInText.frame = CGRect(x: 10, y: soundCloudText.frame.maxY + 15, width: self.view.frame.size.width - 20, height: 35)
        venmoTxt.frame = CGRect(x: 10, y: linkedInText.frame.maxY + 15, width: self.view.frame.size.width - 20, height: 35)
        tikTokText.frame = CGRect(x: 10, y: venmoTxt.frame.maxY + 15, width: self.view.frame.size.width - 20, height: 35)
        poshmarkText.frame = CGRect(x: 10, y: tikTokText.frame.maxY + 15, width: self.view.frame.size.width - 20, height: 35)
        
        hudlText.frame = CGRect(x: 10, y: poshmarkText.frame.maxY + 15, width: self.view.frame.size.width - 20, height: 35)
        twitchText.frame = CGRect(x: 10, y: hudlText.frame.maxY + 15, width: self.view.frame.size.width - 20, height: 35)
        
        instagramLogo.frame = CGRect(x: 11, y: instagramUsernameTxt.frame.minY + 2, width: 24, height: 33)
        interactiveInstagramTxt.frame = CGRect(x: instagramLogo.frame.maxX + 3, y: instagramUsernameTxt.frame.minY, width: self.view.frame.size.width - instagramLogo.frame.maxX - 5, height: 35)
        snapchatLogo.frame =  CGRect(x: 11, y: snapchatUsernameTxt.frame.minY + 2, width: 24, height: 33)
          interactiveSnapchatUsernameTxt.frame = CGRect(x: snapchatLogo.frame.maxX + 3, y: snapchatUsernameTxt.frame.minY, width: self.view.frame.size.width - snapchatLogo.frame.maxX - 5, height: 35)
        twitterLogo.frame = CGRect(x: 11, y: twitterHandleTxt.frame.minY + 2, width: 24, height: 33)
          interactiveTwitterHandleTxt.frame = CGRect(x: twitterLogo.frame.maxX + 3, y: twitterHandleTxt.frame.minY, width: self.view.frame.size.width - twitterLogo.frame.maxX - 5, height: 35)
        
        soundCloudLogo.frame =  CGRect(x: 11, y: soundCloudText.frame.minY + 2, width: 24, height: 33)
        
          interactiveSoundCloudText.frame = CGRect(x: soundCloudLogo.frame.maxX + 3, y: soundCloudText.frame.minY, width: self.view.frame.size.width - soundCloudLogo.frame.maxX - 5, height: 35)
        
        linkedInLogo.frame =  CGRect(x: 11, y: linkedInText.frame.minY + 2, width: 24, height: 33)
        
        hudlLogo.frame =  CGRect(x: 11, y: hudlText.frame.minY + 2, width: 24, height: 33)
        
        twitchLogo.frame =  CGRect(x: 11, y: twitchText.frame.minY + 2, width: 24, height: 33)
        
          interactiveLinkedInText.frame = CGRect(x: linkedInLogo.frame.maxX + 3, y: linkedInText.frame.minY, width: self.view.frame.size.width - linkedInLogo.frame.maxX - 5, height: 35)
        
        venmoLogo.frame =  CGRect(x: 11, y: venmoTxt.frame.minY + 2, width: 24, height: 33)
        
          interactiveVenmoTxt.frame = CGRect(x: venmoLogo.frame.maxX + 3, y: venmoTxt.frame.minY, width: self.view.frame.size.width - venmoLogo.frame.maxX - 5, height: 35)
        
        tikTokLogo.frame =  CGRect(x: 11, y: tikTokText.frame.minY + 2, width: 24, height: 33)
          interactiveTikTokText.frame = CGRect(x: tikTokLogo.frame.maxX + 3, y: tikTokText.frame.minY, width: self.view.frame.size.width - tikTokLogo.frame.maxX - 5, height: 35)
        
        poshmarkLogo.frame =  CGRect(x: 11, y: poshmarkText.frame.minY + 2, width: 24, height: 33)
          interactivePoshmarkTxt.frame = CGRect(x: poshmarkLogo.frame.maxX + 3, y: poshmarkText.frame.minY, width: self.view.frame.size.width - poshmarkLogo.frame.maxX - 5, height: 35)
        
        interactiveHudlText.frame = CGRect(x: hudlLogo.frame.maxX + 3, y: hudlText.frame.minY, width: self.view.frame.size.width - hudlLogo.frame.maxX - 5, height: 35)
        
        interactiveTwitchText.frame = CGRect(x: twitchLogo.frame.maxX + 3, y: twitchText.frame.minY, width: self.view.frame.size.width - twitchLogo.frame.maxX - 5, height: 35)
        
        continueBtn.frame =  CGRect(x: 10.0, y: twitchText.frame.maxY + 15, width: twitchText.frame.width, height: 30)
       continueBtn.layer.cornerRadius = continueBtn.frame.size.width / 20
        cancelBtn.frame =  CGRect(x: 10.0, y: continueBtn.frame.maxY + 10, width: continueBtn.frame.width, height: 30)
       //cancelBtn.layer.cornerRadius = cancelBtn.frame.size.width / 20
        
        // background
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "manaloghourglass")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
        
        //remove borders of interactive textfileds
        interactiveInstagramTxt.borderStyle = .none
        interactiveSnapchatUsernameTxt.borderStyle = .none
        interactiveTwitterHandleTxt.borderStyle = .none
        interactiveSoundCloudText.borderStyle = .none
        interactiveLinkedInText.borderStyle = .none
        interactiveVenmoTxt.borderStyle = .none
        interactiveTikTokText.borderStyle = .none
        interactivePoshmarkTxt.borderStyle = .none
        interactiveHudlText.borderStyle = .none
        interactiveTwitchText.borderStyle = .none
        
        

        
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
        
        // dismiss keyboard
        self.view.endEditing(true)
        let userData = userDataVM?.userData.value
        if userData == nil {
            return
        }
        
        // if fields are empty
        if (interactiveInstagramTxt.text!.isEmpty && interactiveSnapchatUsernameTxt.text!.isEmpty && interactiveTwitterHandleTxt.text!.isEmpty && interactiveSoundCloudText.text!.isEmpty && interactiveLinkedInText.text!.isEmpty && interactiveVenmoTxt.text!.isEmpty && interactiveTikTokText.text!.isEmpty && interactivePoshmarkTxt.text!.isEmpty && interactiveHudlText.text!.isEmpty && interactiveTwitchText.text!.isEmpty) {
            
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
        if (!interactiveInstagramTxt.text!.isEmpty) {
            var myText = interactiveInstagramTxt.text!
            let trimmedText = myText.trimmingCharacters(in: .whitespaces)
            
            numPosts += 1
            let instaHex = HexagonStructData(resource: "https://instagram.com/\(trimmedText)", type: "socialmedia_instagram", location: numPosts, thumbResource: "icons/instagramLogo.png", createdAt: NSDate.now.description, postingUserID: username, text: "\(interactiveInstagramTxt.text!)", views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "@\(trimmedText)", isPrioritized: false, array: [])
            addHex(hexData: instaHex, completion: { bool in
                success = success && bool
                
            })
        }
        
        if (!interactiveSnapchatUsernameTxt.text!.isEmpty) {
            numPosts += 1
            var myText = interactiveSnapchatUsernameTxt.text!
            let trimmedText = myText.trimmingCharacters(in: .whitespaces)
            print("This is trimmedText \(trimmedText)")
            let snapHex = HexagonStructData(resource: "snapchat://add/\(trimmedText)", type: "socialmedia_snapchat", location: numPosts, thumbResource: "icons/snapchatlogo.jpg", createdAt: NSDate.now.description, postingUserID: username, text: trimmedText, views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "\(trimmedText)", isPrioritized: false, array: [])
            addHex(hexData: snapHex, completion: {bool in
                success = success && bool
                
            })
        }
        
        if (!interactiveTwitterHandleTxt.text!.isEmpty) {
            numPosts += 1
            var myText = interactiveTwitterHandleTxt.text!
            let trimmedText = myText.trimmingCharacters(in: .whitespaces)
            let twitterHex = HexagonStructData(resource: "https://twitter.com/\(trimmedText)", type: "socialmedia_twitter", location: numPosts, thumbResource: "icons/twitter.png", createdAt: NSDate.now.description, postingUserID: username, text: trimmedText, views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "@\(trimmedText)", isPrioritized: false, array: [])
            addHex(hexData: twitterHex, completion: {bool in
                success = success && bool
                
            })
        }
        
        if (!interactiveSoundCloudText.text!.isEmpty) {
            numPosts += 1
            var myText = interactiveSoundCloudText.text!
            let trimmedText = myText.trimmingCharacters(in: .whitespaces)
            print("This is trimmedText \(trimmedText)")
            let soundCloudHex = HexagonStructData(resource: trimmedText, type: "socialmedia_soundCloud", location: numPosts, thumbResource: "icons/soundCloudLogo.png", createdAt: NSDate.now.description, postingUserID: username, text: trimmedText, views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "", isPrioritized: false, array: [])
            addHex(hexData: soundCloudHex, completion: {bool in
                success = success && bool
                
            })
        }
        
        if (!interactiveLinkedInText.text!.isEmpty) {
            numPosts += 1
            var myText = interactiveLinkedInText.text!
            let trimmedText = myText.trimmingCharacters(in: .whitespaces)
            print("This is trimmedText \(trimmedText)")
            
            let linkedInHex = HexagonStructData(resource: trimmedText, type: "socialmedia_linkedIn", location: numPosts, thumbResource: "icons/linkedInLogo.jpg", createdAt: NSDate.now.description, postingUserID: username, text: trimmedText, views: 0,isArchived: false, docID: "WillBeSetLater", coverText: "", isPrioritized: false, array: [])
            addHex(hexData: linkedInHex, completion: {bool in
                success = success && bool
                
            })
        }
        
        if (!interactiveVenmoTxt.text!.isEmpty) {
            numPosts += 1
            var myText = interactiveVenmoTxt.text!
            let trimmedText = myText.trimmingCharacters(in: .whitespaces)
            print("This is trimmedText \(trimmedText)")
            let venmoHex = HexagonStructData(resource: "https://venmo.com/\(trimmedText)", type: "socialmedia_venmo", location: numPosts, thumbResource: "icons/venmologo.png", createdAt: NSDate.now.description, postingUserID: username, text: trimmedText, views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "@\(trimmedText)", isPrioritized: false, array: [])
            addHex(hexData: venmoHex, completion: {bool in
                success = success && bool
                
            })
        }
        
        if (!interactiveTikTokText.text!.isEmpty) {
            numPosts += 1
            var myText = interactiveTikTokText.text!
            let trimmedText = myText.trimmingCharacters(in: .whitespaces)
            print("This is trimmedText \(trimmedText)")
            let tikTokHex = HexagonStructData(resource: "https://www.tiktok.com/\(trimmedText)/", type: "socialmedia_tiktok", location: numPosts, thumbResource: "icons/tikTokLogo4.png", createdAt: NSDate.now.description, postingUserID: username, text: "\(trimmedText)", views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "", isPrioritized: false, array: [])
            addHex(hexData: tikTokHex, completion: {bool in
                success = success && bool
                
            })
        }
        
        if (!interactiveHudlText.text!.isEmpty) {
            numPosts += 1
            var myText = interactiveHudlText.text!
            let trimmedText = myText.trimmingCharacters(in: .whitespaces)
            print("This is trimmedText \(trimmedText)")
            let hudlHex = HexagonStructData(resource: "\(trimmedText)/", type: "socialmedia_hudl", location: numPosts, thumbResource: "icons/hudl.png", createdAt: NSDate.now.description, postingUserID: username, text: trimmedText, views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "", isPrioritized: false, array: [])
            addHex(hexData: hudlHex, completion: {bool in
                success = success && bool
                
            })
        }
        if (!interactiveTwitchText.text!.isEmpty) {
            numPosts += 1
            var myText = interactiveTwitchText.text!
            let trimmedText = myText.trimmingCharacters(in: .whitespaces)
            print("This is trimmedText \(trimmedText)")
            let twitchHex = HexagonStructData(resource: "\(trimmedText)/", type: "socialmedia_twitch", location: numPosts, thumbResource: "icons/twitch1.png", createdAt: NSDate.now.description, postingUserID: username, text: "https://m.twitch.tv/\(trimmedText)/profile", views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "", isPrioritized: false, array: [])
            addHex(hexData: twitchHex, completion: {bool in
                success = success && bool
                
            })
        }
        
        
        if (!interactivePoshmarkTxt.text!.isEmpty) {
            numPosts += 1
            var myText = interactivePoshmarkTxt.text!
            let trimmedText = myText.trimmingCharacters(in: .whitespaces)
            print("This is trimmedText \(trimmedText)")
            let poshmarkHex = HexagonStructData(resource: "https://poshmark.com/closet/\(trimmedText)", type: "socialmedia_poshmark", location: numPosts, thumbResource: "icons/poshmarkLogo.png", createdAt: NSDate.now.description, postingUserID: username, text: trimmedText, views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "@\(trimmedText)", isPrioritized: false, array: [])
            addHex(hexData: poshmarkHex, completion: {bool in
                success = success && bool
                
            })
        }
        
        print("passed wait for social media tiles")
        userData?.numPosts = numPosts
        userData?.lastTimePosted = NSDate.now.description
        userDataVM?.updateUserData(newUserData: userData!, completion: { success in
            if success {
                
            }
                //present Home View Controller Segue
            self.performSegue(withIdentifier: "rewindToFront", sender: nil)
            
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
    
    func openTwitch(twitchURl: String) {
       // guard let url = URL(string: "https://instagram.com/\(instagramHandle)")  else { return }
        guard let url = URL(string:twitchURl) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
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

