//
//  EditProfilePhotoVC.swift
//  
//
//  Created by Ann McDonough on 10/14/20.
//

import UIKit
import Firebase
import FirebaseAuth

class EditProfilePhotoVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    var hasOpenedImagePickerAlready = false

    var cancelButton = UIButton()
    var signInButton = UIButton()
    var imageView = UIImageView()
    var myImage = UIImage(named: "user-2")
    let auth = Auth.auth()
    var navBarView = NavBarView()
    var titleLabel1 = UILabel()
    var userDataVM: UserDataVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = myImage
        view.addSubview(imageView)
        view.addSubview(cancelButton)
        view.addSubview(signInButton)
        cancelButton.frame = CGRect(x: 10 , y: 10 , width: 25, height: 25)
        cancelButton.imageView?.image = UIImage(named: "whiteChevron")
        formatStuff()
        //ava tap
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(self.loadImg(_:)))
        avaTap.numberOfTapsRequired = 1
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(avaTap)
        
      //cancel tap
        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(cancelButonClicked))
        cancelTap.numberOfTapsRequired = 1
        cancelButton.isUserInteractionEnabled = true
        cancelButton.addGestureRecognizer(cancelTap)
        
        //sign in tap tap
          let signInTap = UITapGestureRecognizer(target: self, action: #selector(signInClicked))
          signInTap.numberOfTapsRequired = 1
          //signInTap.isUserInteractionEnabled = true
          signInButton.addGestureRecognizer(signInTap)
        
        signInButton.layer.cornerRadius = signInButton.frame.width/20
        // Do any additional setup after loading the view.
       var rect1 = signInButton.frame
        //signInButton.frame = CGRect(x: rect1.minX, y: rect1.minY, width: rect1.width, height: rect1.height*(5/4))
        setUpNavBarView()
  //      formatStuff()
    }
    
    @objc func loadImg(_ recognizer:UITapGestureRecognizer) {
        self.hasOpenedImagePickerAlready = true
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        self.signInButton.setTitle("Confirm New Profile Picture", for: .normal)
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
        
        self.signInButton.frame = CGRect(x: imageView.frame.minX, y: imageView.frame.maxY + 20, width: imageView.frame.width, height: 44)
        self.signInButton.backgroundColor = .darkGray
        self.signInButton.setTitle("Change Profile Picture", for: .normal)
        print("This is imageview.frame \(imageView.frame)")
        
    }
    
    func setUpNavBarView() {
        self.view.addSubview(self.navBarView)
        self.navBarView.addSubview(self.titleLabel1)
    //    self.navBarView.addSubview
        self.navBarView.addBehavior()
       
        self.titleLabel1.text = "Change Profile Picture"
        self.titleLabel1.font = UIFont(name: "DINAlternate-Bold", size: 28)
        self.navBarView.frame = CGRect(x: 0, y: self.cancelButton.frame.minY/2, width: self.view.frame.width, height: self.view.frame.height/12)
        self.titleLabel1.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/12)
        self.titleLabel1.textAlignment = .center
        
//        self.cancelButton.frame = CGRect(x: 10 , y: 10 , width: 25, height: 25)
//        self.cancelButton.image = UIImage(named: "whiteChevron")
       
        
        self.titleLabel1.textColor = .white
        self.navBarView.backgroundColor = .clear
        self.navBarView.isUserInteractionEnabled = false
    }
    
    
    
    
    @objc func signInClicked(_ recognizer: UITapGestureRecognizer) {
        if hasOpenedImagePickerAlready == false {
            print("You havent tried to pick an image yet.")
            loadImg(UITapGestureRecognizer())
            signInButton.setTitle("Confirm New Profile Picture", for: .normal)
        }
        else {
            print("Set the user's profile picture as the current image")
            
        }
    }
    
    
    
    @objc func cancelButonClicked(_ recognizer:UITapGestureRecognizer) {
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
