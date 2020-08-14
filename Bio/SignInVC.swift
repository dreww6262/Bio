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
    
    let auth = Auth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
