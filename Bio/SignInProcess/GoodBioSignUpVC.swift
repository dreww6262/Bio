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
import MRCountryPicker

class GoodBioSignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MRCountryPickerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var changedProfilePic = false
    var bioCharacterLimit = 20
    var countries: [String] = []
    var minimumAge = 13
   // var myCountry = ""
//    var userData: UserData?
    var country = ""
    var GDPRCountries: [String] = ["Austria", "Belgium", "Bulgaria", "Croatia", "Cyprus", "Czech Republic", "Denmark", "Estonia", "Finland", "France", "Germany", "Greece", "Hungary", "Ireland", "Italy", "Latvia", "Lithuania", "Luxembourg", "Malta", "Netherlands", "Poland", "Portugal", "Romania", "Slovakia", "Slovenia", "Spain", "Sweden"]
    var checkBox = UIButton()
    var checkBoxStatus = false
    var checkBox2 = UIButton()
    var checkBoxStatus2 = false
    var termsOfServiceLabel = UILabel()
    var privacyPolicyLabel = UILabel()
    var termsOfServiceButton = UIButton()
    var privacyPolicyButton = UIButton()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.countries[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.countryTextField.text = self.countries[row]
    }
    
    func getCountryList() -> [String]{
        var countries: [String] = []
        for code in NSLocale.isoCountryCodes {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country Not Found \(code)"
            countries.append(name)
        }
        return countries
    }
    
    
    // scrollView
    @IBOutlet weak var scrollView: UIScrollView!
    // profile image
    @IBOutlet weak var avaImg: UIImageView!
    
    @IBOutlet weak var gradientImage: UIImageView!
    @IBOutlet weak var displayNameTxt: UITextField!
    
    @IBOutlet weak var emailTxt: UITextField!
    // textfields
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var repeatPassword: UITextField!
    @IBOutlet weak var countryPicker: MRCountryPicker!
    @IBOutlet weak var bioTxt: UITextField!
    
    
    // buttons
    var signUpBtn = UIButton()
    var cancelBtn = UIButton()
    var profileImageLabel = UILabel()
   
    
    var userDataVM: UserDataVM?
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
    
    lazy var countryTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Country"
        textField.borderStyle = .none
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        textField.inputView = pickerView
        
        return textField
        
    }()
    let db = Firestore.firestore()
    

    // a picker item was selected
    func countryPhoneCodePicker(_ picker: MRCountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        self.countryName.text = name
        self.countryCode.text = countryCode
        self.phoneCode.text = phoneCode
        self.countryFlag.image = flag
    }
    
    
    
    

    // default func
    override func viewDidLoad() {
        super.viewDidLoad()
        checkBox.setImage(UIImage(named: "tealEmpty"), for: .normal)
        checkBox2.setImage(UIImage(named: "tealEmpty"), for: .normal)
        termsOfServiceLabel.text = "I have read and accept the Terms and Conditions"
        privacyPolicyLabel.text = "I have read and accept the Privacy Policy"
        termsOfServiceButton.setTitle("Terms and Conditions", for: .normal)
        termsOfServiceButton.setTitleColor(.link, for: .normal)
        privacyPolicyButton.setTitle("Privacy Policy", for: .normal)
        privacyPolicyButton.setTitleColor(.link, for: .normal)
        
        termsOfServiceLabel.textColor = .white
        privacyPolicyLabel.textColor = .white
        let checkBoxTap = UITapGestureRecognizer(target: self, action: #selector(checkBoxTapped(_:)))
        let checkBoxTap2 = UITapGestureRecognizer(target: self, action: #selector(checkBox2Tapped(_:)))
        
        let termsTap = UITapGestureRecognizer(target: self, action: #selector(termsOfServiceTapped(_:)))
        let privacyTap = UITapGestureRecognizer(target: self, action: #selector(privacyPolicyTapped(_:)))
        //   checkBoxTap.numberOfTapsRequired = 1
        //checkBox.isUserInteractionEnabled = true
        checkBox.addGestureRecognizer(checkBoxTap)
        checkBox2.addGestureRecognizer(checkBoxTap2)
        termsOfServiceButton.addGestureRecognizer(termsTap)
        privacyPolicyButton.addGestureRecognizer(privacyTap)
        termsOfServiceLabel.isUserInteractionEnabled = false
        privacyPolicyLabel.isUserInteractionEnabled = false
        view.addSubview(checkBox)
        view.addSubview(checkBox2)
        view.addSubview(termsOfServiceLabel)
        view.addSubview(privacyPolicyLabel)
        view.addSubview(termsOfServiceButton)
        view.addSubview(privacyPolicyButton)
        profileImageLabel.isHidden = true
        self.countries = self.getCountryList()
        self.countries = self.countries.sorted(by: <)
        self.countries.insert("United States", at: 0)
        self.countries.insert("", at: 0)
        self.scrollView.addSubview(countryTextField)
        countryPicker.isHidden = true
        avaImg.image = UIImage(named: "user-2")
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
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(GoodBioSignUpVC.loadImg(_:)))
        avaTap.numberOfTapsRequired = 1
        avaImg.isUserInteractionEnabled = true
        avaImg.addGestureRecognizer(avaTap)
  

        countryPicker.countryPickerDelegate = self
        countryPicker.showPhoneNumbers = true

        // set country by its code
        countryPicker.setCountry("SI")

        // optionally set custom locale; defaults to system's locale
        countryPicker.setLocale("sl_SI")

        // set country by its name
        countryPicker.setCountryByName("Canada")
      
        // alignment
        avaImg.frame = CGRect(x: self.view.frame.size.width / 2 - 60, y: 80, width: 120, height: 120)
//        avaImg.setupHexagonMask(lineWidth: 7.5, color: gray, cornerRadius: 10.0)
        avaImg.layer.cornerRadius = avaImg.frame.width/2
        avaImg.layer.borderWidth = 5.0
        avaImg.layer.borderColor = white.cgColor
     //   HexagonView.setupHexagonImageView(imageView: avaImg)
              avaImg.clipsToBounds = true
        emailTxt.frame = CGRect(x: 10, y: avaImg.frame.maxY + 20, width: self.view.frame.size.width - 20, height: 30)
        emailTxt.autocorrectionType = .no
        usernameTxt.frame = CGRect(x: 10, y: emailTxt.frame.maxY + 10, width: self.view.frame.size.width - 20, height: 30)
        usernameTxt.autocorrectionType = .no
        displayNameTxt.frame = CGRect(x: 10, y: usernameTxt.frame.maxY + 10, width: self.view.frame.size.width - 20, height: 30)
        displayNameTxt.autocorrectionType = .no
        passwordTxt.frame = CGRect(x: 10, y: displayNameTxt.frame.maxY + 10, width: self.view.frame.size.width - 20, height: 30)
        passwordTxt.autocorrectionType = .no
        repeatPassword.frame = CGRect(x: 10, y: passwordTxt.frame.maxY + 10, width: self.view.frame.size.width - 20, height: 30)
        repeatPassword.autocorrectionType = .no
        countryTextField.frame = CGRect(x: 10, y: repeatPassword.frame.maxY + 10, width: self.view.frame.size.width - 20, height: 30)
        countryTextField.autocorrectionType = .no
        bioTxt.frame = CGRect(x: 10, y: countryTextField.frame.maxY + 10, width: self.view.frame.size.width - 20, height: 30)
        bioTxt.autocorrectionType = .no
        checkBox.frame = CGRect(x: 10, y: bioTxt.frame.maxY + 5, width: 30, height: 30)
        checkBox2.frame = CGRect(x: 10, y: checkBox.frame.maxY + 5, width: 30, height: 30)
        termsOfServiceLabel.frame = CGRect(x: checkBox.frame.maxX + 7, y: bioTxt.frame.maxY + 5, width: view.frame.width - checkBox.frame.maxX - 7, height: 30)
        privacyPolicyLabel.frame = CGRect(x: checkBox.frame.maxX + 7, y: checkBox.frame.maxY + 5, width: view.frame.width - checkBox.frame.maxX - 7, height: 30)
        termsOfServiceButton.frame = CGRect(x: 10, y: privacyPolicyLabel.frame.maxY + 5, width: (view.frame.width - 10)/2, height: 30)
        privacyPolicyButton.frame = CGRect(x: view.frame.width/2, y: privacyPolicyLabel.frame.maxY + 5, width:(view.frame.width - 10)/2, height: 30)
        privacyPolicyLabel.textAlignment = .left
        termsOfServiceLabel.textAlignment = .left
        
        
        signUpBtn.frame = CGRect(x: 10, y: bioTxt.frame.maxY + 10, width: self.view.frame.size.width - 20, height: 40)
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
    

    @objc func skipTapped(_ sender: UITapGestureRecognizer) {
        let linkVC = storyboard?.instantiateViewController(withIdentifier: "linkVC") as! AddLinkVCViewController
        linkVC.userDataVM = userDataVM
        linkVC.cancelLbl = "Skip"
        self.present(linkVC, animated: false, completion: nil)
    }
    
    @objc func checkBoxTapped(_ sender: UITapGestureRecognizer) {
        if checkBoxStatus == false {
            
            checkBox.setImage(UIImage(named: "check-2"), for: .normal)
            checkBoxStatus = true
        
        }
        else {
            checkBox.setImage(UIImage(named: "tealEmpty"), for: .normal)
            
            checkBoxStatus = false
            //    linkHexagonImage.frame = CGRect(x: 40, y: navBarView.frame.maxY + 10, width: scrollView.frame.width - 80, height: scrollView.frame.width - 80)
    
        }
    }

    @objc func checkBox2Tapped(_ sender: UITapGestureRecognizer) {
        if checkBoxStatus2 == false {
            
            checkBox2.setImage(UIImage(named: "check-2"), for: .normal)
            checkBoxStatus2 = true
        
        }
        else {
            checkBox2.setImage(UIImage(named: "tealEmpty"), for: .normal)
            
            checkBoxStatus2 = false

    
        }
    }
    
    
   func formatBottomLines(){
    let bottomLine = CALayer()
    bottomLine.frame = CGRect(x: 0, y: self.emailTxt.frame.height, width: self.emailTxt.frame.width, height: 1.0)
    bottomLine.backgroundColor = UIColor(red: 0.82, green: 0.82, blue: 0.84, alpha: 1.00).cgColor
    self.emailTxt.borderStyle = UITextField.BorderStyle.none
    self.emailTxt.layer.addSublayer(bottomLine)
    
    let bottomLine2 = CALayer()
    bottomLine2.frame = CGRect(x: 0, y: usernameTxt.frame.height, width: usernameTxt.frame.width, height: 1.0)
    bottomLine2.backgroundColor = UIColor(red: 0.82, green: 0.82, blue: 0.84, alpha: 1.00).cgColor
    usernameTxt.borderStyle = UITextField.BorderStyle.none
    usernameTxt.layer.addSublayer(bottomLine2)
    
    let bottomLine3 = CALayer()
    bottomLine3.frame = CGRect(x: 0, y: self.displayNameTxt.frame.height, width: self.displayNameTxt.frame.width, height: 1.0)
    bottomLine3.backgroundColor = UIColor(red: 0.82, green: 0.82, blue: 0.84, alpha: 1.00).cgColor
    self.displayNameTxt.borderStyle = UITextField.BorderStyle.none
    self.displayNameTxt.layer.addSublayer(bottomLine3)
    
    let bottomLine4 = CALayer()
    bottomLine4.frame = CGRect(x: 0, y: passwordTxt.frame.height, width: passwordTxt.frame.width, height: 1.0)
    bottomLine4.backgroundColor = UIColor(red: 0.82, green: 0.82, blue: 0.84, alpha: 1.00).cgColor
    passwordTxt.borderStyle = UITextField.BorderStyle.none
    passwordTxt.layer.addSublayer(bottomLine4)
    
    
    let bottomLine5 = CALayer()
    bottomLine5.frame = CGRect(x: 0, y: repeatPassword.frame.height, width: repeatPassword.frame.width, height: 1.0)
    bottomLine5.backgroundColor = UIColor(red: 0.82, green: 0.82, blue: 0.84, alpha: 1.00).cgColor
    repeatPassword.borderStyle = UITextField.BorderStyle.none
    repeatPassword.layer.addSublayer(bottomLine5)

    let bottomLine7 = CALayer()
    bottomLine7.frame = CGRect(x: 0, y: countryTextField.frame.height, width: countryPicker.frame.width, height: 1.0)
    bottomLine7.backgroundColor = UIColor(red: 0.82, green: 0.82, blue: 0.84, alpha: 1.00).cgColor
    countryTextField.borderStyle = UITextField.BorderStyle.none
    countryTextField.layer.addSublayer(bottomLine7)
    
    let bottomLine8 = CALayer()
    bottomLine8.frame = CGRect(x: 0, y: bioTxt.frame.height, width: bioTxt.frame.width, height: 1.0)
    bottomLine8.backgroundColor = UIColor(red: 0.82, green: 0.82, blue: 0.84, alpha: 1.00).cgColor
    bioTxt.borderStyle = UITextField.BorderStyle.none
    bioTxt.layer.addSublayer(bottomLine8)
    
    emailTxt.attributedPlaceholder = NSAttributedString(string: "Email Address",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.82, green: 0.82, blue: 0.84, alpha: 1.00)])
    emailTxt.textColor = .white
    usernameTxt.attributedPlaceholder = NSAttributedString(string: "Username",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.82, green: 0.82, blue: 0.84, alpha: 1.00)])
    usernameTxt.textColor = .white
    displayNameTxt.attributedPlaceholder = NSAttributedString(string: "Display Name",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.82, green: 0.82, blue: 0.84, alpha: 1.00)])
    displayNameTxt.textColor = .white
    passwordTxt.attributedPlaceholder = NSAttributedString(string: "Password",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.82, green: 0.82, blue: 0.84, alpha: 1.00)])
    passwordTxt.textColor = .white
    repeatPassword.attributedPlaceholder = NSAttributedString(string: "Repeat Password",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.82, green: 0.82, blue: 0.84, alpha: 1.00)])
    repeatPassword.textColor = .white
    

    
    self.countryTextField.attributedPlaceholder = NSAttributedString(string: "Country",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.82, green: 0.82, blue: 0.84, alpha: 1.00)])
    self.countryTextField.textColor = .white
    
    self.bioTxt.attributedPlaceholder = NSAttributedString(string: "Bio",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.82, green: 0.82, blue: 0.84, alpha: 1.00)])
    self.bioTxt.textColor = .white
    
