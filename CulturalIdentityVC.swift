//
//  CulturalIdentityVC.swift
//  Bio
//
//  Created by Ann McDonough on 12/10/20.
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
import MRCountryPicker

class CulturalIdentityVC: UIViewController, UITextFieldDelegate, MRCountryPickerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.countries[row]
    }
    
    var selectedCountry: String?
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCountry = countries[row]
    }
    
    var delegate: isAbleToReceiveData?
    
    var countryName = UILabel()
   var countryCode = UILabel()
 var countryFlag = UIImageView()
  var phoneCode = UILabel()
   var countries: [String] = []
    func countryPhoneCodePicker(_ picker: MRCountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        self.countryName.text = name
        self.countryCode.text = countryCode
        self.phoneCode.text = phoneCode
        self.countryFlag.image = flag
    }
    var countryPicker = MRCountryPicker()
    var userCountries: [String] = []
    var maxCountriesAllowed = 6
    
    var navBarView = NavBarView()
    var titleLabel1 = UILabel()
    @IBOutlet weak var doneButton: UIButton!
    var birthday = ""
    var age = 0
    var cellArray: [PersonalDetailCell] = []
    
    var backButton = UIButton()
    var postButton = UIButton()
    var continueButton = UIButton()
    var datePicker = UIDatePicker()
    var indexPaths: [IndexPath] = []
    var txtDatePicker = UITextField()
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    
    var currentUser: User?
    var loadUserDataArray = ThreadSafeArray<UserData>()
    var userDataVM: UserDataVM?
//    var textFieldArray = [UITextField]()
    
    var followList = [String]()
    var followListener: ListenerRegistration?
    
    var cancelLbl: String?
    
    var socialMediaArray: [String] = ["instagram", "snapchat", "tikTok", "twitter", "youtube", "vsco", "soundcloud", "twitch", "linkedIn", "etsy", "poshmark", "hudl", "venmo", "cashapp", "cameo"]
    

    var image1 = UIImage(named: "unity")
  
    
    
    
    
    var iconArray: [UIImage] = []
    //[image1,image2,image3,image4,image5,image6,image7,image8,image9,image10,image11,image12]
    //var iconArray: [UIImage] = [UIImage(named: "icons/instagramLogo.png")!,UIImage(named: "icons/snapchatLogo.png")!,UIImage(named: "icons/tikTokLogo.png")!,UIImage(named: "icons/twitterLogo.png")!,UIImage(named: "icons/youtubeLogo.png")!,UIImage(named: "icons/twitch1.png")!,UIImage(named: "icons/soundCloudLogo.png")!,UIImage(named: "icons/venmo1.png")!,UIImage(named: "icons/linkedInLogo.png")!,UIImage(named: "icons/etsyLogo.png")!,UIImage(named: "icons/poshmarkLogo.png")!,UIImage(named: "icons/hudl1.png")!]
    var placeHolderTextArray: [String] = ["Cultural Identity"]
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
        
//        view.addSubview(countryPicker)
        countryPicker.dataSource = self
      countryPicker.delegate = self
        self.countries = self.getCountryList()
        self.countries = self.countries.sorted(by: <)
        self.countries.insert("United States", at: 0)
        textFieldData = Array(repeating: "", count: socialMediaArray.count)
        cancelButton.isHidden = true
        doneButton.isHidden = true
        titleLabel1.isHidden = true
        view.backgroundColor = .systemGray6
        doneButton.titleLabel!.font = UIFont(name: "DINAlternate-Bold", size: 19)
        setUpNavBarView()
        countryPicker.countryPickerDelegate = self
        countryPicker.showPhoneNumbers = true
        countryPicker.setCountry("SI")

        // optionally set custom locale; defaults to system's locale
        countryPicker.setLocale("sl_SI")

    //     set country by its name
        countryPicker.setCountryByName("Canada")
        
        view.addSubview(tableView)
