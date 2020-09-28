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

    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    let auth = Auth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.layer.cornerRadius = signInButton.frame.width/20
        // Do any additional setup after loading the view.
       var rect1 = signInButton.frame
        signInButton.frame = CGRect(x: rect1.minX, y: rect1.minY, width: rect1.width, height: rect1
                                        .height*(5/4))
    }
    
 func formatStuff() {
    emailText.frame = CGRect(x: self.view.frame.width/2 - 50, y: self.view.frame.height-66, width: 100, height: 44)
    passwordText.frame = CGRect(x: emailText.frame.minX, y: emailText.frame.maxY + 10, width: 100, height: 44)
    signInButton.frame = CGRect(x: passwordText.frame.minX, y: passwordText.frame.maxY + 10, width: 100, height: 66)
    cancelButton.frame = CGRect(x: signInButton.frame.minX, y: signInButton.frame.maxY + 10, width: 100, height: 44)
    signInButton.layer.cornerRadius = signInButton.frame.width/20
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
