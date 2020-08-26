//
//  NewPostOptionsVC.swift
//  Bio
//
//  Created by Ann McDonough on 8/3/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import FMPhotoPicker

class NewPostOptionsVC: UIViewController, FMPhotoPickerViewControllerDelegate {
    func fmPhotoPickerController(_ picker: FMPhotoPickerViewController, didFinishPickingPhotoWith photos: [UIImage]) {
        if photos.isEmpty {
            self.dismiss(animated: true, completion: nil)
        }
        else {

            // TODO: Learn how to implement video
            let uploadPreviewVC = storyboard?.instantiateViewController(identifier: "uploadPreviewVC") as! UploadPreviewVC
            print(photos)
            uploadPreviewVC.userData = userData
            uploadPreviewVC.photos = photos
            self.dismiss(animated: false, completion: nil)
            self.present(uploadPreviewVC, animated: false, completion: nil)
           // uploadPreviewVC.modalPresentationStyle = .fullScreen
            uploadPreviewVC.modalPresentationStyle = .overFullScreen
            
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    
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
    
    @IBOutlet weak var gradientImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        addMenuButtons()
  
        pic1.layer.cornerRadius = pic1.frame.size.width / 2
            pic1.clipsToBounds = true
        
        pic2.layer.cornerRadius = pic2.frame.size.width / 2
                  pic2.clipsToBounds = true
        
        pic3.layer.cornerRadius = pic3.frame.size.width / 2
                  pic3.clipsToBounds = true
        
        pic4.layer.cornerRadius = pic4.frame.size.width / 2
                  pic4.clipsToBounds = true
        
        formatPicturesAndLabels()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        menuView.tabController = (tabBarController! as! NavigationMenuBaseController)
    }
    
    func addMenuButtons() {
        view.addSubview(menuView)
        menuView.currentTab = 4
        menuView.addBehavior()
    }
    
    @IBAction func addPhotoPressed(_ sender: UIButton) {
      //  sender.sendActions(for: .touchUpInside)
        let picker = FMPhotoPickerViewController(config: config)
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    @IBAction func addLinkPressed(_ sender: UIButton) {
        let linkVC = storyboard?.instantiateViewController(identifier: "linkVC") as! AddLinkVCViewController
        linkVC.userData = userData
        show(linkVC, sender: nil)
        linkVC.modalPresentationStyle = .fullScreen
    }
    
    @IBAction func addSocialMediaPressed(_ sender: UIButton) {
        let addSocialMediaVC = storyboard?.instantiateViewController(identifier: "addSocialMediaVC") as! AddSocialMediaVC
           addSocialMediaVC.userData = userData
       // addSocialMediaVC.publicID = userData?.publicID
           show(addSocialMediaVC, sender: nil)
           addSocialMediaVC.modalPresentationStyle = .fullScreen
    }
    
    func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
          let xDist = a.x - b.x
          let yDist = a.y - b.y
          return CGFloat(sqrt(xDist * xDist + yDist * yDist))
      }
    
    
    func formatPicturesAndLabels(){
        titleLabel.frame = CGRect(x: 0, y: 10.0, width: self.view.frame.width, height: 66.0)
        pic1.frame = CGRect(x: (self.view.frame.width/12), y: (self.view.frame.height/3) - (self.view.frame.width/6) - 20 , width: self.view.frame.width/3, height: self.view.frame.width/3)
        l1.frame = CGRect(x: self.view.frame.width/12, y: pic1.frame.maxY + 30.0, width: self.view.frame.width/3, height: 33.0)
        l1.text = "Add Photo"
         l2.text = "Add Video"
         l3.text = "Add Link"
         l4.text = "Add Social Media"
        
        pic2.frame = CGRect(x: (self.view.frame.width*7/12), y: (self.view.frame.height/3) - (self.view.frame.width/6)-20, width: self.view.frame.width/3, height: self.view.frame.width/3)
        l2.frame = CGRect(x: (self.view.frame.width*7/12), y: pic1.frame.maxY + 30.0, width: self.view.frame.width/3, height: 33.0)
        
            pic3.frame = CGRect(x: self.view.frame.width/12, y: (self.view.frame.height*2/3) - (self.view.frame.width/6) - 20, width: self.view.frame.width/3, height: self.view.frame.width/3)
          pic4.frame = CGRect(x: (self.view.frame.width*7/12), y: (self.view.frame.height*2/3) - (self.view.frame.width/6) - 20, width: self.view.frame.width/3, height: self.view.frame.width/3)
       
            l3.frame = CGRect(x: self.view.frame.width/12, y: pic3.frame.maxY + 30.0, width: self.view.frame.width/3, height: 33.0)
        
        l4.frame = CGRect(x: self.view.frame.width*7/12, y: pic4.frame.maxY + 30.0, width: self.view.frame.width/3, height: 33.0)
    }
}
