//
//  AddMusicVC.swift
//  Bio
//
//  Created by Ann McDonough on 9/14/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseUI
import FirebaseFirestore
import Alamofire



class AddMusicVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    var navBarView = NavBarView()
    var changedProfilePic = false
    var poppinsBlack = UIFont(name: "poppins-Black", size: UIFont.labelFontSize)
    var poppinsSemiBold = UIFont(name: "poppins-SemiBold", size: UIFont.labelFontSize)
    
    //    label.font = UIFontMetrics.default.scaledFont(for: customFont)
    //    label.adjustsFontForContentSizeCategory = true
    
    var textOverlayLabel = UILabel()
    
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
    
    var userDataVM: UserDataVM?
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    var cancelLbl: String?
    
    @IBOutlet weak var changeCoverLabel: UILabel!
    
    var captionTextField = UITextField()
    var textOverlayTextField = UITextField()
    var prioritizeLabel = UILabel()
    var checkBox = UIButton()
    var checkBoxStatus = false
    
    // reset default size
    var scrollViewHeight : CGFloat = 0
    
    // keyboard frame size
    var keyboard = CGRect()
    
    var searchResults = [MusicItem]()
    
    let searchTable = UITableView()
    
    // default func
    override func viewDidLoad() {
        textOverlayLabel.isHidden = true
        checkBox.setImage(UIImage(named: "tealEmpty"), for: .normal)
        linkLogo.isHidden = true
        
        linkHexagonImage.isHidden = false
        //        confirmLinkButton.isHidden = true
        setUpNavBarView()
        
        let checkBoxTap = UITapGestureRecognizer(target: self, action: #selector(checkBoxTapped(_:)))
        //   checkBoxTap.numberOfTapsRequired = 1
        //checkBox.isUserInteractionEnabled = true
        checkBox.addGestureRecognizer(checkBoxTap)
        
        scrollView.addSubview(captionTextField)
        scrollView.addSubview(textOverlayTextField)
        scrollView.addSubview(prioritizeLabel)
        scrollView.addSubview(checkBox)
        textOverlayTextField.delegate = self
        var alreadySnapped = false
        super.viewDidLoad()
        
        let linkTap = UITapGestureRecognizer(target: self, action: #selector(AddLinkVCViewController.loadImg(_:)))
        let linkTapCopy = UITapGestureRecognizer(target: self, action: #selector(AddLinkVCViewController.loadImg(_:)))
        linkTap.numberOfTapsRequired = 1
        linkHexagonImage.isUserInteractionEnabled = true
        linkHexagonImage.addGestureRecognizer(linkTap)
        
        // insertTextOverlay()
        
        
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
        
        
        linkHexagonImage.frame = CGRect(x: 40, y: navBarView.frame.maxY + 10, width: scrollView.frame.width - 80, height: scrollView.frame.width - 80)
        
        
        
        
        linkTextField.frame = CGRect(x: 10, y: linkHexagonImage.frame.maxY + 20, width: self.view.frame.size.width - 20, height: 30)
        linkTextField.attributedPlaceholder = NSAttributedString(string: "Artist",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        linkLogo.frame = CGRect(x: scrollView.frame.width - 40, y: linkTextField.frame.minY, width: 30, height: 30)
        songNameTextField.isHidden = true
//        songNameTextField.frame = CGRect(x: 10, y: linkTextField.frame.maxY + 5, width: self.view.frame.size.width - 20, height: 30)
//        songNameTextField.attributedPlaceholder = NSAttributedString(string: "Song/Album Name (Optional)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        
        setUpNavBarView()
        
        
        // set up link text Field
        
        
        linkTextField.attributedPlaceholder = NSAttributedString(string: "Artist Name (Required)",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        linkLogo.frame = CGRect(x: scrollView.frame.width - 40, y: linkTextField.frame.minY, width: 30, height: 30)
        
        linkHexagonImage.frame = CGRect(x: 40, y: self.navBarView.frame.maxY + 10, width: scrollView.frame.width - 80, height: scrollView.frame.width - 80)
        linkHexagonImage.setupHexagonMask(lineWidth: linkHexagonImage.frame.width/15, color: myBlueGreen, cornerRadius: linkHexagonImage.frame.width/15)
        
        
        linkTextField.frame = CGRect(x: 10, y: linkHexagonImage.frame.maxY, width: self.view.frame.size.width - 20, height: 30)
//        songNameTextField.frame =
        let sframe = CGRect(x: 10, y: linkTextField.frame.maxY + 10, width: self.view.frame.size.width - 20, height: 30)
        
        captionTextField.frame = CGRect(x: 10, y: sframe.maxY + 5, width: self.view.frame.size.width - 20, height: 30)
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
        self.bottomLine.backgroundColor = UIColor.systemGray4.cgColor
        var bottomLine2 = CALayer()
        bottomLine2.frame = CGRect(x: 0.0, y: sframe.height, width: linkTextField.frame.width, height: 1.0)
        bottomLine2.backgroundColor = UIColor.systemGray4.cgColor
        linkTextField.borderStyle = UITextField.BorderStyle.none
        linkTextField.layer.addSublayer(self.bottomLine)
        linkTextField.backgroundColor = .clear
//        songNameTextField.borderStyle = UITextField.BorderStyle.none
//        songNameTextField.layer.addSublayer(bottomLine2)
//        songNameTextField.backgroundColor = .clear
        linkLogo.frame = CGRect(x: scrollView.frame.width - 40, y: linkTextField.frame.minY, width: 30, height: 30)
        
        
        linkTextField.font = UIFont(name: "Poppins", size: 20)
        
        var bottomLine3 = CALayer()
        bottomLine3.backgroundColor = UIColor.systemGray4.cgColor
        captionTextField.borderStyle = UITextField.BorderStyle.none
        captionTextField.layer.addSublayer(bottomLine3)
        bottomLine3.frame = CGRect(x: 0.0, y: captionTextField.frame.height, width: captionTextField.frame.width, height: 1.0)
        captionTextField.backgroundColor = .clear
        captionTextField.borderStyle = UITextField.BorderStyle.none
        captionTextField.font = UIFont(name: "Poppins", size: 20)
        captionTextField.textColor = .white
        
        var bottomLine4 = CALayer()
        bottomLine4.backgroundColor = UIColor.systemGray4.cgColor
        textOverlayTextField.borderStyle = UITextField.BorderStyle.none
        textOverlayTextField.layer.addSublayer(bottomLine4)
        bottomLine4.frame = CGRect(x: 0.0, y: textOverlayTextField.frame.height, width: textOverlayTextField.frame.width, height: 1.0)
        textOverlayTextField.backgroundColor = .clear
        textOverlayTextField.borderStyle = UITextField.BorderStyle.none
        textOverlayLabel.font = UIFont(name: "DINAlternate-Bold", size: 50)
        textOverlayTextField.textColor = .white
        
        
        var bottomLine5 = CALayer()
        bottomLine5.backgroundColor = UIColor.systemGray4.cgColor
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
    
    var token: String?
    
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
        textOverlayLabel.text = "image.hexData!.coverText"
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == linkTextField {
            linkTextField.text = ""
            createRequestURL = ""
            searchResults.removeAll()
            searchTable.reloadData()
            if !hasChosenThumbnailImage {
                linkHexagonImage.image = nil
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
        
        self.navBarView.addBehavior()
        self.navBarView.titleLabel.text = "Add Music"
        // self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y: navBarView.frame.maxY - 30, width: 200, height: 30)
        self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y: postButton.frame.minY, width: 200, height: 25)
//        print("This is navBarView.")
        
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        print("I recognize that it is ending")
        if textOverlayTextField.text != "" {
            textOverlayLabel.isHidden = false
            textOverlayLabel.text = textOverlayTextField.text!
        }
        else {
//            print("text overlay textfield empty")
            textOverlayLabel.isHidden = true
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
    
    @objc func checkBoxTapped(_ sender: UITapGestureRecognizer) {
        if checkBoxStatus == false {
            
            checkBox.setImage(UIImage(named: "check-2"), for: .normal)
            checkBoxStatus = true
            linkHexagonImage.pulse(withIntensity: 0.8, withDuration: 1.5, loop: true)
        }
        else {
            checkBox.setImage(UIImage(named: "tealEmpty"), for: .normal)
            
            checkBoxStatus = false
            //    linkHexagonImage.frame = CGRect(x: 40, y: navBarView.frame.maxY + 10, width: scrollView.frame.width - 80, height: scrollView.frame.width - 80)
            linkHexagonImage.isHidden = true
            linkHexagonImage.pulse(withIntensity: 1.0, withDuration: 0.001, loop: false)
            linkHexagonImage.isHidden = false
        }
    }
    
    
    
    
    // hide keyboard if tapped
    @objc func hideKeyboardTap(_ recoginizer:UITapGestureRecognizer) {
        //   pushEverythingDown()
        self.view.endEditing(true)
    }
    
    @objc func backButtonpressed() {
//        print("It should dismiss here")
        self.dismiss(animated: true)
    }
    
    

    
    
    // show keyboard
    @objc func showKeyboard(_ notification:Notification) {
        // pushEverythingUp()
        
        // define keyboard size
        keyboard = ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue)!

        
        
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
//        print("back hit!")
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
//                print("added hex: \(hexData)")
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
    
    var createRequestURL = ""
    
    func createMusicLink() {
        let i = linkTextField.text!.indexOf(char: ",")
        var artistText = linkTextField.text?.replacingOccurrences(of: "'", with: "") ?? ""
        if i != nil {
            let s = artistText.substring(start: 0, offsetBy: i!)
            artistText = String(s ?? artistText)
            print("artistText: \(artistText)")
        }
        
        
//        var songText = songNameTextField.text?.replacingOccurrences(of: "'", with: "") ?? ""
        while artistText.hasPrefix(" ") {
            artistText = artistText.chopPrefix()
//            print("This is trimmedText now 1 \(artistText)")
        }
        while artistText.hasSuffix(" ") {
            artistText = artistText.chopSuffix()
//            print("This is trimmedText now 2 \(artistText)")
        }
        
        while songText.hasPrefix(" ") {
            songText = songText.chopPrefix()
//            print("This is trimmedText now 3 \(songText)")
        }
        while songText.hasSuffix(" ") {
            songText = songText.chopSuffix()
//            print("This is trimmedText now 4 \(songText)")
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
        
        if createRequestURL == "" {
            let alert = UIAlertController(title: "Invalid Input", message: "Please select a valid track, album or artist.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        else {
            let userData = userDataVM?.userData.value
            if userData == nil {
                return
            }
    //        createMusicLink()
            
            let username = userData!.publicID
            var numPosts = userData!.numPosts
            
            if numPosts + 1 > 37 {
                // too many posts
                let alert = UIAlertController(title: "Not Enough Space :/", message: "Either cancel or delete a post from your home grid.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            
            if hasChosenThumbnailImage == false && (selectedMusicItem?.imageUrl == nil || selectedMusicItem?.imageUrl == "") {
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
                    var refText = "userFiles/\(username)/\(imageFileName)"
                    if !hasChosenThumbnailImage {
                        refText = selectedMusicItem!.imageUrl
                    }
//                    let imageRef = storageRef.child(refText)
                    numPosts += 1
    //                print("music link before \(musicLink)")
//                    musicLink = musicLink.replacingOccurrences(of: " ", with: "-")
//                    musicLink = musicLink.replacingOccurrences(of: "'", with: "")
//                    //musicLink.trimmingCharacters(in: ["'", "!", "?"])
//    //                print("music Link after \(musicLink)")
//    //                print("This is music Link")
//                    let trimmedMusicLink = musicLink.trimmingCharacters(in: .whitespaces)
                    
                    
                    let musicHex = HexagonStructData(resource: createRequestURL, type: "music", location: numPosts, thumbResource: refText, createdAt: NSDate.now.description, postingUserID: username, text: captionTextField.text ?? "", views: 0, isArchived: false, docID: "WillBeSetLater", coverText: textOverlayTextField.text ?? "", isPrioritized: checkBoxStatus, array: [])
                    let previewVC = storyboard?.instantiateViewController(identifier: "linkPreview") as! LinkPreviewVC
                    previewVC.webHex = musicHex
                    
                    if hasChosenThumbnailImage == true {
                        previewVC.thumbImage = linkHexagonImage.image
                    }
                    else {
                        previewVC.thumbImage = nil
                    }
                    
                    previewVC.userDataVM = userDataVM
                    previewVC.modalPresentationStyle = .fullScreen
                    previewVC.cancelLbl = cancelLbl
                    self.present(previewVC, animated: false, completion: nil)
                    
                }
                
            }
        }
    }
    
   
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // call picker to select image
    @objc func loadImg(_ recognizer:UITapGestureRecognizer) {
        self.hasChosenThumbnailImage = true
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.modalPresentationStyle = .fullScreen
        present(picker, animated: true, completion: nil)
    }
    
    
    // connect selected image to our ImageView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        linkHexagonImage.image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage
        changedProfilePic = true
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    // clicked cancel
    @IBAction func cancelBtn_click(_ sender: AnyObject) {
//        print("hit cancel button")
        // hide keyboard when pressed cancel
        self.view.endEditing(true)
//        print("should dismiss vc")
        self.dismiss(animated: true, completion: nil)
        
    }
    
    var selectedMusicItem: MusicItem?
    @objc func cellTapped(_ sender: UITapGestureRecognizer) {
        if sender.view!.tag > -1 && sender.view!.tag < searchResults.count {
            selectedMusicItem = searchResults[sender.view!.tag]
            setTextFields(musicItem: searchResults[sender.view!.tag])
            
            if !hasChosenThumbnailImage {
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

extension AddMusicVC: UITableViewDelegate {
    
}

extension AddMusicVC: UITableViewDataSource {
    
    
    
    
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
