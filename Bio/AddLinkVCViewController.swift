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
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
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
        cancelBtn.layer.cornerRadius = cancelBtn.frame.size.width / 20
        titleText.frame = CGRect(x: 0,y:60, width: self.view.frame.size.width, height: 30)
        subtitleText.frame = CGRect(x:0, y: titleText.frame.origin.y + 30, width: self.view.frame.size.width, height: 30)
        
        
        
        
        //         linkHexagonImage.frame = CGRect(x: 10, y: linkTextField.frame.origin.y + 30, width: self.view.frame.size.width - 20, height: 30)
        linkHexagonImage.frame = CGRect(x: 40, y: subtitleText.frame.maxY + 35, width: scrollView.frame.width - 80, height: scrollView.frame.width - 80)
        changeCoverLabel.frame = CGRect(x: 10, y: linkHexagonImage.frame.origin.y + scrollView.frame.width/2, width: self.view.frame.size.width - 20, height: 30)
        
        
        linkTextField.frame = CGRect(x: 10, y: linkHexagonImage.frame.maxY + 20, width: self.view.frame.size.width - 20, height: 30)
        linkTextField.attributedPlaceholder = NSAttributedString(string: "Paste Link Here",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        linkLogo.frame = CGRect(x: scrollView.frame.width - 40, y: linkTextField.frame.minY, width: 30, height: 30)
        
        continueBtn.frame =  CGRect(x: 10.0, y: linkTextField.frame.maxY + 20, width: self.view.frame.width - 20, height: 24)
        continueBtn.layer.cornerRadius = continueBtn.frame.size.width / 20
        cancelBtn.frame =  CGRect(x: 10.0, y: continueBtn.frame.maxY + 10, width: continueBtn.frame.width, height: 24)
        cancelBtn.layer.cornerRadius = cancelBtn.frame.size.width / 20
        linkHexagonImage.setupHexagonMask(lineWidth: linkHexagonImage.frame.width/15, color: myCoolBlue, cornerRadius: linkHexagonImage.frame.width/15)
        // background
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "manaloghourglass")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
        var lowTitleTextFrame = titleText.frame
        var lowSubtitleTextFrame = subtitleText.frame
        var lowLinkLogoFrame = linkLogo.frame
        var lowLinkTextfieldFrame = linkTextField.frame
        var lowLinkHexagonImageFrame = linkHexagonImage.frame
        var lowContinueButtonFrame = continueBtn.frame
        var lowCancelButtonFrame = cancelBtn.frame
        
        var highTitleTextFrame = CGRect(x: titleText.frame.minX, y: lowTitleTextFrame.minY - 70, width: titleText.frame.width, height: titleText.frame.height)
        var highSubtitleTextFrame = CGRect(x: subtitleText.frame.minX, y: lowSubtitleTextFrame.minY - 70, width: lowSubtitleTextFrame.width, height: lowSubtitleTextFrame.height)
        var highLinkLogoFrame = CGRect(x: linkLogo.frame.minX, y: lowTitleTextFrame.minY - 70, width: linkLogo.frame.width, height: titleText.frame.height)
        var highLinkTextfieldFrame = CGRect(x: linkTextField.frame.minX, y: lowLinkTextfieldFrame.minY - 70, width: linkTextField.frame.width, height: linkTextField.frame.height)
        var highLinkHexagonImageFrame = CGRect(x: linkHexagonImage.frame.minX, y: lowLinkHexagonImageFrame.minY - 70, width: linkHexagonImage.frame.width, height: linkHexagonImage.frame.height)
        var highContinueButtonFrame = CGRect(x: continueBtn.frame.minX, y: lowContinueButtonFrame.minY - 70, width: continueBtn.frame.width, height: continueBtn.frame.height)
        var highCancelButtonFrame = CGRect(x: cancelBtn.frame.minX, y: lowCancelButtonFrame.minY - 70, width: cancelBtn.frame.width, height: cancelBtn.frame.height)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("userData, view will appear: \(userData)")
        hasChosenThumbnailImage = false 
    }
    
    // hide keyboard if tapped
    @objc func hideKeyboardTap(_ recoginizer:UITapGestureRecognizer) {
        //   pushEverythingDown()
        self.view.endEditing(true)
    }
    
    func pushEverythingUp() {
        titleText.frame = CGRect(x: 0,y:60, width: self.view.frame.size.width, height: 30)
        subtitleText.frame = CGRect(x:0, y: titleText.frame.origin.y + 30, width: self.view.frame.size.width, height: 30)
        linkHexagonImage.frame = CGRect(x: 40, y: subtitleText.frame.maxY + 35, width: scrollView.frame.width - 80, height: scrollView.frame.width - 80)
        changeCoverLabel.frame = CGRect(x: 10, y: linkHexagonImage.frame.origin.y + scrollView.frame.width/2, width: self.view.frame.size.width - 20, height: 30)
        linkTextField.frame = CGRect(x: 10, y: linkHexagonImage.frame.maxY + 20, width: self.view.frame.size.width - 20, height: 30)
        linkTextField.attributedPlaceholder = NSAttributedString(string: "Paste Link Here",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        linkLogo.frame = CGRect(x: scrollView.frame.width - 40, y: linkTextField.frame.minY, width: 30, height: 30)
        continueBtn.frame =  CGRect(x: 10.0, y: linkTextField.frame.maxY + 20, width: self.view.frame.width - 20, height: 24)
        continueBtn.layer.cornerRadius = continueBtn.frame.size.width / 20
        cancelBtn.frame =  CGRect(x: 10.0, y: continueBtn.frame.maxY + 10, width: continueBtn.frame.width, height: 24)
        
        
        highTitleTextFrame = CGRect(x: titleText.frame.minX, y: lowTitleTextFrame.minY - 70, width: titleText.frame.width, height: titleText.frame.height)
        highSubtitleTextFrame = CGRect(x: subtitleText.frame.minX, y: lowSubtitleTextFrame.minY - 70, width: lowSubtitleTextFrame.width, height: lowSubtitleTextFrame.height)
        highLinkLogoFrame = CGRect(x: linkLogo.frame.minX, y: lowTitleTextFrame.minY - 70, width: linkLogo.frame.width, height: titleText.frame.height)
        highLinkTextfieldFrame = CGRect(x: linkTextField.frame.minX, y: lowLinkTextfieldFrame.minY - 70, width: linkTextField.frame.width, height: linkTextField.frame.height)
        highLinkHexagonImageFrame = CGRect(x: linkHexagonImage.frame.minX, y: lowLinkHexagonImageFrame.minY - 70, width: linkHexagonImage.frame.width, height: linkHexagonImage.frame.height)
        highContinueButtonFrame = CGRect(x: continueBtn.frame.minX, y: lowContinueButtonFrame.minY - 70, width: continueBtn.frame.width, height: continueBtn.frame.height)
        highCancelButtonFrame = CGRect(x: cancelBtn.frame.minX, y: lowCancelButtonFrame.minY - 70, width: cancelBtn.frame.width, height: cancelBtn.frame.height)
        
        titleText.frame = highTitleTextFrame
        subtitleText.frame = highSubtitleTextFrame
        linkLogo.frame = highLinkLogoFrame
        linkTextField.frame = highLinkTextfieldFrame
        linkHexagonImage.frame = highLinkHexagonImageFrame
        continueBtn.frame = highContinueButtonFrame
        cancelBtn.frame = highCancelButtonFrame
        print("New Frames")
        print(titleText.frame)
        print(subtitleText.frame)
        print(linkLogo.frame)
        print(linkTextField.frame)
        print(linkHexagonImage.frame)
        print(continueBtn.frame)
        print(cancelBtn.frame)
        
        
    }
    
    @objc func keyboard(notification:Notification) {
        guard let keyboardReact = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification ||  notification.name == UIResponder.keyboardWillChangeFrameNotification {
            self.view.frame.origin.y = -keyboardReact.height
        }else{
            self.view.frame.origin.y = 0
        }
        
    }
    
    
    
    
    func pushEverythingDown() {
        lowTitleTextFrame = CGRect(x: titleText.frame.minX, y: titleText.frame.minY + 70, width: titleText.frame.width, height: titleText.frame.height)
        lowSubtitleTextFrame = CGRect(x: subtitleText.frame.minX, y: subtitleText.frame.minY + 70, width: subtitleText.frame.width, height: subtitleText.frame.height)
        lowLinkLogoFrame = CGRect(x: linkLogo.frame.minX, y: linkLogo.frame.minY + 70, width: linkLogo.frame.width, height: linkLogo.frame.height)
        lowLinkTextfieldFrame = CGRect(x: linkTextField.frame.minX, y: linkTextField.frame.minY + 70, width: linkTextField.frame.width, height: linkTextField.frame.height)
        lowLinkHexagonImageFrame = CGRect(x: linkHexagonImage.frame.minX, y: linkHexagonImage.frame.minY + 70, width: linkHexagonImage.frame.width, height: linkHexagonImage.frame.height)
        lowContinueButtonFrame = CGRect(x: continueBtn.frame.minX, y: continueBtn.frame.minY + 70, width: continueBtn.frame.width, height: continueBtn.frame.height)
        cancelBtn.frame = CGRect(x: cancelBtn.frame.minX, y: cancelBtn.frame.minY + 70, width: cancelBtn.frame.width, height: cancelBtn.frame.height)
        
        titleText.frame = lowTitleTextFrame
        subtitleText.frame = lowSubtitleTextFrame
        linkLogo.frame = lowLinkLogoFrame
        linkTextField.frame = lowLinkTextfieldFrame
        linkHexagonImage.frame = lowLinkHexagonImageFrame
        continueBtn.frame = lowContinueButtonFrame
        cancelBtn.frame = lowCancelButtonFrame
        print("New Frames")
        print(titleText.frame)
        print(subtitleText.frame)
        print(linkLogo.frame)
        print(linkTextField.frame)
        print(linkHexagonImage.frame)
        print(continueBtn.frame)
        print(cancelBtn.frame)
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
    
    
    // clicked sign up
    @IBAction func continueClicked(_ sender: AnyObject) {
        print("continue button pressed")
        
        let username = userData!.publicID
        var numPosts = userData!.numPosts
        
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
            
            
            
            
            
            var linkString = "\(linkTextField.text!)"
            print("This is linkString \(linkString)")
            let url = URL(string: linkString)
            if linkString.isValidURL {
                print("linkString is valid URL")
                validURL = true
                print("This is url \(url)")
                ////                let url = URL(string: linkString)
                ////                let session = URLSession.shared
                ////                let task = session.downloadTask(with:url as! URL) { loc, resp, err in
                ////                    let status = (resp as! HTTPURLResponse).statusCode
                ////                    print("response status: \(status)")
                ////                }
                ////                task.resume()
                //            let task = URLSession.shared.dataTask(with: url!) { _, response, _ in
                //                if let httpResponse = response as? HTTPURLResponse {
                //                    print(httpResponse.statusCode)
                //                }
                //            }
                //
                //            task.resume()
                
                
                
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
                let imageRef = storageRef.child(refText)
                numPosts += 1
                let linkHex = HexagonStructData(resource: linkTextField.text!, type: "link", location: numPosts, thumbResource: refText, createdAt: NSDate.now.description, postingUserID: username, text: "\(linkTextField.text!)", views: 0, isArchived: false, docID: "WillBeSetLater")
                
                
                
                
                imageRef.putData(linkHexagonImage.image!.pngData()!, metadata: nil){ data, error in
                    if (error == nil) {
                        print ("upload successful")
                        self.addHex(hexData: linkHex, completion: { bool in
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

