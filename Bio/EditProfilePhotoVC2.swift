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

class EditProfilePhotoVC2: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    var hasOpenedImagePickerAlready = false
    let storage = Storage.storage().reference()
    @IBOutlet weak var signInButton: UIButton!
    var user = Auth.auth().currentUser
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var cancelButton: UIButton!
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
        signInButton.layer.cornerRadius = signInButton.frame.width/20
        // Do any additional setup after loading the view.
       var rect1 = signInButton.frame
        signInButton.frame = CGRect(x: rect1.minX, y: rect1.minY, width: rect1.width, height: rect1
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
    
    func setUpNavBarView() {
        self.view.addSubview(self.navBarView)
        self.navBarView.addSubview(self.titleLabel1)
        self.navBarView.addBehavior()
       
        self.titleLabel1.text = "Change Profile Picture"
        self.titleLabel1.font = UIFont(name: "DINAlternate-Bold", size: 28)
        self.navBarView.frame = CGRect(x: 0, y: self.cancelButton.frame.minY/2, width: self.view.frame.width, height: self.view.frame.height/12)
        self.titleLabel1.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/12)
        self.titleLabel1.textAlignment = .center
       
        
        self.titleLabel1.textColor = .white
        self.navBarView.backgroundColor = .clear
        self.navBarView.isUserInteractionEnabled = false
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
                            self.performSegue(withIdentifier: "unwindFromEditVC", sender: self)
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
            })
        }
        
        
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
       
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