//    self.txtDatePicker.attributedPlaceholder = NSAttributedString(string: "Repeat Password",
//                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.82, green: 0.82, blue: 0.84, alpha: 1.00)])
    
    
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
        //picker. setupHexagonMaskView(lineWidth: picker.cameraOverlayView!.frame.width/15, color: white, cornerRadius: picker.cameraOverlayView!.frame.width)
        picker.modalPresentationStyle = .fullScreen
        present(picker, animated: true, completion: nil)
    }
    
    
    // connect selected image to our ImageView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        avaImg.image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage
//        }
        changedProfilePic = true
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // hide keyboard if tapped
    @objc func hideKeyboardTap(_ recoginizer:UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @objc func termsOfServiceTapped(_ recoginizer:UITapGestureRecognizer) {
        self.view.endEditing(true)
        let pdfVC = self.storyboard?.instantiateViewController(identifier: "pdfViewer") as! PDFViewer
        pdfVC.pdfString = "Bio Beta Terms and Conditions"
        pdfVC.navBarView.titleLabel.text = "Terms and Conditions"
        pdfVC.titleString = "Terms and Conditions"
    pdfVC.modalPresentationStyle = .fullScreen
        self.present(pdfVC, animated: false)
    }
    
    @objc func privacyPolicyTapped(_ recoginizer:UITapGestureRecognizer) {
        self.view.endEditing(true)
        let pdfVC = self.storyboard?.instantiateViewController(identifier: "pdfViewer") as! PDFViewer
pdfVC.pdfString = "Bio Beta Privacy Policy"
pdfVC.titleString = "Privacy Policy"
pdfVC.navBarView.titleLabel.text = "Privacy Policy"
    pdfVC.modalPresentationStyle = .fullScreen
    self.present(pdfVC, animated: false)
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
        self.scrollView.addSubview(self.profileImageLabel)
        var photoFrame = self.avaImg.frame
        self.profileImageLabel.frame = CGRect(x: self.view.frame.width/32, y: photoFrame.minY - 10, width: self.view.frame.width/2, height: 44)
        self.profileImageLabel.text = "Choose A Profile Picture:"
        self.profileImageLabel.font = emailTxt.font
       self.profileImageLabel.font = emailTxt.font?.withSize(12)
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
    
    
    func createUser(email: String, password: String, completion: @escaping (User?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { obj, error in
            if error == nil {
                guard let obj = obj else { return }
                completion(obj.user)
            }
            else {
                print("failed to create user \(error?.localizedDescription)")
                // alert message
                let alert = UIAlertController(title: "Invalid Email", message: "Enter a valid email address.", preferredStyle: UIAlertController.Style.alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                completion(nil)
                return
              
            }
//            print("completed")
        })
    }
    

    
    
    var loadingIndicator: UIViewController?
    var blurEffectView: UIVisualEffectView?
    // clicked sign up
    @objc func signUpTapped(_ recognizer: UITapGestureRecognizer) {
//        print("sign up pressed")
        
        // dismiss keyboard
        self.view.endEditing(true)
        
        // if fields are empty
        if (emailTxt.text!.isEmpty || usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty || repeatPassword.text!.isEmpty || countryTextField.text!.isEmpty || displayNameTxt.text!.isEmpty) {
            
            // alert message
            let alert = UIAlertController(title: "PLEASE", message: "fill all fields", preferredStyle: UIAlertController.Style.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        if checkBoxStatus == false {
            let alert = UIAlertController(title: "PLEASE", message: "Check the box to accept Terms and Conditions", preferredStyle: UIAlertController.Style.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        if checkBoxStatus2 == false {
            let alert = UIAlertController(title: "PLEASE", message: "Check the box to accept Privacy Policy", preferredStyle: UIAlertController.Style.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        self.country = self.countryTextField.text!
//        print("This is country \(country)")
        if GDPRCountries.contains(country) {
//            print("GDPR country! 16 and up")
            minimumAge = 16
        } else {
            minimumAge = 13
        }
        
        if bioTxt.text!.count > bioCharacterLimit {
            // alert message
            let alert = UIAlertController(title: "Bio is too long!", message: "Your bio can only be up to 20 characters long", preferredStyle: UIAlertController.Style.alert)
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
        
        var username = usernameTxt.text!
        while username.last == " " {
            username = "\(username.removeLast())"
            print(username)
        }
        
        var email = emailTxt.text!
        while email.last == " " {
            email = "\(email.removeLast())"
            print(email)
        }
        var password = passwordTxt.text!
        while password.last == " " {
            password = "\(password.removeLast())"
            print(password)
        }
        let bio = bioTxt.text ?? ""
        var signedInUser: User?
        
//        print("about to create new user")
        
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
        
        db.collection("UserData1").whereField("publicID", isEqualTo: usernameTxt.text!).getDocuments(completion: { obj, error in
            if let docs = obj?.documents {
                if docs.count > 0 {
                    let alert = UIAlertController(title: "Username has already been taken", message: "Please choose a different username.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    DispatchQueue.global().async {
                        DispatchQueue.main.sync {
                            self.present(alert, animated: true, completion: nil)
                            self.blurEffectView?.removeFromSuperview()
                            loadingIndicator!.view.removeFromSuperview()
                            loadingIndicator!.removeFromParent()
                        }
                    }
                    return
                }
                
                self.createUser(email: email, password: password, completion: { [self]user in
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
                   // country = self.countryTextField.text ?? ""
                    avaFileRef.putData(self.avaImg.image!.pngData()!, metadata: nil, completion: { meta, error in
                        if (error == nil) {
                            let userData = UserData(email: email, publicID: self.usernameTxt.text!.lowercased(), privateID: signedInUser!.uid, avaRef: reference, hexagonGridID: "", userPage: "", subscribedUsers: [""], subscriptions: [String: String](), numPosts: 0, displayName: self.displayNameTxt.text!, birthday: "", blockedUsers: [String](), isBlockedBy: [String](), pageViews: 0, bio: bio, country: country, lastTimePosted: NSDate.now.description, currentCity: "", gender: "", phoneNumber: "", identityHexIDs: [String]())
                            let db = Firestore.firestore()
                            let userDataCollection = db.collection("UserData1")
                            let docRef = userDataCollection.document(user!.uid)
                            docRef.setData(userData.dictionary, completion: { error in
                                if error == nil {
//                                    print("userData posted")
                                    self.userDataVM?.userData.value = userData
                                    self.userDataVM?.retreiveUserData(username: userData.publicID, completion: {})
                                    
                                    if self.changedProfilePic == false {
                                        let addProfilePic = self.storyboard?.instantiateViewController(withIdentifier: "addProfilePhotoVC") as! AddProfilePhotoVC
                                        addProfilePic.userDataVM = self.userDataVM
                                        addProfilePic.country = country
                                        addProfilePic.minimumAge = minimumAge
                                        self.present(addProfilePic, animated: false, completion: nil)
                                    }
                // this triggers old/bad sign out process
                                    else {
                                        let personalDetailTableViewVC = self.storyboard?.instantiateViewController(withIdentifier: "personalDetailTableViewVC") as! PersonalDetailTableViewVC
                                        personalDetailTableViewVC.userDataVM = self.userDataVM
                                        personalDetailTableViewVC.myCountry = self.country
                                        personalDetailTableViewVC.myCountries.append(self.country)
                                        personalDetailTableViewVC.myAgeLimit = minimumAge
                                        self.present(personalDetailTableViewVC, animated: false, completion: nil)
                                    }
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
            
        })
        
        
        
        
    }
    
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        
    }
    
    
    // clicked cancel
    @objc func backButtonpressed(_ recognizer: UITapGestureRecognizer) {
        
        // hide keyboard when pressed cancel
        self.view.endEditing(true)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpNavBarView() {
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
       //self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y:  statusBarHeight + (navBarHeightRemaining - 25)/2, width: 200, height: 25)
       // self.navBarView.titleLabel.sizet
        self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y: signUpBtn.frame.minY, width: 200, height: 25)
//        print("This is navBarView.")
      
      
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

