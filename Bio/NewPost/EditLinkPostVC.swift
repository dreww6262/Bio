//
//  EditLinkPostVC.swift
//  Bio
//
//  Created by Ann McDonough on 11/24/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
//import Parse
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseUI
import FirebaseFirestore

class EditLinkPostVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    var changedProfilePic = false
    var textOverlayLabel = UILabel()
    var navBarView = NavBarView()
    var bottomLine = CALayer()
    var bottomLine2 = CALayer()
    var bottomLine3 = CALayer()
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
    
    var titleText = UILabel()
    var subtitleText = UILabel()
    var hexData: HexagonStructData?
    var captionString = ""
    var textOverlayString = ""
    var originalCaption = ""
    var originalTextOverlay = ""
    var originalPriority = false
    var changedPhoto = false
    @IBOutlet weak var linkLogo: UIImageView!
    
    
    // scrollView
    @IBOutlet weak var scrollView: UIScrollView!
    
    // profile image
    
    // textfields
    var linkTextField = UITextField()
    var captionTextField = UITextField()
    var textOverlayTextField = UITextField()
    
    var linkHexagonImage = UIImageView()
    var linkHexagonImageCopy = UIImageView()
    // buttons
    
    var postButton = UIButton()
    var backButton = UIButton()
    
    var currentUser: User? = Auth.auth().currentUser
    var userDataVM: UserDataVM?
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    
    var prioritizeLabel = UILabel()
    var checkBox = UIButton()
    var checkBoxStatus = false
    
    
    @IBOutlet weak var changeCoverLabel: UILabel!
    
    // reset default size
    var scrollViewHeight : CGFloat = 0
    
    // keyboard frame size
    var keyboard = CGRect()
    
    
    // default func
    override func viewDidLoad() {
        textOverlayLabel.isHidden = true
        linkLogo.isHidden = true
        scrollView.addSubview(captionTextField)
        scrollView.addSubview(textOverlayTextField)
        scrollView.addSubview(prioritizeLabel)
        scrollView.addSubview(linkHexagonImage)
        scrollView.addSubview(linkTextField)
        scrollView.addSubview(checkBox)
        captionTextField.text = captionString
        originalTextOverlay = textOverlayString
        originalCaption = captionString
        originalPriority = checkBoxStatus
        textOverlayLabel.text = textOverlayString
        if textOverlayString != "" {
            textOverlayLabel.isHidden = false
        }
        let checkBoxTap = UITapGestureRecognizer(target: self, action: #selector(checkBoxTapped(_:)))
        checkBox.addGestureRecognizer(checkBoxTap)
        checkBox.setImage(UIImage(named: "blueEmpty"), for: .normal)
        textOverlayTextField.delegate = self
        
        linkHexagonImageCopy.contentMode = .scaleAspectFit
       // linkHexagonImageCopy.image = UIImage(named: "addCover")
        scrollView.addSubview(linkHexagonImageCopy)
        linkHexagonImage.isHidden = false
        linkHexagonImageCopy.isHidden = true
        
        let linkTapCopy = UITapGestureRecognizer(target: self, action: #selector(AddLinkVCViewController.loadImg(_:)))
        linkHexagonImageCopy.isUserInteractionEnabled = true
        linkHexagonImageCopy.addGestureRecognizer(linkTapCopy)
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboard(notification:)), name:UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        
        var alreadySnapped = false
        super.viewDidLoad()
        titleText.isHidden = true
        subtitleText.isHidden = true
        
        setUpNavBarView()
        
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
        
        titleText.frame = CGRect(x: 0,y:60, width: self.view.frame.size.width, height: 30)
        subtitleText.frame = CGRect(x:0, y: titleText.frame.origin.y + 30, width: self.view.frame.size.width, height: 30)
        
        

        linkTextField.attributedPlaceholder = NSAttributedString(string: "Paste Link Here",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    
      
        
        linkHexagonImage.frame = CGRect(x: 40, y: navBarView.frame.maxY + 10, width: scrollView.frame.width - 80, height: scrollView.frame.width - 80)
        
        linkHexagonImageCopy.frame = CGRect(x: 40, y: navBarView.frame.maxY + 10, width: scrollView.frame.width - 80, height: scrollView.frame.width - 80)
        
        linkHexagonImageCopy.setupHexagonMask(lineWidth: linkHexagonImageCopy.frame.width/15, color: myCoolBlue, cornerRadius: linkHexagonImageCopy.frame.width/15)
        
        changeCoverLabel.frame = CGRect(x: 10, y: linkHexagonImage.frame.origin.y + scrollView.frame.width/2, width: self.view.frame.size.width - 20, height: 30)
        linkTextField.frame = CGRect(x: 10, y: linkHexagonImage.frame.maxY, width: self.view.frame.size.width - 20, height: 30)
        
        captionTextField.frame = CGRect(x: 10, y: linkTextField.frame.maxY + 10, width: self.view.frame.size.width - 20, height: 30)
        
        textOverlayTextField.frame = CGRect(x: 10, y: captionTextField.frame.maxY + 10, width: self.view.frame.size.width - 20, height: 30)
        
        prioritizeLabel.frame = CGRect(x: 10, y: textOverlayTextField.frame.maxY + 5, width: self.view.frame.size.width - 20, height: 30)
        prioritizeLabel.text = "Prioritize This Post?"
                checkBox.frame = CGRect(x: 165, y: textOverlayTextField.frame.maxY + 5, width: 30, height: 30)
        prioritizeLabel.textColor = .white
        
        
        self.bottomLine.frame = CGRect(x: 0.0, y: linkTextField.frame.height, width: linkTextField.frame.width, height: 1.0)
        self.bottomLine.backgroundColor = UIColor.systemGray4.cgColor
        linkTextField.borderStyle = UITextField.BorderStyle.none
        linkTextField.layer.addSublayer(self.bottomLine)
        linkTextField.backgroundColor = .clear
        linkTextField.font = UIFont(name: "Poppins", size: 20)
        linkTextField.textColor = .white
        
        self.bottomLine2.frame = CGRect(x: 0.0, y: captionTextField.frame.height, width: captionTextField.frame.width, height: 1.0)
        self.bottomLine2.backgroundColor = UIColor.systemGray4.cgColor
        captionTextField.borderStyle = UITextField.BorderStyle.none
        captionTextField.layer.addSublayer(self.bottomLine2)
        captionTextField.backgroundColor = .clear
        captionTextField.font = UIFont(name: "Poppins", size: 20)
        captionTextField.textColor = .white
        
        self.bottomLine3.frame = CGRect(x: 0.0, y: textOverlayTextField.frame.height, width: textOverlayTextField.frame.width, height: 1.0)
        self.bottomLine3.backgroundColor = UIColor.systemGray4.cgColor
        textOverlayTextField.borderStyle = UITextField.BorderStyle.none
        textOverlayTextField.layer.addSublayer(self.bottomLine3)
        textOverlayTextField.backgroundColor = .clear
        textOverlayTextField.font = UIFont(name: "Poppins", size: 20)
        textOverlayTextField.textColor = .white
        
        
        var bottomLine5 = CALayer()
        bottomLine5.backgroundColor = UIColor.systemGray4.cgColor
        //prioritizeLabel.borderStyle = UITextField.BorderStyle.none
        prioritizeLabel.layer.addSublayer(bottomLine5)
        bottomLine5.frame = CGRect(x: 0.0, y: prioritizeLabel.frame.height, width: prioritizeLabel.frame.width, height: 1.0)
        
      prioritizeLabel.backgroundColor = .clear
        
        linkTextField.attributedPlaceholder = NSAttributedString(string: "Paste Link Here",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        captionTextField.attributedPlaceholder = NSAttributedString(string: "Write a Caption... (Optional)",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        textOverlayTextField.attributedPlaceholder = NSAttributedString(string: "Add Text To Cover Photo (Optional)",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        
        
        
        linkLogo.frame = CGRect(x: scrollView.frame.width - 40, y: linkTextField.frame.minY, width: 30, height: 30)
        linkHexagonImage.setupHexagonMask(lineWidth: linkHexagonImage.frame.width/15, color: myCoolBlue, cornerRadius: linkHexagonImage.frame.width/15)
        addLinkLabel.font = UIFont(name: "DINAlternate-Bold", size: 22)
        postButton.titleLabel!.font = UIFont(name: "DINAlternate-Bold", size: 19)
        
       // insertTextOverlay()
        insertTextOverlay(linkHexagonImage: linkHexagonImage)
     //   insertTextOverlay(linkHexagonImage: linkHexagonImageCopy)
        if textOverlayString != "" {
            textOverlayLabel.isHidden = false
        }
        else {
        textOverlayLabel.isHidden = true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("I recognize that it is ending")
        if textOverlayTextField.text != "" {
            textOverlayLabel.isHidden = false
            textOverlayLabel.text = textOverlayTextField.text
        }
        else {
            print("text overlay textfield empty")
            textOverlayLabel.isHidden = true
        }
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
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
//        print("This is status bar height \(statusBarHeight)")
        self.view.addSubview(navBarView)
        self.navBarView.addSubview(backButton)
        self.navBarView.addSubview(postButton)
        self.navBarView.frame = CGRect(x: -5, y: -5, width: self.view.frame.width + 10, height: (self.view.frame.height/12)+5)
       
        var navBarHeightRemaining = navBarView.frame.maxY - statusBarHeight
        navBarView.backButton.isHidden = true
        navBarView.postButton.isHidden = true
//        self.navBarView.addSubview(toSettingsButton)
//        self.navBarView.addSubview(toSearchButton)
        
        self.backButton.frame = CGRect(x: 10, y: statusBarHeight + (navBarHeightRemaining - 34)/2, width: 34, height: 34)
        
        if cancelLbl != nil {
            backButton.setTitle(cancelLbl, for: .normal)
            backButton.sizeToFit()
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
        postButton.setTitleColor(myCoolBlue, for: .normal)
      //  postButton.frame = CGRect(x: (self.view.frame.width) - (topBar.frame.height) - 5, y: 0, width: topBar.frame.height, height: topBar.frame.height)
        postButton.titleLabel?.sizeToFit()
        postButton.titleLabel?.textAlignment = .right
        
    
      //  self.backButton.frame = CGRect(x: 10, y: statusBarHeight + (navBarHeightRemaining - 25)/2, width: 25, height: 25)
        
    //    backButton.sizeToFit()
        postButton.frame = CGRect(x: navBarView.frame.width - 50, y: statusBarHeight + (navBarHeightRemaining - 34)/2, width: 40, height: 34)
        navBarView.postButton.titleLabel?.textAlignment = .right
        let yOffset = navBarView.frame.maxY
  
        self.navBarView.addBehavior()
        self.navBarView.titleLabel.text = "Edit Post"
     //   self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y: navBarView.frame.maxY - 30, width: 200, height: 30)
        self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y: postButton.frame.minY, width: 200, height: 25)
//        print("This is navBarView.")
      
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
        
        let userData = userDataVM?.userData.value
        if userData == nil {
            return
        }
        let username = userData!.publicID
        let numPosts = userData!.numPosts
        
        if (originalCaption == captionTextField.text! && originalTextOverlay == textOverlayTextField.text && originalPriority == checkBoxStatus && changedPhoto == false) {
         print("Changed Nothing and Dismiss")
            self.dismiss(animated: false, completion: nil)
            return
        }
        
        print("TODO: Something changed so archive the old one in this spot and replace with new one")
        
        
        
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
                let alert = UIAlertController(title: "Hold up", message: "Paste a Link or Hit Cancel", preferredStyle: UIAlertController.Style.alert)
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
                let alert = UIAlertController(title: "Invalid URL", message: "Please Enter a Valid Url", preferredStyle: UIAlertController.Style.alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            
            //let group = DispatchGroup()
            if (!linkTextField.text!.isEmpty && validURL) {
                let timestamp = Timestamp.init().seconds
                let imageFileName = "\(username)_\(timestamp)_link.png"
                let refText = "userFiles/\(username)/\(imageFileName)"
                var link = linkTextField.text!
                var trimmedLink = link.trimmingCharacters(in: .whitespaces)
                let linkHex = HexagonStructData(resource: trimmedLink, type: "link", location: hexData?.location ?? numPosts + 1, thumbResource: refText, createdAt: NSDate.now.description, postingUserID: username, text: captionTextField.text ?? "", views: hexData?.views ?? 0, isArchived: false, docID: "WillBeSetLater", coverText: textOverlayTextField.text ?? "", isPrioritized: checkBoxStatus, array: [])
                let previewVC = storyboard?.instantiateViewController(identifier: "linkPreview") as! LinkPreviewVC
                previewVC.webHex = linkHex
                if changedProfilePic == true {
                previewVC.thumbImage = linkHexagonImage.image
                }
                else {
                    previewVC.thumbImage = UIImage(named: "linkCenter")
                }
                previewVC.userDataVM = userDataVM
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
        linkHexagonImageCopy.image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage
        self.changedProfilePic = true
        changedPhoto = true 
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func checkBoxTapped(_ sender: UITapGestureRecognizer) {
        if checkBoxStatus == false {
            linkHexagonImage.isHidden = false
            linkHexagonImageCopy.isHidden = true
            insertTextOverlay(linkHexagonImage: linkHexagonImage)
            checkBox.setImage(UIImage(named: "check-3"), for: .normal)
            checkBoxStatus = true
            linkHexagonImage.pulse(withIntensity: 0.8, withDuration: 1.5, loop: true)
        }
        else {
            insertTextOverlay(linkHexagonImage: linkHexagonImageCopy)
            linkHexagonImage.isHidden = true
            linkHexagonImageCopy.isHidden = false
            checkBox.setImage(UIImage(named: "blueEmpty"), for: .normal)
            checkBoxStatus = false
           linkHexagonImage.pulse(withIntensity: 1.0, withDuration: 0.1, loop: false)
        }
    }
    
    
    func insertTextOverlay(linkHexagonImage: UIImageView) {
   // var textOverlayLabel = UILabel()
    linkHexagonImage.addSubview(textOverlayLabel)
    textOverlayLabel.clipsToBounds = true
    textOverlayLabel.textAlignment = .center
    linkHexagonImage.bringSubviewToFront(textOverlayLabel)
    //self.contentView.addSubview(imageCopy)
        textOverlayLabel.frame = CGRect(x: 0, y: linkHexagonImage.frame.height*(6/10), width: linkHexagonImage.frame.width, height: 20*(linkHexagonImage.frame.height/150))
   // textOverlayLabel.frame = CGRect(x: 0, y: linkHexagonImage.frame.height*(6/10), width: linkHexagonImage.frame.width, height: 20)
        textOverlayLabel.text = textOverlayTextField.text!
    textOverlayLabel.numberOfLines = 1
    textOverlayLabel.font = UIFont(name: "DINAternate-Bold", size: 16)
    textOverlayLabel.textColor = white
        
    textOverlayLabel.textAlignment = .center

      //textOverlayLabel.text = "image.hexData!.coverText"
        textOverlayLabel.numberOfLines = 1
        textOverlayLabel.font = UIFont(name: "DINAternate-Bold", size: 10)
        textOverlayLabel.textColor = white
        textOverlayLabel.backgroundColor = UIColor(white: 0.25, alpha: 0.5)
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

