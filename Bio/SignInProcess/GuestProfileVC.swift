//
//  GuestProfileVC.swift
//  Bio
//
//  Created by Ann McDonough on 11/18/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseUI
import Photos
import SDWebImage

class GuestProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var profilePicCancelButton = UIButton()
    var returnButton = UIButton()
    // scrollView
    @IBOutlet weak var scrollView: UIScrollView!
    // profile image
    @IBOutlet weak var avaImg: UIImageView!
    
    @IBOutlet weak var gradientImage: UIImageView!
var newImageView = UIImageView()
    var emailLabel = UILabel()
    var usernameLabel = UILabel()
    var displayNameLabel = UILabel()
    var countryLabel = UILabel()
    var bioLabel = UILabel()
    
    var emailLabel2 = UILabel()
    var usernameLabel2 = UILabel()
    var displayNameLabel2 = UILabel()
    var countryLabel2 = UILabel()
    var bioLabel2 = UILabel()
    
    var ogAvaImg = UIImage()
    var ogEmail = ""
    var ogUsername = ""
    var ogDisplayName = ""
    var ogCountry = ""
    var ogBio = ""
    
    
    // buttons
    var signUpBtn = UIButton()
    var cancelBtn = UIButton()
    var profileImageLabel = UILabel()
    var birthday = ""
    
    //var userData: UserData?
    var userDataVM: UserDataVM?
    var guestUserData: UserData?
    //var avaImageExtension = ".jpg"
    
    let storage = Storage.storage().reference()
    
    // reset default size
    var scrollViewHeight : CGFloat = 0
    
    // keyboard frame size
    var keyboard = CGRect()
    var navBarView = NavBarView()
    var titleLabel1 = UILabel()
    var age = 0
    
 //  var countryPicker = MRCountryPicker()
   var countryName = UILabel()
  var countryCode = UILabel()
var countryFlag = UIImageView()
 var phoneCode = UILabel()
    
 
    
    
    
    
    
    

    // default func
    override func viewDidLoad() {
        super.viewDidLoad()
        let userData = userDataVM?.userData.value
        addReturnButton()
        ogAvaImg = avaImg.image!
        ogEmail = userData?.email ?? ""
        ogUsername = userData?.publicID ?? ""
        ogDisplayName = userData?.displayName ?? ""
        ogCountry = userData?.country ?? ""
        ogBio = userData?.bio ?? ""
        
        scrollView.addSubview(emailLabel)
        scrollView.addSubview(usernameLabel)
        scrollView.addSubview(displayNameLabel)
        scrollView.addSubview(countryLabel)
        scrollView.addSubview(bioLabel)
        scrollView.addSubview(emailLabel2)
        scrollView.addSubview(usernameLabel2)
        scrollView.addSubview(displayNameLabel2)
        scrollView.addSubview(countryLabel2)
        scrollView.addSubview(bioLabel2)
        
        emailLabel2.textColor = .white
        usernameLabel2.textColor = .white
        displayNameLabel2.textColor = .white
        countryLabel2.textColor = .white
        bioLabel2.textColor = .white
        
        
        emailLabel.text = "Email:"
        usernameLabel.text = "Username:"
        displayNameLabel.text = "Display Name:"
        countryLabel.text = "Country:"
        bioLabel.text = "Bio:"
        emailLabel.textColor = .white
        usernameLabel.textColor = .white
        displayNameLabel.textColor = .white
        countryLabel.textColor = .white
        bioLabel.textColor = .white
    
        

      
        avaImg.image = UIImage(named: "boyprofile")
        let gold = #colorLiteral(red: 0.9882352941, green: 0.7607843137, blue: 0, alpha: 1)
        let gray = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
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

        
        // declare select image tap
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(handleProfilePicTapView))
        avaTap.numberOfTapsRequired = 1
        avaImg.isUserInteractionEnabled = true
        avaImg.addGestureRecognizer(avaTap)

      
        // alignment
        avaImg.frame = CGRect(x: self.view.frame.size.width / 2 - 60, y: 80, width: 120, height: 120)
    
      //  avaImg.setupHexagonMask(lineWidth: 7.5, color: gray, cornerRadius: 10.0)
     //   HexagonView.setupHexagonImageView(imageView: avaImg)
        avaImg.layer.cornerRadius = avaImg.frame.width/2
        avaImg.layer.borderWidth = 5.0
        avaImg.layer.borderColor = white.cgColor
              avaImg.clipsToBounds = true
        emailLabel2.frame = CGRect(x: 125, y: avaImg.frame.maxY + 20, width: self.view.frame.size.width - 135, height: 30)
        usernameLabel2.frame = CGRect(x: 125, y: emailLabel2.frame.maxY + 10, width: self.view.frame.size.width - 135, height: 30)
        displayNameLabel2.frame = CGRect(x: 125, y: usernameLabel2.frame.maxY + 10, width: self.view.frame.size.width - 135, height: 30)
        countryLabel2.frame = CGRect(x: 125, y: displayNameLabel2.frame.maxY + 10, width: self.view.frame.size.width - 135, height: 30)
        bioLabel2.frame = CGRect(x: 125, y: countryLabel2.frame.maxY + 10, width: self.view.frame.size.width - 135, height: 30)
        emailLabel.frame = CGRect(x: 10, y: emailLabel2.frame.minY, width: 110, height: 30)
        usernameLabel.frame = CGRect(x: 10, y: usernameLabel2.frame.minY, width: 110, height: 30)
        displayNameLabel.frame = CGRect(x: 10, y: displayNameLabel2.frame.minY, width: 110, height: 30)
        countryLabel.frame = CGRect(x: 10, y: countryLabel2.frame.minY, width: 110, height: 30)
        bioLabel.frame = CGRect(x: 10, y: bioLabel2.frame.minY, width: 110, height: 30)
        
        
        
