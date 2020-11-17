//
//  SignInVC.swift
//  Bio
//
//  Created by Ann McDonough on 8/14/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignInVC: UIViewController {
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
  //var signInButton = UIButton()
    
    @IBOutlet weak var signInButton: UIButton!
    
 var cancelButton = UIButton()
    
    let auth = Auth.auth()
    var navBarView = NavBarView()
    var titleLabel1 = UILabel()
    
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
    self.emailText.attributedPlaceholder = NSAttributedString(string: "Email",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray4])
    self.passwordText.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray4])
    self.emailText.textColor = white
    self.passwordText.textColor = white
    //self.emailText.font = UIFont(name: "Poppins-SemiBold", size: 20)
    //self.passwordText.font = UIFont(name: "Poppins-SemiBold", size: 20)
    
    emailText.backgroundColor = .clear
    passwordText.backgroundColor = .clear

    
    let bottomLine = CALayer()
    bottomLine.frame = CGRect(x: 0, y: self.emailText.frame.height, width: self.emailText.frame.width, height: 1.0)
    bottomLine.backgroundColor = UIColor.systemGray4.cgColor
    self.emailText.borderStyle = UITextField.BorderStyle.none
    self.emailText.layer.addSublayer(bottomLine)
    
    let bottomLine2 = CALayer()
    bottomLine2.frame = CGRect(x: 0, y: passwordText.frame.height, width: passwordText.frame.width, height: 1.0)
    bottomLine2.backgroundColor = UIColor.systemGray4.cgColor
    passwordText.borderStyle = UITextField.BorderStyle.none
    passwordText.layer.addSublayer(bottomLine2)
    
    
    
    
    
    
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
        
//        let postTap = UITapGestureRecognizer(target: self, action: #selector(self.signInClicked))
//        postTap.numberOfTapsRequired = 1
//        signInButton.isUserInteractionEnabled = true
//        signInButton.addGestureRecognizer(postTap)
//        signInButton.setTitle("Next", for: .normal)
//        signInButton.setTitleColor(.systemBlue, for: .normal)
//      //  postButton.frame = CGRect(x: (self.view.frame.width) - (topBar.frame.height) - 5, y: 0, width: topBar.frame.height, height: topBar.frame.height)
//        signInButton.titleLabel?.sizeToFit()
//        signInButton.titleLabel?.textAlignment = .right
//
//
    
       cancelButton.frame = CGRect(x: 10, y: statusBarHeight + (navBarHeightRemaining - 25)/2, width: 25, height: 25)
       // signInButton.frame = CGRect(x: navBarView.frame.width - 50, y: statusBarHeight + (navBarHeightRemaining - 30)/2, width: 40, height: 30)
        //navBarView.postButton.titleLabel?.sizeToFit()
        navBarView.postButton.titleLabel?.textAlignment = .right
        let yOffset = navBarView.frame.maxY
  
        self.navBarView.addBehavior()
        self.navBarView.titleLabel.text = "Sign In"
        
        self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y: self.cancelButton.frame.minY, width: 200, height: 25)
        //self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y: navBarView.frame.maxY - 30, width: 200, height: 30)
        print("This is navBarView.")
      
      
    }
    
    func setUpNavBarViewBad() {
        self.view.addSubview(self.navBarView)
        self.navBarView.addSubview(self.titleLabel1)
        self.navBarView.addBehavior()
       
        self.titleLabel1.text = "Sign In"
        self.titleLabel1.font = UIFont(name: "DINAlternate-Bold", size: 28)
        self.navBarView.frame = CGRect(x: 0, y: self.cancelButton.frame.minY/2, width: self.view.frame.width, height: self.view.frame.height/12)
       // self.tableView.frame = CGRect(x: 0, y: self.view.frame.height/12, width: self.view.frame.width, height: self.view.frame.height*(11/12))
        self.titleLabel1.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/12)
        self.titleLabel1.textAlignment = .center
       
     //   self.titleLabel1.font = self.emailText.font
     //   self.titleLabel1.font.withSize(45)
        
        self.titleLabel1.textColor = .white
        self.navBarView.backgroundColor = .clear
        self.navBarView.isUserInteractionEnabled = false
    }
    
    @IBAction func signInClicked(_ sender: Any) {
        print("signin in")
        auth.signIn(withEmail: emailText.text!, password: passwordText.text!, completion: { result, error in
            if error == nil {
                if result?.user != nil {
                    print("success should segue")
                    self.performSegue(withIdentifier: "unwindFromSignIn", sender: nil)
                }
                
            }
            else {
                print("error during signin: \(error?.localizedDescription)")
                // make toast
            }
        })
    }
    
//    @objc func signInClicked(_ recognizer: UITapGestureRecognizer) {
//        auth.signIn(withEmail: emailText.text!, password: passwordText.text!, completion: { result, error in
//            if error == nil {
//                if result?.user != nil {
//                    self.performSegue(withIdentifier: "unwindFromSignIn", sender: nil)
//                }
//
//            }
//            else {
//                print("error during signin: \(error?.localizedDescription)")
//                // make toast
//            }
//        })
//    }
    
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
