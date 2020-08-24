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
    @IBOutlet weak var addPostButton: UIButton!
      
      @IBOutlet weak var newPostButton: UIButton!
      @IBOutlet weak var friendsButton: UIButton!
      
      @IBOutlet weak var settingsButton: UIButton!
      
      @IBOutlet weak var dmButton: UIButton!
      
      @IBOutlet weak var homeProfileButton: UIButton!
    
    
    
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var pic1: UIButton!
    
    @IBOutlet weak var pic2: UIButton!
    
    @IBOutlet weak var pic3: UIButton!
    
    @IBOutlet weak var pic4: UIButton!
    
    @IBOutlet weak var pic5: UIButton!
    
    @IBOutlet weak var pic6: UIButton!
    
    @IBOutlet weak var l1: UILabel!
    @IBOutlet weak var l2: UILabel!
    @IBOutlet weak var l3: UILabel!
    @IBOutlet weak var l4: UILabel!
    @IBOutlet weak var l5: UILabel!
    @IBOutlet weak var l6: UILabel!
    
    var customTabBar: TabNavigationMenu!
    
    let config = FMPhotoPickerConfig()
    
    var userData: UserData?
    
    @IBOutlet weak var gradientImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        self.view.addSubview(addPostButton)
        
               self.view.addSubview(newPostButton)
               
               self.view.addSubview(friendsButton)
               
               self.view.addSubview(settingsButton)
               
               self.view.addSubview(dmButton)
               
               self.view.addSubview(homeProfileButton)
        
        newPostButton.isHidden = true
        settingsButton.isHidden = true
        friendsButton.isHidden = true
        dmButton.isHidden = true
        homeProfileButton.isHidden = true
        //  curvedLayer.isHidden = true
        // show add Post button
        addPostButton.isHidden = false
         addPostButton.layer.zPosition = 2
               
        addPostButton.frame = CGRect(x: self.view.frame.width/2-40, y: self.view.frame.height - 83, width: 80, height: 80)
               //  addPostButton.imageView?.setupHexagonMask(lineWidth: 10.0, color: .black, cornerRadius: 10.0)
               // round ava
               addPostButton.layer.cornerRadius = addPostButton.frame.size.width / 2
               addPostButton.clipsToBounds = true
               
               
               newPostButton.frame = CGRect(x: 13, y: addPostButton.frame.minY, width: 80, height: 80)
               //  newPostButton.imageView?.setupHexagonMask(lineWidth: 10.0, color: .black, cornerRadius: 10.0)
               // round ava
               newPostButton.layer.cornerRadius = newPostButton.frame.size.width / 2
               newPostButton.clipsToBounds = true
               
               
               friendsButton.frame = CGRect(x: self.view.frame.width/2 - 40, y: self.view.frame.height - 203, width: 80, height: 80)
               // friendsButton.imageView?.setupHexagonMask(lineWidth: 10.0, color: .black, cornerRadius: 10.0)
               // round ava
               friendsButton.layer.cornerRadius = friendsButton.frame.size.width / 2
               friendsButton.clipsToBounds = true
               
               
               
               
               dmButton.frame = CGRect(x: self.view.frame.width*3/5 + 20, y: self.view.frame.height - 166, width: 80, height: 80)
               //  dmButton.imageView?.setupHexagonMask(lineWidth: 10.0, color: .black, cornerRadius: 10.0)
               // round ava
               dmButton.layer.cornerRadius = dmButton.frame.size.width / 2
               dmButton.clipsToBounds = true
               
               
               
               settingsButton.frame = CGRect(x: self.view.frame.width - 93, y: self.view.frame.height - 83, width: 80, height: 80)
               // settingsButton.imageView?.setupHexagonMask(lineWidth: 10.0, color: .black, cornerRadius: 10.0)
               // round ava
               settingsButton.layer.cornerRadius = settingsButton.frame.size.width / 2
               settingsButton.clipsToBounds = true
               
               
               
               homeProfileButton.frame = CGRect(x: self.view.frame.width/5 - 20, y: dmButton.frame.minY, width: 80, height: 80)
               // homeProfileButton.imageView?.setupHexagonMask(lineWidth: 10.0, color: .black, cornerRadius: 10.0)
               // round ava
               homeProfileButton.layer.cornerRadius = homeProfileButton.frame.size.width / 2
               homeProfileButton.clipsToBounds = true
               //        let curvedHeight = friendsButton.frame.minY - 10
               //        curvedRect = CGRect(x: 0.0, y: curvedHeight, width: self.view.frame.width, height: self.view.frame.height )
               //        var curvedRect = CGRect(x: 0.0, y: curvedHeight, width: scrollView.frame.width, height: scrollView.frame.height)
               //        curvedLayer = UIImageView(frame: curvedRect)
               //        curvedLayer.backgroundColor = gold
               //
               //        //round layer
               //        curvedLayer.layer.cornerRadius = curvedLayer.frame.size.width / 2
               //        curvedLayer.clipsToBounds = true
               
        let menuTapped = UITapGestureRecognizer(target: self, action: #selector(HomeHexagonGrid.tappedMenuButton))
        let menuDragged = UIPanGestureRecognizer(target: self, action: #selector(HomeHexagonGrid.draggedMenuButton))
        let menuLongPressed = UILongPressGestureRecognizer(target: self, action: #selector(HomeHexagonGrid.longPressMenuButton))
               addPostButton.addGestureRecognizer(menuTapped)
               addPostButton.addGestureRecognizer(menuDragged)
               addPostButton.addGestureRecognizer(menuLongPressed)
               
        
        
        
        
        formatPicturesAndLabels()

        // Do any additional setup after loading the view.
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
    
    @IBAction func friendsButtonClicked(_ sender: UIButton) {
        //      let profileHexGrid =   storyboard?.instantiateViewController(identifier: "ProfileHexGrid") as! BioProfileHexagonGrid2
        //        profileHexGrid.userData = userData
        //        self.dismiss(animated: false, completion: nil)
        //        present(profileHexGrid, animated: false)
        //self.dismiss(animated: false, completion: nil)
        let viewControllers = tabBarController!.customizableViewControllers!
        let profileGrid = (viewControllers[3] as! BioProfileHexagonGrid2)
        let tabController = tabBarController! as! NavigationMenuBaseController
        profileGrid.userData = userData
        profileGrid.refresh()
        tabController.viewControllers![3] = profileGrid
        tabController.customTabBar.switchTab(from: 4, to: 3)
    }
    
    @IBAction func homeButtonClicked(_ sender: Any) {
        let viewControllers = tabBarController!.customizableViewControllers!
        let homeVC = (viewControllers[2] as! HomeHexagonGrid)
        let tabController = tabBarController! as! NavigationMenuBaseController
        homeVC.userData = userData
        tabController.viewControllers![2] = homeVC
        tabController.customTabBar.switchTab(from: 4, to: 2)
    }
    
    
    @IBAction func newPostButtonClicked(_ sender: UIButton) {
        //        let newPostVC =   storyboard?.instantiateViewContr?
    }
    
    @objc func tappedMenuButton(sender: UITapGestureRecognizer) {
        if (dmButton.isHidden == true) {
            makeAllMenuButtonsBlack()
            showMenuOptions()
        }
            //sleep(3000)
        else {
            hideMenuOptions()
        }
    }
    
    
    // TODO: TO DO Redo this for circular border
    func makeAllMenuButtonsBlack() {
        newPostButton.imageView?.makeRounded()
        homeProfileButton.imageView?.makeRounded()
        dmButton.imageView?.makeRounded()
        settingsButton.imageView?.makeRounded()
        friendsButton.imageView?.makeRounded()
        addPostButton.imageView?.makeRounded()
        
        //        newPostButton.layer.borderWidth = 4
        //        homeProfileButton.layer.borderWidth = 4
        //        dmButton.layer.borderWidth = 4
        //        settingsButton.layer.borderWidth = 4
        //        friendsButton.layer.borderWidth = 4
        //
        //
        //
        //        newPostButton.layer.borderColor = UIColor.black.cgColor
        //         homeProfileButton.layer.borderColor = UIColor.black.cgColor
        //         dmButton.layer.borderColor = UIColor.black.cgColor
        //         settingsButton.layer.borderColor = UIColor.black.cgColor
        //         friendsButton.layer.borderColor = UIColor.black.cgColor
        
        //        newPostButton.imageView!.setupHexagonMask(lineWidth: 10.0, color: .black, cornerRadius: 10)
        //        homeProfileButton.imageView!.setupHexagonMask(lineWidth: 10.0, color: .black, cornerRadius: 10)
        //        dmButton.imageView!.setupHexagonMask(lineWidth: 10.0, color: .black, cornerRadius: 10)
        //        settingsButton.imageView!.setupHexagonMask(lineWidth: 10.0, color: .black, cornerRadius: 10)
        //        friendsButton.imageView!.setupHexagonMask(lineWidth: 10.0, color: .black, cornerRadius: 10)
    }
    
    @objc func draggedMenuButton(sender: UIPanGestureRecognizer) {
        var point : CGPoint = sender.translation(in: view)
        point.x += sender.view!.frame.midX
        point.y += sender.view!.frame.midY
        //        print(point)
        if (sender.state == .began) {
            makeAllMenuButtonsBlack()
            showMenuOptions()
        }
        if (sender.state == .changed) {
            //showMenuOptions()
            //            print("changing")
            makeAllMenuButtonsBlack()
            let button = findMenuHexagonButton(hexCenter: point)
            //            print("buttin \(button?.titleLabel)")
            // button?.imageView?.setupHexagonMask(lineWidth: 10.0, color: red, cornerRadius: 10)
            button?.imageView?.makeRoundedGold()
        }
        if (sender.state == .ended) {
            //find button
            let button = findMenuHexagonButton(hexCenter: point)
            button?.sendActions(for: .touchUpInside)
            //print("button triggered: \(button?.titleLabel)")
            hideMenuOptions()
            //change VC
        }
    }
    
    func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
          let xDist = a.x - b.x
          let yDist = a.y - b.y
          return CGFloat(sqrt(xDist * xDist + yDist * yDist))
      }
    
    func findMenuHexagonButton(hexCenter: CGPoint) -> UIButton? {
        //        print(hexCenter)
        if (distance(hexCenter, newPostButton.center) < 70) {
            return newPostButton
        }
        if (distance(hexCenter, homeProfileButton.center) < 70) {
            return homeProfileButton
        }
        if (distance(hexCenter, dmButton.center) < 70) {
            return dmButton
        }
        if (distance(hexCenter, settingsButton.center) < 70) {
            return settingsButton
        }
        if (distance(hexCenter, friendsButton.center) < 70) {
            return friendsButton
        }
        return nil
        
        
    }
    
    @objc func longPressMenuButton(sender: UILongPressGestureRecognizer) {
        if (sender.state == .began) {
            makeAllMenuButtonsBlack()
            showMenuOptions()
        }
        if (sender.state == .ended) {
            hideMenuOptions()
        }
    }
    
    
    func showMenuOptions() {
        newPostButton.isHidden = false
        homeProfileButton.isHidden = false
        dmButton.isHidden = false
        settingsButton.isHidden = false
        friendsButton.isHidden = false
        //curvedLayer.isHidden = false
    }
    func hideMenuOptions() {
        newPostButton.isHidden = true
        homeProfileButton.isHidden = true
        dmButton.isHidden = true
        settingsButton.isHidden = true
        friendsButton.isHidden = true
       // curvedLayer.isHidden = true
    }
    
    
    
    func formatPicturesAndLabels(){
        titleLabel.frame = CGRect(x: 10.0, y: 10.0, width: self.view.frame.width, height: 66.0)
        pic1.frame = CGRect(x: 10.0, y: titleLabel.frame.maxY + 20.0, width: self.view.frame.width/3, height: self.view.frame.width/6)
        l1.frame = CGRect(x: 10.0, y: pic1.frame.maxY + 20.0, width: self.view.frame.width/3, height: 33.0)
        l1.text = "Add Photo/Video"
         l2.text = "Add Song/Playlist"
         l3.text = "Write A Blog"
         l4.text = "Add Social Media"
         l5.text = "Add Link"
         l6.text = "Add Badge"
        
        pic2.frame = CGRect(x: ((self.view.frame.width*2/3)-30.0), y: titleLabel.frame.maxY + 20.0, width: self.view.frame.width/3, height: self.view.frame.width/6)
        l2.frame = CGRect(x: ((self.view.frame.width*2/3)-30.0), y: pic1.frame.maxY + 20.0, width: self.view.frame.width/3, height: 33.0)
        
        pic3.frame = CGRect(x: 10.0, y: pic1.frame.maxY + 100.0, width: self.view.frame.width/3, height: self.view.frame.width/6)
          l3.frame = CGRect(x: 10.0, y: pic3.frame.maxY + 20.0, width: self.view.frame.width/3, height: 33.0)
          pic4.frame = CGRect(x: ((self.view.frame.width*2/3)-30.0), y: pic2.frame.maxY + 100.0, width: self.view.frame.width/3, height: self.view.frame.width/6)
          l4.frame = CGRect(x: ((self.view.frame.width*2/3)-30.0), y: pic4.frame.maxY + 20.0, width: self.view.frame.width/3, height: 33.0)
        
        pic5.frame = CGRect(x: 10.0, y: pic3.frame.maxY + 100.0, width: self.view.frame.width/3, height: self.view.frame.width/6)
               l5.frame = CGRect(x: 10.0, y: pic5.frame.maxY + 20.0, width: self.view.frame.width/3, height: 33.0)
               pic6.frame = CGRect(x: ((self.view.frame.width*2/3)-30.0), y: pic4.frame.maxY + 100.0, width: self.view.frame.width/3, height: self.view.frame.width/6)
               l6.frame = CGRect(x: ((self.view.frame.width*2/3)-30.0), y: pic6.frame.maxY + 20.0, width: self.view.frame.width/3, height: 33.0)
        
        
//         pic1.setupHexagonMask(lineWidth: 10.0, color: gold, cornerRadius: 10.0)
//         pic2.setupHexagonMask(lineWidth: 10.0, color: gold, cornerRadius: 10.0)
//         pic3.setupHexagonMask(lineWidth: 10.0, color: gold, cornerRadius: 10.0)
//         pic4.setupHexagonMask(lineWidth: 10.0, color: gold, cornerRadius: 10.0)
//         pic5.setupHexagonMask(lineWidth: 10.0, color: gold, cornerRadius: 10.0)
//         pic6.setupHexagonMask(lineWidth: 10.0, color: gold, cornerRadius: 10.0)
        
        
        
        
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
