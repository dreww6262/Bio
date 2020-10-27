//
//  ForgotPasswordVC.swift
//  Bio
//
//  Created by Ann McDonough on 10/26/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//


import UIKit
import Firebase
import FirebaseAuth

class ChangePasswordVC: UIViewController {
    @IBOutlet weak var currentPasswordText: UITextField!
    @IBOutlet weak var newPasswordText: UITextField!
    
    @IBOutlet weak var confirmNewPasswordText: UITextField!
    //var signInButton = UIButton()
    
    @IBOutlet weak var signInButton: UIButton!
    
 var cancelButton = UIButton()
    
    let auth = Auth.auth()
    var navBarView = NavBarView()
    var titleLabel1 = UILabel()
    var userData: UserData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.layer.cornerRadius = signInButton.frame.width/20
        // Do any additional setup after loading the view.
       var rect1 = signInButton.frame
        signInButton.frame = CGRect(x: rect1.minX, y: rect1.minY, width: rect1.width, height: rect1
                                        .height*(5/4))
        setUpNavBarView()
        formatStuff()
    }
    
 func formatStuff() {
//    self.emailText.frame = CGRect(x: self.view.frame.width/2 - 50, y: self.view.frame.height/2-66, width: 100, height: 44)
//    self.passwordText.frame = CGRect(x: emailText.frame.minX, y: emailText.frame.maxY + 10, width: 100, height: 44)
//    signInButton.frame = CGRect(x: passwordText.frame.minX, y: passwordText.frame.maxY + 10, width: 100, height: 66)
//    cancelButton.frame = CGRect(x: signInButton.frame.minX, y: signInButton.frame.maxY + 10, width: 100, height: 44)
//    signInButton.layer.cornerRadius = signInButton.frame.width/20
    self.currentPasswordText.attributedPlaceholder = NSAttributedString(string: "Current Password",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray4])
    self.newPasswordText.attributedPlaceholder = NSAttributedString(string: "New Password",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray4])
    self.currentPasswordText.textColor = white
    self.newPasswordText.textColor = white
    
    self.confirmNewPasswordText.attributedPlaceholder = NSAttributedString(string: "Confirm New Password",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray4])
    self.confirmNewPasswordText.textColor = white
    
    //self.emailText.font = UIFont(name: "Poppins-SemiBold", size: 20)
    //self.passwordText.font = UIFont(name: "Poppins-SemiBold", size: 20)
    
    currentPasswordText.backgroundColor = .clear
    newPasswordText.backgroundColor = .clear

    
    let bottomLine = CALayer()
    bottomLine.frame = CGRect(x: 0, y: self.currentPasswordText.frame.height, width: self.currentPasswordText.frame.width, height: 1.0)
    bottomLine.backgroundColor = UIColor.systemGray4.cgColor
    self.currentPasswordText.borderStyle = UITextField.BorderStyle.none
    self.currentPasswordText.layer.addSublayer(bottomLine)
    
    let bottomLine2 = CALayer()
    bottomLine2.frame = CGRect(x: 0, y: newPasswordText.frame.height, width: newPasswordText.frame.width, height: 1.0)
    bottomLine2.backgroundColor = UIColor.systemGray4.cgColor
    newPasswordText.borderStyle = UITextField.BorderStyle.none
    newPasswordText.layer.addSublayer(bottomLine2)
    
    let bottomLine3 = CALayer()
    bottomLine3.frame = CGRect(x: 0, y: confirmNewPasswordText.frame.height, width: confirmNewPasswordText.frame.width, height: 1.0)
    bottomLine3.backgroundColor = UIColor.systemGray4.cgColor
    confirmNewPasswordText.borderStyle = UITextField.BorderStyle.none
    confirmNewPasswordText.layer.addSublayer(bottomLine3)
    
    
    newPasswordText.frame = CGRect(x: currentPasswordText.frame.minX, y: currentPasswordText.frame.maxY + 15, width: currentPasswordText.frame.width, height: currentPasswordText.frame.height)
    
    confirmNewPasswordText.frame = CGRect(x: confirmNewPasswordText.frame.minX, y: newPasswordText.frame.maxY + 15, width: currentPasswordText.frame.width, height: currentPasswordText.frame.height)
    
    signInButton.frame = CGRect(x: confirmNewPasswordText.frame.minX, y: confirmNewPasswordText.frame.maxY + 25, width: currentPasswordText.frame.width, height: currentPasswordText.frame.height)
    
    
    
    }
    
    func setUpNavBarView() {
        var statusBarHeight = UIApplication.shared.statusBarFrame.height
        print("This is status bar height \(statusBarHeight)")
        self.view.addSubview(navBarView)
        self.navBarView.addSubview(self.cancelButton)
       // self.navBarView.addSubview(self.signInButton)
        self.navBarView.frame = CGRect(x: -5, y: -5, width: self.view.frame.width + 10, height: (self.view.frame.height/12)+5)
       
        var navBarHeightRemaining = navBarView.frame.maxY - statusBarHeight
        navBarView.backButton.isHidden = true
        navBarView.postButton.isHidden = true
//        self.navBarView.addSubview(toSettingsButton)
//        self.navBarView.addSubview(toSearchButton)
        
        let backTap = UITapGestureRecognizer(target: self, action: #selector(self.cancelButtonClicked))
        backTap.numberOfTapsRequired = 1
        self.cancelButton.isUserInteractionEnabled = true
        self.cancelButton.addGestureRecognizer(backTap)
        self.cancelButton.setImage(UIImage(named: "whiteChevron"), for: .normal)
        

       cancelButton.frame = CGRect(x: 10, y: statusBarHeight + (navBarHeightRemaining - 25)/2, width: 25, height: 25)
   
        navBarView.postButton.titleLabel?.textAlignment = .right
        let yOffset = navBarView.frame.maxY
  
        self.navBarView.addBehavior()
        self.navBarView.titleLabel.text = "Change Password"
      //  self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y: navBarView.frame.maxY - 30, width: 200, height: 30)
        self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y: statusBarHeight + (navBarHeightRemaining - 30)/2, width: 200, height: 30)
        
        print("This is navBarView.")
      
      
    }
    
 
    
    @IBAction func changePasswordClicked(_ sender: Any) {
        print("trying to change password")
        
        // dismiss keyboard
        self.view.endEditing(true)
        
        
        
        
        // if fields are empty
        if (currentPasswordText.text!.isEmpty || newPasswordText.text!.isEmpty || confirmNewPasswordText.text!.isEmpty) {
            
            // alert message
            let alert = UIAlertController(title: "PLEASE", message: "Fill All Fields", preferredStyle: UIAlertController.Style.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        //check if current password is correct
        auth.signIn(withEmail: userData!.email, password: currentPasswordText.text!, completion: { result, error in
            if error == nil {
                if result?.user != nil {
                  print("This is the correct password. continue")
                }
                
            }
            else {
                print("error during signin: \(error?.localizedDescription)")
                // alert message
                let alert = UIAlertController(title: "Incorrect Password", message: "Enter Current Password Correctly", preferredStyle: UIAlertController.Style.alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
                return
                
            }
        })
        
        
    
        //if new password matches old password
        if newPasswordText.text == currentPasswordText.text || confirmNewPasswordText.text == currentPasswordText.text {
            let alert = UIAlertController(title: "Cannot Change To Current Password", message: "Change To A New Password", preferredStyle: UIAlertController.Style.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        
        
        // if different passwords
        if newPasswordText.text != confirmNewPasswordText.text {
            
            // alert message
            let alert = UIAlertController(title: "New Passwords", message: "Do Not Match", preferredStyle: UIAlertController.Style.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        let username = userData?.publicID
        let email = userData?.email
        let password = confirmNewPasswordText.text!
        var signedInUser: User?
        
        print("about to create new user")
        
        let loadingIndicator = storyboard?.instantiateViewController(withIdentifier: "loading")
    
        var blurEffectView = UIVisualEffectView()
        
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
        view.addSubview(blurEffectView)
        
        addChild(loadingIndicator!)
        view.addSubview(loadingIndicator!.view)
        
        
        // TODO: right here we need to go in and replace the old password with the new password
      
        
    }
    
    
    @objc func cancelButtonClicked(_ recognizer: UITapGestureRecognizer) {
       
            
            // hide keyboard when pressed cancel
            self.view.endEditing(true)
            
            self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
