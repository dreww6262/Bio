//
//  GoodBioSignInVC.swift
//  Bio
//
//  Created by Ann McDonough on 6/28/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit

class GoodBioSignInVC: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var mottoLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    @IBOutlet weak var signUpWithInstagramButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    
    @IBOutlet weak var popUpView: SignUpPopUpView!
    
    @IBOutlet weak var signUpLabel: UILabel!
    
    @IBOutlet weak var signUpMottoLabel: UILabel!
    
    @IBOutlet weak var facebookButton: UIButton!
    
    @IBOutlet weak var googleButton: UIButton!
    
    @IBOutlet weak var emailButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.addSubview(popUpView)

    }
    override func viewWillLayoutSubviews() {
        self.view.bringSubviewToFront(popUpView)
        popUpView.isUserInteractionEnabled = true
        popUpView.backgroundColor = UIColor.white
        popUpView.frame = CGRect(x: 0, y: self.view.frame.height-400, width: 400, height: 400)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //UIColor(white: <#T##CGFloat#>, alpha: <#T##CGFloat#>)
        
        //popUpView.isHidden = true
        label.frame = CGRect(x: 0, y: self.view.frame.height/4, width: self.view.frame.size.width, height: 300)
        mottoLabel.frame = CGRect(x: (self.view.frame.width-224)/2, y: (0.5)*(label.frame.maxY + label.frame.minY) + 20, width: 224, height: 50)
        signUpButton.frame = CGRect(x: (self.view.frame.width-224)/2 , y: self.view.frame.height*3/4, width: 224, height: 44)
        signInButton.frame = CGRect(x: (self.view.frame.size.width-224)/2, y: signUpButton.frame.maxY + 20, width: 224, height: 44)
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
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        popUpView.isHidden = false
       // expandSliderButton.isHidden = true
   //   let xPosition = view.frame.width - popUpView.frame.width
        let xPosition = 0.0
       //    let xPosition = navigatorSlider.frame.origin.x
        let yPosition = self.view.frame.height - 400  // Slide Up - 20px

           let width = popUpView.frame.size.width
           let height = popUpView.frame.size.height

           UIView.animate(withDuration: 1.0, animations: {
            self.popUpView.frame = CGRect(x: CGFloat(xPosition), y: yPosition, width: width, height: height)
           })
    }
    
    
    @IBAction func facebookPressed(_ sender: UIButton) {
        print("try to log in with facebook")
    }
    
    
    
    
}
