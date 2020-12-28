//
//  ContentPhoneVC.swift
//  Bio
//
//  Created by Ann McDonough on 12/16/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//
import UIKit
import Firebase
class ContentPhoneVC: UIViewController, UIScrollViewDelegate {
    
    var birthdayHex: HexagonStructData?
    var showOpenAppButton = false
    var scrollView = UIScrollView()
    var newImageView = UIImageView()
    var currentPostingUserID = ""
    var userDataVM: UserDataVM?
    let db = Firestore.firestore()
   // var captionTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setUpScrollView()
        setZoomScale()
        scrollView.addSubview(newImageView)
        
        
        newImageView = UIImageView(image: UIImage(named: "kbit"))
//        let cleanRef = birthdayHex!.thumbResource.replacingOccurrences(of: "/", with: "%2F")
//        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/bio-social-media.appspot.com/o/\(cleanRef)?alt=media")
//        newImageView!.sd_setImage(with: url!, completed: {_, error, _, _ in
//            if error != nil {
//                print(error!.localizedDescription)
//            }
//        })
        newImageView.image = UIImage(named: "smartphone")
        newImageView.backgroundColor = .white
        newImageView.layer.borderWidth = 5.0
        newImageView.layer.borderColor = white.cgColor
        scrollView.addSubview(newImageView)
        scrollView.bringSubviewToFront(newImageView)
        
       // let frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 65)
        let frame = CGRect(x: view.frame.width/6, y: view.frame.height/12, width: view.frame.width*(2/3), height: view.frame.width*(2/3))
        let birthdayFrame = CGRect(x: 0, y: frame.maxY + 5, width: view.frame.width, height: 20)
        let ageFrame = CGRect(x: 0, y: birthdayFrame.maxY + 5, width: view.frame.width, height: 20)
        let zodiacFrame = CGRect(x: 0, y: ageFrame.maxY + 5, width: view.frame.width, height: 20)
//        captionTextField.font = UIFont(name: "DINAlternate-Bold", size: 28)
//        captionTextField.textAlignment = .center
//        captionTextField.isUserInteractionEnabled = false
        newImageView.frame = frame
        newImageView.layer.cornerRadius = (frame.width)/2
        //newImageView.backgroundColor = .black
        
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        setUpCaption()
        //let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        //newImageView.addGestureRecognizer(tap)
        
        let textView = UITextView()
        textView.text = "asdfkjlasdfjasdf"
        textView.textColor = .red
        // Do any additional setup after loading the view.
        
