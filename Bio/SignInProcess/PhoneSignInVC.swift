//
//  PhoneSignInVC.swift
//  Bio
//
//  Created by Ann McDonough on 7/16/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//


import UIKit
//import FBSDKLoginKit
//import FBSDKCoreKit
//import Parse
import Firebase
import FirebaseAuth
//import PopupDialog

class PhoneSignInVC: UIViewController {
    @IBOutlet weak var mottoLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var signIn: UIButton!
    
    @IBOutlet weak var logo: UIImageView!
    //@IBOutlet weak var popUpView: SignUpPopUpView!
    
    @IBOutlet weak var signUpLabel: UILabel!
    
    @IBOutlet weak var signUpMottoLabel: UILabel!
    var userDataVM: UserDataVM?
    
    //private var loginButton: FBLoginButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        //    view.backgroundColor = backgroundBlue
        //  setGradientBackground()
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        //     self.view.addSubview(popUpView)
        
    }
    override func viewWillLayoutSubviews() {
        //        self.view.bringSubviewToFront(popUpView)
        //   popUpView.isUserInteractionEnabled = true
        //   popUpView.backgroundColor = UIColor.white
        //  popUpView.frame = CGRect(x: 0, y: self.view.frame.height-400, width: 400, height: 400)
    }
    
    
    var blurEffectView: UIView?
    var loadingIndicator: UIViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.setTitle("Create an OSI Account", for: .normal)
        userDataVM = UserDataVM()
        if let email = Auth.auth().currentUser?.email {
            loadingIndicator = storyboard?.instantiateViewController(withIdentifier: "loading")
            
            blurEffectView = UIView(frame: view.bounds)
            blurEffectView!.autoresizingMask = [
                .flexibleWidth, .flexibleHeight
            ]
            blurEffectView!.backgroundColor = .black
            view.addSubview(blurEffectView!)
            
            addChild(loadingIndicator!)
            view.addSubview(loadingIndicator!.view)
            userDataVM?.retreiveUserData(email: email, completion: {
                let tabVC = self.storyboard?.instantiateViewController(identifier: "tabController") as! NavigationMenuBaseController
                tabVC.userDataVM = self.userDataVM
                self.modalPresentationStyle = .fullScreen
                tabVC.modalPresentationStyle = .fullScreen
                DispatchQueue.global().async {
                    DispatchQueue.main.sync {
                        self.present(tabVC, animated: false, completion: nil)
                    }
                }
            })
            
        }
        
        formatLogo()
        formatLabelAndButtons()
        
        signUpButton.layer.borderColor = white.cgColor
        signUpButton.layer.borderWidth = 1.0
        signUpButton.layer.cornerRadius = signUpButton.frame.size.width / 20
        signIn.layer.cornerRadius = signIn.frame.size.width / 20
        
        //    logo.pulse(withIntensity: 1.2, withDuration: ,loop: true)
        
        signUpButton.layer.cornerRadius = signUpButton.layer.frame.width / 20
        
        // tap to hide keyboard
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        blurEffectView?.removeFromSuperview()
        loadingIndicator?.view.removeFromSuperview()
        loadingIndicator?.removeFromParent()
        blurEffectView = nil
        loadingIndicator = nil
    }
    
    func formatLogo() {
        let screenWidth = self.view.frame.width
        let screenHeight = self.view.frame.height
        self.logo.frame = CGRect(x: screenWidth/32, y: screenHeight/9, width: screenWidth*(30/32), height: screenWidth*(30/32))
        self.logo.setupHexagonMask(lineWidth: self.logo.frame.width/15, color: myCoolBlue, cornerRadius: self.logo.frame.width/15)
    }
    
    func formatLabelAndButtons() {
        let screenWidth = self.view.frame.width
        let screenHeight = self.view.frame.height
        let logoFrame = logo.frame
        let logoMaxY = logo.frame.maxY
        let heightRemaining = screenHeight - logoFrame.maxY
        //mottoLabel.frame = CGRect(x: <#T##CGFloat#>, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
        let heightOf3ThingsAndSpacing = CGFloat(178)
        var spaceBelowLogo = (heightRemaining - heightOf3ThingsAndSpacing)/3
        
        mottoLabel.frame = CGRect(x: 0, y: logoMaxY + spaceBelowLogo , width: screenWidth, height: 50)
        
        
        signUpButton.frame = CGRect(x: (self.view.frame.width-224)/2 , y: mottoLabel.frame.maxY + 20, width: 224, height: 44)
        signUpButton.layer.borderColor = UIColor.white.cgColor
        signIn.frame = CGRect(x: (self.view.frame.size.width-224)/2, y: signUpButton.frame.maxY + 20, width: 224, height: 44)
        //   mottoLabel.frame = CGRect(x: 0, y: signUpButton.frame.minY - 60, width: self.view.frame.size.width, height: 50)
        mottoLabel.text = "One Social Internet"
        
        
        
    }
    
    
    @IBAction func signInPressed(_ sender: UIButton) {
        let signInVC = storyboard?.instantiateViewController(identifier: "signInVC") as! SignInVC
        signInVC.userDataVM = userDataVM
        self.present(signInVC, animated: false)
        signInVC.modalPresentationStyle = .fullScreen
    }
    
    @IBAction func createAccountPressed(_ sender: UIButton) {
        let signUpVC = storyboard?.instantiateViewController(identifier: "signUpID") as! GoodBioSignUpVC
        signUpVC.userDataVM = userDataVM
        self.present(signUpVC, animated: false)
        signUpVC.modalPresentationStyle = .fullScreen
    }
    
    
    
    @IBAction func unvindSegueToMenu(segue:UIStoryboardSegue) {
        //        let tabBar = self.tabBarController! as! NavigationMenuBaseController
        //
        //        for vc in tabBar.viewControllers! {
        //            vc.viewDidLoad()
        //        }
        //
        //        let homeHexGrid = (tabBar.viewControllers![2] as! HomeHexagonGrid)
        //        //homeHexGrid.userDataVM = userDataVM
        //        tabBar.viewControllers![2] = homeHexGrid
        //        tabBar.customTabBar.switchTab(from: 5, to: 2) // to home controller
        
        let tabVC = storyboard?.instantiateViewController(identifier: "tabController") as! NavigationMenuBaseController
        tabVC.userDataVM = userDataVM
        tabVC.modalPresentationStyle = .fullScreen
        modalPresentationStyle = .fullScreen
        DispatchQueue.global().async {
            DispatchQueue.main.sync {
                self.present(tabVC, animated: false, completion: nil)
            }
        }
        
        
        
    }
    
    
    var _user: User?
    func fakeUserSignIn() {
        //  let phoneNumber = "+17817333496"
        let phoneNumber = "+16177807235"
        // This test verification code is specified for the given test phone number in the developer console.
        //let testVerificationCode = "123456"
        let testVerificationCode = "654321"
        PhoneAuthProvider.provider(auth: Auth.auth())
        Auth.auth().settings!.isAppVerificationDisabledForTesting = true
        print("Phone auth provider() \(PhoneAuthProvider.provider())")
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) {
            verificationID, error in
            if ((error) != nil) {
                print ("Big Yikes, error in verify phone number")
                print(error as Any)
                return
            }
            
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID!,
                                                                     verificationCode: testVerificationCode)
            
            Auth.auth().signIn(with: credential, completion: { authData, error in
                if ((error) != nil) {
                    print("Big Yikes, error in signInAndRetrieveData")
                    // Handles error
                    print(error as Any)
                    return
                }
                self._user = authData!.user
            })
        }
    }
    
    // hide keyboard func
    @objc func hideKeyboard(_ recognizer : UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}
