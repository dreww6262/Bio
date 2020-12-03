//
//  AddProfilePhotoVC.swift
//  Bio
//
//  Created by Ann McDonough on 10/14/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SDWebImage

class AddProfilePhotoVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    var userDataVM: UserDataVM?
    var hasOpenedImagePickerAlready = false
    @IBOutlet weak var addProfilePictureButton: UIButton!
    let storage = Storage.storage().reference()
    @IBOutlet weak var imageView: UIImageView!
    

    
    let auth = Auth.auth()
    var navBarView = NavBarView()
    var titleLabel1 = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(GoodBioSignUpVC.loadImg(_:)))
        avaTap.numberOfTapsRequired = 1
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(avaTap)
        addProfilePictureButton.layer.cornerRadius = addProfilePictureButton.frame.width/20
        // Do any additional setup after loading the view.
       var rect1 = addProfilePictureButton.frame
        addProfilePictureButton.frame = CGRect(x: rect1.minX, y: rect1.minY, width: rect1.width, height: rect1
                                        .height*(5/4))
        setUpNavBarView()
        formatStuff()
    }
    
    @objc func loadImg(_ recognizer:UITapGestureRecognizer) {
        self.hasOpenedImagePickerAlready = true
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        self.addProfilePictureButton.setTitle("Add Profile Picture", for: .normal)
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
        self.imageView.layer.borderWidth = 10.0
        self.imageView.layer.borderColor = white.cgColor
    }
    
    func setUpNavBarView() {
        var statusBarHeight = UIApplication.shared.statusBarFrame.height
        print("This is status bar height \(statusBarHeight)")
        self.view.addSubview(navBarView)
        self.navBarView.frame = CGRect(x: -5, y: -5, width: self.view.frame.width + 10, height: (self.view.frame.height/12)+5)
        var navBarHeightRemaining = navBarView.frame.maxY - statusBarHeight
        navBarView.backButton.isHidden = true
        navBarView.postButton.isHidden = true

        let yOffset = navBarView.frame.maxY
      //  self.tableView.frame = CGRect(x: 0, y: yOffset, width: self.view.frame.width, height: self.view.frame.height - yOffset)
      //  self.navBarView.addSubview(titleLabel1)
        self.navBarView.addBehavior()
        self.navBarView.titleLabel.text = "Choose A Profile Picture"
        //self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y: navBarView.frame.maxY - 30, width: 200, height: 30)
        print("This is navBarView.")
        self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 150, y: (self.navBarView.frame.height - 25)/2, width: 300, height: 25)
    }
    
    
    
    @IBAction func signInClicked(_ sender: Any) {
        let userData = userDataVM?.userData.value
        if userData == nil {
            return
        }
        let loadingIndicator = storyboard?.instantiateViewController(withIdentifier: "loading")
        let blurEffectView: UIVisualEffectView = {
            let blurEffect = UIBlurEffect(style: .dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            
            blurEffectView.alpha = 0.8

            blurEffectView.autoresizingMask = [
                .flexibleWidth, .flexibleHeight
            ]
            blurEffectView.frame = view.bounds
            
            return blurEffectView
        }()
        
        if hasOpenedImagePickerAlready == false {
            print("You havent tried to pick an image yet.")
            loadImg(UITapGestureRecognizer())
            addProfilePictureButton.setTitle("Confirm Profile Picture", for: .normal)
        }
        else {
            print("Set the user's profile picture as the current image")
            
            var username = userData?.publicID
            let userDataStorageRef = self.storage.child(userData!.avaRef)
            view.addSubview(blurEffectView)
            
            addChild(loadingIndicator!)
            view.addSubview(loadingIndicator!.view)
            
            userDataStorageRef.putData(self.imageView.image!.pngData()!, metadata: nil, completion: { meta, error in
                if (error == nil) {
         
                    SDImageCache.shared.clearMemory()
                    SDImageCache.shared.clearDisk(onCompletion: {
                    })

                    
                }
                else {
                    print("could not upload profile photo")
                    
                }
                blurEffectView.removeFromSuperview()
                loadingIndicator?.view.removeFromSuperview()
                loadingIndicator?.removeFromParent()
                let addsocialmediaVC = self.storyboard?.instantiateViewController(withIdentifier: "addSocialMediaTableView") as! AddSocialMediaTableView
                addsocialmediaVC.userDataVM = self.userDataVM
                addsocialmediaVC.currentUser = Auth.auth().currentUser
                addsocialmediaVC.cancelLbl = "Skip"
                self.present(addsocialmediaVC, animated: false, completion: nil)
            })
        
        }

    }
    
    @objc func cancelButtonClicked(_ sender: UITapGestureRecognizer) {
            self.view.endEditing(true)
            
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
