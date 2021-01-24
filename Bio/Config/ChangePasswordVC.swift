//
//  ChangePasswordVC.swift
//  Bio
//
//  Created by Ann McDonough on 10/26/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import Firebase

class ChangePasswordVC: UIViewController {
    
    @IBOutlet weak var changePasswordButton: UIButton!
    
    
    @IBOutlet weak var confirmNewPasswordText: UITextField!
    @IBOutlet weak var newPasswordText: UITextField!
    @IBOutlet weak var currentPasswordText: UITextField!

    var navBarView = NavBarView()
    var backButton: UIButton?

    var userDataVM: UserDataVM?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavBarView()
        backButton = navBarView.backButton
        addBackTap()
        
        currentPasswordText.frame = CGRect(x: 20, y: view.frame.height / 3, width: view.frame.width - 40, height: 30)
        newPasswordText.frame = CGRect(x: 20, y: currentPasswordText.frame.maxY + 16, width: view.frame.width - 40, height: 30)
        confirmNewPasswordText.frame = CGRect(x: 20, y: newPasswordText.frame.maxY + 16, width: view.frame.width - 40, height: 30)
        
        currentPasswordText.textColor = .white
        newPasswordText.textColor = .white
        confirmNewPasswordText.textColor = .white
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.currentPasswordText.frame.height, width: self.currentPasswordText.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.systemGray4.cgColor
        self.currentPasswordText.borderStyle = UITextField.BorderStyle.none
        self.currentPasswordText.layer.addSublayer(bottomLine)
        
        let bottomLine2 = CALayer()
        bottomLine2.frame = CGRect(x: 0, y: self.newPasswordText.frame.height, width: self.newPasswordText.frame.width, height: 1.0)
        bottomLine2.backgroundColor = UIColor.systemGray4.cgColor
        self.newPasswordText.borderStyle = UITextField.BorderStyle.none
        self.newPasswordText.layer.addSublayer(bottomLine2)
        self.newPasswordText.clipsToBounds = false
        
        let bottomLine3 = CALayer()
        bottomLine3.frame = CGRect(x: 0, y: self.confirmNewPasswordText.frame.height, width: self.confirmNewPasswordText.frame.width, height: 1.0)
        bottomLine3.backgroundColor = UIColor.systemGray4.cgColor
        self.confirmNewPasswordText.borderStyle = UITextField.BorderStyle.none
        self.confirmNewPasswordText.layer.addSublayer(bottomLine3)
        self.confirmNewPasswordText.clipsToBounds = false
        
        currentPasswordText.attributedPlaceholder = NSAttributedString(string: "Current Password",
                                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray4, NSAttributedString.Key.font: UIFont(name: "Poppins-SemiBold", size: 16)])
        newPasswordText.attributedPlaceholder = NSAttributedString(string: "New Password",
                                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray4, NSAttributedString.Key.font: UIFont(name: "Poppins-SemiBold", size: 16)!])
        
        confirmNewPasswordText.attributedPlaceholder = NSAttributedString(string: "Confirm Password",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray4, NSAttributedString.Key.font: UIFont(name: "Poppins-SemiBold", size: 16)!])
        
        currentPasswordText.font = UIFont(name: "Poppins-SemiBold", size: 16)
        newPasswordText.font = UIFont(name: "Poppins-SemiBold", size: 16)
        confirmNewPasswordText.font = UIFont(name: "Poppins-SemiBold", size: 16)
        
        
        changePasswordButton.frame = CGRect(x: 20, y: confirmNewPasswordText.frame.maxY + 64, width: view.frame.width - 40, height: 45)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(changeTapped))
        changePasswordButton.addGestureRecognizer(tap)
        
    }
    
    
    @objc func changeTapped(_ sender: UITapGestureRecognizer) {
        let user = Auth.auth().currentUser
        if (user == nil) {
            let alert = UIAlertController(title: "Hmmm...", message: "Either you are not signed in or you are not connected to the internet.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true)
            self.clearInputs()
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: user!.email!, password: currentPasswordText.text!)
        user?.reauthenticate(with: credential, completion: { result, error in
            if (error != nil) {
                let alert = UIAlertController(title: "Incorrect password", message: "Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: {_ in
                    self.clearInputs()
                }))
                self.present(alert, animated: true, completion: nil)
            }
            else {
                if (self.newPasswordText.text != self.confirmNewPasswordText.text) {
                    let alert = UIAlertController(title: "Uh oh", message: "Looks like your new password don't match.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { _ in
                        self.clearInputs()
                    }))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                user?.updatePassword(to: self.newPasswordText.text!, completion: { error in
                    if (error != nil) {
                        let alert = UIAlertController(title: "Uh oh", message: "Something unexpected occurred. Please try again.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { _ in
                            self.clearInputs()
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                    else {
                        self.clearInputs()
                        self.dismiss(animated: true, completion: nil)
                    }
                })
                
            }
        })
    }
    
    func clearInputs() {
        newPasswordText.text = ""
        confirmNewPasswordText.text = ""
        currentPasswordText.text = ""
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setUpNavBarView() {
        self.view.addSubview(navBarView)
        self.navBarView.frame = CGRect(x: -5, y: -5, width: self.view.frame.width + 10, height: (self.view.frame.height/12)+5)
        self.navBarView.titleLabel.text = "Change Password"
        self.navBarView.addBehavior()
        self.navBarView.postButton.isHidden = true
        self.navBarView.isUserInteractionEnabled = false
        self.navBarView.clipsToBounds = true
        
    }
    
    func addBackTap() {
        backButton!.isUserInteractionEnabled = true
        backButton?.addTarget(self, action: #selector(ChangePasswordVC.backTapped), for: .touchUpInside)
    }
    
    @objc func backTapped(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
}
