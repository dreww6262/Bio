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
    
    @IBOutlet weak var signInButton: UIButton!
    
    
    @IBOutlet weak var cancelButton: UIButton!
    
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
        auth.signIn(withEmail: emailText.text!, password: passwordText.text!, completion: { result, error in
            if error == nil {
                if result?.user != nil {
                    self.performSegue(withIdentifier: "unwindFromSignIn", sender: nil)
                }
                
            }
            else {
                print("error during signin: \(error?.localizedDescription)")
                // make toast
            }
        })
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
       
            
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