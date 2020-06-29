//
//  GoodBioSignInVC.swift
//  Bio
//
//  Created by Ann McDonough on 6/28/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import FBSDKLoginKit
 import FBSDKCoreKit
import Parse
//import PopupDialog

class GoodBioSignInVC: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var mottoLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    @IBOutlet weak var signUpWithInstagramButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var testButton: UIButton!
    
    @IBOutlet weak var popUpView: SignUpPopUpView!
    
    @IBOutlet weak var signUpLabel: UILabel!
    
    @IBOutlet weak var signUpMottoLabel: UILabel!
    
    @IBOutlet weak var facebookButton: UIButton!
    
    @IBOutlet weak var googleButton: UIButton!
    
    @IBOutlet weak var emailButton: UIButton!
    
    private var loginButton: FBLoginButton!
    
    var fullnameFB = String()
     var idFB = String()
     var emailFB = String()
     var isFBSignUp = Bool()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
   //     self.view.addSubview(popUpView)

    }
    override func viewWillLayoutSubviews() {
//        self.view.bringSubviewToFront(popUpView)
     //   popUpView.isUserInteractionEnabled = true
     //   popUpView.backgroundColor = UIColor.white
      //  popUpView.frame = CGRect(x: 0, y: self.view.frame.height-400, width: 400, height: 400)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton = FBLoginButton()
       // loginButton.center = signUpButton.frame.or signInButton.center +
        self.view.addSubview(loginButton)
        //check if user logged in
        if let token = AccessToken.current,
            !token.isExpired {
            // User is logged in, do work such as go to next view controller.
            print("user is logged in with token \(token)")
        } else {
            print("user is expired")
        }
        loginButton.permissions = ["public_profile", "email"]
        
        //UIColor(white: <#T##CGFloat#>, alpha: <#T##CGFloat#>)
        
        //popUpView.isHidden = true
        label.frame = CGRect(x: 0, y: self.view.frame.height/4, width: self.view.frame.size.width, height: 300)
        testButton.frame = CGRect(x: (self.view.frame.width-224)/2, y: (0.5)*(label.frame.maxY + label.frame.minY) - 60, width: 224, height: 50)
        mottoLabel.frame = CGRect(x: (self.view.frame.width-224)/2, y: (0.5)*(label.frame.maxY + label.frame.minY) + 20, width: 224, height: 50)
        signUpButton.frame = CGRect(x: (self.view.frame.width-224)/2 , y: self.view.frame.height*3/4, width: 224, height: 44)
        signInButton.frame = CGRect(x: (self.view.frame.size.width-224)/2, y: signUpButton.frame.maxY + 20, width: 224, height: 44)
            loginButton.frame = CGRect(x: (self.view.frame.size.width-224)/2, y: signInButton.frame.maxY + 20, width: 224, height: 44)
        
     //   popUpView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        
        
//         usernameTxt.frame = CGRect(x: 10, y: label.frame.origin.y + 70, width: self.view.frame.size.width - 20, height: 30)
//         passwordTxt.frame = CGRect(x: 10, y: usernameTxt.frame.origin.y + 40, width: self.view.frame.size.width - 20, height: 30)
//
//
//         signUpWithInstagramButton.frame = CGRect(x: 20, y: passwordTxt.frame.origin.y + 40, width: self.view.frame.size.width / 4, height: 30)
//         signUpWithInstagramButton.layer.cornerRadius = signUpWithInstagramButton.frame.size.width / 20
//
//         moreOpportunitiesButton.frame = CGRect(x: self.view.frame.size.width - self.view.frame.size.width / 4 - 20, y: signUpWithInstagramButton.frame.origin.y, width: self.view.frame.size.width / 4, height: 30)
//         moreOpportunitiesButton.layer.cornerRadius = moreOpportunitiesButton.frame.size.width / 20
         
         // tap to hide keyboard
         let hideTap = UITapGestureRecognizer(target: self, action: #selector(GoodBioSignInVC.hideKeyboard(_:)))
         hideTap.numberOfTapsRequired = 1
         self.view.isUserInteractionEnabled = true
         self.view.addGestureRecognizer(hideTap)
         
        
    }
    
    // hide keyboard func
       @objc func hideKeyboard(_ recognizer : UITapGestureRecognizer) {
           self.view.endEditing(true)
       }
    
    func showCustomDialog(animated: Bool = true) {

        // Create a custom view controller
        let ratingVC = RatingViewController(nibName: "RatingViewController", bundle: nil)

        // Create the dialog
        let popup = PopupDialog(viewController: ratingVC,
                                buttonAlignment: .horizontal,
                                transitionStyle: .bounceDown,
                                tapGestureDismissal: true,
                                panGestureDismissal: false)
        
        // Create first button
        let buttonOne = CancelButton(title: "CANCEL", height: 60) {
            self.label.text = "You canceled the rating dialog"
        }

        // Create second button
        let buttonTwo = DefaultButton(title: "RATE", height: 60) {
            self.label.text = "You rated \(ratingVC.cosmosStarRating.rating) stars"
        }

        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])

        // Present dialog
        present(popup, animated: animated, completion: nil)
    }
    
    
    
    