//        textField.isUserInteractionEnabled = false
//        interactiveTextField.isUserInteractionEnabled = true
//
     

        tableView.delegate = self
        tableView.dataSource = self
        var numRows = CGFloat(6.0)
        var rowHeight = CGFloat(90)
        var tableViewHeight = CGFloat(numRows*rowHeight)
        tableView.frame = CGRect(x: 0, y: navBarView.frame.height, width: view.frame.width, height: tableViewHeight)
        tableView.reloadData()
       // showDatePicker()
   setUpContinueButton()
        
       
        
    }
    
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        currentUser = Auth.auth().currentUser
        iconArray = [image1 ?? UIImage()]
        
    }
    
    func getCountryList() -> [String]{
        var countries: [String] = []
        for code in NSLocale.isoCountryCodes {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country Not Found \(code)"
            countries.append(name)
        }
    //    countries.insert("United States of America", at: 0)
     //   countries.insert("", at: 0)
        
        return countries
    }
    
    
    func setUpContinueButton() {
        view.addSubview(continueButton)
        var buttonHeight = CGFloat(55)
        var buttonWidth = CGFloat(view.frame.width*(3/4))
        continueButton.frame = CGRect(x: (view.frame.width - buttonWidth)/2, y: view.frame.height - buttonHeight - buttonHeight, width: buttonWidth, height: buttonHeight)
        continueButton.layer.cornerRadius = continueButton.frame.width/40
        continueButton.backgroundColor = .systemBlue
        continueButton.titleLabel!.textColor = .white
        continueButton.setTitle("Save", for: .normal)
        continueButton.titleLabel!.font = UIFont(name: "DINAlternate-Bold", size: 20)
        
        let savePressed = UITapGestureRecognizer(target: self, action: #selector(saveButtonPressed))
        continueButton.addGestureRecognizer(savePressed)
        //continueButt
    }
    
    @objc func saveButtonPressed(_ sender: UITapGestureRecognizer) {
        delegate?.passArray(dataArray: userCountries)
        self.dismiss(animated: true, completion: nil)
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
                onePostVC.userDataVM = self.userDataVM
                onePostVC.items = items
                onePostVC.cancelLbl = self.cancelLbl
                
                picker.present(onePostVC, animated: false, completion: nil)
                onePostVC.modalPresentationStyle = .fullScreen
            }
            if (items.count > 1) {
                let uploadPreviewVC = self.storyboard?.instantiateViewController(identifier: "newUploadPreviewVC") as! NewUploadPreviewVC
                //print(photos)
                uploadPreviewVC.userDataVM = self.userDataVM
                uploadPreviewVC.cancelLbl = self.cancelLbl
                uploadPreviewVC.items = items
                //picker.dismiss(animated: false, completion: nil)
                picker.present(uploadPreviewVC, animated: false, completion: nil)
                uploadPreviewVC.modalPresentationStyle = .fullScreen
            }
            else {
//                if (self.cancelLbl == "Skip") {
//                    let musicVC = self.storyboard?.instantiateViewController(withIdentifier: "addMusicVC") as! AddMusicVC
//                    musicVC.userData = self.userData
//                    musicVC.currentUser = self.currentUser
//                    musicVC.cancelLbl = "Skip"
//                    picker.present(musicVC, animated: false, completion: nil)
//                }
                //else {
                    picker.dismiss(animated: false, completion: nil)
                //}
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
        
        let userData = userDataVM?.userData.value
        if userData == nil {
            return
        }
        
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
            let instaHex = HexagonStructData(resource: "https://instagram.com/\(trimmedText)", type: "socialmedia_instagram", location: numPosts, thumbResource: "icons/instagramLogo.png", createdAt: NSDate.now.description, postingUserID: username, text: "", views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "@\(trimmedText)", isPrioritized: false, array: [])
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
            let snapHex = HexagonStructData(resource: "https://www.snapchat.com/add/\(trimmedText)", type: "socialmedia_snapchat", location: numPosts, thumbResource: "icons/snapchatlogo.jpg", createdAt: NSDate.now.description, postingUserID: username, text: "", views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "\(trimmedText)", isPrioritized: false, array: [])
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
            let tikTokHex = HexagonStructData(resource: trimmedText, type: "socialmedia_tiktok", location: numPosts, thumbResource: "icons/tikTokLogo4.png", createdAt: NSDate.now.description, postingUserID: username, text: "", views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "", isPrioritized: false, array: [])
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
            let twitterHex = HexagonStructData(resource: "https://twitter.com/\(trimmedText)", type: "socialmedia_twitter", location: numPosts, thumbResource: "icons/twitter.png", createdAt: NSDate.now.description, postingUserID: username, text: "", views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "@\(trimmedText)", isPrioritized: false, array: [])
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
            let youtubeHex = HexagonStructData(resource: "\(trimmedText)", type: "socialmedia_youtube", location: numPosts, thumbResource: "icons/youtube3.png", createdAt: NSDate.now.description, postingUserID: username, text: "", views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "", isPrioritized: false, array: [])
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
            let vscoHex = HexagonStructData(resource: "https://www.vsco.co/\(trimmedText)/gallery", type: "socialmedia_vsco", location: numPosts, thumbResource: "icons/vscologo1.png", createdAt: NSDate.now.description, postingUserID: username, text: "", views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "@\(trimmedText)", isPrioritized: false, array: [])
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
            let soundCloudHex = HexagonStructData(resource: trimmedText, type: "socialmedia_soundCloud", location: numPosts, thumbResource: "icons/soundCloudLogo.png", createdAt: NSDate.now.description, postingUserID: username, text: "", views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "", isPrioritized: false, array: [])
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
            let twitchHex = HexagonStructData(resource: "https://m.twitch.tv/\(trimmedText)/profile", type: "socialmedia_twitch", location: numPosts, thumbResource: "icons/twitch1.png", createdAt: NSDate.now.description, postingUserID: username, text: "", views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "@\(trimmedText)", isPrioritized: false, array: [])
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
            let linkedInHex = HexagonStructData(resource: "\(trimmedText)", type: "socialmedia_linkedIn", location: numPosts, thumbResource: "icons/linkedInLogo.jpg", createdAt: NSDate.now.description, postingUserID: username, text: "", views: 0,isArchived: false, docID: "WillBeSetLater", coverText: "", isPrioritized: false, array: [])
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
            let etsyHex = HexagonStructData(resource: "https://etsy.com/shop/\(trimmedText)", type: "socialmedia_etsy", location: numPosts, thumbResource: "icons/etsyLogoCircle.png", createdAt: NSDate.now.description, postingUserID: username, text: "", views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "\(trimmedText)", isPrioritized: false, array: [])
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
            let poshmarkHex = HexagonStructData(resource: "https://poshmark.com/closet/\(trimmedText)", type: "socialmedia_poshmark", location: numPosts, thumbResource: "icons/poshmarkLogo.png", createdAt: NSDate.now.description, postingUserID: username, text: "", views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "@\(trimmedText)", isPrioritized: false, array: [])
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
            let hudlHex = HexagonStructData(resource: "\(trimmedText)/", type: "socialmedia_hudl", location: numPosts, thumbResource: "icons/hudl.png", createdAt: NSDate.now.description, postingUserID: username, text: "", views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "", isPrioritized: false, array: [])
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
            let venmoHex = HexagonStructData(resource: "https://venmo.com/\(trimmedText)", type: "socialmedia_venmo", location: numPosts, thumbResource: "icons/venmologo.png", createdAt: NSDate.now.description, postingUserID: username, text: "", views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "\(trimmedText)", isPrioritized: false, array: [])
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
            let cashAppHex = HexagonStructData(resource: "https://cash.app/$\(trimmedText)", type: "socialmedia_cashapp", location: numPosts, thumbResource: "icons/cashapp.png", createdAt: NSDate.now.description, postingUserID: username, text: "", views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "$\(trimmedText)", isPrioritized: false, array: [])
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
            let cameoHex = HexagonStructData(resource: trimmedText, type: "socialmedia_cameo", location: numPosts, thumbResource: "icons/cameo.png", createdAt: NSDate.now.description, postingUserID: username, text: "", views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "", isPrioritized: false, array: [])
            addHex(hexData: cameoHex, completion: {bool in
                success = success && bool
                
            })
        }
   
     

 
        
        print("passed wait for social media tiles")
        userData?.numPosts = numPosts
        userData?.lastTimePosted = NSDate.now.description
        userDataVM?.updateUserData(newUserData: userData!, completion: { success in
            if success {
                //present Home View Controller Segue
//                if (self.cancelLbl == nil) {
                    self.performSegue(withIdentifier: "rewindToFront", sender: nil)
//                }
//                else {
//                    self.skipTapped(recognizer)
//                }
            }
//            else {
//                print("userData not saved \(error?.localizedDescription)")
//            }
            
        })
    }
    
    
    @objc func doneCountryPressed() {
        if (selectedCountry != nil && !userCountries.contains(selectedCountry!)) {
            userCountries.append(selectedCountry!)
        }
        countryPicker.resignFirstResponder()
        tableView.reloadData()
    }
    
    @objc func cancelCountry() {
        countryPicker.resignFirstResponder()
        tableView.reloadData()
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
    
    @objc func xButtonPressed(_ sender: UITapGestureRecognizer) {
        let cell = sender.view?.superview?.superview as! PersonalDetailCell
        print("cell tag: \(cell.interactiveTextField) \(cell.tag)")
        userCountries.remove(at: cell.tag)
        tableView.reloadData()
    }
    
    func formatCountryToImage(myCountry: String) -> String {
        var success = true

        var hyphenCountry = myCountry.replacingOccurrences(of: " ", with: "-") as! String
        hyphenCountry = hyphenCountry.lowercased()
        print("This is hypehenCountry \(hyphenCountry)")
        print("should be a country hex!")
        var countryString = "icons/Flags/\(hyphenCountry).png"
  return countryString
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
        var backButtonWidth = CGFloat(30)
        self.backButton.frame = CGRect(x: 10, y: statusBarHeight + (navBarHeightRemaining - backButtonWidth)/2, width: backButtonWidth, height: backButtonWidth)
        

            let backTap = UITapGestureRecognizer(target: self, action: #selector(self.backButtonpressed))
            backTap.numberOfTapsRequired = 1
            backButton.isUserInteractionEnabled = true
            backButton.addGestureRecognizer(backTap)
            backButton.setImage(UIImage(named: "blackChevron"), for: .normal)
        
        
        let postTap = UITapGestureRecognizer(target: self, action: #selector(self.postTapped))
        postTap.numberOfTapsRequired = 1
        postButton.isUserInteractionEnabled = true
        postButton.addGestureRecognizer(postTap)
        postButton.setTitle("Next", for: .normal)
        postButton.setTitleColor(.systemBlue, for: .normal)
        postButton.isHidden = true
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
        self.navBarView.titleLabel.text = "Add Your Ethnicities"
        
       // self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y: navBarView.frame.maxY - 30, width: 200, height: 30)
        self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 140, y: postButton.frame.minY, width: 280, height: 25)
        navBarView.backgroundColor = .white
        navBarView.titleLabel.textColor = .black
      
    }
    
    
    var textFieldData = [String]()
    @objc func textFieldDidChange(_ textField: UITextField) {
        textFieldData[textField.tag] = textField.text!
    }
    
    
   

}


extension CulturalIdentityVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userCountries.count + 1
    }
    
    // cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     //   print("This is height for row at: \(self.view.frame.height/8)")
    //    return self.view.frame.height/8
   // return 66
        return 90
    }
    

  