//        usernameLabel.frame = CGRect(x: 10, y: emailLabel2.frame.maxY + 10, width: self.view.frame.size.width - 20, height: 30)
//        displayNameLabel2.frame = CGRect(x: 10, y: usernameLabel2.frame.maxY + 10, width: self.view.frame.size.width - 20, height: 30)
//        countryLabel2.frame = CGRect(x: 10, y: displayNameLabel2.frame.maxY + 10, width: self.view.frame.size.width - 20, height: 30)
//        bioLabel2.frame = CGRect(x: 10, y: countryLabel2.frame.maxY + 10, width: self.view.frame.size.width - 20, height: 30)
        
        
        signUpBtn.frame = CGRect(x: 10, y: bioLabel2.frame.maxY + 10, width: self.view.frame.size.width - 20, height: 40)
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
    
        let cleanRef = guestUserData!.avaRef.replacingOccurrences(of: "/", with: "%2F")
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/bio-social-media.appspot.com/o/\(cleanRef)?alt=media")
        if url != nil {
        avaImg!.sd_setImage(with: url!, completed: {_, error, _, _ in
            if error != nil {
                print(error!.localizedDescription)
            }
        })
        }
        fillLabels()
        //fillTextFields()
        
    }
    




    // call picker to select image
    @objc func loadImg(_ recognizer:UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
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
       // self.scrollView.addSubview(self.profileImageLabel)
        var photoFrame = self.avaImg.frame
        self.profileImageLabel.frame = CGRect(x: self.view.frame.width/32, y: photoFrame.minY - 10, width: self.view.frame.width/2, height: 44)
        self.profileImageLabel.text = "Choose A Profile Picture:"
        self.profileImageLabel.font = emailLabel2.font
       self.profileImageLabel.font = emailLabel2.font?.withSize(12)
        self.profileImageLabel.textAlignment = .left
        self.profileImageLabel.textColor = .white
    }
    
    
    // hide keyboard func
    @objc func hideKeybard(_ notification:Notification) {
        
        // move down UI
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.scrollView.frame.size.height = self.view.frame.height
        })
    }
    
    
