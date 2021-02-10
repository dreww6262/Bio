//
//  EditMusicPostVC.swift
//  
//
//  Created by Ann McDonough on 11/24/20.
//
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseUI
import FirebaseFirestore
import Alamofire



class EditMusicPostVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    var navBarView = NavBarView()
    var poppinsBlack = UIFont(name: "poppins-Black", size: UIFont.labelFontSize)
    var poppinsSemiBold = UIFont(name: "poppins-SemiBold", size: UIFont.labelFontSize)
    
    //    label.font = UIFontMetrics.default.scaledFont(for: customFont)
    //    label.adjustsFontForContentSizeCategory = true
    var hasMadeChanges = false
   var textOverlayLabel = UILabel()
    
    var bottomLine = CALayer()
    var badMusicLink = false
    var hasChosenThumbnailImage = false
    var artistText = ""
    var songText = ""
    var lowTitleTextFrame = CGRect()
    var lowSubtitleTextFrame = CGRect()
//   var songNameTextField = UITextField()
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
    var hexData: HexagonStructData?
    var madeAnEdit = false
    var changedPhoto = false
    var originalCaption = ""
    var originalTextOverlay = ""
    var originalPriority = false
    var captionString = ""
    var textOverlayString = ""
    @IBOutlet weak var linkLogo: UIImageView!
    
    // scrollView
    @IBOutlet weak var scrollView: UIScrollView!
    
    // textfields
    var linkTextField = UITextField()
    
   var linkHexagonImage = UIImageView()
    var linkHexagonImageCopy = UIImageView()
    
    // buttons
    var postButton = UIButton()
    var backButton = UIButton()
    
    var currentUser: User? = Auth.auth().currentUser
    var userDataVM: UserDataVM?
    var userDataRef: DocumentReference? = nil
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    var cancelLbl: String?
    
    @IBOutlet weak var changeCoverLabel: UILabel!
    
    var captionTextField = UITextField()
    var textOverlayTextField = UITextField()
    var prioritizeLabel = UILabel()
    var checkBox = UIButton()
    var checkBoxStatus = false
    var ogMusicLink = ""
    var ogCaption = ""
    var ogTextOverlay = ""
    var ogPhoto = UIImage()
    var ogCheckboxStatus = false
    
    
    // reset default size
    var scrollViewHeight : CGFloat = 0
    
    // keyboard frame size
    var keyboard = CGRect()
    
    let searchTable = UITableView()
    var searchResults = [MusicItem]()


    
    // default func
    override func viewDidLoad() {
        textOverlayLabel.isHidden = true
        checkBox.setImage(UIImage(named: "tealEmpty"), for: .normal)
        linkLogo.isHidden = true
        linkHexagonImage.isHidden = false
        textOverlayTextField.text = textOverlayString
        captionTextField.text = captionString
        originalTextOverlay = textOverlayString
        originalCaption = captionString
        originalPriority = checkBoxStatus
        textOverlayLabel.text = textOverlayString
//        confirmLinkButton.isHidden = true
        setUpNavBarView()
        
        let checkBoxTap = UITapGestureRecognizer(target: self, action: #selector(checkBoxTapped(_:)))
     //   checkBoxTap.numberOfTapsRequired = 1
        //checkBox.isUserInteractionEnabled = true
        checkBox.addGestureRecognizer(checkBoxTap)
        
        linkHexagonImageCopy.contentMode = .scaleAspectFit
       // linkHexagonImageCopy.image = UIImage(named: "addCover")
        scrollView.addSubview(linkHexagonImageCopy)
        linkHexagonImage.isHidden = false
        linkHexagonImageCopy.isHidden = true
        
        let linkTapCopy = UITapGestureRecognizer(target: self, action: #selector(AddLinkVCViewController.loadImg(_:)))
        linkHexagonImageCopy.isUserInteractionEnabled = true
        linkHexagonImageCopy.addGestureRecognizer(linkTapCopy)
        
        
        scrollView.addSubview(captionTextField)
        scrollView.addSubview(textOverlayTextField)
        scrollView.addSubview(textOverlayLabel)
        scrollView.addSubview(prioritizeLabel)
        scrollView.addSubview(linkHexagonImage)
//        scrollView.addSubview(songNameTextField)
        scrollView.addSubview(linkTextField)
        scrollView.addSubview(checkBox)
        scrollView.addSubview(linkHexagonImageCopy)
        textOverlayTextField.delegate = self
        _ = false
        super.viewDidLoad()
                
        let linkTap = UITapGestureRecognizer(target: self, action: #selector(AddLinkVCViewController.loadImg(_:)))
        linkTap.numberOfTapsRequired = 1
        linkHexagonImage.isUserInteractionEnabled = true
        linkHexagonImage.addGestureRecognizer(linkTap)
        
    // insertTextOverlay()
        
        
        //poshmarkLogo.image = UIImage(named: "poshmarkLogo")
        _ = #colorLiteral(red: 0.9882352941, green: 0.7607843137, blue: 0, alpha: 1)
        _ = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        _ = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        
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
        
        
        linkHexagonImage.frame = CGRect(x: 40, y: navBarView.frame.maxY + 10, width: scrollView.frame.width - 80, height: scrollView.frame.width - 80)
        
        linkHexagonImage.setupHexagonMask(lineWidth: linkHexagonImage.frame.width/15, color: myCoolBlue, cornerRadius: linkHexagonImage.frame.width/15)
        linkTextField.frame = CGRect(x: 10, y: linkHexagonImage.frame.maxY + 20, width: self.view.frame.size.width - 20, height: 30)
        linkTextField.attributedPlaceholder = NSAttributedString(string: "Artist",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        linkLogo.frame = CGRect(x: scrollView.frame.width - 40, y: linkTextField.frame.minY, width: 30, height: 30)
        
//        songNameTextField.frame = CGRect(x: 10, y: linkTextField.frame.maxY + 5, width: self.view.frame.size.width - 20, height: 30)
//        songNameTextField.attributedPlaceholder = NSAttributedString(string: "Song/Album Name (Optional)",attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
   

        setUpNavBarView()
        
        
        let placeHolderImage = UIImage(named: "musicCenter")
        if hexData!.thumbResource.contains("userFiles") {
            let cleanRef = hexData!.thumbResource.replacingOccurrences(of: "/", with: "%2F")
            let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/bio-social-media.appspot.com/o/\(cleanRef)?alt=media")
            if url != nil {
                
                linkHexagonImage.sd_setImage(with: url!, placeholderImage: placeHolderImage, options: .refreshCached) { (_, error, _, _) in
                    if (error != nil) {
                        print(error!.localizedDescription)
                        self.linkHexagonImage.image = placeHolderImage
                    }
                }
            }
            else {
                linkHexagonImage.image = placeHolderImage
            }
        }
        else {
            let url = URL(string: hexData!.thumbResource)
            if url != nil {
                linkHexagonImage.sd_setImage(with: url, completed: nil)
            }
        }
        
        
        linkTextField.attributedPlaceholder = NSAttributedString(string: "Track Name (Required)",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        linkLogo.frame = CGRect(x: scrollView.frame.width - 40, y: linkTextField.frame.minY, width: 30, height: 30)
        
        linkHexagonImage.frame = CGRect(x: 40, y: self.navBarView.frame.maxY + 10, width: scrollView.frame.width - 80, height: scrollView.frame.width - 80)
        
        linkHexagonImageCopy.frame = CGRect(x: 40, y: navBarView.frame.maxY + 10, width: scrollView.frame.width - 80, height: scrollView.frame.width - 80)
        
        linkHexagonImageCopy.setupHexagonMask(lineWidth: linkHexagonImageCopy.frame.width/15, color: myBlueGreen, cornerRadius: linkHexagonImageCopy.frame.width/15)
        
        linkTextField.frame = CGRect(x: 10, y: linkHexagonImage.frame.maxY, width: self.view.frame.size.width - 20, height: 30)
        let frame = CGRect(x: 10, y: linkTextField.frame.maxY + 10, width: self.view.frame.size.width - 20, height: 30)
        
        captionTextField.frame = CGRect(x: 10, y: frame.maxY + 5, width: self.view.frame.size.width - 20, height: 30)
        captionTextField.attributedPlaceholder = NSAttributedString(string: "Write a Caption... (Optional)",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        textOverlayTextField.frame = CGRect(x: 10, y: captionTextField.frame.maxY + 5, width: self.view.frame.size.width - 20, height: 30)
        textOverlayTextField.attributedPlaceholder = NSAttributedString(string: "Add Text To Cover Photo (Optional)",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
prioritizeLabel.frame = CGRect(x: 10, y: textOverlayTextField.frame.maxY + 5, width: self.view.frame.size.width - 20, height: 30)
prioritizeLabel.text = "Prioritize This Post?"
        checkBox.frame = CGRect(x: 165, y: textOverlayTextField.frame.maxY + 5, width: 30, height: 30)
        

     
        
        
        
        
        // let bottomLine = CALayer()
        self.bottomLine.frame = CGRect(x: 0.0, y: linkTextField.frame.height, width: linkTextField.frame.width, height: 1.0)
        self.bottomLine.backgroundColor = UIColor(red: 0.82, green: 0.82, blue: 0.84, alpha: 1.00).cgColor
        let bottomLine2 = CALayer()
        bottomLine2.frame = CGRect(x: 0.0, y: frame.height, width: linkTextField.frame.width, height: 1.0)
        bottomLine2.backgroundColor = UIColor(red: 0.82, green: 0.82, blue: 0.84, alpha: 1.00).cgColor
        linkTextField.borderStyle = UITextField.BorderStyle.none
        linkTextField.layer.addSublayer(self.bottomLine)
        linkTextField.backgroundColor = .clear
//        songNameTextField.borderStyle = UITextField.BorderStyle.none
//        songNameTextField.layer.addSublayer(bottomLine2)
//        songNameTextField.backgroundColor = .clear
        linkLogo.frame = CGRect(x: scrollView.frame.width - 40, y: linkTextField.frame.minY, width: 30, height: 30)
        
        
        linkTextField.font = UIFont(name: "Poppins", size: 20)
        
        let bottomLine3 = CALayer()
        bottomLine3.backgroundColor = UIColor(red: 0.82, green: 0.82, blue: 0.84, alpha: 1.00).cgColor
        captionTextField.borderStyle = UITextField.BorderStyle.none
        captionTextField.layer.addSublayer(bottomLine3)
        bottomLine3.frame = CGRect(x: 0.0, y: captionTextField.frame.height, width: captionTextField.frame.width, height: 1.0)
        captionTextField.backgroundColor = .clear
        captionTextField.borderStyle = UITextField.BorderStyle.none
        captionTextField.font = UIFont(name: "Poppins", size: 20)
        captionTextField.textColor = .white
        
        let bottomLine4 = CALayer()
        bottomLine4.backgroundColor = UIColor(red: 0.82, green: 0.82, blue: 0.84, alpha: 1.00).cgColor
        textOverlayTextField.borderStyle = UITextField.BorderStyle.none
        textOverlayTextField.layer.addSublayer(bottomLine4)
        bottomLine4.frame = CGRect(x: 0.0, y: textOverlayTextField.frame.height, width: textOverlayTextField.frame.width, height: 1.0)
        textOverlayTextField.backgroundColor = .clear
        textOverlayTextField.borderStyle = UITextField.BorderStyle.none
        textOverlayLabel.font = UIFont(name: "DINAlternate-Bold", size: 50)
        textOverlayTextField.textColor = .white
        
        
        let bottomLine5 = CALayer()
        bottomLine5.backgroundColor = UIColor(red: 0.82, green: 0.82, blue: 0.84, alpha: 1.00).cgColor
        //prioritizeLabel.borderStyle = UITextField.BorderStyle.none
        prioritizeLabel.layer.addSublayer(bottomLine5)
        bottomLine5.frame = CGRect(x: 0.0, y: prioritizeLabel.frame.height, width: prioritizeLabel.frame.width, height: 1.0)
        
      prioritizeLabel.backgroundColor = .clear
        
    //    prioritizeLabel.borderStyle = UITextField.BorderStyle.none
       // prio.font = UIFont(name: "DINAlternate-Bold", size: 50)
        prioritizeLabel.textColor = .white

        
        
        
        
    
        linkTextField.textColor = .white
//        songNameTextField.textColor = .white
       
        
        postButton.titleLabel?.font = UIFontMetrics.default.scaledFont(for: poppinsSemiBold ?? UIFont(name: "DINAlternate-Bold", size: 20)!)
        postButton.titleLabel!.adjustsFontForContentSizeCategory = true
        
     //   setUpTextOverlayLabel()
        insertTextOverlay(linkHexagonImage: linkHexagonImage)
        if textOverlayString != "" {
            textOverlayLabel.isHidden = false
        }
        else {
       textOverlayLabel.isHidden = true
        }
        
        searchTable.frame = CGRect(x: linkTextField.frame.minX, y: linkTextField.frame.maxY, width: linkTextField.frame.width, height: 0)
        searchTable.register(MusicSuggestionCell.self, forCellReuseIdentifier: "musicSuggestion")
        searchTable.dataSource = self
        searchTable.delegate = self
        searchTable.backgroundColor = .gray
        searchTable.rowHeight = 70
        searchTable.estimatedRowHeight = 100
        searchTable.allowsSelection = true
        
        view.addSubview(searchTable)
        
        linkTextField.delegate = self
        linkTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        getSpotifyToken()
        
    }
    func getSpotifyToken() {
        let parameters = ["client_id" : "747b180c3b2746a3a235d4cc93c62173",
                              "client_secret" : "796e347bb2de4214a320703ee7e85f74",
                              "grant_type" : "client_credentials"]
        
        AF.request("https://accounts.spotify.com/api/token", method: .post, parameters: parameters).responseJSON(completionHandler: {
            response in
//            print(response.result)
            if response.data != nil {
                do {
                    let readableJSON = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! [String: Any]
                    self.token = readableJSON["access_token"] as! String?
                }
                catch {
                    print(error)
                }
            }
        })
       
    }
    
    func insertTextOverlay(linkHexagonImage: UIImageView) {
    linkHexagonImage.addSubview(textOverlayLabel)
    textOverlayLabel.clipsToBounds = true
    textOverlayLabel.textAlignment = .center
    linkHexagonImage.bringSubviewToFront(textOverlayLabel)
    //self.contentView.addSubview(imageCopy)
        textOverlayLabel.frame = CGRect(x: 0, y: linkHexagonImage.frame.height*(6/10), width: linkHexagonImage.frame.width, height: 20*(linkHexagonImage.frame.height/150))
   // textOverlayLabel.frame = CGRect(x: 0, y: linkHexagonImage.frame.height*(6/10), width: linkHexagonImage.frame.width, height: 20)
        textOverlayLabel.text = textOverlayTextField.text!
    textOverlayLabel.numberOfLines = 1
    textOverlayLabel.font = UIFont(name: "DINAternate-Bold", size: 10)
    textOverlayLabel.textColor = white
        
    textOverlayLabel.textAlignment = .center
      //  image.bringSubviewToFront(image.textOverlay)
        //self.contentView.addSubview(imageCopy)
    //    image.textOverlay.frame = CGRect(x: 0, y: image.frame.height*(5/10) + 4, width: image.frame.width, height: 20)
        //textOverlayLabel.frame = CGRect(x: self.linkHexagonImage.frame.minX, y:self.linkHexagonImage.frame.minY + linkHexagonImage.frame.height*(6/10), width: linkHexagonImage.frame.width, height: 20)
//      textOverlayLabel.text = "image.hexData!.coverText"
        textOverlayLabel.numberOfLines = 1
        textOverlayLabel.font = UIFont(name: "DINAternate-Bold", size: 10)
        textOverlayLabel.textColor = white
        
      
        
        
        
  //      if image.hexData!.coverText != "" {
            textOverlayLabel.backgroundColor = UIColor(white: 0.25, alpha: 0.5)
//            let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
//            visualEffectView.backgroundColor = .clear
//            image.textOverlay.addSubview(visualEffectView)
//            visualEffectView.frame = CGRect(x: 0, y: 0, width: image.textOverlay.frame.width, height: image.textOverlay.frame.height)
            
//            visualEffectView.backgroundColor = UIColor(white: 0.1, alpha: 0.3)
//            image.sendSubviewToBack(visualEffectView)
      //  }

        
     //   textOverlayLabel.text = "YOOOOOOOOOO"
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
        self.backButton.frame = CGRect(x: 10, y: statusBarHeight + (navBarHeightRemaining - 34)/2, width: 34, height: 34)
//        self.navBarView.addSubview(toSettingsButton)
//        self.navBarView.addSubview(toSearchButton)
        
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
        
    
        
        //self.backButton.frame = CGRect(x: 10, y: (navBarView.frame.height - 25)/2, width: 25, height: 25)
        
        //backButton.sizeToFit()
        postButton.frame = CGRect(x: navBarView.frame.width - 50, y: statusBarHeight + (navBarHeightRemaining - 34)/2, width: 40, height: 34)
        //navBarView.postButton.titleLabel?.sizeToFit()
        navBarView.postButton.titleLabel?.textAlignment = .right
        _ = navBarView.frame.maxY
  
        self.navBarView.addBehavior()
        self.navBarView.titleLabel.text = "Edit Post"
       // self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y: navBarView.frame.maxY - 30, width: 200, height: 30)
        self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y: postButton.frame.minY, width: 200, height: 25)
//        print("This is navBarView.")
      
      
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == linkTextField {
            linkTextField.text = ""
            createRequestURL = ""
            searchResults.removeAll()
            searchTable.reloadData()
            if !hasChosenThumbnailImage  && !hexData!.thumbResource.contains("userFiles") {
                linkHexagonImage.image = UIImage(named: "addCover")
            }
            
//            UIView.animate(withDuration: 0.25, animations: {
//                self.searchTable.frame = CGRect(x: self.linkTextField.frame.minX, y: self.linkTextField.frame.maxY, width: self.linkTextField.frame.width, height: 150)
//            })
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
        if textField == linkTextField {
            UIView.animate(withDuration: 0.25, animations: {
                self.searchTable.frame = CGRect(x: self.linkTextField.frame.minX, y: self.linkTextField.frame.maxY, width: self.linkTextField.frame.width, height: 0)
            })
        }
        
        else if textOverlayLabel == textField {
            if textOverlayTextField.text != "" {
                textOverlayLabel.isHidden = false
                textOverlayLabel.text = textOverlayTextField.text!
            }
            else {
                print("text overlay textfield empty")
                textOverlayLabel.isHidden = true
            }
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if textField.text == "" {
            searchResults.removeAll()
            searchTable.reloadData()
        }
        
        let keywords = linkTextField.text
        let finalKeywords = keywords?.replacingOccurrences(of: " ", with: "+")
        let searchURL = "https://api.spotify.com/v1/search?q=\(finalKeywords!)&type=track&limit=10"
        
        
        let url = URL(string: searchURL)
        if url != nil {
            var request = URLRequest(url: url!)
            request.addValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")
            //callAlamo(url: searchURL)
            AF.request(request).responseJSON(completionHandler: { response in
                if response.data != nil {
                    self.parseData(jsonData: response.data!)
                }
            })
        
        }
    }
    
    func parseData(jsonData: Data) {
        do {
            let readableJSON = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as! [String: Any]
            //print("readableJson: \(readableJSON)")
            if let tracks = readableJSON["tracks"] as? [String: Any] {
                if let items = tracks["items"] as? [[String: Any]] {
                    searchResults.removeAll()
                    for i in 0..<items.count{
                        let item = items[i]
//                        print("item: \(item)")
                        let name = item["name"] as! String
                        
                        let previewURL = item["uri"] as? String? ?? ""
                        if let album = item["album"] as? [String: Any] {
                            var artist = ""
                            //print("album: \(album)")
                            var imageUrl = ""
                            if let images = album["images"] as? [[String: Any]] {
                                if images.count > 0 {
                                    imageUrl = images[0]["url"] as? String ?? ""
                                }
                            }
                            
                            if let artists = album["artists"] as? [[String: Any]] {
//                                print("entered")
                                for i in 0 ..< artists.count {
                                    artist.append((artists[i]["name"] as? String? ?? "") ?? "")
                                    if (i != artists.count - 1) {
                                        artist.append(", ")
                                    }
                                }
                                //artist = (artists["name"] as? String? ?? "") ?? ""
                            }
                            let albumName = album["name"] as? String? ?? ""
                            let music = MusicItem(track: name, artist: artist, album: albumName ?? "", uri: previewURL ?? "", imageUrl: imageUrl)
                            searchResults.append(music)
                            print(music.dictionary)
                        }
                    }
                    self.searchTable.reloadData()
                    searchTable.scrollToRow(at: IndexPath(row: 1, section: 0), at: .top, animated: false)
                }
            }
        }
        catch{
            print(error)
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hasChosenThumbnailImage = false
    }
    
    @objc func skipTapped(_ sender: UITapGestureRecognizer) {
        let linkVC = storyboard?.instantiateViewController(withIdentifier: "linkVC") as! AddLinkVCViewController
        linkVC.userDataVM = userDataVM
        linkVC.cancelLbl = "Skip"
        self.present(linkVC, animated: false, completion: nil)
    }
    
    var createRequestURL = ""
    var token: String?

    func setTextFields(musicItem: MusicItem) {
//        if musicItem.track != "" {
//            songNameTextField.text = musicItem.track
//        }
//        else {
//            songNameTextField.text = musicItem.album
//        }
        
        if musicItem.track != "" {
            linkTextField.text = "\(musicItem.track), \(musicItem.artist)"
        }
        else {
            linkTextField.text = "\(musicItem.album), \(musicItem.artist)"
        }
                
        let formatted = musicItem.uri.replacingOccurrences(of: ":", with: "%3A")
        createRequestURL = "https://songwhip.com/convert?url=\(formatted)&sourceAction=pasteUrl"
    }
    
    @objc func checkBoxTapped(_ sender: UITapGestureRecognizer) {
        if checkBoxStatus == false {
            linkHexagonImage.isHidden = false
            linkHexagonImageCopy.isHidden = true
            insertTextOverlay(linkHexagonImage: linkHexagonImage)
            checkBox.setImage(UIImage(named: "check-2"), for: .normal)
            checkBoxStatus = true
            linkHexagonImage.pulse(withIntensity: 0.8, withDuration: 1.5, loop: true)
        }
        else {
            linkHexagonImage.isHidden = true
            linkHexagonImageCopy.isHidden = false
            checkBox.setImage(UIImage(named: "tealEmpty"), for: .normal)
            insertTextOverlay(linkHexagonImage: linkHexagonImageCopy)
            checkBoxStatus = false
        //    linkHexagonImage.frame = CGRect(x: 40, y: navBarView.frame.maxY + 10, width: scrollView.frame.width - 80, height: scrollView.frame.width - 80)
           linkHexagonImage.pulse(withIntensity: 1.0, withDuration: 0.1, loop: false)
        }
    }
    
    
    
    
    // hide keyboard if tapped
    @objc func hideKeyboardTap(_ recoginizer:UITapGestureRecognizer) {
        //   pushEverythingDown()
        self.view.endEditing(true)
    }
    
    @objc func backButtonpressed() {
      if ogCaption != captionTextField.text {
            hasMadeChanges = true
        } else if ogCheckboxStatus != checkBoxStatus {
            hasMadeChanges = true
        }
        else if ogMusicLink != musicLink {
            hasMadeChanges = true
        }
        
        if hasMadeChanges {
            print("Are you sure you want to leave")
            let sureAlert = UIAlertController(title: "Discard Changes?", message: "Are you sure you want to lose these changes?", preferredStyle: .alert)
            
            sureAlert.addAction(UIKit.UIAlertAction(title: "Yes", style: .default, handler: {_ in
                self.dismiss(animated: true)
            }))
            
            sureAlert.addAction(UIKit.UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(sureAlert, animated: true, completion: nil)
        }
        else {
        print("It should dismiss here")
        self.dismiss(animated: true)
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
    
    
    
    @objc func keyboard(notification:Notification) {
        guard ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil else{
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
    
    
    func createMusicLink() {
        var artistText = linkTextField.text?.replacingOccurrences(of: "'", with: "") ?? ""
//        var songText = songNameTextField.text?.replacingOccurrences(of: "'", with: "") ?? ""
        while artistText.hasPrefix(" ") {
            artistText = artistText.chopPrefix()
            print("This is trimmedText now 1 \(artistText)")
        }
        while artistText.hasSuffix(" ") {
            artistText = artistText.chopSuffix()
            print("This is trimmedText now 2 \(artistText)")
        }
        
        while songText.hasPrefix(" ") {
           songText = songText.chopPrefix()
            print("This is trimmedText now 3 \(songText)")
        }
        while songText.hasSuffix(" ") {
           songText = songText.chopSuffix()
            print("This is trimmedText now 4 \(songText)")
        }
   
        
        artistText = artistText.replacingOccurrences(of: " ", with: "-") 
        
        
         songText = songText.replacingOccurrences(of: " ", with: "-")
        songText = songText.replacingOccurrences(of: "'", with: "") 
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
        
        let userData = userDataVM?.userData.value
        if userData == nil {
            return
        }
        let username = userData!.publicID
        
        if (originalCaption == captionTextField.text! && originalTextOverlay == textOverlayTextField.text && originalPriority == checkBoxStatus && changedPhoto == false && createRequestURL == hexData?.resource) {
         print("Changed Nothing and Dismiss")
            self.dismiss(animated: false, completion: nil)
            return
        }
        
        
//        if hasChosenThumbnailImage == false || !hexData!.thumbResource.contains("userFiles") {
//            loadImg(UITapGestureRecognizer())
//        }
//        else {
            
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
                var refText = "userFiles/\(username)/\(imageFileName)"
                if !hasChosenThumbnailImage {
                    refText = selectedMusicItem!.imageUrl
                }
//                let imageRef = storageRef.child(refText)
                musicLink = musicLink.replacingOccurrences(of: " ", with: "-")
                musicLink = musicLink.replacingOccurrences(of: "'", with: "")
                musicLink.trimmingCharacters(in: ["'", "!", "?"])
                //let trimmedMusicLink = musicLink.trimmingCharacters(in: .whitespaces)
                
                
                let musicHex = HexagonStructData(resource: createRequestURL, type: "music", location: hexData!.location, thumbResource: refText, createdAt: NSDate.now.description, postingUserID: username, text: captionTextField.text ?? "", views: hexData!.views, isArchived: false, docID: hexData!.docID, coverText: textOverlayTextField.text ?? "", isPrioritized: checkBoxStatus, array: [])
                let previewVC = storyboard?.instantiateViewController(identifier: "linkPreview") as! LinkPreviewVC
                previewVC.webHex = musicHex
                
                if hasChosenThumbnailImage {
                previewVC.thumbImage = linkHexagonImage.image
                }
                else {
                    previewVC.thumbImage = UIImage(named: "musicCenter")
                }
    
                previewVC.userDataVM = userDataVM
                previewVC.modalPresentationStyle = .fullScreen
                previewVC.cancelLbl = cancelLbl
                self.present(previewVC, animated: false, completion: nil)
                
            }
            
//        }
    }
    
    
    
    // call picker to select image
    @objc func loadImg(_ recognizer:UITapGestureRecognizer) {
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
        self.hasChosenThumbnailImage = true
        self.hasMadeChanges = true
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
    
    var selectedMusicItem: MusicItem?
    @objc func cellTapped(_ sender: UITapGestureRecognizer) {
        if sender.view!.tag > -1 && sender.view!.tag < searchResults.count {
            selectedMusicItem = searchResults[sender.view!.tag]
            setTextFields(musicItem: searchResults[sender.view!.tag])
            
            if !hasChosenThumbnailImage  || !hexData!.thumbResource.contains("userFiles"){
                if let imageUrl = URL(string: searchResults[sender.view!.tag].imageUrl) {
                    linkHexagonImage.sd_setImage(with: imageUrl, completed: nil)
                }
            }
        }
        searchResults.removeAll()
        
        linkTextField.resignFirstResponder()
        
        
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
extension EditMusicPostVC: UITableViewDelegate {
    
}

extension EditMusicPostVC: UITableViewDataSource {
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        UIView.animate(withDuration: 0.25, animations: {
            if (self.searchResults.count >= 3) {
                self.searchTable.frame = CGRect(x: self.linkTextField.frame.minX, y: self.linkTextField.frame.maxY, width: self.linkTextField.frame.width, height: 150)
            }
            else {
                self.searchTable.frame = CGRect(x: self.linkTextField.frame.minX, y: self.linkTextField.frame.maxY, width: self.linkTextField.frame.width, height: CGFloat(self.searchResults.count * 70))
            }
        })
            
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "musicSuggestion") as! MusicSuggestionCell
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = .gray
        }
        else {
            cell.backgroundColor = .lightGray
        }
        
        cell.contentView.frame = cell.frame
        cell.isUserInteractionEnabled = true
        cell.contentView.isUserInteractionEnabled = false
        
        let cellTap = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        cell.addGestureRecognizer(cellTap)
        cell.tag = indexPath.row
        
        print("creating cell \(searchResults[indexPath.row].track)")
        cell.albumLabel.text = searchResults[indexPath.row].album
        cell.trackLabel.text = searchResults[indexPath.row].track
        cell.artistLabel.text = searchResults[indexPath.row].artist
        
        
        cell.albumLabel.textColor = .black
        cell.trackLabel.textColor = .black
        cell.artistLabel.textColor = .black
        
        cell.albumLabel.font = UIFont(name: "Poppins-SemiBold", size: 14)
        cell.trackLabel.font = UIFont(name: "Poppins-SemiBold", size: 14)
        cell.artistLabel.font = UIFont(name: "Poppins-SemiBold", size: 14)

        
        cell.trackLabel.frame = CGRect(x: 8, y: 8, width: cell.frame.width, height: 15)
        
        cell.clipsToBounds = true
        
        if (cell.trackLabel.text != "" || cell.albumLabel.text != "") {
            cell.artistLabel.frame = CGRect(x: 8, y: cell.trackLabel.frame.maxY + 4, width: cell.frame.width, height: 15)
        }
        else {
            cell.artistLabel.frame = CGRect(x: 8, y: cell.frame.midY - 6, width: cell.frame.width, height: 15)
        }
        if (cell.trackLabel.text != "") {
            cell.albumLabel.frame = CGRect(x: 8, y: cell.artistLabel.frame.maxY + 4, width: cell.frame.width, height: 15)
        }
        else {
            cell.albumLabel.frame = CGRect(x: 8, y: 4, width: cell.frame.width, height: 15)
        }
        
        
        return cell
    }
    
    
    
}

fileprivate extension String {
    func indexOf(char: Character) -> Int? {
        return firstIndex(of: char)?.utf16Offset(in: self)
    }
}