//
//    func openPopUp2() {
//        let popupVC = DummyVCForPopUp(contentController: DummyVCForPopUp(), position: .bottom(20), popupWidth: 200, popupHeight: 300)
//             popupVC.backgroundAlpha = 0.3
//             popupVC.backgroundColor = .black
//             popupVC.canTapOutsideToDismiss = true
//             popupVC.cornerRadius = 10
//             popupVC.shadowEnabled = true
//             present(popupVC, animated: true, completion: nil)
//    }
    
    
    
    
//    func openPopUp() {
//        var helpView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DummyVCForPopUp") as? DummyVCForPopUp
//        helpView?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//        let window = UIApplication.shared.keyWindow
//       // let window = UIApplication.shared.wind
//        helpView!.view.backgroundColor = UIColor.white
//        helpView!.view!.frame = (window!.frame)
//        window!.addSubview(helpView!.view)
//        window?.rootViewController?.addChild(helpView!)
//        helpView!.didMove(toParent: self)
//    }
    
    
    
    
    
    
    func popUpViewNow() {
         popUpView.isHidden = false
            popUpView.backgroundColor = .white
        //    popUpView.frame.height
          //  popUpView.backgroundColor?.cgColor =
      //  self.addChild(<#T##childController: UIViewController##UIViewController#>)
        
            popUpView.backgroundColor = .white
            popUpView.frame.origin.y = self.view.frame.height - popUpView.frame.height
            print(popUpView.frame.height)
        popUpView.isUserInteractionEnabled = true 
        print(popUpView.backgroundColor)
            print("sign up pressed")
    }
    
    
//    @IBAction func zoomIn(button: UIButton) {
//    print("I'm in zoomIn function")
//   // let popUpVC = AnimationCurvePickerViewController(style: .grouped)
//      // popUpVC.delegate = self
//        let popUpVC = DummyVCForPopUp()
//        popUpVC.view.bounds = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
//       popUpVC.view.center = view.center
//       
//       addChild(popUpVC)
//        view.addSubview(popUpVC.view)
//      // view.addSubviewWithZoomInAnimation(popUpVC.view, duration: 1.0, options: selectedCurve.animationOption)
//       popUpVC.didMove(toParent: self)
//     }
    
    // this had an error but can be tweaked i think 🎯🎯🎯🎯
