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

class AddSocialMediaTableView: UIViewController {
    var navBarView = NavBarView()
    var titleLabel1 = UILabel()
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    
    var currentUser: User?
    var loadUserDataArray = ThreadSafeArray<UserData>()
    var searchString: String = ""
    var userData: UserData?
    var textFieldArray: [UITextField] = []
    
    var followList = [String]()
    var followListener: ListenerRegistration?
    var isCompletelyEmpty = true
    
    var socialMediaArray: [String] = ["instagram", "snapchat", "tikTok", "twitter", "youtube", "vsco", "soundcloud", "twitch", "linkedIn", "etsy", "poshmark", "hudl"]
    
    var image1 = UIImage(named: "instagramLogo")
    var image2 = UIImage(named: "snapchatlogo")
    var image3 = UIImage(named: "tikTokCircle")
    var image4 = UIImage(named: "twitterapp")
    var image5 = UIImage(named: "youtube3")
    var image6 = UIImage(named: "vscologo1")
    var image7 = UIImage(named: "soundCloudCircleOrange")
    var image8 = UIImage(named: "twitchCircle")
    var image9 = UIImage(named: "linkedIn7")
    var image10 = UIImage(named: "etsyLogoCircle")
    var image11 = UIImage(named: "poshmarkLogo")
    var image12 = UIImage(named: "hudlapp")
    var image13 = UIImage(named: "twitchCircle")
    
    
    
    
    var iconArray: [UIImage] = []
    //[image1,image2,image3,image4,image5,image6,image7,image8,image9,image10,image11,image12]
    //var iconArray: [UIImage] = [UIImage(named: "icons/instagramLogo.png")!,UIImage(named: "icons/snapchatLogo.png")!,UIImage(named: "icons/tikTokLogo.png")!,UIImage(named: "icons/twitterLogo.png")!,UIImage(named: "icons/youtubeLogo.png")!,UIImage(named: "icons/twitch1.png")!,UIImage(named: "icons/soundCloudLogo.png")!,UIImage(named: "icons/venmo1.png")!,UIImage(named: "icons/linkedInLogo.png")!,UIImage(named: "icons/etsyLogo.png")!,UIImage(named: "icons/poshmarkLogo.png")!,UIImage(named: "icons/hudl1.png")!]
    var placeHolderTextArray: [String] = ["Instagram Username", "Snapchat Username", "Tik Tok Username", "Twitter Handle", "Youtube Channel Name", "Twitch Username", "Soundcloud Link", "Twitch Username", "LinkedIn Link", "Etsy Shop Name", "Poshmark Username", "Hudl Link"]
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
        cancelButton.sizeToFit()
        cancelButton.frame = CGRect(x: 5, y: (navBarView.frame.height/4), width: navBarView.frame.height/2, height: navBarView.frame.height/2)
        cancelButton.setBackgroundImage(UIImage(named: "whiteBack"), for: .normal)
        doneButton.frame = CGRect(x: self.view.frame.width - doneButton.frame.width-5, y: self.tableView.frame.minY/4, width: doneButton.frame.width, height: doneButton.frame.height)
        doneButton.frame = CGRect(x: (self.view.frame.width) - (navBarView.frame.height) - 5, y: 0, width: navBarView.frame.height, height: navBarView.frame.height)
        doneButton.setTitle("Post", for: .normal)
        doneButton.setTitleColor(.systemBlue, for: .normal)
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        currentUser = Auth.auth().currentUser
        iconArray = [image1 ?? UIImage(),image2 ?? UIImage(),image3 ?? UIImage(),image4 ?? UIImage(),image5 ?? UIImage(),image6 ?? UIImage(),image7 ?? UIImage(),image8 ?? UIImage(),image9 ?? UIImage(),image10 ?? UIImage(),image11 ?? UIImage(),image12 ?? UIImage()]
    }
    
    @IBAction func donePressed(_ sender: UIButton) {
        print("done button pressed")
        
        // dismiss keyboard
        self.view.endEditing(true)
        
        
        // if fields are empty
        self.isCompletelyEmpty = true
        
        for txtField in self.textFieldArray {
            if txtField.text!.isEmpty {
                print("nothing here")
            } else {
                self.isCompletelyEmpty = false
            }
        }
        
        
        if (isCompletelyEmpty == true) {
            
            // alert message
            let alert = UIAlertController(title: "Hold up", message: "Fill in a field or Hit Cancel", preferredStyle: UIAlertController.Style.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        let username = userData!.publicID
        var numPosts = userData!.numPosts
        
        var count = 0
        for field in textFieldArray {
            if !field.text!.isEmpty {
                count += 1
            }
        }
        if numPosts + count > 37 {
            // too many posts
            let overflow = numPosts + count - 37
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
        if (!textFieldArray[0].text!.isEmpty) {
            numPosts += 1
            let instaHex = HexagonStructData(resource: "https://instagram.com/\(textFieldArray[0].text!)", type: "socialmedia_instagram", location: numPosts, thumbResource: "icons/instagramLogo.png", createdAt: NSDate.now.description, postingUserID: username, text: "\(textFieldArray[0].text!)", views: 0, isArchived: false, docID: "WillBeSetLater")
            addHex(hexData: instaHex, completion: { bool in
                success = success && bool
                
            })
        }
        
        if (!textFieldArray[1].text!.isEmpty) {
            numPosts += 1
            let snapHex = HexagonStructData(resource: "https://www.snapchat.com/add/\(textFieldArray[1].text!)", type: "socialmedia_snapchat", location: numPosts, thumbResource: "icons/snapchatlogo.jpg", createdAt: NSDate.now.description, postingUserID: username, text: "\(textFieldArray[1].text!)", views: 0, isArchived: false, docID: "WillBeSetLater")
            addHex(hexData: snapHex, completion: {bool in
                success = success && bool
                
            })
        }
        
        if (!textFieldArray[3].text!.isEmpty) {
            numPosts += 1
            let twitterHex = HexagonStructData(resource: "https://twitter.com/\(textFieldArray[3].text!)", type: "socialmedia_twitter", location: numPosts, thumbResource: "icons/twitter.png", createdAt: NSDate.now.description, postingUserID: username, text: "\(textFieldArray[3].text!)", views: 0, isArchived: false, docID: "WillBeSetLater")
            addHex(hexData: twitterHex, completion: {bool in
                success = success && bool
                
            })
        }
        
        if (!textFieldArray[6].text!.isEmpty) {
            numPosts += 1
            let soundCloudHex = HexagonStructData(resource: textFieldArray[6].text!, type: "socialmedia_soundCloud", location: numPosts, thumbResource: "icons/soundCloudLogo.png", createdAt: NSDate.now.description, postingUserID: username, text: "\(textFieldArray[6].text!)", views: 0, isArchived: false, docID: "WillBeSetLater")
            addHex(hexData: soundCloudHex, completion: {bool in
                success = success && bool
                
            })
        }
        
        if (!textFieldArray[8].text!.isEmpty) {
            numPosts += 1
            let linkedInHex = HexagonStructData(resource: "\(textFieldArray[8].text!)", type: "socialmedia_linkedIn", location: numPosts, thumbResource: "icons/linkedInLogo.jpg", createdAt: NSDate.now.description, postingUserID: username, text: "\(textFieldArray[8].text!)", views: 0,isArchived: false, docID: "WillBeSetLater")
            addHex(hexData: linkedInHex, completion: {bool in
                success = success && bool
                
            })
        }
     
        
        if (!textFieldArray[2].text!.isEmpty) {
            numPosts += 1
            let tikTokHex = HexagonStructData(resource: "https://www.tiktok.com/\(textFieldArray[2].text!)/", type: "socialmedia_tiktok", location: numPosts, thumbResource: "icons/tiktoklogo.png", createdAt: NSDate.now.description, postingUserID: username, text: "\(textFieldArray[2].text!)", views: 0, isArchived: false, docID: "WillBeSetLater")
            addHex(hexData: tikTokHex, completion: {bool in
                success = success && bool
                
            })
        }
        
        if (!textFieldArray[5].text!.isEmpty) {
            numPosts += 1
            let vscoHex = HexagonStructData(resource: "https://www.vsco.co/\(textFieldArray[5].text!)/gallery", type: "socialmedia_vsco", location: numPosts, thumbResource: "icons/vscologo1.png", createdAt: NSDate.now.description, postingUserID: username, text: "\(textFieldArray[5].text!)", views: 0, isArchived: false, docID: "WillBeSetLater")
            addHex(hexData: vscoHex, completion: {bool in
                success = success && bool
                
            })
        }
        
        if (!textFieldArray[11].text!.isEmpty) {
            numPosts += 1
            let hudlHex = HexagonStructData(resource: "\(textFieldArray[11].text!)/", type: "socialmedia_hudl", location: numPosts, thumbResource: "icons/hudl.png", createdAt: NSDate.now.description, postingUserID: username, text: "\(textFieldArray[11].text!)", views: 0, isArchived: false, docID: "WillBeSetLater")
            addHex(hexData: hudlHex, completion: {bool in
                success = success && bool
                
            })
        }
        if (!textFieldArray[7].text!.isEmpty) {
            numPosts += 1
            let twitchHex = HexagonStructData(resource: "https://m.twitch.tv/\(textFieldArray[5].text!)/profile", type: "socialmedia_twitch", location: numPosts, thumbResource: "icons/twitch1.png", createdAt: NSDate.now.description, postingUserID: username, text: "https://m.twitch.tv/\(textFieldArray[5].text!)/profile", views: 0, isArchived: false, docID: "WillBeSetLater")
            addHex(hexData: twitchHex, completion: {bool in
                success = success && bool
                
            })
        }
        
        
        if (!textFieldArray[10].text!.isEmpty) {
            numPosts += 1
            let poshmarkHex = HexagonStructData(resource: "https://poshmark.com/closet/\(textFieldArray[10].text!)", type: "socialmedia_poshmark", location: numPosts, thumbResource: "icons/poshmarkLogo.png", createdAt: NSDate.now.description, postingUserID: username, text: "\(textFieldArray[10].text!)", views: 0, isArchived: false, docID: "WillBeSetLater")
            addHex(hexData: poshmarkHex, completion: {bool in
                success = success && bool
                
            })
        }
        
        if (!textFieldArray[9].text!.isEmpty) {
            numPosts += 1
            let etsyHex = HexagonStructData(resource: "https://etsy.com/closet/\(textFieldArray[9].text!)", type: "socialmedia_etsy", location: numPosts, thumbResource: "icons/etsyLogo.png", createdAt: NSDate.now.description, postingUserID: username, text: "\(textFieldArray[9].text!)", views: 0, isArchived: false, docID: "WillBeSetLater")
            addHex(hexData: etsyHex, completion: {bool in
                success = success && bool
                
            })
        }
        
//        if (!textFieldArray[11].text!.isEmpty) {
//            numPosts += 1
//            let poshmarkHex = HexagonStructData(resource: "https://poshmark.com/closet/\(textFieldArray[11].text!)", type: "socialmedia_poshmark", location: numPosts, thumbResource: "icons/poshmarkLogo.png", createdAt: NSDate.now.description, postingUserID: username, text: "\(textFieldArray[11].text!)", views: 0, isArchived: false, docID: "WillBeSetLater")
//            addHex(hexData: poshmarkHex, completion: {bool in
//                success = success && bool
//
//            })
//        }
        
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
    
    func setUpNavBarView() {
        self.view.addSubview(navBarView)
        self.navBarView.addSubview(titleLabel1)
        self.navBarView.addBehavior()
        self.navBarView.frame = CGRect(x: -5, y: -5, width: self.view.frame.width + 10, height: (self.view.frame.height/12)+5)
        self.navBarView.backgroundColor = UIColor(cgColor: CGColor(gray: 0.05, alpha: 1.0))
        self.navBarView.layer.borderWidth = 0.25
        self.navBarView.layer.borderColor = CGColor(gray: 2/3, alpha: 1.0)
        self.titleLabel1.text = "Add Social Media"
    //    self.navBarView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/15)
       // self.tableiew.frame = CGRect(x: 0, y: self.view.frame.height/12, width: self.view.frame.width, height: self.view.frame.height*(11/12))
        self.titleLabel1.frame = CGRect(x: 0, y: 10, width: self.view.frame.width, height: self.navBarView.frame.height-10)
        self.titleLabel1.textAlignment = .center
       
        self.titleLabel1.font = UIFont(name: "DINAlternate-Bold", size: 22)
        self.titleLabel1.textColor = .white
      //  self.navBarView.backgroundColor = .clear
        
        cancelButton.sizeToFit()
        cancelButton.frame = CGRect(x: 5, y: navBarView.frame.midY - cancelButton.frame.height/2 + 10, width: cancelButton.frame.width, height: cancelButton.frame.height)
        cancelButton.frame = CGRect(x: 5, y: (navBarView.frame.height/4), width: navBarView.frame.height/2, height: navBarView.frame.height/2)
    //    backButton.setBackgroundImage(UIImage(named: "whiteBack"), for: .normal)
        
        
        view.bringSubviewToFront(cancelButton)
        doneButton.sizeToFit()
        doneButton.frame = CGRect(x: view.frame.width - doneButton.frame.width - 10, y: navBarView.frame.midY - cancelButton.frame.height/2 + 10, width: cancelButton.frame.width, height: cancelButton.frame.height)
        view.bringSubviewToFront(doneButton)
//        doneButton.titleLabel!.font = UIFont(name: "DINAlternate-Bold", size: 20)
    }
 
    
    var listenerList: [ListenerRegistration]?
    
  
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
    return 80
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("socialMediaArray: \(socialMediaArray.count)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "addSocialMediaCell", for: indexPath) as! AddSocialMediaCell
        cell.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/8)
       // let cellTappedRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
       // cell.addGestureRecognizer(cellTappedRecognizer)
        cell.userData = userData
        //  Configure the cell...
        print("This is cell \(cell)")
        cell.socialMediaIcon.image = iconArray[indexPath.row] ?? UIImage(named: "instagramLogo")
        cell.socialMediaIcon.layer.cornerRadius = cell.socialMediaIcon.frame.size.width / 2
        cell.socialMediaIcon.clipsToBounds = true
        cell.socialMediaIcon.layer.borderWidth = 1.0
        cell.socialMediaIcon.layer.borderColor = white.cgColor
        
        if indexPath.row == 2 {
            cell.socialMediaIcon.layer.cornerRadius = cell.socialMediaIcon.frame.size.width / 2
            cell.socialMediaIcon.clipsToBounds = true
            cell.socialMediaIcon.image = UIImage(named: "tikTokLogo4")
//            cell.socialMediaIcon.layer.borderWidth = 1.0
//            cell.socialMediaIcon.layer.borderColor = white.cgColor
        }
        
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
        self.textFieldArray.append(cell.interactiveTextField)
        
       
        
        
        //cell = loadUserDataArray![indexPath.row]
        //print("This is cell image \(cell.avaImg.image)")
        //   cell.previewImage.setupHexagonMask(lineWidth: 10.0, color: .black, cornerRadius: 10.0)
        //     cellArray.append(cell)
        return cell
    }
}