//    func createUser(email: String, password: String, completion: @escaping (User?) -> Void) {
//        Auth.auth().createUser(withEmail: email, password: password, completion: { obj, error in
//            if error == nil {
//                guard let obj = obj else { return }
//                self.user = obj.user
//                print("\(self.user!) successfully added")
//                completion(self.user!)
//            }
//            else {
//                print("failed to create user \(error?.localizedDescription)")
//                completion(nil)
//            }
//            print("completed")
//        })
//    }
    
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

    
    func fillLabels() {
        emailLabel2.text = guestUserData?.email
        usernameLabel2.text = guestUserData?.publicID
        displayNameLabel2.text = guestUserData?.displayName
        countryLabel2.text = guestUserData?.country
        bioLabel2.text = guestUserData?.bio
    }
    
    // clicked cancel
    @objc func backButtonpressed(_ recognizer: UITapGestureRecognizer) {
        
        // hide keyboard when pressed cancel
        self.view.endEditing(true)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpNavBarView() {
        cancelBtn.isHidden = true
        signUpBtn.isUserInteractionEnabled = true
        signUpBtn.isHidden = true
        var statusBarHeight = UIApplication.shared.statusBarFrame.height
//        print("This is status bar height \(statusBarHeight)")
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

        signUpBtn.setTitle("Done", for: .normal)
        signUpBtn.setTitleColor(.systemBlue, for: .normal)
      //  postButton.frame = CGRect(x: (self.view.frame.width) - (topBar.frame.height) - 5, y: 0, width: topBar.frame.height, height: topBar.frame.height)
        signUpBtn.titleLabel?.sizeToFit()
        signUpBtn.titleLabel?.textAlignment = .right
        
    
       cancelBtn.frame = CGRect(x: 10, y: statusBarHeight + (navBarHeightRemaining - 25)/2, width: 25, height: 25)
        signUpBtn.frame = CGRect(x: navBarView.frame.width - 60, y: statusBarHeight + (navBarHeightRemaining - 30)/2, width: 50, height: 30)
        //navBarView.postButton.titleLabel?.sizeToFit()
        navBarView.postButton.titleLabel?.textAlignment = .right
        let yOffset = navBarView.frame.maxY
  
        self.navBarView.addBehavior()
        self.navBarView.titleLabel.text = "\(guestUserData!.displayName)"
       //self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y:  statusBarHeight + (navBarHeightRemaining - 25)/2, width: 200, height: 25)
       // self.navBarView.titleLabel.sizet
        self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y: signUpBtn.frame.minY, width: 200, height: 25)
//        print("This is navBarView.")
      
      
    }
    
    @objc func handleProfilePicTapView(_ sender: UITapGestureRecognizer) {
        //            print("Tried to click profile pic handle later")
        //  menuView.menuButton.isHidden = true
        newImageView = UIImageView(image: UIImage(named: "kbit"))
        let cleanRef = guestUserData!.avaRef.replacingOccurrences(of: "/", with: "%2F")
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/bio-social-media.appspot.com/o/\(cleanRef)?alt=media")
        newImageView.sd_setImage(with: url!, completed: {_, error, _, _ in
            if error != nil {
                print(error!.localizedDescription)
            }
        })
        
        self.view.addSubview(newImageView)
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        newImageView.frame = frame
        newImageView.backgroundColor = .black
        
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImageHandler))
        profilePicCancelButton.addGestureRecognizer(tap)
        profilePicCancelButton.isUserInteractionEnabled = true
        view.addSubview(profilePicCancelButton)
        profilePicCancelButton.frame = CGRect(x: view.frame.width/2-40, y: view.frame.height-112, width: 80, height: 80)
        profilePicCancelButton.setImage(UIImage(named: "cancel2"), for: .normal)
        view.bringSubviewToFront(profilePicCancelButton)
        profilePicCancelButton.layer.cornerRadius = profilePicCancelButton.frame.size.width / 2
        profilePicCancelButton.backgroundColor = .clear
        //returnButton.setBackgroundImage(UIImage(named: "cancel11"), for: .normal)
        profilePicCancelButton.clipsToBounds = true
    }

    @objc func dismissFullscreenImageHandler(_ sender: UITapGestureRecognizer) {
        dismissFullscreenImage(view: sender.view!)
        newImageView.removeFromSuperview()
        dismissFullscreenImage(view: newImageView)
    }
    
    func dismissFullscreenImage(view: UIView) {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        returnButton.isHidden = false
        view.removeFromSuperview()
    }
    
    func addReturnButton() {
        view.addSubview(returnButton)
        let returnTap = UITapGestureRecognizer(target: self, action: #selector(self.backButtonpressed))
        returnButton.addGestureRecognizer(returnTap)
        returnButton.setImage(UIImage(named: "cancel2"), for: .normal)
        returnButton.frame = CGRect(x: view.frame.width/2-40, y: view.frame.height-112, width: 80, height: 80)
        view.bringSubviewToFront(returnButton)
        profilePicCancelButton.backgroundColor = .clear
       // profilePicCancelButton.backgroundColor = .black
        returnButton.layer.cornerRadius = returnButton.frame.size.width / 2
        //returnButton.setBackgroundImage(UIImage(named: "cancel11"), for: .normal)
        returnButton.clipsToBounds = true
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

