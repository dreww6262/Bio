//
//  OnePostPreview.swift
//  Bio
//
//  Created by Ann McDonough on 8/28/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseUI
import FirebaseFirestore
import YPImagePicker
import Photos

class OnePostPreview: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
  //  @IBOutlet weak var titleText: UILabel!
   // @IBOutlet weak var subtitleText: UILabel!
    var items: [YPMediaItem]?
    var navBarView = NavBarView()
    var textOverlayLabel = UILabel()
    var prioritizeLabel = UILabel()
    // scrollView
    @IBOutlet weak var scrollView: UIScrollView!
    
    // profile image
    
    // textfields
    @IBOutlet weak var captionTextField: UITextField!
    var textOverlayTextField = UITextField()
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var tagTextField: UITextField!
    
    @IBOutlet weak var previewImage: UIImageView!
    var linkHexagonImageCopy = UIImageView()
    
    // buttons
    var postButton = UIButton()
    var backButton = UIButton()
    
    var currentUser: User? = Auth.auth().currentUser
    var userDataVM: UserDataVM?
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    
    var cancelLbl: String?
    
    var photoBool = true
    
    // reset default size
    var scrollViewHeight : CGFloat = 0
    
    // keyboard frame size
    var keyboard = CGRect()
    
    let filterSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890/_-."
    
    var checkBox = UIButton()
    var checkBoxStatus = false
    
    
    // default func
    override func viewDidLoad() {
        captionTextField.textColor = .white
        textOverlayTextField.delegate = self
        
        textOverlayLabel.isHidden = true
        super.viewDidLoad()
        locationTextField.isHidden = true
        tagTextField.isHidden = true
        setUpNavBarView()
        scrollView.addSubview(textOverlayTextField)
        scrollView.addSubview(prioritizeLabel)
        scrollView.addSubview(checkBox)
        
        linkHexagonImageCopy.contentMode = .scaleAspectFit
        linkHexagonImageCopy.image = UIImage(named: "addCover")
        scrollView.addSubview(linkHexagonImageCopy)
        previewImage.isHidden = false
        linkHexagonImageCopy.isHidden = true
       
        let checkBoxTap = UITapGestureRecognizer(target: self, action: #selector(checkBoxTapped(_:)))
        checkBox.addGestureRecognizer(checkBoxTap)
        checkBox.setImage(UIImage(named: "emptyOrange"), for: .normal)
        
        let linkTapCopy = UITapGestureRecognizer(target: self, action: #selector(AddLinkVCViewController.loadImg(_:)))
        linkHexagonImageCopy.isUserInteractionEnabled = true
        linkHexagonImageCopy.addGestureRecognizer(linkTapCopy)
        previewImage.addGestureRecognizer(linkTapCopy)
        
        
        switch items![0] {
        case .photo(let photo):
            previewImage.image = photo.image
            photoBool = true
        case .video(let video) :
            previewImage.image = video.thumbnail
            photoBool = false

        }
        
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
     
        backButton.layer.cornerRadius = backButton.frame.size.width / 20
        previewImage.frame = CGRect(x: 40, y: navBarView.frame.maxY + 10, width: scrollView.frame.width - 80, height: scrollView.frame.width - 80)
        
        linkHexagonImageCopy.frame = CGRect(x: 40, y: navBarView.frame.maxY + 10, width: scrollView.frame.width - 80, height: scrollView.frame.width - 80)
        
        linkHexagonImageCopy.setupHexagonMask(lineWidth: linkHexagonImageCopy.frame.width/15, color: myOrange, cornerRadius: linkHexagonImageCopy.frame.width/15)
        
        
        captionTextField.frame = CGRect(x: 10, y: previewImage.frame.maxY + 20, width: self.view.frame.size.width - 20, height: 30)
        
        textOverlayTextField.frame = CGRect(x: 10, y: captionTextField.frame.maxY + 10, width: self.view.frame.size.width - 20, height: 30)

        prioritizeLabel.frame = CGRect(x: 10, y: textOverlayTextField.frame.maxY + 5, width: self.view.frame.size.width - 20, height: 30)
        prioritizeLabel.text = "Prioritize This Post?"
                checkBox.frame = CGRect(x: 165, y: textOverlayTextField.frame.maxY + 5, width: 30, height: 30)
        prioritizeLabel.textColor = .white
        
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: captionTextField.frame.height, width: captionTextField.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor(red: 0.82, green: 0.82, blue: 0.84, alpha: 1.00).cgColor
        captionTextField.borderStyle = UITextField.BorderStyle.none
        captionTextField.layer.addSublayer(bottomLine)
        captionTextField.backgroundColor = .clear
        captionTextField.attributedPlaceholder = NSAttributedString(string: "Write A Caption...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        textOverlayTextField.attributedPlaceholder = NSAttributedString(string: "Add Text To Cover Photo (Optional)",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        
    
        let bottomLine3 = CALayer()
        bottomLine3.frame = CGRect(x: 0.0, y: textOverlayTextField.frame.height, width: textOverlayTextField.frame.width, height: 1.0)
        bottomLine3.backgroundColor = UIColor(red: 0.82, green: 0.82, blue: 0.84, alpha: 1.00).cgColor
        textOverlayTextField.borderStyle = UITextField.BorderStyle.none
        textOverlayTextField.layer.addSublayer(bottomLine3)
        textOverlayTextField.backgroundColor = .clear
        textOverlayTextField.font = UIFont(name: "Poppins", size: 20)
        textOverlayTextField.textColor = .white
        
        
        let bottomLine5 = CALayer()
        bottomLine5.backgroundColor = UIColor(red: 0.82, green: 0.82, blue: 0.84, alpha: 1.00).cgColor
        //prioritizeLabel.borderStyle = UITextField.BorderStyle.none
        prioritizeLabel.layer.addSublayer(bottomLine5)
        bottomLine5.frame = CGRect(x: 0.0, y: prioritizeLabel.frame.height, width: prioritizeLabel.frame.width, height: 1.0)
        
      prioritizeLabel.backgroundColor = .clear
        
    
        backButton.layer.cornerRadius = backButton.frame.size.width / 20
        previewImage.setupHexagonMask(lineWidth: previewImage.frame.width/15, color: myOrange, cornerRadius: previewImage.frame.width/15)
        // background
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "manaloghourglass")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
        
        insertTextOverlay()
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("I recognize that it is ending")
        if textOverlayTextField.text != "" {
            textOverlayLabel.isHidden = false
            textOverlayLabel.text = textOverlayTextField.text!
        }
        else {
            print("text overlay textfield empty")
            textOverlayLabel.isHidden = true
        }
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
    @objc func postTapped(recognizer: UITapGestureRecognizer) {
        print("continue button pressed")
        // dismiss keyboard
        self.view.endEditing(true)
        
        let userData = userDataVM!.userData.value
        if userData == nil {
            return
        }
        
        if userData!.numPosts + 1 > 37 {
            // too many posts
            let alert = UIAlertController(title: "Not Enough Space :/", message: "Either cancel or delete a post from your home grid.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        postButton.isUserInteractionEnabled = false

        let username = userData!.publicID
        var numPosts = userData!.numPosts
        
            
            let loadingIndicator = storyboard?.instantiateViewController(withIdentifier: "loading")
            let blurEffectView = { () -> UIVisualEffectView in
                let blurEffect = UIBlurEffect(style: .dark)
                let blurEffectV = UIVisualEffectView(effect: blurEffect)
                
                blurEffectV.alpha = 0.8
 
                blurEffectV.autoresizingMask = [
                    .flexibleWidth, .flexibleHeight
                ]
                blurEffectV.frame = view.bounds
                
                return blurEffectV
            }()
            view.addSubview(blurEffectView)
            
            addChild(loadingIndicator!)
            view.addSubview(loadingIndicator!.view)
            
            let type = { () -> String in
                if (self.photoBool) {
                    return "photo"
                }
                return "video"
            }()
            
            let timestamp = Timestamp.init().seconds
            let imageFileName = "\(username)_\(timestamp)_\(type).png"
            let refText = "userFiles/\(username)/\(imageFileName)"

            let photoLocation = refText.filter{filterSet.contains($0)}
            
            numPosts += 1
            
            
            
        let photoHex = HexagonStructData(resource: photoLocation, type: type, location: numPosts, thumbResource: photoLocation, createdAt: NSDate.now.description, postingUserID: username, text: "\(captionTextField.text!)", views: 0, isArchived: false, docID: "WillBeSetLater", coverText: textOverlayTextField.text ?? "", isPrioritized: checkBoxStatus, array: [])
        
        
            
            switch(items![0]) {
                case .photo(let photo):
                    uploadPhoto(reference: photoLocation, image: photo, completion: { error in
                        
                        self.addHex(hexData: photoHex, completion: { error in
                            userData?.numPosts = numPosts
                            userData?.lastTimePosted = NSDate.now.description

                            self.userDataVM?.updateUserData(newUserData: userData!, completion: { _ in
                                self.postButton.isUserInteractionEnabled = true
                                        self.performSegue(withIdentifier: "unwindFromUpload", sender: nil)

                            })
                        })
                    })
            case .video(v: let video):
                uploadVideo(reference: photoLocation, video: video, completion: { error in
                    let rawThumbLocation = "userFiles/\(userData!.publicID)/_\(Timestamp.init().dateValue())_thumb.png"
                    let thumbLocation = rawThumbLocation.filter{self.filterSet.contains($0)}
                    self.uploadPhoto(reference: thumbLocation, image: YPMediaPhoto(image: video.thumbnail), completion: { error in
                        self.addHex(hexData: photoHex, completion: { error in
                            userData?.numPosts = numPosts
                            userData?.lastTimePosted = NSDate.now.description

                            self.userDataVM?.updateUserData(newUserData: userData!, completion: { success in
                                self.postButton.isUserInteractionEnabled = true
                                        self.performSegue(withIdentifier: "unwindFromUpload", sender: nil)
                            })
                        })
                    })
                })
        // }
            }
    }
    
    
    // call picker to select image
    @objc func loadImg(_ recognizer:UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.cameraOverlayView!.clipsToBounds = true
        present(picker, animated: true, completion: nil)
    }
    
    
    // connect selected image to our ImageView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        previewImage.image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage
        linkHexagonImageCopy.image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpNavBarView() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
//        print("This is status bar height \(statusBarHeight)")
        self.view.addSubview(navBarView)
        self.navBarView.addSubview(backButton)
        self.navBarView.addSubview(postButton)
        self.navBarView.frame = CGRect(x: -5, y: -5, width: self.view.frame.width + 10, height: (self.view.frame.height/12)+5)
       
        let navBarHeightRemaining = navBarView.frame.maxY - statusBarHeight
        navBarView.backButton.isHidden = true
        navBarView.postButton.isHidden = true
            let backTap = UITapGestureRecognizer(target: self, action: #selector(self.backButtonpressed))
            backTap.numberOfTapsRequired = 1
            backButton.isUserInteractionEnabled = true
            backButton.addGestureRecognizer(backTap)
            backButton.setImage(UIImage(named: "whiteChevron"), for: .normal)
        
        let postTap = UITapGestureRecognizer(target: self, action: #selector(self.postTapped))
        postTap.numberOfTapsRequired = 1
        postButton.isUserInteractionEnabled = true
        postButton.addGestureRecognizer(postTap)
        postButton.setTitle("Post", for: .normal)
        postButton.setTitleColor(.systemBlue, for: .normal)
        postButton.titleLabel?.sizeToFit()
        postButton.titleLabel?.textAlignment = .right
        
        postButton.frame = CGRect(x: navBarView.frame.width - 50, y: statusBarHeight + (navBarHeightRemaining - 30)/2, width: 40, height: 30)
        navBarView.postButton.titleLabel?.textAlignment = .right
        self.backButton.frame = CGRect(x: 10, y: statusBarHeight + (navBarHeightRemaining - 34)/2, width: 34, height: 34)
        
        postButton.frame = CGRect(x: navBarView.frame.width - 50, y: statusBarHeight + (navBarHeightRemaining - 34)/2, width: 40, height: 34)
        
        self.navBarView.addBehavior()
        self.navBarView.titleLabel.text = "Add A Photo Or Video"
        self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y: postButton.frame.minY, width: 200, height: 25)
    }
    
    
    // clicked cancel
    @objc func backButtonpressed(recognizer: UITapGestureRecognizer) {
        self.items = []
        self.dismiss(animated: false, completion: nil)
    }
    
    func insertTextOverlay() {
   // var textOverlayLabel = UILabel()
    previewImage.addSubview(textOverlayLabel)
    textOverlayLabel.clipsToBounds = true
    textOverlayLabel.textAlignment = .center
    previewImage.bringSubviewToFront(textOverlayLabel)
    //self.contentView.addSubview(imageCopy)
        textOverlayLabel.frame = CGRect(x: 0, y: previewImage.frame.height*(6/10), width: previewImage.frame.width, height: 20*(previewImage.frame.height/150))
        textOverlayLabel.text = textOverlayTextField.text!
    textOverlayLabel.numberOfLines = 1
    textOverlayLabel.font = UIFont(name: "DINAternate-Bold", size: 16)
    textOverlayLabel.textColor = white
        
    textOverlayLabel.textAlignment = .center

      textOverlayLabel.text = "image.hexData!.coverText"
        textOverlayLabel.numberOfLines = 1
        textOverlayLabel.font = UIFont(name: "DINAternate-Bold", size: 10)
        textOverlayLabel.textColor = white
        textOverlayLabel.backgroundColor = UIColor(white: 0.25, alpha: 0.5)
    }
    
    
    func uploadPhoto(reference: String, image: YPMediaPhoto, completion: @escaping (Bool) -> Void) {
        
        let photoRef = storageRef.child(reference)
        print("ref and img")
        print(reference)
        print(image)
        photoRef.putData(image.image.pngData()!, metadata: nil, completion: { data, error in
            print("got complete")
            return completion(error == nil)
        })
    }
    
    func uploadVideo(reference: String, video: YPMediaVideo, completion: @escaping (Bool) -> Void) {
        
        let videoRef = storageRef.child(reference)
        uploadTOFireBaseVideo(url: video.url, storageRef: videoRef, completion: { bool in
            completion(bool)
        })
        
        
    }
    
    func uploadTOFireBaseVideo(url: URL, storageRef: StorageReference,
                                      completion : @escaping (Bool) -> Void) {

        let name = "\(Int(Date().timeIntervalSince1970)).mp4"
        let path = NSTemporaryDirectory() + name

        let dispatchgroup = DispatchGroup()

        dispatchgroup.enter()

        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let outputurl = documentsURL.appendingPathComponent(name)
        var ur = outputurl
        self.convertVideo(toMPEG4FormatForVideo: url as URL, outputURL: outputurl) { (session) in

            ur = session.outputURL!
            dispatchgroup.leave()

        }
        dispatchgroup.wait()

        let data = NSData(contentsOf: ur as URL)

        do {

            try data?.write(to: URL(fileURLWithPath: path), options: .atomic)

        } catch {

            print(error)
        }

        if let uploadData = data as Data? {
            storageRef.putData(uploadData, metadata: nil
                , completion: { (metadata, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        completion(false)
                    }else{
                        //let strPic:String = (metadata?.downloadURL()?.absoluteString)!
                        completion(true)
                    }
            })
        }
    }
    
    
    @objc func checkBoxTapped(_ sender: UITapGestureRecognizer) {
        if checkBoxStatus == false {
            linkHexagonImageCopy.image = previewImage.image
            previewImage.isHidden = false
            linkHexagonImageCopy.isHidden = true
            checkBox.setImage(UIImage(named: "check-4"), for: .normal)
            checkBoxStatus = true
            previewImage.pulse(withIntensity: 0.8, withDuration: 1.5, loop: true)
        }
        else {
            linkHexagonImageCopy.image = previewImage.image
            previewImage.isHidden = true
            linkHexagonImageCopy.isHidden = false
            checkBox.setImage(UIImage(named: "emptyOrange"), for: .normal)
            checkBoxStatus = false
           previewImage.pulse(withIntensity: 1.0, withDuration: 0.1, loop: false)
        }
    }
    
    func convertVideo(toMPEG4FormatForVideo inputURL: URL, outputURL: URL, handler: @escaping (AVAssetExportSession) -> Void) {
        do{
            try FileManager.default.removeItem(at: outputURL as URL)
        }
        catch {
            print("bade")
        }
        let asset = AVURLAsset(url: inputURL as URL, options: nil)

        let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)!
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mp4
        exportSession.exportAsynchronously(completionHandler: {
            handler(exportSession)
        })
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
