//
//  LinkPreviewVC.swift
//  Bio
//
//  Created by Andrew Williamson on 10/8/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import WebKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class LinkPreviewVC: UIViewController, WKUIDelegate, WKNavigationDelegate {
    var changedProfilePic = false
    var webConfig = WKWebViewConfiguration()
    var navBarView = NavBarView()
    var webView = WKWebView()
    var webHex: HexagonStructData?
    var thumbImage: UIImage?
    var userDataVM: UserDataVM?
    var user = Auth.auth().currentUser
    var captionTextField = UITextField()
    var cancelLbl: String?
    
    var backButton = UIButton()
    var postButton = UIButton()
    
    private var db = Firestore.firestore()
    private var storage = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setUpNavBarView()
        
        navBarView.backgroundColor = .black
        let frame = CGRect(x: 0, y: self.view.frame.height/12, width: view.frame.width, height: view.frame.height - navBarView.frame.height)
        webView = WKWebView(frame: frame, configuration: webConfig)
        view.addSubview(webView)
        webView.frame = frame
        
        //  webView = WKWebView(frame: frame, configuration: webConfig)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = false
        
        
        
        let link = webHex!.resource
        let myUrl = URL(string: link)
        
        if webHex?.text != "" {
            self.captionTextField.isHidden = false
            print("This is web hex text \(webHex?.text)")
            setUpCaption()
            
        }
        else {
            self.captionTextField.isHidden = true
            print("This is web hex text \(webHex?.text)")
            webView.frame = CGRect(x: 0, y: self.view.frame.height/12, width: view.frame.width, height: view.frame.height*(11/12))
        }
        
        if (myUrl != nil) {
            let myRequest = URLRequest(url: myUrl!)
            print("should be loading url!")
            webView.load(myRequest)
        }
        print("This is webView.frame \(webView.frame)")
        
        view.bringSubviewToFront(navBarView)
        navBarView.bringSubviewToFront(navBarView.titleLabel)
        
    }
    
    func setUpCaption() {
        view.addSubview(self.captionTextField)
        var captionText = webHex?.text
        self.captionTextField.text = captionText
        let captionFrame = CGRect(x: 0, y: navBarView.frame.maxY, width: view.bounds.width, height: 66)
        self.captionTextField.font = UIFont(name: "DINAlternate-Bold", size: 28)
        self.captionTextField.textAlignment = .center
        self.captionTextField.isUserInteractionEnabled = false
        self.captionTextField.backgroundColor = .black
        print("This is caption text \(captionText)")
        print("This is text field text \(captionTextField.text)")
        self.captionTextField.textColor = .white
        self.captionTextField.frame = captionFrame
        let webFrame = CGRect(x: 0, y: self.captionTextField.frame.maxY, width: view.frame.width, height: view.frame.height*(11/12) - 66)
        webView.frame = webFrame
        print("This is webView.frame \(webView.frame)")
    }
    
    func setUpNavBarView() {
        var statusBarHeight = UIApplication.shared.statusBarFrame.height
        print("This is status bar height \(statusBarHeight)")
        self.view.addSubview(navBarView)
        self.navBarView.addSubview(backButton)
        self.navBarView.addSubview(postButton)
        var alternateTitleLabel = UILabel()
        self.navBarView.addSubview(alternateTitleLabel)
        self.navBarView.frame = CGRect(x: -5, y: -5, width: self.view.frame.width + 10, height: (self.view.frame.height/12)+5)
        
        var navBarHeightRemaining = navBarView.frame.maxY - statusBarHeight
        navBarView.backButton.isHidden = true
        navBarView.postButton.isHidden = true
        //        self.navBarView.addSubview(toSettingsButton)
        //        self.navBarView.addSubview(toSearchButton)
        
        let backTap = UITapGestureRecognizer(target: self, action: #selector(self.backPressed))
        backTap.numberOfTapsRequired = 1
        backButton.isUserInteractionEnabled = true
        backButton.addGestureRecognizer(backTap)
        backButton.setImage(UIImage(named: "whiteChevron"), for: .normal)
        
        let postTap = UITapGestureRecognizer(target: self, action: #selector(self.finishPressed))
        postTap.numberOfTapsRequired = 1
        postButton.isUserInteractionEnabled = true
        postButton.addGestureRecognizer(postTap)
        postButton.setTitle("Post", for: .normal)
        postButton.setTitleColor(.systemBlue, for: .normal)
        //  postButton.frame = CGRect(x: (self.view.frame.width) - (topBar.frame.height) - 5, y: 0, width: topBar.frame.height, height: topBar.frame.height)
        postButton.titleLabel?.sizeToFit()
        postButton.titleLabel?.textAlignment = .right
        
        
        backButton.frame = CGRect(x: 10, y: statusBarHeight + (navBarHeightRemaining - 25)/2, width: 25, height: 25)
        postButton.frame = CGRect(x: navBarView.frame.width - 50, y: statusBarHeight + (navBarHeightRemaining - 25)/2, width: 40, height: 25)
        //navBarView.postButton.titleLabel?.sizeToFit()
        navBarView.postButton.titleLabel?.textAlignment = .right
        let yOffset = navBarView.frame.maxY
        
        self.navBarView.addBehavior()
        self.navBarView.titleLabel.text = "Preview"
        self.navBarView.titleLabel.textColor = .white
        //    self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y: navBarView.frame.maxY - 30, width: 200, height: 30)
        self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y: postButton.frame.minY, width: 200, height: 25)
        self.navBarView.titleLabel.isHidden = true
        
        print("This is navBarView.")
        
        alternateTitleLabel.text = "Preview"
        alternateTitleLabel.textColor = .white
        alternateTitleLabel.textAlignment = .center
        //    self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y: navBarView.frame.maxY - 30, width: 200, height: 30)
        alternateTitleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y: postButton.frame.minY, width: 200, height: 25)
        alternateTitleLabel.font = UIFont(name: "DINAlternate-Bold", size: 20)
        
        
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
    
    @objc func backPressed(_ sender: UITapGestureRecognizer) {
        if self.presentingViewController is AddLinkVCViewController {
            let parent = self.presentingViewController as! AddLinkVCViewController
            parent.hasChosenThumbnailImage = true
        }
        else if self.presentingViewController is AddMusicVC {
            let parent = self.presentingViewController as! AddMusicVC
            parent.hasChosenThumbnailImage = true
        }
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func finishPressed(_ sender: UITapGestureRecognizer) {
        let imageRef = storage.child(webHex!.thumbResource)
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
        
        let userData = self.userDataVM?.userData.value
        if (userData == nil) {
            return
        }
        
        imageRef.putData(thumbImage!.pngData()!, metadata: nil){ data, error in
            if (error == nil) {
                print ("upload successful")
                
                self.addHex(hexData: self.webHex!, completion: { bool in
                    if (bool) {
                        userData?.numPosts = self.webHex!.location
                        userData?.lastTimePosted = NSDate.now.description
                        
                        self.userDataVM?.updateUserData(newUserData: userData!, completion: { success in
                            if success {
                                print("userdata updated successfully")
                                
                                //                                    if (self.cancelLbl == nil || self.webHex?.type == "link") {
                                self.performSegue(withIdentifier: "unwindFromLinkToHome", sender: nil)
                                //                                    }
                                
                                //                                    else {
                                //                                        let linkVC = self.storyboard?.instantiateViewController(withIdentifier: "linkVC") as! AddLinkVCViewController
                                //                                        linkVC.userData = self.userData
                                //                                        linkVC.currentUser = self.user
                                //                                        linkVC.cancelLbl = "Skip"
                                //                                        self.present(linkVC, animated: false, completion: nil)
                                //                                    }
                            }
                            else {
                                print("userData not saved \(error!.localizedDescription)")
                                loadingIndicator?.view.removeFromSuperview()
                                loadingIndicator?.removeFromParent()
                            }
                            
                        })
                    }
                    else {
                        print("didnt add hex")
                        loadingIndicator?.view.removeFromSuperview()
                        loadingIndicator?.removeFromParent()
                    }
                })
            }
            else {
                print ("upload failed")
                loadingIndicator?.view.removeFromSuperview()
                loadingIndicator?.removeFromParent()
            }
        }
        
    }
    
}
