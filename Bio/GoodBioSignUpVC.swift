//
//  GoodBioSignUpVC.swift
//  Bio
//
//  Created by Ann McDonough on 6/30/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseUI
import Photos

class GoodBioSignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // scrollView
    @IBOutlet weak var scrollView: UIScrollView!
    
    // profile image
    @IBOutlet weak var avaImg: UIImageView!
    
    @IBOutlet weak var displayNameTxt: UITextField!
    
    @IBOutlet weak var emailTxt: UITextField!
    // textfields
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var repeatPassword: UITextField!
    // buttons
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    var user: User?
    var userData: UserData?
    //var avaImageExtension = ".jpg"
    
    let storage = Storage.storage().reference()
    
    // reset default size
    var scrollViewHeight : CGFloat = 0
    
    // keyboard frame size
    var keyboard = CGRect()
        
    
    // default func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avaImg.image = UIImage(named: "boyprofile")
        let gold = #colorLiteral(red: 0.9882352941, green: 0.7607843137, blue: 0, alpha: 1)
        let gray = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        avaImg.setupHexagonMask(lineWidth: 7.5, color: gray, cornerRadius: 10.0)
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
        
        // round ava
        //  avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        //hexagonAva
        HexagonView.setupHexagonImageView(imageView: avaImg)
        avaImg.clipsToBounds = true
        
        // declare select image tap
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(GoodBioSignUpVC.loadImg(_:)))
        avaTap.numberOfTapsRequired = 1
        avaImg.isUserInteractionEnabled = true
        avaImg.addGestureRecognizer(avaTap)
        
        // alignment
        avaImg.frame = CGRect(x: self.view.frame.size.width / 2 - 40, y: 40, width: 80, height: 80)
        emailTxt.frame = CGRect(x: 10, y: avaImg.frame.origin.y + 90, width: self.view.frame.size.width - 20, height: 30)
        usernameTxt.frame = CGRect(x: 10, y: emailTxt.frame.origin.y + 40, width: self.view.frame.size.width - 20, height: 30)
        displayNameTxt.frame = CGRect(x: 10, y: usernameTxt.frame.origin.y + 40, width: self.view.frame.size.width - 20, height: 30)
        passwordTxt.frame = CGRect(x: 10, y: displayNameTxt.frame.origin.y + 40, width: self.view.frame.size.width - 20, height: 30)
        repeatPassword.frame = CGRect(x: 10, y: passwordTxt.frame.origin.y + 40, width: self.view.frame.size.width - 20, height: 30)
        
        signUpBtn.frame = CGRect(x: 10, y: repeatPassword.frame.origin.y + 50, width: self.view.frame.size.width - 20, height: 30)
        signUpBtn.layer.cornerRadius = signUpBtn.frame.size.width / 20
        cancelBtn.frame = CGRect(x: 5, y: 15, width: 24, height: 23)
        cancelBtn.layer.cornerRadius = cancelBtn.frame.size.width / 20
        
        // background
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "manaloghourglass")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
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
        avaImg.image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage
//        if let imageURL = info[UIImagePickerController.InfoKey.referenceURL.rawValue] as? URL {
//            let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
//            avaImageExtension = String((result.firstObject?.value(forKey: "filename") as! String).split(separator: ".")[1])
//            print("extension \(avaImageExtension)")
//        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // hide keyboard if tapped
    @objc func hideKeyboardTap(_ recoginizer:UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    // show keyboard
    @objc func showKeyboard(_ notification:Notification) {
        
        // define keyboard size
        keyboard = ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue)!
        
        // move up UI
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.scrollView.frame.size.height = self.scrollViewHeight - self.keyboard.height
        })
    }
    
    
    // hide keyboard func
    @objc func hideKeybard(_ notification:Notification) {
        
        // move down UI
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.scrollView.frame.size.height = self.view.frame.height
        })
    }
    
    
    func createUser(email: String, password: String, completion: @escaping (User) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { obj, error in
            if error == nil {
                guard let obj = obj else { return }
                self.user = obj.user
                print("\(self.user!) successfully added")
                completion(self.user!)
            }
            else {
                print("failed to create user \(error?.localizedDescription)")
            }
            print("completed")
        })
    }
    
    
    
    // clicked sign up
    @IBAction func signUpBtn_click(_ sender: AnyObject) {
        print("sign up pressed")
        
        // dismiss keyboard
        self.view.endEditing(true)
        
        // if fields are empty
        if (emailTxt.text!.isEmpty || usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty || repeatPassword.text!.isEmpty || displayNameTxt.text!.isEmpty) {
            
            // alert message
            let alert = UIAlertController(title: "PLEASE", message: "fill all fields", preferredStyle: UIAlertController.Style.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        
        // if different passwords
        if passwordTxt.text != repeatPassword.text {
            
            // alert message
            let alert = UIAlertController(title: "PASSWORDS", message: "do not match", preferredStyle: UIAlertController.Style.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        let username = usernameTxt.text!
        let email = emailTxt.text!
        let password = passwordTxt.text!
        var signedInUser: User? = nil
        
        print("about to create new user")
        
        createUser(email: email, password: password, completion: {user in
            signedInUser = user
            let changableUser = signedInUser?.createProfileChangeRequest()
            changableUser?.displayName = self.displayNameTxt.text!
            changableUser?.commitChanges(completion: { (error) in
                if (error != nil) {
                    print(error as Any)
                }
            })
            var reference = "userFiles/\(username)"
            let userDataStorageRef = self.storage.child(reference)
            let filename = "\(username)_avatar.png"
            reference.append("/\(filename)")
            let avaFileRef = userDataStorageRef.child(filename)
            avaFileRef.putData(self.avaImg.image!.pngData()!, metadata: nil, completion: { meta, error in
                if (error == nil) {
                    self.userData = UserData(email: email, publicID: self.usernameTxt.text!, privateID: signedInUser!.uid, avaRef: reference, hexagonGridID: "", userPage: "", subscribedUsers: [""], subscriptions: [""], numPosts: 0)
                    let db = Firestore.firestore()
                    let userDataCollection = db.collection("UserData")
                    let docRef = userDataCollection.document(user.uid)
                    docRef.setData(self.userData!.dictionary, completion: { error in
                        print("userData posted")
                    })
                    print("performing segue")
                    self.performSegue(withIdentifier: "toAddSocialMedia", sender: self)
                }
                else {
                    print("could not upload profile photo \(error?.localizedDescription)")
                }
            })
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var addSocialMediaVC = segue.destination as! AddSocialMediaVC
        addSocialMediaVC.currentUser = user
        addSocialMediaVC.userData = userData
    }
    
    
    // clicked cancel
    @IBAction func cancelBtn_click(_ sender: AnyObject) {
        
        // hide keyboard when pressed cancel
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