//     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        tableView.deselectRow(at: indexPath, animated: true)
//        print("This is number cell tapped \(indexPath.row)")
//        let cell = tableView.dequeueReusableCell(withIdentifier: "personalDetailCell", for: indexPath) as! PersonalDetailCell
//        //birthday cell tapped
//
//        //this is the add country Cell
//
//
//
//        if indexPath.row == 0 {
//
//        }
//
//        //current city cell tapped
//        if indexPath.row == 1 {
//
//        }
//        //gender cell tapped
//        if indexPath.row == 2 {
//
//        }
//        //cultural identity cell tapped
//        if indexPath.row == 3 {
//
//
//        }
//        //phone number cell tapped
//        if indexPath.row == 4 {
//
//        }
//        //relationship cell tapped
//        if indexPath.row == 5 {
//
//        }
//
//
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personalDetailCell", for: indexPath) as! PersonalDetailCell
        cell.tag = indexPath.row
        cell.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/8)
        cell.backgroundColor = .systemGray6
        var myGray = cell.backgroundColor
        cell.layer.borderColor = myGray?.cgColor
        cell.layer.borderWidth = 10
       // let cellTappedRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
       // cell.addGestureRecognizer(cellTappedRecognizer)
        //  Configure the cell...
        //cell.socialMediaIcon.image = UIImage(named: "unity")
        cell.socialMediaIcon.layer.cornerRadius = cell.socialMediaIcon.frame.size.width / 2
        cell.socialMediaIcon.clipsToBounds = true
        cell.socialMediaIcon.layer.borderWidth = 1.0
        cell.socialMediaIcon.layer.borderColor = white.cgColor
        cell.interactiveTextField.isUserInteractionEnabled = true
        cell.interactiveTextField.textColor = .black
        
   
        cell.interactiveTextField.attributedPlaceholder = NSAttributedString(string: "Cultural Identity",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        
        if indexPath.row < userCountries.count {
        cell.interactiveTextField.text = userCountries[indexPath.row]
            cell.xButton.isHidden = false
            cell.xButton.setImage(UIImage(named: "x"), for: .normal)
            let xtap = UITapGestureRecognizer(target: self, action: #selector(xButtonPressed))
            cell.xButton.addGestureRecognizer(xtap)
        var countryText = formatCountryToImage(myCountry: userCountries[indexPath.row])
            var countryName = userCountries[indexPath.row]
            if countryText != "" {
                countryText = "icons/Flags/\(countryText).png"
//                print("This is countryText")
        }
            cell.interactiveTextField.isUserInteractionEnabled = false

            if countryName != "" {
                countryName = countryName.lowercased()
                countryName = countryName.replacingOccurrences(of: " ", with: "-")
            cell.socialMediaIcon.image = UIImage(named: "\(countryName).png") ?? UIImage(named: "unity")
//                print("This should be chaning the image and this is country name \(countryName)")
            }
            
        }
            
            
        cell.circularMask.frame = cell.socialMediaIcon.frame
        cell.interactiveTextField.textColor = .black
        cell.interactiveTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        cell.interactiveTextField.tag = indexPath.row
//        if (textFieldData.count > indexPath.row) {
//            cell.interactiveTextField.text = textFieldData[indexPath.row]
//        }
        if indexPath.row == userCountries.count {
            cell.xButton.isHidden = true
            cell.interactiveTextField.attributedPlaceholder = NSAttributedString(string: "Add Another Cultural Identity",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
          //  let cellTap = UITapGestureRecognizer(target: self, action: #selector(relationshipCellTap))
           //     cell.addGestureRecognizer(cellTap)
            cell.interactiveTextField.inputView = countryPicker
            //ToolBar
            let toolbar = UIToolbar();
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneCountryPressed));
             let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
           let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelCountry));

          toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)

            cell.interactiveTextField.inputAccessoryView = toolbar
             cell.interactiveTextField.inputView = countryPicker
            
            cell.socialMediaIcon.image = UIImage(named: "unity")
            
        }
        
        

       // cell.frame = cell.frame.offsetBy(dx: 10, dy: 10)
      //  cell.socialMediaIcon.image = UIImage(named: "united-states")
        cellArray.append(cell)
        
        return cell
    }
}

