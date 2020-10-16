//
//  AddLinkVCViewController.swift
//  Bio
//
//  Created by Ann McDonough on 8/12/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//


import UIKit
//import Parse
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseUI
import FirebaseFirestore

class AddLinkVCViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var navBarView = NavBarView()
    let bottomLine = CALayer()
    var hasChosenThumbnailImage = false
    var lowTitleTextFrame = CGRect()
    var validURL = false
    var lowSubtitleTextFrame = CGRect()
    var lowLinkLogoFrame = CGRect()
    var lowLinkTextfieldFrame = CGRect()
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
    var addLinkLabel = UILabel()
    var cancelLbl: String?
    
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var subtitleText: UILabel!
    
    @IBOutlet weak var linkLogo: UIImageView!
    
    
    // scrollView
    @IBOutlet weak var scrollView: UIScrollView!
    
    // profile image
    
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
    
    @IBOutlet weak var changeCoverLabel: UILabel!
    
    // reset default size
    var scrollViewHeight : CGFloat = 0
    
    // keyboard frame size
    var keyboard = CGRect()
    
    
    // default func
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboard(notification:)), name:UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        
        var alreadySnapped = false
        super.viewDidLoad()
        titleText.isHidden = true
        subtitleText.isHidden = true
        
        setUpNavBarView()
        
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
    
        titleText.frame = CGRect(x: 0,y:60, width: self.view.frame.size.width, height: 30)
        subtitleText.frame = CGRect(x:0, y: titleText.frame.origin.y + 30, width: self.view.frame.size.width, height: 30)
        
        
        
        
        //         linkHexagonImage.frame = CGRect(x: 10, y: linkTextField.frame.origin.y + 30, width: self.view.frame.size.width - 20, height: 30)
 
        


        // background
  
        
        
        
        
        // set up link text Field
       // linkTextField.frame = CGRect(x: 10, y: addLinkLabel.frame.maxY + 40, width: self.view.frame.size.width - 20, height: 30)
        linkTextField.attributedPlaceholder = NSAttributedString(string: "Paste Link Here",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    
        
    //    linkHexagonImage.frame = CGRect(x: 40, y: linkTextField.frame.minY, width: scrollView.frame.width - 80, height: scrollView.frame.width - 80)
        linkTextField.frame = CGRect(x: 10, y: linkHexagonImage.frame.maxY, width: self.view.frame.size.width - 20, height: 30)
     //   linkLogo.frame = CGRect(x: scrollView.frame.width - 40, y: linkTextField.frame.minY, width: 30, height: 30)
      
        self.bottomLine.frame = CGRect(x: 0.0, y: linkTextField.frame.height, width: linkTextField.frame.width, height: 1.0)
        self.bottomLine.backgroundColor = UIColor.systemGray4.cgColor
        linkTextField.borderStyle = UITextField.BorderStyle.none
        linkTextField.layer.addSublayer(self.bottomLine)
        linkTextField.backgroundColor = .clear
        linkTextField.font = UIFont(name: "Poppins", size: 20)
        linkTextField.textColor = .white
        
        
        linkHexagonImage.frame = CGRect(x: 40, y: navBarView.frame.maxY + 10, width: scrollView.frame.width - 80, height: scrollView.frame.width - 80)
        changeCoverLabel.frame = CGRect(x: 10, y: linkHexagonImage.frame.origin.y + scrollView.frame.width/2, width: self.view.frame.size.width - 20, height: 30)
        
        
        linkTextField.frame = CGRect(x: 10, y: linkHexagonImage.frame.maxY, width: self.view.frame.size.width - 20, height: 30)
        linkTextField.attributedPlaceholder = NSAttributedString(string: "Paste Link Here",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        linkLogo.frame = CGRect(x: scrollView.frame.width - 40, y: linkTextField.frame.minY, width: 30, height: 30)
        linkHexagonImage.setupHexagonMask(lineWidth: linkHexagonImage.frame.width/15, color: myCoolBlue, cornerRadius: linkHexagonImage.frame.width/15)
        addLinkLabel.font = UIFont(name: "DINAlternate-Bold", size: 22)
        postButton.titleLabel!.font = UIFont(name: "DINAlternate-Bold", size: 19)
        
    }
    
    var navBarView = NavBarView()
    
    override func viewWillAppear(_ animated: Bool) {
        print("userData, view will appear: \(userData)")
        if cancelLbl != nil {
            navBarView.backButton.setTitle(cancelLbl, for: .normal)
            navBarView.backButton.setImage(UIImage(), for: .normal)
            navBarView.removeGestureRecognizer(navBarView.backButton.gestureRecognizers![0])
            let skipOverride = UITapGestureRecognizer(target: self, action: #selector(skipTapped))
        }
        hasChosenThumbnailImage = false 
    }
    
    @objc func skipTapped(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "rewindToFront", sender: self)
    }
    
    // hide keyboard if tapped
    @objc func hideKeyboardTap(_ recoginizer:UITapGestureRecognizer) {
        //   pushEverythingDown()
        self.view.endEditing(true)
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
        
        let backTap = UITapGestureRecognizer(target: self, action: #selector(self.backButtonpressed))
        backTap.numberOfTapsRequired = 1
        backButton.isUserInteractionEnabled = true
        backButton.addGestureRecognizer(backTap)
        backButton.setImage(UIImage(named: "whiteChevron"), for: .normal)
        
        let postTap = UITapGestureRecognizer(target: self, action: #selector(self.postTapped))
        postTap.numberOfTapsRequired = 1
        postButton.isUserInteractionEnabled = true
        postButton.addGestureRecognizer(postTap)
        postButton.setTitle("Next", for: .normal)
        postButton.setTitleColor(myCoolBlue, for: .normal)
      //  postButton.frame = CGRect(x: (self.view.frame.width) - (topBar.frame.height) - 5, y: 0, width: topBar.frame.height, height: topBar.frame.height)
        postButton.titleLabel?.sizeToFit()
        postButton.titleLabel?.textAlignment = .right
        
    
       backButton.frame = CGRect(x: 10, y: statusBarHeight + (navBarHeightRemaining - 25)/2, width: 25, height: 25)
        postButton.frame = CGRect(x: navBarView.frame.width - 50, y: statusBarHeight + (navBarHeightRemaining - 30)/2, width: 40, height: 30)
        //navBarView.postButton.titleLabel?.sizeToFit()
        navBarView.postButton.titleLabel?.textAlignment = .right
        let yOffset = navBarView.frame.maxY
  
        self.navBarView.addBehavior()
        self.navBarView.titleLabel.text = "Add A Link"
        print("This is navBarView.")
      
      
    }
    
    @objc func backButtonpressed() {
        print("It should dismiss here")
        self.dismiss(animated: true)
     }
    
    
    
    @objc func keyboard(notification:Notification) {
        guard let keyboardReact = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification ||  notification.name == UIResponder.keyboardWillChangeFrameNotification {
           // self.view.frame.origin.y = -keyboardReact.height
      //      self.view.frame.origin.y = -self.bottomLine.frame.maxY
        }else{
            self.view.frame.origin.y = 0
        }
        
    }
    
    
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
    
    
    // hide keyboard func
    @objc func hideKeybard(_ notification:Notification) {
        //    pushEverythingDown()
        // move down UI
        //        UIView.animate(withDuration: 0.4, animations: { () -> Void in
        //            self.scrollView.frame.size.height = self.view.frame.height
        //        })
    }
    
    
    
    @objc func backTapped(_ sender: UITapGestureRecognizer) {
        print("back hit!")
        for v in view.subviews {
            v.isHidden = true
        }
        self.dismiss(animated: false, completion: nil)
    }
    
    
        
    
    // clicked sign up
    @objc func postTapped(_ sender: UITapGestureRecognizer) {
        let username = userData!.publicID
        let numPosts = userData!.numPosts
        
        if numPosts + 1 > 37 {
            // too many posts
            let alert = UIAlertController(title: "Not Enough Space :/", message: "Either cancel this or delete a post from your home grid and try again.", preferredStyle: .alert)
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
    
            let linkString = "\(linkTextField.text!)"
            print("This is linkString \(linkString)")
            let url = URL(string: linkString)
            if linkString.isValidURL {
                print("linkString is valid URL")
                validURL = true
            }
            else {
                print("linkString is not valid URL \(linkString)")
                validURL = false
            }
            
            //let group = DispatchGroup()
            if (!linkTextField.text!.isEmpty && validURL) {
                let timestamp = Timestamp.init().seconds
                let imageFileName = "\(username)_\(timestamp)_link.png"
                let refText = "userFiles/\(username)/\(imageFileName)"
                let linkHex = HexagonStructData(resource: linkTextField.text!, type: "link", location: numPosts + 1, thumbResource: refText, createdAt: NSDate.now.description, postingUserID: username, text: "\(linkTextField.text!)", views: 0, isArchived: false, docID: "WillBeSetLater")
                let previewVC = storyboard?.instantiateViewController(identifier: "linkPreview") as! LinkPreviewVC
                previewVC.webHex = linkHex
                previewVC.thumbImage = linkHexagonImage.image
                previewVC.userData = userData
                previewVC.modalPresentationStyle = .fullScreen
                self.present(previewVC, animated: false, completion: nil)
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

