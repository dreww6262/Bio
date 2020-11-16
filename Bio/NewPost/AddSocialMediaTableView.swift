//
//  AddSocialMediaTableView.swift
//  Bio
//
//  Created by Ann McDonough on 9/30/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import SDWebImage
import FirebaseUI
import FirebaseStorage
import YPImagePicker

class AddSocialMediaTableView: UIViewController, UITextFieldDelegate {
    var navBarView = NavBarView()
    var titleLabel1 = UILabel()
    @IBOutlet weak var doneButton: UIButton!
    
    var backButton = UIButton()
    var postButton = UIButton()
    
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    
    var currentUser: User?
    var loadUserDataArray = ThreadSafeArray<UserData>()
    var searchString: String = ""
    var userData: UserData?
//    var textFieldArray = [UITextField]()
    
    var followList = [String]()
    var followListener: ListenerRegistration?
    
    var cancelLbl: String?
    
    var socialMediaArray: [String] = ["instagram", "snapchat", "tikTok", "twitter", "youtube", "vsco", "soundcloud", "twitch", "linkedIn", "etsy", "poshmark", "hudl", "venmo", "cashapp", "cameo"]
    
    var image1 = UIImage(named: "instagramLogo")
    var image2 = UIImage(named: "snapchatlogo")
    var image3 = UIImage(named: "tikTokLogo4")
    var image4 = UIImage(named: "twitterapp")
    var image5 = UIImage(named: "youtube3")
    var image6 = UIImage(named: "vscologo1")
    var image7 = UIImage(named: "soundCloudCircleOrange")
    var image8 = UIImage(named: "twitchCircle")
    var image9 = UIImage(named: "linkedIn7")
    var image10 = UIImage(named: "etsyLogoCircle")
    var image11 = UIImage(named: "poshmarkLogo")
    var image12 = UIImage(named: "hudlapp")
    var image13 = UIImage(named: "venmoCircle")
    var image14 = UIImage(named: "cashapp")
    var image15 = UIImage(named: "cameo")
    
    
    
    
    var iconArray: [UIImage] = []
    //[image1,image2,image3,image4,image5,image6,image7,image8,image9,image10,image11,image12]
    //var iconArray: [UIImage] = [UIImage(named: "icons/instagramLogo.png")!,UIImage(named: "icons/snapchatLogo.png")!,UIImage(named: "icons/tikTokLogo.png")!,UIImage(named: "icons/twitterLogo.png")!,UIImage(named: "icons/youtubeLogo.png")!,UIImage(named: "icons/twitch1.png")!,UIImage(named: "icons/soundCloudLogo.png")!,UIImage(named: "icons/venmo1.png")!,UIImage(named: "icons/linkedInLogo.png")!,UIImage(named: "icons/etsyLogo.png")!,UIImage(named: "icons/poshmarkLogo.png")!,UIImage(named: "icons/hudl1.png")!]
    var placeHolderTextArray: [String] = ["Instagram Username", "Snapchat Username", "Link to Tik Tok Profile", "Twitter Handle", "Link to Youtube Channel", "VSCO Username", "Link to Soundcloud Profile", "Twitch Username", "Link to LinkedIn Profile", "Etsy Shop Name", "Poshmark Username", "Link to Hudl Profile", "Venmo Username", "Cash App Username", "Link to Cameo Profile"]
//    var textField = UITextField()
//    var interactiveTextField = UITextField()
//    @IBOutlet weak var verifyView: UIView!
//    //
//    @IBOutlet weak var verifyImage: UIImageView!
//    @IBOutlet weak var verifyLabel: UILabel!
//    @IBOutlet weak var iconImageView: UIImageView!
//    
//    @IBOutlet weak var interactiveTextField: UITextField!
//    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldData = Array(repeating: "", count: socialMediaArray.count)
        cancelButton.isHidden = true
        doneButton.isHidden = true
        titleLabel1.isHidden = true
        doneButton.titleLabel!.font = UIFont(name: "DINAlternate-Bold", size: 19)
        setUpNavBarView()
        view.addSubview(tableView)
//        textField.isUserInteractionEnabled = false
//        interactiveTextField.isUserInteractionEnabled = true
//      
     

        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = CGRect(x: 0, y: navBarView.frame.height, width: view.frame.width, height: view.frame.height - navBarView.frame.height)
        tableView.reloadData()
        