//    func loginButton(_ loginButton: FBLoginButton!, didCompleteWith result: LoginManagerLoginResult!, error: Error!) {
//        if error != nil { //if theres an error
//            print(error)
//        } else if result.isCancelled { // if user cancels the sign up request
//            print("user cancelled login")
//        } else {
//            PFFacebookUtils.logInInBackground(with: result!.token!) { (user, error) in
//                if error == nil {
//
//                if let user = user {
//
//                    if user.isNew {
//                        print("User signed up and logged in through Facebook!")
//                    } else {
//                        print("User logged in through Facebook!")
//                    }
//
//                    if result.grantedPermissions.contains("email") {
//                      //  if let graphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "email, name"]) {
//                            if let graphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "email, name"]) {
//
//                            graphRequest.start(completionHandler: { (connection, result, error) in
//                                if error != nil {
//                                    print(error?.localizedDescription ?? String())
//                                } else {
//                                    if let userDetails = result as? [String: String]{
//                                        print(userDetails)
//                                        self.fullnameFB = userDetails["name"]!
//                                        self.idFB = userDetails["id"]!
//                                        self.emailFB = userDetails["email"]!
//                                        self.isFBSignUp = true
//                                    }
//                                }
//                            })
//                        }
//                    } else {
//                        print("didnt get email")
//                        let alert = UIAlertController(title: "Facebook Sign Up", message: "To signup with Facebook, we need your email address", preferredStyle: UIAlertController.Style.alert)
//                        let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
//                        alert.addAction(ok)
//                        self.present(alert, animated: true, completion: nil)
//                    }
//
//                } else {
//                    print("Error while trying to login using Facebook: \(error?.localizedDescription ?? "---")")
//                }
//                } else {
//                    print(error?.localizedDescription ?? String())
//                }
//            }
//        }
//    }
    
    
    
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        PFFacebookUtils.logInInBackground(withReadPermissions: loginButton.permissions) {
         (user: PFUser?, error: Error?) in
         //   self.performSegue(withIdentifier: "toHexagonGrid", sender: UIButton?.self)
            
         if let user = user {
             if user.isNew {
                print("This is access token \(AccessToken.current?.userID)")
                
                
                
                
                
                
                
                
               // user.email = PFFacebookUtils.
                //user.email
             print("User signed up and logged in through Facebook!")
                    
//                    // send data to server to related collumns
//                //    let user = PFUser()
//                    user.username = usernameTxt.text?.lowercased()
//                    user.email = emailTxt.text?.lowercased()
//                    user.password = passwordTxt.text
//                    user["fullname"] = fullnameTxt.text?.lowercased()
//                    user["bio"] = bioTxt.text
//                    user["web"] = webTxt.text?.lowercased()
//
//                    // in Edit Profile it's gonna be assigned
//                    user["tel"] = ""
//                    user["gender"] = ""
//
//                    // convert our image for sending to server
//                    let avaData = avaImg.image!.jpegData(compressionQuality: 0.5)
//                    let avaFile = PFFile(name: "ava.jpg", data: avaData!)
//                    user["ava"] = avaFile
//
//                    // save data in server
//                    user.signUpInBackground { (success, error) -> Void in
//                        if success {
//                            print("registered")
//
//                            // remember looged user
//                            UserDefaults.standard.set(user.username, forKey: "username")
//                            UserDefaults.standard.synchronize()
//
//                            // call login func from AppDelegate.swift class
//            //                let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
//            //                appDelegate.login()
//                                //      let sceneDelegate : SceneDelegate = UIApplication.shared.delegate as! SceneDelegate
//                            let sceneDelegate = UIApplication.shared.connectedScenes
//                                  .first!.delegate as! SceneDelegate
//                            sceneDelegate.login()
//
//                        } else {
//
//                            // show alert message
//                            let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: UIAlertController.Style.alert)
//                            let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
//                            alert.addAction(ok)
//                            self.present(alert, animated: true, completion: nil)
//                        }
//                   }
//
//
//
//             // end of if user.isNew {}
      } else {
          print("User logged in through Facebook!")
        
            }
    //else {
     //        print("Uh oh. The user cancelled the Facebook login.")
     //    }
         }

        
    //    popUpView.isHidden = false
       // expandSliderButton.isHidden = true
   //   let xPosition = view.frame.width - popUpView.frame.width
        let xPosition = 0.0
       //    let xPosition = navigatorSlider.frame.origin.x
        let yPosition = self.view.frame.height - 400  // Slide Up - 20px

        //   let width = popUpView.frame.size.width
        //   let height = popUpView.frame.size.height

//           UIView.animate(withDuration: 1.0, animations: {
//            self.popUpView.frame = CGRect(x: CGFloat(xPosition), y: yPosition, width: width, height: height)
//           })
    }
        
    }
    
    
    @IBAction func facebookPressed(_ sender: UIButton) {
        print("try to log in with facebook")
    }
    
    
    
    
}
