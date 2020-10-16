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
    var datePicker = UIDatePicker()
    // profile image
    @IBOutlet weak var avaImg: UIImageView!
    
    @IBOutlet weak var gradientImage: UIImageView!
    @IBOutlet weak var displayNameTxt: UITextField!
    var txtDatePicker = UITextField()
    
    @IBOutlet weak var emailTxt: UITextField!
    // textfields
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var repeatPassword: UITextField!
    // buttons
    var signUpBtn = UIButton()
    var cancelBtn = UIButton()
    var profileImageLabel = UILabel()
    var birthday = ""
    
    var user: User?
    var userData: UserData?
    //var avaImageExtension = ".jpg"
    
    let storage = Storage.storage().reference()
    
    // reset default size
    var scrollViewHeight : CGFloat = 0
    
    // keyboard frame size
    var keyboard = CGRect()
    var navBarView = NavBarView()
    var titleLabel1 = UILabel()
    var age = 0
    

    // default func
    override func viewDidLoad() {
        super.viewDidLoad()
       
        avaImg.image = UIImage(named: "boyprofile")
        let gold = #colorLiteral(red: 0.9882352941, green: 0.7607843137, blue: 0, alpha: 1)
        let gray = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        // scrollview frame size
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        scrollView.contentSize.height = self.view.frame.height
        scrollViewHeight = scrollView.frame.size.height
        showDatePicker()
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

        
        // declare select image tap
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(GoodBioSignUpVC.loadImg(_:)))
        avaTap.numberOfTapsRequired = 1
        avaImg.isUserInteractionEnabled = true
        avaImg.addGestureRecognizer(avaTap)
        view.addSubview(txtDatePicker)
        txtDatePicker.backgroundColor = .clear

      
        // alignment
        avaImg.frame = CGRect(x: self.view.frame.size.width / 2 - 60, y: 80, width: 120, height: 120)
        avaImg.setupHexagonMask(lineWidth: 7.5, color: gray, cornerRadius: 10.0)
     //   HexagonView.setupHexagonImageView(imageView: avaImg)
              avaImg.clipsToBounds = true
        emailTxt.frame = CGRect(x: 10, y: avaImg.frame.maxY + 20, width: self.view.frame.size.width - 20, height: 30)
        usernameTxt.frame = CGRect(x: 10, y: emailTxt.frame.maxY + 10, width: self.view.frame.size.width - 20, height: 30)
        displayNameTxt.frame = CGRect(x: 10, y: usernameTxt.frame.maxY + 10, width: self.view.frame.size.width - 20, height: 30)
        passwordTxt.frame = CGRect(x: 10, y: displayNameTxt.frame.maxY + 10, width: self.view.frame.size.width - 20, height: 30)
        repeatPassword.frame = CGRect(x: 10, y: passwordTxt.frame.maxY + 10, width: self.view.frame.size.width - 20, height: 30)
        txtDatePicker.frame = CGRect(x: 10, y: repeatPassword.frame.maxY + 10, width: self.view.frame.size.width - 20, height: 30)
        
        signUpBtn.frame = CGRect(x: 10, y: txtDatePicker.frame.maxY + 10, width: self.view.frame.size.width - 20, height: 40)
        signUpBtn.layer.cornerRadius = signUpBtn.frame.size.width / 20
        cancelBtn.frame = CGRect(x: 5, y: 40, width: 24, height: 23)
        cancelBtn.layer.cornerRadius = cancelBtn.frame.size.width / 20
        setUpNavBarView()
        // background
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "manaloghourglass")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
        formatPhotoLabel()
        formatBottomLines()
    }
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date

       //ToolBar
       let toolbar = UIToolbar();
       toolbar.sizeToFit()
       let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
      let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

     toolbar.setItems([spaceButton,doneButton], animated: false)

      txtDatePicker.inputAccessoryView = toolbar
      txtDatePicker.inputView = datePicker

     }

      @objc func donedatePicker(){

       let formatter = DateFormatter()
       formatter.dateFormat = "MM/dd/yyyy"
       txtDatePicker.text = formatter.string(from: datePicker.date)
        var birthdaySubmitted = txtDatePicker.text
        self.birthday = birthdaySubmitted!
      age = calcAge(birthday: birthdaySubmitted!)
       self.view.endEditing(true)
     }

     @objc func cancelDatePicker(){
        self.view.endEditing(true)
      }
    
    
   func formatBottomLines(){
    let bottomLine = CALayer()
    bottomLine.frame = CGRect(x: 0, y: self.emailTxt.frame.height, width: self.emailTxt.frame.width, height: 1.0)
    bottomLine.backgroundColor = UIColor.systemGray4.cgColor
    self.emailTxt.borderStyle = UITextField.BorderStyle.none
    self.emailTxt.layer.addSublayer(bottomLine)
    
    let bottomLine2 = CALayer()
    bottomLine2.frame = CGRect(x: 0, y: usernameTxt.frame.height, width: usernameTxt.frame.width, height: 1.0)
    bottomLine2.backgroundColor = UIColor.systemGray4.cgColor
    usernameTxt.borderStyle = UITextField.BorderStyle.none
    usernameTxt.layer.addSublayer(bottomLine2)
    
    let bottomLine3 = CALayer()
    bottomLine3.frame = CGRect(x: 0, y: self.displayNameTxt.frame.height, width: self.displayNameTxt.frame.width, height: 1.0)
    bottomLine3.backgroundColor = UIColor.systemGray4.cgColor
    self.displayNameTxt.borderStyle = UITextField.BorderStyle.none
    self.displayNameTxt.layer.addSublayer(bottomLine3)
    
    let bottomLine4 = CALayer()
    bottomLine4.frame = CGRect(x: 0, y: passwordTxt.frame.height, width: passwordTxt.frame.width, height: 1.0)
    bottomLine4.backgroundColor = UIColor.systemGray4.cgColor
    passwordTxt.borderStyle = UITextField.BorderStyle.none
    passwordTxt.layer.addSublayer(bottomLine4)
    
    
    let bottomLine5 = CALayer()
    bottomLine5.frame = CGRect(x: 0, y: repeatPassword.frame.height, width: repeatPassword.frame.width, height: 1.0)
    bottomLine5.backgroundColor = UIColor.systemGray4.cgColor
    repeatPassword.borderStyle = UITextField.BorderStyle.none
    repeatPassword.layer.addSublayer(bottomLine5)
    let bottomLine6 = CALayer()
    bottomLine6.frame = CGRect(x: 0, y: txtDatePicker.frame.height, width: txtDatePicker.frame.width, height: 1.0)
    bottomLine6.backgroundColor = UIColor.systemGray4.cgColor
    txtDatePicker.borderStyle = UITextField.BorderStyle.none
    txtDatePicker.layer.addSublayer(bottomLine6)
    
    emailTxt.attributedPlaceholder = NSAttributedString(string: "Email Address",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray4])
    emailTxt.textColor = .white
    usernameTxt.attributedPlaceholder = NSAttributedString(string: "Username",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray4])
    usernameTxt.textColor = .white
    displayNameTxt.attributedPlaceholder = NSAttributedString(string: "Display Name",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray4])
    displayNameTxt.textColor = .white
    passwordTxt.attributedPlaceholder = NSAttributedString(string: "Password",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray4])
    passwordTxt.textColor = .white
    repeatPassword.attributedPlaceholder = NSAttributedString(string: "Repeat Password",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray4])
    repeatPassword.textColor = .white
    
    self.txtDatePicker.attributedPlaceholder = NSAttributedString(string: "Birthday",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray4])
    self.txtDatePicker.textColor = .white
