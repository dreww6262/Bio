//
//  AddMusicVC.swift
//  Bio
//
//  Created by Ann McDonough on 9/14/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
//import Parse
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseUI
import FirebaseFirestore



class AddMusicVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var navBarView = NavBarView()
    
    var poppinsBlack = UIFont(name: "poppins-Black", size: UIFont.labelFontSize)
    var poppinsSemiBold = UIFont(name: "poppins-SemiBold", size: UIFont.labelFontSize)
    
    //    label.font = UIFontMetrics.default.scaledFont(for: customFont)
    //    label.adjustsFontForContentSizeCategory = true
    
    
    
    var bottomLine = CALayer()
    var badMusicLink = false
    var hasChosenThumbnailImage = false
    var artistText = ""
    var songText = ""
    var lowTitleTextFrame = CGRect()
    var lowSubtitleTextFrame = CGRect()
    @IBOutlet weak var songNameTextField: UITextField!
    var musicLink = ""
    var lowLinkLogoFrame = CGRect()
    var lowLinkTextfieldFrame = CGRect()
    var lowSongTextFieldFram = CGRect()
    var lowLinkHexagonImageFrame = CGRect()
    var lowContinueButtonFrame = CGRect()
    var lowCancelButtonFrame = CGRect()
    var highTitleTextFrame = CGRect()
    var highSubtitleTextFrame = CGRect()
    var highLinkLogoFrame = CGRect()
    var highLinkTextfieldFrame = CGRect()
    var highLinkHexagonImageFrame = CGRect()
    var highContinueButtonFrame = CGRect()
    var highCancelButtonFrame = CGRect()
    var highSongTextFieldFrame = CGRect()
    
    
    
    @IBOutlet weak var linkLogo: UIImageView!
    
    // scrollView
    @IBOutlet weak var scrollView: UIScrollView!
    
    // textfields
    @IBOutlet weak var linkTextField: UITextField!
    
    @IBOutlet weak var linkHexagonImage: UIImageView!
    // buttons
    var postButton = UIButton()
    var backButton = UIButton()
    
    var currentUser: User? = Auth.auth().currentUser
    var userData: UserData?
    var userDataRef: DocumentReference? = nil
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    var cancelLbl: String?
    
    @IBOutlet weak var changeCoverLabel: UILabel!
    
    // reset default size
    var scrollViewHeight : CGFloat = 0
    
    // keyboard frame size
    var keyboard = CGRect()
    
    
    // default func
    override func viewDidLoad() {
        linkHexagonImage.isHidden = false
//        confirmLinkButton.isHidden = true
        setUpNavBarView()
        //        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        //        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        //                NotificationCenter.default.addObserver(self, selector: #selector(self.keyboard(notification:)), name:UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        
        var alreadySnapped = false
        super.viewDidLoad()
        
        if (userData == nil) {
            print("userdata is nil")
        }
        else {
            print("loaded addVC with userdata: \(userData!.publicID) and user \(currentUser!.email)")
        }
        
        let linkTap = UITapGestureRecognizer(target: self, action: #selector(AddLinkVCViewController.loadImg(_:)))
        linkTap.numberOfTapsRequired = 1
        linkHexagonImage.isUserInteractionEnabled = true
        linkHexagonImage.addGestureRecognizer(linkTap)
        
        
        
        //poshmarkLogo.image = UIImage(named: "poshmarkLogo")
        let gold = #colorLiteral(red: 0.9882352941, green: 0.7607843137, blue: 0, alpha: 1)
        let gray = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        let orange = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        
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
//        cancelBtn.layer.cornerRadius = cancelBtn.frame.size.width / 20
//        titleText.frame = CGRect(x: 0,y:60, width: self.view.frame.size.width, height: 30)
//        subtitleText.frame = CGRect(x:0, y: titleText.frame.origin.y + 30, width: self.view.frame.size.width, height: 30)
        
        
        
        
        //         linkHexagonImage.frame = CGRect(x: 10, y: linkTextField.frame.origin.y + 30, width: self.view.frame.size.width - 20, height: 30)
        
        
        
//        linkTextField.frame = CGRect(x: 10, y: subtitleText.frame.maxY + 20, width: self.view.frame.size.width - 20, height: 30)
//        linkTextField.attributedPlaceholder = NSAttributedString(string: "Artist",
//                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
//        linkLogo.frame = CGRect(x: scrollView.frame.width - 40, y: linkTextField.frame.minY, width: 30, height: 30)
//
//        songNameTextField.frame = CGRect(x: 10, y: linkTextField.frame.maxY + 5, width: self.view.frame.size.width - 20, height: 30)
//        songNameTextField.attributedPlaceholder = NSAttributedString(string: "Song/Album Name (Optional)",
//                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        //               linkLogo.frame = CGRect(x: scrollView.frame.width - 40, y: linkTextField.frame.minY, width: 30, height: 30)
        //
        //    changeCoverLabel.frame = CGRect(x: 10, y: songNameTextField.frame.origin.y + 10, width: self.view.frame.size.width - 20, height: 30)
        
        
       // confirmLinkButton.frame =  CGRect(x: 10.0, y: linkTextField.frame.maxY + 10, width: self.view.frame.width - 20, height: 24)
    //    confirmLinkButton.layer.cornerRadius = continueBtn.frame.size.width / 20
        linkHexagonImage.frame = CGRect(x: 40, y: navBarView.frame.maxY + 10, width: scrollView.frame.width - 80, height: scrollView.frame.width - 80)
        
        linkHexagonImage.setupHexagonMask(lineWidth: linkHexagonImage.frame.width/15, color: myBlueGreen, cornerRadius: linkHexagonImage.frame.width/15)
        linkTextField.frame = CGRect(x: 10, y: linkHexagonImage.frame.maxY + 20, width: self.view.frame.size.width - 20, height: 30)
        linkTextField.attributedPlaceholder = NSAttributedString(string: "Artist",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        linkLogo.frame = CGRect(x: scrollView.frame.width - 40, y: linkTextField.frame.minY, width: 30, height: 30)
        
        songNameTextField.frame = CGRect(x: 10, y: linkTextField.frame.maxY + 5, width: self.view.frame.size.width - 20, height: 30)
        songNameTextField.attributedPlaceholder = NSAttributedString(string: "Song/Album Name (Optional)",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
   
     
        
        
        
        // set up Top View
//        let topBar = UIView()
//        view.addSubview(topBar)
//        topBar.backgroundColor = .clear
//        // topBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/15)
//        topBar.frame = CGRect(x: -5, y: -5, width: self.view.frame.width + 10, height: (self.view.frame.height/10)+5)
//        topBar.backgroundColor = UIColor(cgColor: CGColor(gray: 0.05, alpha: 1.0))
//        topBar.layer.borderWidth = 0.25
//        topBar.layer.borderColor = CGColor(gray: 2/3, alpha: 1.0)
//        let backButton = UIButton()
//        topBar.addSubview(backButton)
//        backButton.imageView?.image?.withTintColor(.white)
//        backButton.tintColor = .white
//        backButton.imageView?.tintColor = white
//        let backTap = UITapGestureRecognizer(target: self, action: #selector(backTapped))
//        let postTap = UITapGestureRecognizer(target: self, action: #selector(postTapped))
//        var addMusicLabel = UILabel()
//        backButton.addGestureRecognizer(backTap)
//        backButton.sizeToFit()
//      //  backButton.frame = CGRect(x: 5, y: (topBar.frame.height/4), width: topBar.frame.height/2, height: topBar.frame.height/2)
//        backButton.frame = CGRect(x: 15, y: topBar.frame.maxY - 25, width: 20, height: 20)
//        backButton.setBackgroundImage(UIImage(named: "whiteBack"), for: .normal)
//
//        topBar.addSubview(addMusicLabel)
//       // addMusicLabel.frame = CGRect(x: (topBar.frame.width/2) - 60, y: 0, width: 120, height: topBar.frame.height)
//        addMusicLabel.frame = CGRect(x: (topBar.frame.width/2) - 60, y: topBar.frame.maxY - 25, width: 120, height: 25)
//        addMusicLabel.text = "Add Music"
//        addMusicLabel.textColor = white
//        addMusicLabel.font.withSize(40)
//        // addLinkLabel.
//
//        addMusicLabel.textAlignment = .center
//
//        backButton.imageView?.frame = backButton.frame
//        // backButton.imageView?.image = UIImage(named: "whiteBack")
//
//        let postButton = UIButton()
//        topBar.addSubview(postButton)
//        postButton.addGestureRecognizer(postTap)
//        postButton.setTitle("Next", for: .normal)
//        postButton.setTitleColor(.systemBlue, for: .normal)
//      //  postButton.frame = CGRect(x: (self.view.frame.width) - (topBar.frame.height) - 5, y: 0, width: topBar.frame.height, height: topBar.frame.height)
//      //  postButton.frame = CGRect(x: (self.view.frame.width) - 40, y: topBar.frame.maxY - 25, width: 40, height: 25)
//        postButton.titleLabel?.sizeToFit()
//        postButton.titleLabel?.textAlignment = .right
        
        setUpNavBarView()
        
        
        // set up link text Field
        
        
        linkTextField.attributedPlaceholder = NSAttributedString(string: "Artist Name (Required)",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        linkLogo.frame = CGRect(x: scrollView.frame.width - 40, y: linkTextField.frame.minY, width: 30, height: 30)
        
        linkHexagonImage.frame = CGRect(x: 40, y: self.navBarView.frame.maxY + 10, width: scrollView.frame.width - 80, height: scrollView.frame.width - 80)
        
        linkTextField.frame = CGRect(x: 10, y: linkHexagonImage.frame.maxY, width: self.view.frame.size.width - 20, height: 30)
        songNameTextField.frame = CGRect(x: 10, y: linkTextField.frame.maxY + 10, width: self.view.frame.size.width - 20, height: 30)
        
        // let bottomLine = CALayer()
        self.bottomLine.frame = CGRect(x: 0.0, y: linkTextField.frame.height, width: linkTextField.frame.width, height: 1.0)
        self.bottomLine.backgroundColor = UIColor.systemGray4.cgColor
        var bottomLine2 = CALayer()
        bottomLine2.frame = CGRect(x: 0.0, y: songNameTextField.frame.height, width: linkTextField.frame.width, height: 1.0)
        bottomLine2.backgroundColor = UIColor.systemGray4.cgColor
        linkTextField.borderStyle = UITextField.BorderStyle.none
        linkTextField.layer.addSublayer(self.bottomLine)
        linkTextField.backgroundColor = .clear
        songNameTextField.borderStyle = UITextField.BorderStyle.none
        songNameTextField.layer.addSublayer(bottomLine2)
        songNameTextField.backgroundColor = .clear
        linkLogo.frame = CGRect(x: scrollView.frame.width - 40, y: linkTextField.frame.minY, width: 30, height: 30)
        
        
        linkTextField.font = UIFont(name: "Poppins", size: 20)
        
        
    
        linkTextField.textColor = .white
        songNameTextField.textColor = .white
        
//        addMusicLabel.font = UIFontMetrics.default.scaledFont(for: poppinsSemiBold ?? UIFont(name: "DINAlternate-Bold", size: 22)!)
//        addMusicLabel.adjustsFontForContentSizeCategory = true
        
        postButton.titleLabel?.font = UIFontMetrics.default.scaledFont(for: poppinsSemiBold ?? UIFont(name: "DINAlternate-Bold", size: 20)!)
        postButton.titleLabel!.adjustsFontForContentSizeCategory = true
        
        
    }
    
    func setUpNavBarView() {
        var statusBarHeight = UIApplication.shared.statusBarFrame.height
        print("This is status bar height \(statusBarHeight)")
        self.view.addSubview(navBarView)
        self.navBarView.addSubview(backButton)
        self.navBarView.addSubview(postButton)
        self.navBarView.frame = CGRect(x: -5, y: -5, width: self.view.frame.width + 10, height: (self.view.frame.height/12)+5)
       
        var navBarHeightRemaining = navBarView.frame.maxY - statusBarHeight
        navBarView.backButton.isHidden = true
        navBarView.postButton.isHidden = true
//        self.navBarView.addSubview(toSettingsButton)
//        self.navBarView.addSubview(toSearchButton)
        
        if cancelLbl != nil {
            backButton.setTitle(cancelLbl, for: .normal)
            backButton.setTitleColor(.systemBlue, for: .normal)
            backButton.titleLabel?.font = UIFont(name: "poppins-SemiBold", size: 14)
            //navBarView.backButton.setImage(UIImage(), for: .normal)
            let skipOverride = UITapGestureRecognizer(target: self, action: #selector(skipTapped))
            backButton.addGestureRecognizer(skipOverride)
        }
        else {
            let backTap = UITapGestureRecognizer(target: self, action: #selector(self.backButtonpressed))
            backTap.numberOfTapsRequired = 1
            backButton.isUserInteractionEnabled = true
            backButton.addGestureRecognizer(backTap)
            backButton.setImage(UIImage(named: "whiteChevron"), for: .normal)
        }
        
        let postTap = UITapGestureRecognizer(target: self, action: #selector(self.postTapped))
        postTap.numberOfTapsRequired = 1
        postButton.isUserInteractionEnabled = true
        postButton.addGestureRecognizer(postTap)
        postButton.setTitle("Next", for: .normal)
        postButton.setTitleColor(.systemBlue, for: .normal)
      //  postButton.frame = CGRect(x: (self.view.frame.width) - (topBar.frame.height) - 5, y: 0, width: topBar.frame.height, height: topBar.frame.height)
        postButton.titleLabel?.sizeToFit()
        postButton.titleLabel?.textAlignment = .right
        
    
        self.backButton.frame = CGRect(x: 10, y: statusBarHeight + (navBarHeightRemaining - 25)/2, width: 25, height: 25)
        //self.backButton.frame = CGRect(x: 10, y: (navBarView.frame.height - 25)/2, width: 25, height: 25)
        
        //backButton.sizeToFit()
        postButton.frame = CGRect(x: navBarView.frame.width - 50, y: statusBarHeight + (navBarHeightRemaining - 30)/2, width: 40, height: 30)
        //navBarView.postButton.titleLabel?.sizeToFit()
        navBarView.postButton.titleLabel?.textAlignment = .right
        let yOffset = navBarView.frame.maxY
  
        self.navBarView.addBehavior()
        self.navBarView.titleLabel.text = "Add Music"
        self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y: navBarView.frame.maxY - 30, width: 200, height: 30)
        print("This is navBarView.")
      
      
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        print("userData, view will appear: \(userData)")
        hasChosenThumbnailImage = false
    }
    
    @objc func skipTapped(_ sender: UITapGestureRecognizer) {
        let linkVC = storyboard?.instantiateViewController(withIdentifier: "linkVC") as! AddLinkVCViewController
        linkVC.userData = userData
        linkVC.currentUser = currentUser
        linkVC.cancelLbl = "Skip"
        self.present(linkVC, animated: false, completion: nil)
    }
    // hide keyboard if tapped
    @objc func hideKeyboardTap(_ recoginizer:UITapGestureRecognizer) {
        //   pushEverythingDown()
        self.view.endEditing(true)
    }
    
    @objc func backButtonpressed() {
        print("It should dismiss here")
        self.dismiss(animated: true)
     }
    
  
    
    //    @objc func keyboard(notification:Notification) {
    //        guard let keyboardReact = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
    //            return
    //        }
    //
    //        if notification.name == UIResponder.keyboardWillShowNotification ||  notification.name == UIResponder.keyboardWillChangeFrameNotification {
    //            self.view.frame.origin.y = -keyboardReact.height
    //        }else{
    //            self.view.frame.origin.y = 0
    //        }
    //
    //    }
    
    
    
    
  
    
    // show keyboard
    @objc func showKeyboard(_ notification:Notification) {
        // pushEverythingUp()
        
        
        
        // define keyboard size
        keyboard = ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue)!
        
        // move up UI
        //        UIView.animate(withDuration: 0.4, animations: { () -> Void in
        //            self.scrollView.frame.size.height = self.scrollViewHeight - self.keyboard.height
        //        })
        
        
    }
    
    
    
    @objc func keyboard(notification:Notification) {
        guard let keyboardReact = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification ||  notification.name == UIResponder.keyboardWillChangeFrameNotification {
            // self.view.frame.origin.y = -keyboardReact.height
            self.view.frame.origin.y = -self.bottomLine.frame.maxY
        }else{
            self.view.frame.origin.y = 0
        }
        
    }
    
    
    @objc func backTapped(_ sender: UITapGestureRecognizer) {
        print("back hit!")
        for v in view.subviews {
            v.isHidden = true
        }
        self.dismiss(animated: false, completion: nil)
    }
    
    // hide keyboard func
    @objc func hideKeybard(_ notification:Notification) {
        //    pushEverythingDown()
        // move down UI
        //        UIView.animate(withDuration: 0.4, animations: { () -> Void in
        //            self.scrollView.frame.size.height = self.view.frame.height
        //        })
    }
    
    func addHex(hexData: HexagonStructData, completion: @escaping (Bool) -> Void) {
        let hexCollectionRef = db.collection("Hexagons2")
        let hexDoc = hexCollectionRef.document()
        var hexCopy = HexagonStructData(dictionary: hexData.dictionary)
        hexCopy.docID = hexDoc.documentID
        hexDoc.setData(hexCopy.dictionary){ error in
            //     group.leave()
            if error == nil {
                print("added hex: \(hexData)")
                completion(true)
            }
            else {
                print("failed to add hex \(hexData)")
                completion(false)
            }
        }
    }
    
   
//
//    @IBAction func confirmButtonClicked(_ sender: UIButton) {
//        createMusicLink()
//
//        //   continueBtn.isHidden = false
//        linkHexagonImage.isHidden = false
//        linkHexagonImage.frame = CGRect(x: linkHexagonImage.frame.minX, y: navBarView.frame.maxY + 10, width: linkHexagonImage.frame.width, height: linkHexagonImage.frame.height)
//    }
    
    func createMusicLink() {
        var artistTextBefore = linkTextField.text?.replacingOccurrences(of: "'", with: "")
        artistText = artistTextBefore?.replacingOccurrences(of: " ", with: "-") as! String
        var songTextBad = songNameTextField.text?.replacingOccurrences(of: " ", with: "-")
        songText = songTextBad?.replacingOccurrences(of: "'", with: "") as! String
        while songText.contains("'") {
            songText.remove(at: songText.firstIndex(of: "'")!)
        }
        while artistText.contains("'") {
            artistText.remove(at: artistText.firstIndex(of: "'")!)
        }
        while songText.contains(" ") {
            songText.remove(at: songText.firstIndex(of: " ")!)
        }
        while artistText.contains(" ") {
            artistText.remove(at: artistText.firstIndex(of: " ")!)
        }
        
        musicLink = "https://songwhip.com/\(artistText)/\(songText)"
        print("This is music Link. Try it yourself! \(musicLink)")
        if artistText == "" {
            badMusicLink = true
        }
        
    }
    
    
    // call picker to select image
    @objc func postTapped(_ recognizer:UITapGestureRecognizer) {
        print("continue button pressed")
        createMusicLink()
        
        let username = userData!.publicID
        var numPosts = userData!.numPosts
        
        if numPosts + 1 > 37 {
            // too many posts
            let alert = UIAlertController(title: "Not Enough Space :/", message: "Either cancel or delete a post from your home grid.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        if hasChosenThumbnailImage == false {
            loadImg(UITapGestureRecognizer())
        }
        else {
            
            // dismiss keyboard
            self.view.endEditing(true)
            
            // if fields are empty
            if (linkTextField.text!.isEmpty) {
                
                // alert message
                let alert = UIAlertController(title: "Hold up", message: "Fill in a field or hit Cancel", preferredStyle: UIAlertController.Style.alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            
            
            
            
            
            //let group = DispatchGroup()
            if (!linkTextField.text!.isEmpty) {
                let timestamp = Timestamp.init().seconds
                let imageFileName = "\(username)_\(timestamp)_link.png"
                let refText = "userFiles/\(username)/\(imageFileName)"
                let imageRef = storageRef.child(refText)
                numPosts += 1
                print("music link before \(musicLink)")
                musicLink = musicLink.replacingOccurrences(of: " ", with: "-")
                musicLink = musicLink.replacingOccurrences(of: "'", with: "")
                musicLink.trimmingCharacters(in: ["'", "!", "?"])
                print("music Link after \(musicLink)")
                let musicHex = HexagonStructData(resource: musicLink, type: "music", location: numPosts, thumbResource: refText, createdAt: NSDate.now.description, postingUserID: username, text: musicLink, views: 0, isArchived: false, docID: "WillBeSetLater")
                let previewVC = storyboard?.instantiateViewController(identifier: "linkPreview") as! LinkPreviewVC
                previewVC.webHex = musicHex
                previewVC.thumbImage = linkHexagonImage.image
                previewVC.userData = userData
                previewVC.modalPresentationStyle = .fullScreen
                previewVC.cancelLbl = cancelLbl
                self.present(previewVC, animated: false, completion: nil)
                
            }
            
        }
    }
    
    
    // clicked sign up
    @IBAction func continueClicked(_ sender: AnyObject) {
        print("continue button pressed")
        
        let username = userData!.publicID
        var numPosts = userData!.numPosts
        
        if numPosts + 1 > 37 {
            // too many posts
            let alert = UIAlertController(title: "Not Enough Space :/", message: "Either cancel or delete a post from your home grid.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        if hasChosenThumbnailImage == false {
            loadImg(UITapGestureRecognizer())
        }
        else {
            
            // dismiss keyboard
            self.view.endEditing(true)
            
            // if fields are empty
            if (linkTextField.text!.isEmpty) {
                
                // alert message
                let alert = UIAlertController(title: "Hold up", message: "Fill in a field or hit Cancel", preferredStyle: UIAlertController.Style.alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            
            
            
            
            
            //let group = DispatchGroup()
            if (!linkTextField.text!.isEmpty) {
                let timestamp = Timestamp.init().seconds
                let imageFileName = "\(username)_\(timestamp)_link.png"
                let refText = "userFiles/\(username)/\(imageFileName)"
                let imageRef = storageRef.child(refText)
                numPosts += 1
                print("music link before \(musicLink)")
                musicLink = musicLink.replacingOccurrences(of: " ", with: "-")
                musicLink = musicLink.replacingOccurrences(of: "'", with: "")
                musicLink.trimmingCharacters(in: ["'", "!", "?"])
                print("music Link after \(musicLink)")
                let musicHex = HexagonStructData(resource: musicLink, type: "music", location: numPosts, thumbResource: refText, createdAt: NSDate.now.description, postingUserID: username, text: musicLink, views: 0, isArchived: false, docID: "WillBeSetLater")
                
                
                
                
                imageRef.putData(linkHexagonImage.image!.pngData()!, metadata: nil){ data, error in
                    if (error == nil) {
                        print ("upload successful")
                        self.addHex(hexData: musicHex, completion: { bool in
                            if (bool) {
                                print("Add hex successful")
                            }
                            else {
                                print("didnt add hex")
                            }
                        })
                    }
                    else {
                        print ("upload failed")
                    }
                }
                
                
                userData?.numPosts = numPosts
                db.collection("UserData1").document(currentUser!.uid).setData(self.userData!.dictionary, completion: { error in
                    if error == nil {
                        print("userdata updated successfully")
                        self.performSegue(withIdentifier: "unwindFromLinkToHome", sender: nil)
                    }
                    else {
                        print("userData not saved \(error?.localizedDescription)")
                    }
                    
                })
            }
            
        }
    }
    
    
    // call picker to select image
    @objc func loadImg(_ recognizer:UITapGestureRecognizer) {
        self.hasChosenThumbnailImage = true
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    
    // connect selected image to our ImageView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        linkHexagonImage.image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage
        //        if let imageURL = info[UIImagePickerController.InfoKey.referenceURL.rawValue] as? URL {
        //            let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
        //            avaImageExtension = String((result.firstObject?.value(forKey: "filename") as! String).split(separator: ".")[1])
        //            print("extension \(avaImageExtension)")
        //        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    // clicked cancel
    @IBAction func cancelBtn_click(_ sender: AnyObject) {
        print("hit cancel button")
        // hide keyboard when pressed cancel
        self.view.endEditing(true)
        print("should dismiss vc")
        self.dismiss(animated: true, completion: nil)
        
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}

extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}