       // cancelButton.frame = CGRect(x: 0, y: self.tableView.frame.minY/4, width: self.tableView.frame.minY/2, height: self.tableView.frame.minY/2)
//        cancelButton.sizeToFit()
//        cancelButton.frame = CGRect(x: 5, y: (navBarView.frame.height/4), width: navBarView.frame.height/2, height: navBarView.frame.height/2)
//        cancelButton.setBackgroundImage(UIImage(named: "whiteBack"), for: .normal)
//        doneButton.frame = CGRect(x: self.view.frame.width - doneButton.frame.width-5, y: self.tableView.frame.minY/4, width: doneButton.frame.width, height: doneButton.frame.height)
//        doneButton.frame = CGRect(x: (self.view.frame.width) - (navBarView.frame.height) - 5, y: 0, width: navBarView.frame.height, height: navBarView.frame.height)
//        doneButton.setTitle("Post", for: .normal)
//        doneButton.setTitleColor(.systemBlue, for: .normal)
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        currentUser = Auth.auth().currentUser
        iconArray = [image1 ?? UIImage(),image2 ?? UIImage(),image3 ?? UIImage(),image4 ?? UIImage(),image5 ?? UIImage(),image6 ?? UIImage(),image7 ?? UIImage(),image8 ?? UIImage(),image9 ?? UIImage(),image10 ?? UIImage(),image11 ?? UIImage(),image12 ?? UIImage(), image13 ?? UIImage(),image14 ?? UIImage(), image15 ?? UIImage()]
        
    }
    
    @objc func skipTapped(_ sender: UITapGestureRecognizer) {
        var config = YPImagePickerConfiguration()
        config.screens = [.library, .photo, .video]
        config.startOnScreen = .library
        config.library.mediaType = .photoAndVideo
        config.library.maxNumberOfItems = 10
        config.video.trimmerMaxDuration = 60.0
        config.video.recordingTimeLimit = 60.0
        config.video.automaticTrimToTrimmerMaxDuration = true
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, cancelled in
            
            if (items.count == 1) {
                let onePostVC = self.storyboard?.instantiateViewController(identifier: "") as! OnePostPreview
                onePostVC.userData = self.userData
                onePostVC.items = items
                onePostVC.cancelLbl = self.cancelLbl
                
                picker.present(onePostVC, animated: false, completion: nil)
                onePostVC.modalPresentationStyle = .fullScreen
            }
            if (items.count > 1) {
                let uploadPreviewVC = self.storyboard?.instantiateViewController(identifier: "newUploadPreviewVC") as! NewUploadPreviewVC
                //print(photos)
                uploadPreviewVC.userData = self.userData
                uploadPreviewVC.cancelLbl = self.cancelLbl
                uploadPreviewVC.items = items
                //picker.dismiss(animated: false, completion: nil)
                picker.present(uploadPreviewVC, animated: false, completion: nil)
                uploadPreviewVC.modalPresentationStyle = .fullScreen
            }
            else {
                if (self.cancelLbl == "Skip") {
                    let musicVC = self.storyboard?.instantiateViewController(withIdentifier: "addMusicVC") as! AddMusicVC
                    musicVC.userData = self.userData
                    musicVC.currentUser = self.currentUser
                    musicVC.cancelLbl = "Skip"
                    picker.present(musicVC, animated: false, completion: nil)
                }
                else {
                    picker.dismiss(animated: false, completion: nil)
                }
            }
            
        }
        present(picker, animated: false)
        modalPresentationStyle = .fullScreen
    }
    
  //  @IBAction func donePressed(_ sender: UIButton) {
    @objc func postTapped(_ recognizer:UITapGestureRecognizer) {
        print("done button pressed")
        
        // dismiss keyboard
        self.view.endEditing(true)
        
        
        // if fields are empty
        var isCompletelyEmpty = true
        
        var count = 0
        var numAccounts = 0
        while count < socialMediaArray.count {
            if (textFieldData[count] != "") {
                isCompletelyEmpty = false
            }
            else {
                numAccounts += 1
            }
            count += 1
        }
        
        
        if (isCompletelyEmpty == true) {
            
            // alert message
            let alert = UIAlertController(title: "Hold up", message: "Fill in a field or Hit Skip/Cancel", preferredStyle: UIAlertController.Style.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        let username = userData!.publicID
        var numPosts = userData!.numPosts
        

        if numPosts + numAccounts > 37 {
            // too many posts
            let overflow = numPosts + numAccounts - 37
            let alert = UIAlertController(title: "Not Enough Space :/", message: "Either clear out \(overflow) field\(overflow > 1 ? "s" : "") or delete \(overflow) post\(overflow > 1 ? "s" : "") from your home grid.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        
        
        var success = true
        
        let loadingIndicator = storyboard?.instantiateViewController(withIdentifier: "loading")
        
        let blurEffectView: UIVisualEffectView = {
            let blurEffect = UIBlurEffect(style: .dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            
            blurEffectView.alpha = 0.8
            
            // Setting the autoresizing mask to flexible for
            // width and height will ensure the blurEffectView
            // is the same size as its parent view.
            blurEffectView.autoresizingMask = [
                .flexibleWidth, .flexibleHeight
            ]
            blurEffectView.frame = view.bounds
            
            return blurEffectView
        }()
        view.addSubview(blurEffectView)
        
        addChild(loadingIndicator!)
        view.addSubview(loadingIndicator!.view)
        
        //let group = DispatchGroup()
        if (!(textFieldData[0] == "")) {
            numPosts += 1
            var myText = textFieldData[0]
            var trimmedText = myText.trimmingCharacters(in: .whitespaces)
            trimmedText = trimmedText.lowercased()
            print("This is trimmedText \(trimmedText)")
            let instaHex = HexagonStructData(resource: "https://instagram.com/\(trimmedText)", type: "socialmedia_instagram", location: numPosts, thumbResource: "icons/instagramLogo.png", createdAt: NSDate.now.description, postingUserID: username, text: "", views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "@\(trimmedText)")
            addHex(hexData: instaHex, completion: { bool in
                success = success && bool
                
            })
        }
        
        if (!(textFieldData[1] == "")) {
            numPosts += 1
            var myText = textFieldData[1]
            var trimmedText = myText.trimmingCharacters(in: .whitespaces)
            trimmedText = trimmedText.lowercased()
            print("This is trimmedText \(trimmedText)")
            let snapHex = HexagonStructData(resource: "https://www.snapchat.com/add/\(trimmedText)", type: "socialmedia_snapchat", location: numPosts, thumbResource: "icons/snapchatlogo.jpg", createdAt: NSDate.now.description, postingUserID: username, text: "", views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "\(trimmedText)")
            addHex(hexData: snapHex, completion: {bool in
                success = success && bool
                
            })
        }
        
        if (!(textFieldData[2] == "")) {
            numPosts += 1
            var myText = textFieldData[2]
            var trimmedText = myText.trimmingCharacters(in: .whitespaces)
            trimmedText = trimmedText.lowercased()
            print("This is trimmedText \(trimmedText)")
            let tikTokHex = HexagonStructData(resource: trimmedText, type: "socialmedia_tiktok", location: numPosts, thumbResource: "icons/tikTokLogo4.png", createdAt: NSDate.now.description, postingUserID: username, text: "", views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "")
            addHex(hexData: tikTokHex, completion: {bool in
                success = success && bool
                
            })
        }
        
        if (!(textFieldData[3] == "")) {
            numPosts += 1
            var myText = textFieldData[3]
            var trimmedText = myText.trimmingCharacters(in: .whitespaces)
            trimmedText = trimmedText.lowercased()
            print("This is trimmedText \(trimmedText)")
            let twitterHex = HexagonStructData(resource: "https://twitter.com/\(trimmedText)", type: "socialmedia_twitter", location: numPosts, thumbResource: "icons/twitter.png", createdAt: NSDate.now.description, postingUserID: username, text: "", views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "@\(trimmedText)")
            addHex(hexData: twitterHex, completion: {bool in
                success = success && bool
                
            })
        }
        
        if (!(textFieldData[4] == "")) {
            numPosts += 1
            var myText = textFieldData[4]
            var trimmedText = myText.trimmingCharacters(in: .whitespaces)
            trimmedText = trimmedText.lowercased()
            print("This is trimmedText \(trimmedText)")
            let youtubeHex = HexagonStructData(resource: "\(trimmedText)", type: "socialmedia_youtube", location: numPosts, thumbResource: "icons/youtube3 .png", createdAt: NSDate.now.description, postingUserID: username, text: "", views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "")
            addHex(hexData: youtubeHex, completion: {bool in
                success = success && bool
                
            })
        }
        
        if (!(textFieldData[5] == "")) {
            numPosts += 1
            var myText = textFieldData[5]
            var trimmedText = myText.trimmingCharacters(in: .whitespaces)
            trimmedText = trimmedText.lowercased()
            print("This is trimmedText \(trimmedText)")
            let vscoHex = HexagonStructData(resource: "https://www.vsco.co/\(trimmedText)/gallery", type: "socialmedia_vsco", location: numPosts, thumbResource: "icons/vscologo1.png", createdAt: NSDate.now.description, postingUserID: username, text: "", views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "@\(trimmedText)")
            addHex(hexData: vscoHex, completion: {bool in
                success = success && bool
                
            })
        }
        
        if (!(textFieldData[6] == "")) {
            numPosts += 1
            var myText = textFieldData[6]
            var trimmedText = myText.trimmingCharacters(in: .whitespaces)
            trimmedText = trimmedText.lowercased()
            print("This is trimmedText \(trimmedText)")
            let soundCloudHex = HexagonStructData(resource: trimmedText, type: "socialmedia_soundCloud", location: numPosts, thumbResource: "icons/soundCloudLogo.png", createdAt: NSDate.now.description, postingUserID: username, text: "", views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "")
            addHex(hexData: soundCloudHex, completion: {bool in
                success = success && bool
                
            })
        }
        
        if (!(textFieldData[7] == "")) {
            numPosts += 1
            var myText = textFieldData[7]
            var trimmedText = myText.trimmingCharacters(in: .whitespaces)
            trimmedText = trimmedText.lowercased()
            print("This is trimmedText \(trimmedText)")
            let twitchHex = HexagonStructData(resource: "https://m.twitch.tv/\(trimmedText)/profile", type: "socialmedia_twitch", location: numPosts, thumbResource: "icons/twitch1.png", createdAt: NSDate.now.description, postingUserID: username, text: "", views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "@\(trimmedText)")
            addHex(hexData: twitchHex, completion: {bool in
                success = success && bool
                
            })
        }
        
        if (!(textFieldData[8] == "")) {
            numPosts += 1
            var myText = textFieldData[8]
            var trimmedText = myText.trimmingCharacters(in: .whitespaces)
            trimmedText = trimmedText.lowercased()
            print("This is trimmedText \(trimmedText)")
            let linkedInHex = HexagonStructData(resource: "\(trimmedText)", type: "socialmedia_linkedIn", location: numPosts, thumbResource: "icons/linkedInLogo.jpg", createdAt: NSDate.now.description, postingUserID: username, text: "", views: 0,isArchived: false, docID: "WillBeSetLater", coverText: "")
            addHex(hexData: linkedInHex, completion: {bool in
                success = success && bool
                
            })
        }
     
        if (!(textFieldData[9] == "")) {
            numPosts += 1
            var myText = textFieldData[9]
            var trimmedText = myText.trimmingCharacters(in: .whitespaces)
            trimmedText = trimmedText.lowercased()
            print("This is trimmedText \(trimmedText)")
            let etsyHex = HexagonStructData(resource: "https://etsy.com/shop/\(trimmedText)", type: "socialmedia_etsy", location: numPosts, thumbResource: "icons/etsyLogoCircle.png", createdAt: NSDate.now.description, postingUserID: username, text: "", views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "@\(trimmedText)")
            addHex(hexData: etsyHex, completion: {bool in
                success = success && bool
                
            })
        }
    
        if (!(textFieldData[10] == "")) {
            print("Trying to add a poshmark link")
            numPosts += 1
            var myText = textFieldData[10]
            var trimmedText = myText.trimmingCharacters(in: .whitespaces)
            trimmedText = trimmedText.lowercased()
            print("This is trimmedText \(trimmedText)")
            let poshmarkHex = HexagonStructData(resource: "https://poshmark.com/closet/\(trimmedText)", type: "socialmedia_poshmark", location: numPosts, thumbResource: "icons/poshmarkLogo.png", createdAt: NSDate.now.description, postingUserID: username, text: "", views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "@\(trimmedText)")
            addHex(hexData: poshmarkHex, completion: {bool in
                success = success && bool
                
            })
        }
        
        if (!(textFieldData[11] == "")) {
            numPosts += 1
            var myText = textFieldData[11]
            var trimmedText = myText.trimmingCharacters(in: .whitespaces)
            trimmedText = trimmedText.lowercased()
            print("This is trimmedText \(trimmedText)")
            let hudlHex = HexagonStructData(resource: "\(trimmedText)/", type: "socialmedia_hudl", location: numPosts, thumbResource: "icons/hudl.png", createdAt: NSDate.now.description, postingUserID: username, text: "", views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "")
            addHex(hexData: hudlHex, completion: {bool in
                success = success && bool
                
            })
        }
     
        
        if (!(textFieldData[12] == "")) {
            numPosts += 1
            var myText = textFieldData[12]
            var trimmedText = myText.trimmingCharacters(in: .whitespaces)
            trimmedText = trimmedText.lowercased()
            print("This is trimmedText \(trimmedText)")
            print("should be a venmo hex!")
            let venmoHex = HexagonStructData(resource: "https://venmo.com/\(trimmedText)", type: "socialmedia_venmo", location: numPosts, thumbResource: "icons/venmologo.png", createdAt: NSDate.now.description, postingUserID: username, text: "", views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "\(trimmedText)")
            addHex(hexData: venmoHex, completion: {bool in
                success = success && bool
                
            })
        }
        
        if (!(textFieldData[13] == "")) {
            numPosts += 1
            var myText = textFieldData[13]
            var trimmedText = myText.trimmingCharacters(in: .whitespaces)
            trimmedText = trimmedText.lowercased()
            while trimmedText.hasPrefix("$") {
                "hello".chopPrefix()
                print("This is trimmedText now \(trimmedText)")
            }
            print("This is trimmedText \(trimmedText)")
            print("should be a cameo hex!")
            let cashAppHex = HexagonStructData(resource: "https://cash.app/$\(trimmedText)", type: "socialmedia_cashapp", location: numPosts, thumbResource: "icons/cashapp.png", createdAt: NSDate.now.description, postingUserID: username, text: "", views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "$\(trimmedText)")
            addHex(hexData: cashAppHex, completion: {bool in
                success = success && bool
                
            })
        }
        
        
        if (!(textFieldData[14] == "")) {
            numPosts += 1
            var myText = textFieldData[14]
            var trimmedText = myText.trimmingCharacters(in: .whitespaces)
            trimmedText = trimmedText.lowercased()
            print("This is trimmedText \(trimmedText)")
            print("should be a cameo hex!")
            let cameoHex = HexagonStructData(resource: trimmedText, type: "socialmedia_cameo", location: numPosts, thumbResource: "icons/cameo.png", createdAt: NSDate.now.description, postingUserID: username, text: "", views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "")
            addHex(hexData: cameoHex, completion: {bool in
                success = success && bool
                
            })
        }
   
     

 
        
        print("passed wait for social media tiles")
        userData?.numPosts = numPosts
        db.collection("UserData1").document(currentUser!.uid).setData(self.userData!.dictionary, completion: { error in
            if error == nil {
                //present Home View Controller Segue
                print("present home hex grid")
                if (self.cancelLbl == nil) {
                    self.performSegue(withIdentifier: "rewindToFront", sender: nil)
                }
                else {
                    self.skipTapped(recognizer)
                }
            }
            else {
                print("userData not saved \(error?.localizedDescription)")
            }
            
        })
    }
    
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        print("hit cancel button")
        // hide keyboard when pressed cancel
        self.view.endEditing(true)
        if (cancelButton.titleLabel?.text == "Skip") {
            performSegue(withIdentifier: "rewindToFront", sender: nil)
        }
        else {
            print("should dismiss vc")
            self.dismiss(animated: true, completion: nil)
        }
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
    
    @objc func backTapped(_ sender: UITapGestureRecognizer) {
        print("back hit!")
        for v in view.subviews {
            v.isHidden = true
        }
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func backButtonpressed() {
        print("It should dismiss here")
        self.dismiss(animated: true)
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
        postButton.setTitleColor(.systemBlue, for: .normal)
      //  postButton.frame = CGRect(x: (self.view.frame.width) - (topBar.frame.height) - 5, y: 0, width: topBar.frame.height, height: topBar.frame.height)
        postButton.titleLabel?.sizeToFit()
        postButton.titleLabel?.textAlignment = .right
        
    
   //     self.backButton.frame = CGRect(x: 10, y: statusBarHeight + (navBarHeightRemaining - 25)/2, width: 25, height: 25)
        
      //  backButton.sizeToFit()
        postButton.frame = CGRect(x: navBarView.frame.width - 50, y: statusBarHeight + (navBarHeightRemaining - 34)/2, width: 40, height: 34)
        //navBarView.postButton.titleLabel?.sizeToFit()
        navBarView.postButton.titleLabel?.textAlignment = .right
        let yOffset = navBarView.frame.maxY
  
        self.navBarView.addBehavior()
        self.navBarView.titleLabel.text = "Add Social Media"
       // self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y: navBarView.frame.maxY - 30, width: 200, height: 30)
        self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y: postButton.frame.minY, width: 200, height: 25)
      
      
    }
    
    
    var textFieldData = [String]()
    @objc func textFieldDidChange(_ textField: UITextField) {
        textFieldData[textField.tag] = textField.text!
    }
    
    
   
    
  
//    @objc func cellTapped(_ sender : UITapGestureRecognizer) {
//        let cell  = sender.view as! AddSocialMediaCell
//        let linkText = cell.interactiveTextField.text!
//        db.collection("UserData1").whereField("publicID", isEqualTo: username).addSnapshotListener({ objects, error in
//            if error == nil {
//                guard let docs = objects?.documents else{
//                    print("no docs?")
//                    return
//                }
//                if docs.count > 1 {
//                    print("Too many docs \(docs)")
//                }
//                else if (docs.count == 0) {
//                    print("no username")
//                }
//                else {
//                    let userdata = UserData(dictionary: docs[0].data())
//                    let guestVC = self.storyboard!.instantiateViewController(identifier: "guestGridVC") as! GuestHexagonGridVC
//                    guestVC.userData = userdata
//                    guestVC.username = self.userData!.publicID
//                    self.present(guestVC, animated: false)
//                    self.modalPresentationStyle = .fullScreen
//                }
//            }
//            else {
//                print("pulling up guest vc userdata failed")
//            }
//        })
//    }

    
    // MARK: - Table view data source
    
    
    
    
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

// MARK: - Table view data source
extension AddSocialMediaTableView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return socialMediaArray.count
    }
    
    // cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     //   print("This is height for row at: \(self.view.frame.height/8)")
    //    return self.view.frame.height/8
    return 66
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addSocialMediaCell", for: indexPath) as! AddSocialMediaCell
        cell.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/8)
       // let cellTappedRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
       // cell.addGestureRecognizer(cellTappedRecognizer)
        cell.userData = userData
        //  Configure the cell...
        cell.socialMediaIcon.image = iconArray[indexPath.row] ?? UIImage(named: "instagramLogo")
        cell.socialMediaIcon.layer.cornerRadius = cell.socialMediaIcon.frame.size.width / 2
        cell.socialMediaIcon.clipsToBounds = true
        cell.socialMediaIcon.layer.borderWidth = 1.0
        cell.socialMediaIcon.layer.borderColor = white.cgColor
        
//        if indexPath.row == 2 {
//            cell.socialMediaIcon.layer.cornerRadius = cell.socialMediaIcon.frame.size.width / 2
//            cell.socialMediaIcon.clipsToBounds = true
//            cell.socialMediaIcon.image = UIImage(named: "tikTokLogo4")
////            cell.socialMediaIcon.layer.borderWidth = 1.0
////            cell.socialMediaIcon.layer.borderColor = white.cgColor
//        }
        
        if indexPath.row == 8 {
            cell.contentMode = .scaleToFill
            cell.layer.cornerRadius = 0
        }
        
//
//        if indexPath.row == 10 {
//            cell.socialMediaIcon.layer.cornerRadius = cell.socialMediaIcon.frame.size.width / 2
//            cell.socialMediaIcon.clipsToBounds = true
//        }
//        if indexPath.row == 11 {
//            cell.socialMediaIcon.layer.cornerRadius = cell.socialMediaIcon.frame.size.width / 2
//            cell.socialMediaIcon.clipsToBounds = true
//        }
        cell.interactiveTextField.attributedPlaceholder = NSAttributedString(string: placeHolderTextArray[indexPath.row],
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray4])
        cell.circularMask.frame = cell.socialMediaIcon.frame
        cell.interactiveTextField.textColor = .white
        cell.interactiveTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        cell.interactiveTextField.tag = indexPath.row
        if (textFieldData.count > indexPath.row) {
            cell.interactiveTextField.text = textFieldData[indexPath.row]
        }
//        self.textFieldArray.append(cell.interactiveTextField)
       
        
        
        //cell = loadUserDataArray![indexPath.row]
        //print("This is cell image \(cell.avaImg.image)")
        //   cell.previewImage.setupHexagonMask(lineWidth: 10.0, color: .black, cornerRadius: 10.0)
        //     cellArray.append(cell)
        return cell
    }
}

extension String {
    func chopPrefix(_ count: Int = 1) -> String {
        return substring(from: index(startIndex, offsetBy: count))
    }

    func chopSuffix(_ count: Int = 1) -> String {
        return substring(to: index(endIndex, offsetBy: -count))
    }
}
