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
    
    var webView: WKWebView?
    var webHex: HexagonStructData?
    var thumbImage: UIImage?
    var userData: UserData?
    var user = Auth.auth().currentUser
    
    private var db = Firestore.firestore()
    private var storage = Storage.storage().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBarView = NavBarView()
        view.addSubview(navBarView)
        navBarView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: self.view.frame.height/12)
        navBarView.backgroundColor = .systemGray6
        
        let backButton = UIButton()
        backButton.setTitle("whiteChevron", for: .normal)
        backButton.sizeToFit()
        backButton.frame = CGRect(x: 5, y: navBarView.frame.midY - backButton.frame.height/2 + 5, width: backButton.frame.width, height: backButton.frame.height)
        backButton.backgroundColor = .clear
        backButton.setTitleColor(.systemBlue, for: .normal)
        view.addSubview(backButton)
        let backTapped = UITapGestureRecognizer(target: self, action: #selector(backPressed))
        backButton.addGestureRecognizer(backTapped)
        
        let finishButton = UIButton()
        finishButton.setTitle("Post", for: .normal)
        finishButton.sizeToFit()
        finishButton.frame = CGRect(x: view.frame.width - finishButton.frame.width - 5, y: backButton.frame.minY, width: finishButton.frame.width, height: finishButton.frame.height)
        finishButton.backgroundColor = .clear
        finishButton.setTitleColor(.systemBlue, for: .normal)
        view.addSubview(finishButton)
        let finishTapped = UITapGestureRecognizer(target: self, action: #selector(finishPressed))
        finishButton.addGestureRecognizer(finishTapped)
        
        let label = UILabel()
        label.text = "Preview"
        label.sizeToFit()
        label.frame = CGRect(x: view.frame.midX - label.frame.width/2, y: finishButton.frame.minY, width: label.frame.width, height: label.frame.height)
        view.addSubview(label)
        
        
        let webConfig = WKWebViewConfiguration()
        let frame = CGRect(x: 0, y: navBarView.frame.maxY, width: view.frame.width, height: view.frame.height - navBarView.frame.height)
        webView = WKWebView(frame: frame, configuration: webConfig)
        webView?.uiDelegate = self
        webView?.navigationDelegate = self
        webView?.allowsBackForwardNavigationGestures = false
        view.addSubview(webView!)
        
        
        let link = webHex!.resource
        let myUrl = URL(string: link)
        if (myUrl != nil) {
            let myRequest = URLRequest(url: myUrl!)
            webView?.load(myRequest)
        }
        // Do any additional setup after loading the view.
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
        
        imageRef.putData(thumbImage!.pngData()!, metadata: nil){ data, error in
            if (error == nil) {
                print ("upload successful")
                self.addHex(hexData: self.webHex!, completion: { bool in
                    if (bool) {
                        self.userData?.numPosts = self.webHex!.location
                        if (self.user != nil) {
                            self.db.collection("UserData1").document(self.user!.uid).setData(self.userData!.dictionary, completion: { error in
                                if error == nil {
                                    print("userdata updated successfully")
                                    self.performSegue(withIdentifier: "unwindFromLinkToHome", sender: nil)
                                }
                                else {
                                    print("userData not saved \(error!.localizedDescription)")
                                    loadingIndicator?.view.removeFromSuperview()
                                    loadingIndicator?.removeFromParent()
                                }
                                
                            })
                        }
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
