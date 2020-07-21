////
////  PersonalInformationVCViewController.swift
////  Bio
////
////  Created by Ann McDonough on 6/30/20.
////  Copyright © 2020 Patrick McDonough. All rights reserved.
////
//
//import UIKit
////import Parse
//
//
//class PersonalInformationVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    @IBOutlet weak var titleText: UILabel!
//    @IBOutlet weak var subtitleText: UILabel!
//    
//  // scrollView
//    @IBOutlet weak var scrollView: UIScrollView!
//    
//    // profile image
//    
//    // textfields
//    @IBOutlet weak var firstNameText: UITextField!
//    @IBOutlet weak var lastNameText: UITextField!
//    @IBOutlet weak var emailText: UITextField!
//    @IBOutlet weak var educationText:
//    UITextField!
//    @IBOutlet weak var occuptationText: UITextField!
//    @IBOutlet weak var ageText: UITextField!
//    
//    @IBOutlet weak var locationText: UITextField!
//    @IBOutlet weak var hometownText: UITextField!
//    // buttons
//    @IBOutlet weak var signUpBtn: UIButton!
//    @IBOutlet weak var cancelBtn: UIButton!
//    
//
//    // reset default size
//    var scrollViewHeight : CGFloat = 0
//    
//    // keyboard frame size
//    var keyboard = CGRect()
//    
//    
//    // default func
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // scrollview frame size
//        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
//        scrollView.contentSize.height = self.view.frame.height
//        scrollViewHeight = scrollView.frame.size.height
//        
//        // check notifications if keyboard is shown or not
//        NotificationCenter.default.addObserver(self, selector: #selector(GoodBioSignUpVC.showKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(GoodBioSignUpVC.hideKeybard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//        
//        // declare hide kyboard tap
//        let hideTap = UITapGestureRecognizer(target: self, action: #selector(GoodBioSignUpVC.hideKeyboardTap(_:)))
//        hideTap.numberOfTapsRequired = 1
//        self.view.isUserInteractionEnabled = true
//        self.view.addGestureRecognizer(hideTap)
//        
//        // round ava
//      //  avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
//        //hexagonAva
//
//cancelBtn.frame = CGRect(x: 5, y: 15, width: 24, height: 24)
//                       cancelBtn.layer.cornerRadius = cancelBtn.frame.size.width / 20
//titleText.frame = CGRect(x: 0,y:36, width: self.view.frame.size.width, height: 30)
//
// subtitleText.frame = CGRect(x:0, y: titleText.frame.origin.y + 30, width: self.view.frame.size.width, height: 30)
//    
//        firstNameText.frame = CGRect(x: 10, y: subtitleText.frame.origin.y + 50, width: self.view.frame.size.width - 20, height: 30)
//        lastNameText.frame = CGRect(x: 10, y: firstNameText.frame.origin.y + 40, width: self.view.frame.size.width - 20, height: 30)
//        emailText.frame = CGRect(x: 10, y: lastNameText.frame.origin.y + 40, width: self.view.frame.size.width - 20, height: 30)
//        educationText.frame = CGRect(x: 10, y: emailText.frame.origin.y + 40, width: self.view.frame.size.width - 20, height: 30)
//             occuptationText.frame = CGRect(x: 10, y: educationText.frame.origin.y + 40, width: self.view.frame.size.width - 20, height: 30)
//        ageText.frame = CGRect(x: 10, y: occuptationText.frame.origin.y + 40, width: self.view.frame.size.width - 20, height: 30)
//         locationText.frame = CGRect(x: 10, y: ageText.frame.origin.y + 40, width: self.view.frame.size.width - 20, height: 30)
//        hometownText.frame = CGRect(x: 10, y: locationText.frame.origin.y + 40, width: self.view.frame.size.width - 20, height: 30)
//       //    poshmarkText.frame = CGRect(x: 10, y: hometownText.frame.origin.y + 40, width: self.view.frame.size.width - 20, height: 30)
//       
//        
//        signUpBtn.frame = CGRect(x: self.view.frame.size.width*3/4 - 10, y: hometownText.frame.origin.y + 47, width: self.view.frame.size.width/4, height: 30)
//        signUpBtn.layer.cornerRadius = signUpBtn.frame.size.width / 20
//        
//       
//        
//        // background
//        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
//        bg.image = UIImage(named: "manaloghourglass")
//        bg.layer.zPosition = -1
//        self.view.addSubview(bg)
//    }
//    
//    
//    // call picker to select image
//    @objc func loadImg(_ recognizer:UITapGestureRecognizer) {
//        let picker = UIImagePickerController()
//        picker.delegate = self
//        picker.sourceType = .photoLibrary
//        picker.allowsEditing = true
//        present(picker, animated: true, completion: nil)
//    }
//    
//    
//    // connect selected image to our ImageView
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//// Local variable inserted by Swift 4.2 migrator.
//let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
//
//    //    avaImg.image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage
//        self.dismiss(animated: true, completion: nil)
//    }
//    
//    
//    // hide keyboard if tapped
//    @objc func hideKeyboardTap(_ recoginizer:UITapGestureRecognizer) {
//        self.view.endEditing(true)
//    }
//    
//    
//    // show keyboard
//    @objc func showKeyboard(_ notification:Notification) {
//        
//        // define keyboard size
//        keyboard = ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue)!
//        
//        // move up UI
//        UIView.animate(withDuration: 0.4, animations: { () -> Void in
//            self.scrollView.frame.size.height = self.scrollViewHeight - self.keyboard.height
//        })
//    }
//    
//    
//    // hide keyboard func
//    @objc func hideKeybard(_ notification:Notification) {
//        
//        // move down UI
//        UIView.animate(withDuration: 0.4, animations: { () -> Void in
//            self.scrollView.frame.size.height = self.view.frame.height
//        })
//    }
//    
//    
//    
//    // clicked sign up
//    @IBAction func signUpBtn_click(_ sender: AnyObject) {
//        print("sign up pressed")
//        
//        // dismiss keyboard
//        self.view.endEditing(true)
//        
//        // if fields are empty
//        if (firstNameText.text!.isEmpty || lastNameText.text!.isEmpty || emailText.text!.isEmpty || educationText.text!.isEmpty || ageText.text!.isEmpty || locationText.text!.isEmpty || hometownText.text!.isEmpty) {
//            
//            // alert message
//            let alert = UIAlertController(title: "PLEASE", message: "fill all fields", preferredStyle: UIAlertController.Style.alert)
//            let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
//            alert.addAction(ok)
//            self.present(alert, animated: true, completion: nil)
//            
//            return
//        }
//        
//        // if different passwords
//        if lastNameText.text != emailText.text {
//            
//            // alert message
//            let alert = UIAlertController(title: "PASSWORDS", message: "do not match", preferredStyle: UIAlertController.Style.alert)
//            let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
//            alert.addAction(ok)
//            self.present(alert, animated: true, completion: nil)
//            
//            return
//        }
//        
//        
//        // send data to server to related collumns
//        let user = PFUser()
//        user["firstName"] = firstNameText.text?.lowercased()
//        user["lastName"] = lastNameText.text?.lowercased()
//        user["email"] = emailText.text?.lowercased()
//        user.email = emailText.text?.lowercased()
//        user["education"] = educationText.text
//        user["age"] = ageText.text
//        user["location"] = locationText.text
//        user["hometown"] = hometownText.text
//        //user["poshmarkUsername"] = poshmarkText.text?.lowercased()
//
//        // in Edit Profile it's gonna be assigned
////        user["tel"] = ""
////        user["gender"] = ""
//        
//        // convert our image for sending to server
//        ///let avaData = avaImg.image!.jpegData(compressionQuality: 0.5)
//      //  let avaFile = PFFileObject(name: "ava.jpg", data: avaData!)
//     //   user["ava"] = avaFile
//        
//        // save data in server
//        user.signUpInBackground { (success, error) -> Void in
//            if success {
//                print("registered")
//                
//                // remember looged user
//                UserDefaults.standard.set(user.username, forKey: "username")
//                UserDefaults.standard.synchronize()
//                
//                // call login func from AppDelegate.swift class
////                let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
////                appDelegate.login()
//                    //      let sceneDelegate : SceneDelegate = UIApplication.shared.delegate as! SceneDelegate
//                let sceneDelegate = UIApplication.shared.connectedScenes
//                      .first!.delegate as! SceneDelegate
//                //sceneDelegate.login()
//                
//            } else {
//
//                // show alert message
//                let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: UIAlertController.Style.alert)
//                let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
//                alert.addAction(ok)
//                self.present(alert, animated: true, completion: nil)
//            }
//        }
//        
//        
//    }
//    
//    
//    // clicked cancel
//    @IBAction func cancelBtn_click(_ sender: AnyObject) {
//        
//        // hide keyboard when pressed cancel
//        self.view.endEditing(true)
//        
//        self.dismiss(animated: true, completion: nil)
//    }
//
//   
//    
//    
//    
//    
//    
//    
//    
//    
//    
//}
//
//// Helper function inserted by Swift 4.2 migrator.
//fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
//    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
//}
//
//// Helper function inserted by Swift 4.2 migrator.
//fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
//    return input.rawValue
//}
//