//    self.txtDatePicker.attributedPlaceholder = NSAttributedString(string: "Repeat Password",
//                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray4])
    
    
//    emailTxt.font = UIFont(name: "Poppins-SemiBold", size: 17)
//    usernameTxt.font = UIFont(name: "Poppins-SemiBold", size: 17)
//    displayNameTxt.font = UIFont(name: "Poppins-SemiBold", size: 17)
//    repeatPassword.font = UIFont(name: "Poppins-SemiBold", size: 17)
//    passwordTxt.font = UIFont(name: "Poppins-SemiBold", size: 17)
//    signUpBtn.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 25)
    
    
    
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
    
    func formatPhotoLabel() {
        self.view.addSubview(self.profileImageLabel)
        var photoFrame = self.avaImg.frame
        self.profileImageLabel.frame = CGRect(x: self.view.frame.width/32, y: photoFrame.minY, width: (self.view.frame.width/2) - self.view.frame.width/16, height: 44)
        self.profileImageLabel.text = "Choose A Profile Picture:"
        self.profileImageLabel.font = emailTxt.font
        self.profileImageLabel.font = emailTxt.font?.withSize(12)
        self.profileImageLabel.textColor = .white
    }
    
    
    // hide keyboard func
    @objc func hideKeybard(_ notification:Notification) {
        
        // move down UI
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.scrollView.frame.size.height = self.view.frame.height
        })
    }
    
    
    func createUser(email: String, password: String, completion: @escaping (User?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { obj, error in
            if error == nil {
                guard let obj = obj else { return }
                self.user = obj.user
                print("\(self.user!) successfully added")
                completion(self.user!)
            }
            else {
                print("failed to create user \(error?.localizedDescription)")
                completion(nil)
            }
            print("completed")
        })
    }
    
    func calcAge(birthday: String) -> Int {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MM/dd/yyyy"
        let birthdayDate = dateFormater.date(from: birthday)
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components(.year, from: birthdayDate!, to: now, options: [])
        let age = calcAge.year
        print("This is age: \(age)")
        return age!
    }
    
    
    var loadingIndicator: UIViewController?
    var blurEffectView: UIVisualEffectView?
    // clicked sign up
    @objc func signUpTapped(_ recognizer: UITapGestureRecognizer) {
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
        print("This is age \(age)")
        print("This is birthday \(birthday)")
        
        if age < 13 {
            // alert message
            let alert = UIAlertController(title: "👶🏼", message: "You must be at least 13 years old to join Bio", preferredStyle: UIAlertController.Style.alert)
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
        var signedInUser: User?
        
        print("about to create new user")
        
        let loadingIndicator = storyboard?.instantiateViewController(withIdentifier: "loading")
        
        blurEffectView = {
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
        view.addSubview(blurEffectView!)
        
        addChild(loadingIndicator!)
        view.addSubview(loadingIndicator!.view)
        
        createUser(email: email, password: password, completion: {user in
            if (user == nil) {
                self.blurEffectView?.removeFromSuperview()
                loadingIndicator!.view.removeFromSuperview()
                loadingIndicator!.removeFromParent()
                return
            }
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
                    self.userData = UserData(email: email, publicID: self.usernameTxt.text!.lowercased(), privateID: signedInUser!.uid, avaRef: reference, hexagonGridID: "", userPage: "", subscribedUsers: [""], subscriptions: [""], numPosts: 0, displayName: self.displayNameTxt.text!, birthday: self.birthday, blockedUsers: [String]())
                    let db = Firestore.firestore()
                    let userDataCollection = db.collection("UserData1")
                    let docRef = userDataCollection.document(user!.uid)
                    docRef.setData(self.userData!.dictionary, completion: { error in
                        if error == nil {
                            print("userData posted")
                            let addsocialmediaVC = self.storyboard?.instantiateViewController(withIdentifier: "addSocialMediaTableView") as! AddSocialMediaTableView
                            addsocialmediaVC.userData = self.userData
                            addsocialmediaVC.currentUser = self.user
                            addsocialmediaVC.cancelLbl = "Skip"
                            self.present(addsocialmediaVC, animated: false, completion: nil)
                        }
                        else {
                            print(error?.localizedDescription)
                            self.blurEffectView?.removeFromSuperview()
                            loadingIndicator!.view.removeFromSuperview()
                            loadingIndicator!.removeFromParent()
                        }
                    })
                    
                }
                else {
                    print("could not upload profile photo \(error?.localizedDescription)")
                    self.blurEffectView?.removeFromSuperview()
                    loadingIndicator!.view.removeFromSuperview()
                    loadingIndicator!.removeFromParent()
                    
                }
            })
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var addSocialMediaVC = segue.destination as! AddSocialMediaVC
        addSocialMediaVC.currentUser = user
        addSocialMediaVC.userData = userData
        addSocialMediaVC.cancelLbl = "Skip"
    }
    
    
    // clicked cancel
    @objc func backButtonpressed(_ recognizer: UITapGestureRecognizer) {
        
        // hide keyboard when pressed cancel
        self.view.endEditing(true)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpNavBarView() {
        var statusBarHeight = UIApplication.shared.statusBarFrame.height
        print("This is status bar height \(statusBarHeight)")
        self.view.addSubview(navBarView)
        self.navBarView.addSubview(cancelBtn)
        self.navBarView.addSubview(signUpBtn)
        self.navBarView.frame = CGRect(x: -5, y: -5, width: self.view.frame.width + 10, height: (self.view.frame.height/12)+5)
       
        var navBarHeightRemaining = navBarView.frame.maxY - statusBarHeight
        navBarView.backButton.isHidden = true
        navBarView.postButton.isHidden = true
//        self.navBarView.addSubview(toSettingsButton)
//        self.navBarView.addSubview(toSearchButton)
        
        let backTap = UITapGestureRecognizer(target: self, action: #selector(self.backButtonpressed))
        backTap.numberOfTapsRequired = 1
        cancelBtn.isUserInteractionEnabled = true
        cancelBtn.addGestureRecognizer(backTap)
        cancelBtn.setImage(UIImage(named: "whiteChevron"), for: .normal)
        
        let postTap = UITapGestureRecognizer(target: self, action: #selector(self.signUpTapped))
        postTap.numberOfTapsRequired = 1
        signUpBtn.isUserInteractionEnabled = true
        signUpBtn.addGestureRecognizer(postTap)
        signUpBtn.setTitle("Next", for: .normal)
        signUpBtn.setTitleColor(.systemBlue, for: .normal)
      //  postButton.frame = CGRect(x: (self.view.frame.width) - (topBar.frame.height) - 5, y: 0, width: topBar.frame.height, height: topBar.frame.height)
        signUpBtn.titleLabel?.sizeToFit()
        signUpBtn.titleLabel?.textAlignment = .right
        
    
       cancelBtn.frame = CGRect(x: 10, y: statusBarHeight + (navBarHeightRemaining - 25)/2, width: 25, height: 25)
        signUpBtn.frame = CGRect(x: navBarView.frame.width - 50, y: statusBarHeight + (navBarHeightRemaining - 30)/2, width: 40, height: 30)
        //navBarView.postButton.titleLabel?.sizeToFit()
        navBarView.postButton.titleLabel?.textAlignment = .right
        let yOffset = navBarView.frame.maxY
  
        self.navBarView.addBehavior()
        self.navBarView.titleLabel.text = "Create An Account"
        print("This is navBarView.")
      
      
    }
    
    
    func setUpNavBarViewBad() {
        self.view.addSubview(self.navBarView)
        self.navBarView.addSubview(self.titleLabel1)
        self.navBarView.addBehavior()
       
        self.titleLabel1.text = "Create An Account"
        self.navBarView.frame = CGRect(x: 0, y: self.cancelBtn.frame.minY/2, width: self.view.frame.width, height: self.view.frame.height/12)
       // self.tableView.frame = CGRect(x: 0, y: self.view.frame.height/12, width: self.view.frame.width, height: self.view.frame.height*(11/12))
        self.titleLabel1.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/12)
        self.titleLabel1.textAlignment = .center
       
        self.titleLabel1.font = signUpBtn.titleLabel?.font
        self.titleLabel1.font.withSize(45)
       // self.titleLabel1.font = UIFont(name: , size: 25)
        self.titleLabel1.textColor = .white
        self.navBarView.backgroundColor = .clear
        self.navBarView.isUserInteractionEnabled = false
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

