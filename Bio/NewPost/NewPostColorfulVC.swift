//
//  NewPostColorfulVC.swift
//  Bio
//
//  Created by Ann McDonough on 9/21/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import FMPhotoPicker
import YPImagePicker

//var backgroundBlue = UIColor(hex: "#194F87")
//var backgroundGray = UIColor(hex:  "#6B7885")
//var fontWhite = UIColor(hex: "#F8F3F3")
//var lightBlue = UIColor(hex: "#12D3D3")
//var lightPink = UIColor(hex: "#F691EA")


class NewPostColorfulVC: UIViewController { //, FMPhotoPickerViewControllerDelegate {
    var navBarView = NavBarView()
    var titleLabel1 = UILabel()
    var titleFontSize = CGFloat(20)
   var toSearchButton = UIButton()
    var toSettingsButton = UIButton()
    
    @IBOutlet weak var view1: UIView!
    
    @IBOutlet weak var view2: UIView!
    
    @IBOutlet weak var view3: UIView!
    
    @IBOutlet weak var view4: UIView!
    
    @IBOutlet weak var pic1: UIButton!
    
    @IBOutlet weak var pic2: UIButton!
    @IBOutlet weak var pic4: UIButton!
    
    @IBOutlet weak var pic3: UIButton!
    
    var view5 = UIView()
    var pic5 = UIButton()
    var l5 = UILabel()
    
    
    @IBOutlet weak var l1: UILabel!
    @IBOutlet weak var l2: UILabel!
    @IBOutlet weak var l3: UILabel!
    @IBOutlet weak var l4: UILabel!
    
    
    
    
    var customTabBar: TabNavigationMenu!
    
    let config = FMPhotoPickerConfig()
    
    var userDataVM: UserDataVM?
    
    let menuView = MenuView()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        addMenuButtons()
        setUpNavBarView()
//        addSearchButton()
//        addSettingsButton()
        