      //  captionTextField.frame = captionFrame
        
    }
    
    
    func setUpCaption() {
        var birthdayLabel = UILabel()
        var ageLabel = UILabel()
        var zodiacLabel = UILabel()
        var requestButton = UIButton()
        requestButton.tag = 0
        let requestTap = UITapGestureRecognizer(target: self, action: #selector(requestPhoneNumberPressed))
        requestButton.isUserInteractionEnabled = true
        requestButton.addGestureRecognizer(requestTap)
        birthdayLabel.isHidden = true
        ageLabel.isHidden = true
        zodiacLabel.isHidden = true
        scrollView.addSubview(birthdayLabel)
        scrollView.addSubview(ageLabel)
        scrollView.addSubview(zodiacLabel)
        scrollView.addSubview(requestButton)
        requestButton.setTitle("Request Phone Number", for: .normal)
        requestButton.backgroundColor = myCoolBlue
        requestButton.setTitleColor(.white, for: .normal)
  
        var birthdayText = "Birthday: \(birthdayHex!.resource)"
        var zodiacText = "Zodiac: \(birthdayHex!.text)"
        birthdayLabel.text = birthdayText
      //  var theAge = calcAge(birthday: birthdayHex!.resource)
       // ageLabel.text = "Age: \(theAge) years old"
        zodiacLabel.text = zodiacText
        let captionFrame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 66)
        birthdayLabel.font = UIFont(name: "DINAlternate-Bold", size: 28)
        zodiacLabel.font = UIFont(name: "DINAlternate-Bold", size: 28)
        ageLabel.font = UIFont(name: "DINAlternate-Bold", size: 28)
        requestButton.titleLabel?.font = UIFont(name: "DINAlternate-Bold", size: 20)
        let frame = CGRect(x: view.frame.width/3, y: view.frame.height/12, width: view.frame.width/3, height: view.frame.width/3)
        let birthdayFrame = CGRect(x: 0, y: (newImageView.frame.maxY) + 20, width: view.frame.width, height: 30)
        let ageFrame = CGRect(x: view.frame.width/8, y: birthdayFrame.maxY + 10, width: view.frame.width*(6/8), height: 50)
        let zodiacFrame = CGRect(x: view.frame.width/8, y: ageFrame.maxY + 10, width: view.frame.width*(6/8), height: 50)
        requestButton.frame = ageFrame
        requestButton.layer.cornerRadius = requestButton.frame.width/20
        birthdayLabel.frame = birthdayFrame
        ageLabel.frame = ageFrame
        zodiacLabel.frame = zodiacFrame
        birthdayLabel.textColor = .white
        ageLabel.textColor = .white
        zodiacLabel.textColor = .white
        birthdayLabel.textAlignment = .center
        ageLabel.textAlignment = .center
        zodiacLabel.textAlignment = .center
        
        
        
        birthdayLabel.textAlignment = .center
        birthdayLabel.isUserInteractionEnabled = false
        print("This is caption text \(birthdayText)")
        print("This is text field text \(birthdayLabel.text)")
        birthdayLabel.textColor = .white
     //   birthdayLabel.frame = captionFrame
    //    captionTextField.size
        
        print()
    }
    
    // viewdidload helper functions
    func setUpScrollView() {
        view.addSubview(scrollView)
        scrollView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 65)
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.backgroundColor = .black
        //scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.contentMode = .scaleAspectFit
        scrollView.bouncesZoom = false
        
    }
    
    @objc func requestPhoneNumberPressed(_ sender: UITapGestureRecognizer) {
            //let width = UIScreen.main.bounds.width//
        print("trying to request phone number")
        let vc = self
        let button = sender.view as! UIButton
        let displayName = vc.birthdayHex!.resource
            let userData = userDataVM?.userData.value
        print("This is userData \(userData) and tag \(button.tag)")
            if userData != nil {
                if button.tag == 0 {
                    let newRequest = ["requester": currentPostingUserID, "requesting": birthdayHex?.postingUserID]
                    db.collection("PhoneNumberRequests").addDocument(data: newRequest as [String : Any])
                    UIDevice.vibrate()
                    button.setTitle("Requested \(displayName)'s Phone Number", for: .normal)
    //                button?.imageView?.image = UIImage(named: "checkmark32x32")
    //                sender.imageView?.image = UIImage(named: "checkmark32x32")
                    button.tag = 1
                    print("This is newRequest \(newRequest)")
                    
                    let notificationObjectref = db.collection("News2")
                       let notificationDoc = notificationObjectref.document()
                    let notificationObject = NewsObject(ava: "userFiles/\(currentPostingUserID)/\(currentPostingUserID)_avatar.png", type: "requestPhoneNumber", currentUser: currentPostingUserID, notifyingUser: birthdayHex!.postingUserID, thumbResource: "userFiles/\(currentPostingUserID)/\(currentPostingUserID)_avatar.png", createdAt: NSDate.now.description, checked: false, notificationID: notificationDoc.documentID)
                       notificationDoc.setData(notificationObject.dictionary){ error in
                           //     group.leave()
                           if error == nil {
                               print("added notification: \(notificationObject)")
                               
                           }
                           else {
                               print("failed to add notification \(notificationObject)")
                               
                           }
                       }
                    
                }
            }
    
    }
    
    func setZoomScale() {

        scrollView.maximumZoomScale = 60
        scrollView.minimumZoomScale = 1
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageViewSize = newImageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height)/2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width)/2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return newImageView
    }
    
//    @objc func handleTap(_ sender: UITapGestureRecognizer) {
//        for view in view.subviews {
//            view.removeFromSuperview()
//        }
//        self.dismiss(animated: false, completion: nil)
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

