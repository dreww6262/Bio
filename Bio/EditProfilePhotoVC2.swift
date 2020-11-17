//
//  EditProfilePhotoVC2.swift
//  Bio
//
//  Created by Ann McDonough on 10/15/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//


import UIKit
import Firebase
import FirebaseAuth
import SDWebImage

class EditProfilePhotoVC2: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    var hasOpenedImagePickerAlready = false
    let storage = Storage.storage().reference()
    @IBOutlet weak var signInButton: UIButton!
    var user = Auth.auth().currentUser
    @IBOutlet weak var imageView: UIImageView!

    
    var backButton = UIButton()
    
    var userData : UserData?
    let auth = Auth.auth()
    var navBarView = NavBarView()
    var titleLabel1 = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(GoodBioSignUpVC.loadImg(_:)))
        avaTap.numberOfTapsRequired = 1
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(avaTap)
        imageView.contentMode = .scaleToFill
        let cleanRef = userData!.avaRef.replacingOccurrences(of: "/", with: "%2F")
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/bio-social-media.appspot.com/o/\(cleanRef)?alt=media")
        
        imageView!.sd_setImage(with: url!, completed: {_, error, _, _ in
            if error != nil {
                print(error!.localizedDescription)
            }
        })
            
      //  imageView.image = 
        signInButton.layer.cornerRadius = signInButton.frame.width/20
        // Do any additional setup after loading the view.
       var rect1 = signInButton.frame
        signInButton.frame = CGRect(x: rect1.minX, y: rect1.minY, width: rect1.width, height: rect1
                                        .height*(5/4))
        setUpNavBarView()
        formatStuff()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setUpNavBarView() {
        var statusBarHeight = UIApplication.shared.statusBarFrame.height
        print("This is status bar height \(statusBarHeight)")
        self.view.addSubview(navBarView)
        self.navBarView.frame = CGRect(x: -5, y: -5, width: self.view.frame.width + 10, height: (self.view.frame.height/12)+5)
        var navBarHeightRemaining = navBarView.frame.maxY - statusBarHeight
        navBarView.backButton.isHidden = true
        navBarView.postButton.isHidden = true
       
        self.navBarView.addSubview(backButton)
        
        let settingsTap = UITapGestureRecognizer(target: self, action: #selector(self.toSettingsButtonClicked))
        settingsTap.numberOfTapsRequired = 1
        backButton.isUserInteractionEnabled = true
        backButton.addGestureRecognizer(settingsTap)
    
       

        self.backButton.setImage(UIImage(named: "whiteChevron"), for: .normal)
 
     
        self.backButton.frame = CGRect(x: 10, y: navBarView.frame.height - 30, width: 25, height: 25)
        self.backButton.frame = CGRect(x: 10, y: statusBarHeight + (navBarHeightRemaining - 25)/2, width: 25, height: 25)
        let yOffset = navBarView.frame.maxY
      //  self.navBarView.addSubview(titleLabel1)
        self.navBarView.addBehavior()
        self.navBarView.titleLabel.text = "Change Profile Picture"
        print("This is navBarView.")
        self.backButton.setImage(UIImage(named: "whiteChevron"), for: .normal)
        self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y: self.backButton.frame.minY, width: 200, height: 25)

        //self.titleLabel1.text = "Notifications"
       // self.navBarView.frame = CGRect(x: -5, y: -5, width: self.view.frame.width + 10, height: (self.view.frame.height/12)+5)
       // let yOffset = navBarView.frame.maxY
        

    }
    
    
    @objc func toSettingsButtonClicked(_ recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func loadImg(_ recognizer:UITapGestureRecognizer) {
        self.hasOpenedImagePickerAlready = true
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        self.signInButton.setTitle("Change Profile Picture", for: .normal)
    }
    
    // connect selected image to our ImageView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        imageView.image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage
//        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func formatStuff() {
        self.imageView.frame = CGRect(x: self.view.frame.width/4, y: self.navBarView.frame.maxY + 30, width: self.view.frame.width/2, height: self.view.frame.width/2)
        self.imageView.layer.cornerRadius = self.imageView.frame.width / 2
        self.imageView.layer.borderWidth = 1.0
        self.imageView.layer.borderColor = white.cgColor
    }
    
    
    
    @IBAction func signInClicked(_ sender: Any) {
        if hasOpenedImagePickerAlready == false {
            print("You havent tried to pick an image yet.")
            loadImg(UITapGestureRecognizer())
            signInButton.setTitle("Confirm New Profile Picture", for: .normal)
        }
        else {
            print("Set the user's profile picture as the current image 3")
            var username = self.userData?.publicID
//            var reference = "userFiles/\(username!)"
            let userDataStorageRef = self.storage.child(self.userData!.avaRef)
//            let filename = "\(username!)_avatar.png"
//            reference.append("/\(filename)")
//            let avaFileRef = userDataStorageRef.child(filename)
//            print("This is reference \(reference)")
//            print("This is avaFileRef \(avaFileRef)")
            
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
            
            userDataStorageRef.putData(self.imageView.image!.pngData()!, metadata: nil, completion: { meta, error in
                if (error == nil) {
                    //self.userData = UserData(email: self.userData.email, publicID: username, privateID: self.userData.uid, avaRef: reference, hexagonGridID: self.userData?.hexagonGridID, userPage: self.userData?.userPage, subscribedUsers: self.userData?.subscribedUsers, subscriptions: self.userData?.subscriptions, numPosts: self.userData?.numPosts, displayName: self.userData?.displayName, birthday: self.userData.birthday)
//                    self.userData?.avaRef = reference
//                    let db = Firestore.firestore()
//                    let userDataCollection = db.collection("UserData1")
//                    let docRef = userDataCollection.document(self.user!.uid)
//                    docRef.setData(self.userData!.dictionary, completion: { error in
//                        if error == nil {
//                            print("profile pic changed successfully!")
                    SDImageCache.shared.clearMemory()
                    SDImageCache.shared.clearDisk(onCompletion: {
                            self.performSegue(withIdentifier: "unwindFromEditVC", sender: self)
                    })
//                        }
//                        else {
//                            print("error 2")
//                            print(error?.localizedDescription)
////                            self.blurEffectView?.removeFromSuperview()
////                            loadingIndicator!.view.removeFromSuperview()
////                            loadingIndicator!.removeFromParent()
//                        }
//                    })
                    
                }
                else {
                    print("could not upload profile photo \(error?.localizedDescription)")
//                    self.blurEffectView?.removeFromSuperview()
//                    loadingIndicator!.view.removeFromSuperview()
//                    loadingIndicator!.removeFromParent()
                    
                }
                blurEffectView.removeFromSuperview()
                loadingIndicator?.view.removeFromSuperview()
                loadingIndicator?.removeFromParent()
                
            })
        }
        
        
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
