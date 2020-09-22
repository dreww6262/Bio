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
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var view1: UIView!
    
    @IBOutlet weak var view2: UIView!
    
    @IBOutlet weak var view3: UIView!
    
    @IBOutlet weak var view4: UIView!
    
    @IBOutlet weak var pic1: UIButton!
    
    @IBOutlet weak var pic2: UIButton!
    @IBOutlet weak var pic4: UIButton!
    
    @IBOutlet weak var pic3: UIButton!
    
    
    @IBOutlet weak var l1: UILabel!
    @IBOutlet weak var l2: UILabel!
    @IBOutlet weak var l3: UILabel!
    @IBOutlet weak var l4: UILabel!
    
    
    
    
    var customTabBar: TabNavigationMenu!
    
    let config = FMPhotoPickerConfig()
    
    var userData: UserData?
    
    let menuView = MenuView()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        addMenuButtons()
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        menuView.tabController = (tabBarController! as! NavigationMenuBaseController)
        menuView.userData = userData
    }
    
    
    func addMenuButtons() {
        view.addSubview(menuView)
        menuView.currentTab = 4
        menuView.addBehavior()
    }
    
    @IBAction func addPhotoPressed(_ sender: UIButton) {
        var config = YPImagePickerConfiguration()
        config.screens = [.library, .photo, .video]
        config.library.mediaType = .photoAndVideo
        config.library.maxNumberOfItems = 10
        config.video.trimmerMaxDuration = 60.0
        config.video.recordingTimeLimit = 60.0
        config.video.automaticTrimToTrimmerMaxDuration = true
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, cancelled in
//            for item in items {
//                switch item {
//                case .photo(let photo):
//                    print(photo)
//                case .video(let video):
//                    print(video)
//                }
//            }
            picker.dismiss(animated: true, completion: nil)
            if (items.count > 0) {
                let uploadPreviewVC = self.storyboard?.instantiateViewController(identifier: "uploadPreviewVC") as! UploadPreviewVC
                //print(photos)
                uploadPreviewVC.userData = self.userData
                uploadPreviewVC.items = items
                self.present(uploadPreviewVC, animated: false, completion: nil)
                uploadPreviewVC.modalPresentationStyle = .fullScreen
            }
        }
        present(picker, animated: false)
        modalPresentationStyle = .fullScreen
    }
    
    @IBAction func addLinkPressed(_ sender: UIButton) {
        let linkVC = storyboard?.instantiateViewController(identifier: "linkVC") as! AddLinkVCViewController
        linkVC.userData = userData
        present(linkVC, animated: false)
        modalPresentationStyle = .fullScreen
    }
    
    @IBAction func addMusicPressed(_ sender: UIButton) {
        let musicVC = storyboard?.instantiateViewController(identifier: "addMusicVC") as! AddMusicVC
             musicVC.userData = userData
             present(musicVC, animated: false)
             modalPresentationStyle = .fullScreen
    }
    
    
    @IBAction func addSocialMediaPressed(_ sender: UIButton) {
        let addSocialMediaVC = storyboard?.instantiateViewController(identifier: "addSocialMediaVC") as! AddSocialMediaVC
        addSocialMediaVC.userData = userData
        addSocialMediaVC.cancelLbl = "Cancel"
        print("This is addSocialMedia.userData \(addSocialMediaVC.userData)")
        print("2 This is userData from NewPostOptionsVC \(userData)")
        // addSocialMediaVC.publicID = userData?.publicID
        present(addSocialMediaVC, animated: false)
        modalPresentationStyle = .fullScreen
    }
    
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
        pic1.frame = CGRect(x: self.view1.frame.width/4, y: self.view1.frame.height/12, width: self.view1.frame.width/2, height: self.view1.frame.width/2)
        l1.frame =  CGRect(x: self.view1.frame.width/12, y: self.pic1.frame.maxY + 10, width: self.view1.frame.width*(10/12), height: 44)
        
        view2.addSubview(pic2)
        pic2.frame = CGRect(x: self.view2.frame.width/4, y: self.view2.frame.height/12, width: self.view2.frame.width/2, height: self.view2.frame.width/2)
        
        l2.frame =  CGRect(x: self.view2.frame.width/12, y: self.pic2.frame.maxY + 10, width: self.view2.frame.width*(10/12), height: 44)
        
        
        
        view3.addSubview(pic3)
        pic3.frame = CGRect(x: view3.frame.width/4, y: self.view3.frame.height/12, width: self.view3.frame.width/2, height: view3.frame.width/2)
        l3.frame =  CGRect(x: self.view3.frame.width/12, y: self.pic3.frame.maxY + 10, width: self.view3.frame.width*(10/12), height: 44)
        
        view4.addSubview(pic4)
        pic4.frame = CGRect(x: view4.frame.width/4, y: view4.frame.height/12, width: view4.frame.width/2, height: view4.frame.width/2)
        l4.frame =  CGRect(x: self.view4.frame.width/12, y: self.pic4.frame.maxY + 10, width: self.view4.frame.width*(10/12), height: 44)
        
        //rounded views
        view1.layer.cornerRadius = 25.0
        view2.layer.cornerRadius = 25.0
        view3.layer.cornerRadius = 25.0
        view4.layer.cornerRadius = 25.0
    
        
    }
    
    
    
    
    
    func formatPicturesAndLabels(){
        view1.frame = CGRect(x: (self.view.frame.width/12), y: (self.view.frame.height/3) - (self.view.frame.width/6) - 20 , width: self.view.frame.width/3, height: self.view.frame.width/3)
        titleLabel.frame = CGRect(x: 0, y: 10.0, width: self.view.frame.width, height: 66.0)
        
        pic1.frame = view1.frame
//        pic1.frame = CGRect(x: (self.view.frame.width/12), y: (self.view.frame.height/3) - (self.view.frame.width/6) - 20 , width: self.view.frame.width/3, height: self.view.frame.width/3)
        
        l1.frame = CGRect(x: self.view.frame.width/12, y: pic1.frame.maxY + 30.0, width: self.view.frame.width/3, height: 33.0)
        l1.text = "Add Photos/Videos"
        l2.text = "Add Music"
        l3.text = "Add Link"
        l4.text = "Add Social Media"
        
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