        let addPhotoTapped = UITapGestureRecognizer(target: self, action: #selector(tappedPhotoView))
        let addMusicTapped = UITapGestureRecognizer(target: self, action: #selector(tappedMusicView))
        let addLinkTapped = UITapGestureRecognizer(target: self, action: #selector(tappedlinkView))
        let addSocialMediaTapped = UITapGestureRecognizer(target: self, action: #selector(tappedSocialMediaView))
        
        view1.addGestureRecognizer(addPhotoTapped)
        view2.addGestureRecognizer(addSocialMediaTapped)
        view3.addGestureRecognizer(addLinkTapped)
        view4.addGestureRecognizer(addMusicTapped)
        
        pic1.isUserInteractionEnabled = false
        pic2.isUserInteractionEnabled = false
        pic3.isUserInteractionEnabled = false
        pic4.isUserInteractionEnabled = false
        l1.isUserInteractionEnabled = false
        l2.isUserInteractionEnabled = false
        l3.isUserInteractionEnabled = false
        l4.isUserInteractionEnabled = false
        
//        l1.addGestureRecognizer(addPhotoTapped)
//        l2.addGestureRecognizer(addSocialMediaTapped)
//        l3.addGestureRecognizer(addLinkTapped)
//        l4.addGestureRecognizer(addMusicTapped)
        
        
//        pic1.layer.cornerRadius = pic1.frame.size.width / 2
//        pic1.clipsToBounds = true
//
//        pic2.layer.cornerRadius = pic2.frame.size.width / 2
//        pic2.clipsToBounds = true
//
//        pic3.layer.cornerRadius = pic3.frame.size.width / 2
//        pic3.clipsToBounds = true
//
//        pic4.layer.cornerRadius = pic4.frame.size.width / 2
//        pic4.clipsToBounds = true
        
 formatPicturesAndLabelsFinal()
        
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        super.viewWillAppear(animated)
        menuView.tabController = (tabBarController! as! NavigationMenuBaseController)
        navigationController?.navigationBar.isHidden = true
    }
    @objc func toSettingsButtonClicked(_ recognizer: UITapGestureRecognizer) {
        let settingsVC = storyboard?.instantiateViewController(identifier: "settingsVC") as! ProfessionalSettingsVC
        settingsVC.userDataVM = userDataVM
        present(settingsVC, animated: false)
    }
    
    

    
    @objc func toSearchButtonClicked(_ recognizer: UITapGestureRecognizer) {
        let userTableVC = storyboard?.instantiateViewController(identifier: "userTableView") as! UserTableView
        userTableVC.userDataVM = userDataVM
        present(userTableVC, animated: false)
    }
    
    func addSearchButton() {
        self.view.addSubview(self.toSearchButton)
        toSearchButton.frame = CGRect(x: self.view.frame.width - (self.view.frame.height*(3/48)), y: (self.view.frame.height/48) + 2, width: self.view.frame.height/24, height: self.view.frame.height/24)
        // round ava
    //    toSearchButton.layer.cornerRadius = toSearchButton.frame.size.width / 2
        self.toSearchButton.clipsToBounds = true
        self.toSearchButton.isHidden = false
       // followView.isHidden = false
        self.toSettingsButton.isHidden = false
    }
    
    func setUpNavBarView() {
        var statusBarHeight = UIApplication.shared.statusBarFrame.height
//        print("This is status bar height \(statusBarHeight)")
        self.view.addSubview(navBarView)
        self.navBarView.frame = CGRect(x: -5, y: -5, width: self.view.frame.width + 10, height: (self.view.frame.height/12)+5)
        var navBarHeightRemaining = navBarView.frame.maxY - statusBarHeight
        navBarView.backButton.isHidden = true
        navBarView.postButton.isHidden = true
        self.navBarView.addSubview(toSettingsButton)
        self.navBarView.addSubview(toSearchButton)
        
        let settingsTap = UITapGestureRecognizer(target: self, action: #selector(self.toSettingsButtonClicked))
        settingsTap.numberOfTapsRequired = 1
        toSettingsButton.isUserInteractionEnabled = true
        toSettingsButton.addGestureRecognizer(settingsTap)
        
        let searchTap = UITapGestureRecognizer(target: self, action: #selector(self.toSearchButtonClicked))
        searchTap.numberOfTapsRequired = 1
        toSearchButton.isUserInteractionEnabled = true
        toSearchButton.addGestureRecognizer(searchTap)
        

        self.toSettingsButton.setImage(UIImage(named: "lightGrayGearFinal"), for: .normal)
        self.toSearchButton.setImage(UIImage(named: "lightGrayMagnifyingGlassFinal"), for: .normal)
     
       // self.toSettingsButton.frame = CGRect(x: 10, y: navBarView.frame.height - 30, width: 25, height: 25)
        self.toSettingsButton.frame = CGRect(x: 10, y: statusBarHeight + (navBarHeightRemaining - 25)/2, width: 25, height: 25)
        self.toSearchButton.frame = CGRect(x: navBarView.frame.width - 35, y: statusBarHeight + (navBarHeightRemaining - 25)/2, width: 25, height: 25)
        let yOffset = navBarView.frame.maxY
      //  self.navBarView.addSubview(titleLabel1)
        self.navBarView.addBehavior()
        self.navBarView.titleLabel.text = "Add Content"
      //  self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y: navBarView.frame.maxY - 30, width: 200, height: 30)
        self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y: self.toSearchButton.frame.minY, width: 200, height: 25)
//        print("This is navBarView.")
        self.toSettingsButton.setImage(UIImage(named: "lightGrayGearFinal"), for: .normal)
        self.toSearchButton.setImage(UIImage(named: "lightGrayMagnifyingGlassFinal"), for: .normal)


        //self.titleLabel1.text = "Notifications"
     //   self.navBarView.frame = CGRect(x: -5, y: -5, width: self.view.frame.width + 10, height: (self.view.frame.height/12)+5)
       // let yOffset = navBarView.frame.maxY
        

    }
    
    
  
    
    func addMenuButtons() {
        view.addSubview(menuView)
        menuView.currentTab = 4
        menuView.addBehavior()
    }
    
//    @IBAction func addPhotoPressed(_ sender: UIButton) {
//        var config = YPImagePickerConfiguration()
//        config.screens = [.library, .photo, .video]
//        config.library.mediaType = .photoAndVideo
//        config.library.maxNumberOfItems = 10
//        config.video.trimmerMaxDuration = 60.0
//        config.video.recordingTimeLimit = 60.0
//        config.video.automaticTrimToTrimmerMaxDuration = true
//        let picker = YPImagePicker(configuration: config)
//        picker.didFinishPicking { [unowned picker] items, cancelled in
//            picker.dismiss(animated: true, completion: nil)
//            if (items.count > 0) {
//                let uploadPreviewVC = self.storyboard?.instantiateViewController(identifier: "uploadPreviewVC") as! UploadPreviewVC
//                //print(photos)
//                uploadPreviewVC.userData = self.userData
//                uploadPreviewVC.items = items
//                self.present(uploadPreviewVC, animated: false, completion: nil)
//                uploadPreviewVC.modalPresentationStyle = .fullScreen
//            }
//        }
//        present(picker, animated: false)
//        modalPresentationStyle = .fullScreen
//    }
    
    
    

    @objc func tappedSocialMediaView(sender: UITapGestureRecognizer) {
        let addSocialMediaVC = storyboard?.instantiateViewController(identifier: "addSocialMediaTableView") as! AddSocialMediaTableView
        addSocialMediaVC.userDataVM = userDataVM
        //addSocialMediaVC.cancelLbl = "Cancel"
        //print("This is addSocialMedia.userData \(addSocialMediaVC.userData)")
       // print("2 This is userData from NewPostOptionsVC \(userData)")
        // addSocialMediaVC.publicID = userData?.publicID
        present(addSocialMediaVC, animated: false)
        modalPresentationStyle = .fullScreen
    }
    
    @objc func tappedlinkView(sender: UITapGestureRecognizer) {
        let linkVC = storyboard?.instantiateViewController(identifier: "linkVC") as! AddLinkVCViewController
        linkVC.userDataVM = userDataVM
        present(linkVC, animated: false)
        modalPresentationStyle = .fullScreen
    }
    
    @objc func tappedMusicView(sender: UITapGestureRecognizer) {
      //  print("add music pressed want to switch to social media ")
            let musicVC = storyboard?.instantiateViewController(identifier: "addMusicVC") as! AddMusicVC
            musicVC.userDataVM = userDataVM
            present(musicVC, animated: false)
            modalPresentationStyle = .fullScreen
    }
    
    @objc func tappedPhotoView(sender: UITapGestureRecognizer) {
        var config = YPImagePickerConfiguration()
        config.screens = [.library, .photo, .video]
        config.startOnScreen = .library
        config.library.mediaType = .photoAndVideo
        config.library.maxNumberOfItems = 10
        config.video.trimmerMaxDuration = 60.0
        config.video.recordingTimeLimit = 60.0
        config.video.automaticTrimToTrimmerMaxDuration = true
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, cancelled in
           
            if items.count == 1 {
                let onePostPreviewVC = self.storyboard?.instantiateViewController(identifier: "onePostPreview") as! OnePostPreview
                onePostPreviewVC.userDataVM = self.userDataVM
                onePostPreviewVC.items = items
                picker.present(onePostPreviewVC, animated: false, completion: nil)
                onePostPreviewVC.modalPresentationStyle = .fullScreen
            }
            
            
            else if (items.count > 0) {
                let uploadPreviewVC = self.storyboard?.instantiateViewController(identifier: "newUploadPreviewVC") as! NewUploadPreviewVC
                //print(photos)
                uploadPreviewVC.userDataVM = self.userDataVM
                uploadPreviewVC.items = items
                //picker.dismiss(animated: false, completion: nil)
                picker.present(uploadPreviewVC, animated: false, completion: nil)
                uploadPreviewVC.modalPresentationStyle = .fullScreen
            }
            else {
                picker.dismiss(animated: false, completion: nil)
            }
            
        }
        present(picker, animated: false)
        modalPresentationStyle = .fullScreen
    }
    
    
    
//
//    @IBAction func addSocialMediaPressed(_ sender: UIButton) {
//    print("add music pressed want to switch to social media ")
//        let musicVC = storyboard?.instantiateViewController(identifier: "addMusicVC") as! AddMusicVC
//        musicVC.userData = userData
//        present(musicVC, animated: false)
//        modalPresentationStyle = .fullScreen
//    }
//
    func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt(xDist * xDist + yDist * yDist))
    }
    
//    func formatPicturesAndLabelsFinal() {
//        view1.frame = CGRect(x: view.frame.width/24,y: self.view.frame.height/6, width: (self.view.frame.width/2) - (self.view.frame.width/12), height: (self.view.frame.height/2) - self.view.frame/12)
//
//    }
    

    
    
    func formatPicturesAndLabelsFinal() {
        var frame1 = CGRect(x: self.view.frame.width/24, y: (self.view.frame.height*(3/24)), width: (self.view.frame.width)*(5/12), height: self.view.frame.height*(1/3))
        view1.frame = frame1
      //  var frame2 = CGRect(
        var frame2 = CGRect(x: self.view.frame.width*(13/24), y: (self.view.frame.height*(3/24)), width: (self.view.frame.width)*(5/12), height: self.view.frame.height*(1/3))
        view2.frame = frame2
        
        var frame3 = CGRect(x: self.view.frame.width/24, y: self.view.frame.height*(12/24), width: (self.view.frame.width)*(5/12), height: self.view.frame.height*(1/3))
         view3.frame = frame3
        
        var frame4 = CGRect(x: self.view.frame.width*(13/24), y: self.view.frame.height*(12/24), width: (self.view.frame.width)*(5/12), height: self.view.frame.height*(1/3))
        view4.frame = frame4
        view1.addSubview(pic1)
        pic1.frame = CGRect(x: self.view1.frame.width*(3/16), y: self.view1.frame.height/12, width: self.view1.frame.width*(10/16), height: self.view1.frame.width/2)
        l1.frame =  CGRect(x: 0, y: self.pic1.frame.maxY + 10, width: self.view1.frame.width, height: 44)
        
        var piclabelHeight = l1.frame.maxY - pic1.frame.minY
        
        pic1.frame = CGRect(x: pic1.frame.minX, y: (frame1.height-piclabelHeight)/2, width: pic1.frame.width, height: pic1.frame.height)
        
        l1.frame = CGRect(x: l1.frame.minX, y: pic1.frame.maxY + 10, width: l1.frame.width, height: l1.frame.height)
        
        
        view2.addSubview(pic2)
        pic2.frame = CGRect(x: self.view2.frame.width/4, y: self.view2.frame.height/12, width: self.view2.frame.width/2, height: self.view2.frame.width/2)
        
        l2.frame =  CGRect(x: 0, y: self.pic2.frame.maxY + 10, width: self.view2.frame.width, height: 44)
        
        pic2.frame = CGRect(x: pic2.frame.minX, y: (frame1.height-piclabelHeight)/2, width: pic2.frame.width, height: pic2.frame.height)
        
        l2.frame = CGRect(x: l2.frame.minX, y: pic1.frame.maxY + 10, width: l2.frame.width, height: l2.frame.height)
        
        view3.addSubview(pic3)
        pic3.frame = CGRect(x: view3.frame.width/4, y: self.view3.frame.height/12, width: self.view3.frame.width/2, height: view3.frame.width/2)
        l3.frame =  CGRect(x: 0, y: self.pic3.frame.maxY + 10, width: self.view3.frame.width, height: 44)
        
        pic3.frame = CGRect(x: pic3.frame.minX, y: (frame1.height-piclabelHeight)/2, width: pic3.frame.width, height: pic3.frame.height)
        
        l3.frame = CGRect(x: l3.frame.minX, y: pic3.frame.maxY + 10, width: l3.frame.width, height: l3.frame.height)
        
        
        view4.addSubview(pic4)
        pic4.frame = CGRect(x: view4.frame.width/4, y: view4.frame.height/12, width: view4.frame.width/2, height: view4.frame.width/2)
        l4.frame =  CGRect(x: 0, y: self.pic4.frame.maxY + 10, width: self.view4.frame.width, height: 44)
        
        pic4.frame = CGRect(x: pic4.frame.minX, y: (frame4.height-piclabelHeight)/2, width: pic4.frame.width, height: pic4.frame.height)
        
        l4.frame = CGRect(x: l4.frame.minX, y: pic4.frame.maxY + 10, width: l4.frame.width, height: l4.frame.height)
        
        //rounded views
        view1.layer.cornerRadius = 25.0
        view2.layer.cornerRadius = 25.0
        view3.layer.cornerRadius = 25.0
        view4.layer.cornerRadius = 25.0
        
        view5.isHidden = true
        view.addSubview(view5)
       
        view5.backgroundColor = .white
        view5.frame = CGRect(x: (view.frame.width - view4.frame.width)/2, y: (view.frame.height - view4.frame.width)/2, width: view4.frame.width, height: view4.frame.height)
        view5.layer.cornerRadius = view5.frame.width/2
        pic5.frame = CGRect(x: view4.frame.width/4, y: view4.frame.height/12, width: view4.frame.width/2, height: view4.frame.width/2)
        l5.frame =  CGRect(x: 0, y: self.pic4.frame.maxY + 10, width: self.view4.frame.width, height: 44)
        l5.text = "Person Details"
        l5.textColor = .black
        
      
        
    }
    
    
    
    
    
    func formatPicturesAndLabels(){
        view1.frame = CGRect(x: (self.view.frame.width/12), y: (self.view.frame.height/3) - (self.view.frame.width/6) - 20 , width: self.view.frame.width/3, height: self.view.frame.width/3)
        //titleLabel.frame = CGRect(x: 0, y: 10.0, width: self.view.frame.width, height: 66.0)
        
        pic1.frame = view1.frame
//        pic1.frame = CGRect(x: (self.view.frame.width/12), y: (self.view.frame.height/3) - (self.view.frame.width/6) - 20 , width: self.view.frame.width/3, height: self.view.frame.width/3)
        
        l1.frame = CGRect(x: self.view.frame.width/12, y: pic1.frame.maxY + 30.0, width: self.view.frame.width/3, height: 33.0)
        l1.text = "Add Photos/Videos"
        l2.text = "Add Music"
        l3.text = "Add Link"
        l4.text = "Add Social Media"
        l1.textColor = UIColor.black
        l2.textColor = UIColor.black
        l3.textColor = UIColor.black
        l4.textColor = UIColor.black
        
        view2.frame = CGRect(x: (self.view.frame.width*7/12), y: (self.view.frame.height/3) - (self.view.frame.width/6)-20, width: self.view.frame.width/3, height: self.view.frame.width/3)
       
        pic2.frame = view2.frame
      //  pic2.frame = CGRect(x: (self.view.frame.width*7/12), y: (self.view.frame.height/3) - (self.view.frame.width/6)-20, width: self.view.frame.width/3, height: self.view.frame.width/3)
        l2.frame = CGRect(x: (self.view.frame.width*7/12), y: pic1.frame.maxY + 30.0, width: self.view.frame.width/3, height: 33.0)
        
        view3.frame = CGRect(x: self.view.frame.width/12, y: (self.view.frame.height*2/3) - (self.view.frame.width/6) - 20, width: self.view.frame.width/3, height: self.view.frame.width/3)
        
        pic3.frame = view3.frame
       // pic3.frame = CGRect(x: self.view.frame.width/12, y: (self.view.frame.height*2/3) - (self.view.frame.width/6) - 20, width: self.view.frame.width/3, height: self.view.frame.width/3)
        
        view4.frame = CGRect(x: (self.view.frame.width*7/12), y: (self.view.frame.height*2/3) - (self.view.frame.width/6) - 20, width: self.view.frame.width/3, height: self.view.frame.width/3)
        
        pic4.frame = view4.frame
       // pic4.frame = CGRect(x: (self.view.frame.width*7/12), y: (self.view.frame.height*2/3) - (self.view.frame.width/6) - 20, width: self.view.frame.width/3, height: self.view.frame.width/3)
        
        l3.frame = CGRect(x: self.view.frame.width/12, y: pic3.frame.maxY + 30.0, width: self.view.frame.width/3, height: 33.0)
        
        l4.frame = CGRect(x: self.view.frame.width*7/12, y: pic4.frame.maxY + 30.0, width: self.view.frame.width/3, height: 33.0)
        

        
    }
}
extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
