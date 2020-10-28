//
//  MenuView.swift
//  Bio
//
//  Created by Ann McDonough on 8/14/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class MenuView: UIView {
    var blurEffectViewArray: [UIView] = []
    var menuButton: UIButton = UIButton()
    var newPostButton: UIButton = UIButton()
    var friendsButton: UIButton = UIButton()
    var notificationsButton: UIButton = UIButton()
    var dmButton: UIButton = UIButton()
    var homeProfileButton: UIButton =  UIButton()
    var tabController: NavigationMenuBaseController?
    var userData: UserData? {
        didSet {
            if (tabController != nil) {
                let viewControllers = tabController!.customizableViewControllers!
                (viewControllers[0] as! NotificationsVC).userData = userData
                (viewControllers[2] as! HomeHexagonGrid).userData = userData
                (viewControllers[2] as! HomeHexagonGrid).setUpPageViewListener()
                (viewControllers[3] as! DiscoverGrid).userData = userData
                (viewControllers[4] as! NewPostColorfulVC).userData = userData
            }
        }
    }
    var db = Firestore.firestore()
    var user = Auth.auth().currentUser
    
    var currentTab: Int = 0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //addBehavior()
    }
    func setTabController(tabController: NavigationMenuBaseController) {
        self.tabController = tabController
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    func addBehavior() {
        
        if userData == nil {
            user = Auth.auth().currentUser
            if user != nil {
                db.collection("UserData1").whereField("email", isEqualTo: user!.email!).addSnapshotListener({ objects, error in
                    if error == nil {
                        guard let docs = objects?.documents
                            else{
                                print("bad docs")
                                return
                        }
                        
                        if docs.count == 0 {
                            print("no userdata found for this user.  Return to sign in")
                            do {
                                try Auth.auth().signOut()
                            }
                            catch {
                                print("could not sign out from firebase")
                            }
                            self.user = nil
                            self.userData = nil
                            self.tabController?.customTabBar.switchTab(from: self.currentTab, to: 5)
                        }
                        else if docs.count > 1 {
                            print("multiple user data.... fix this")
                        }
                        else {
                            self.userData = UserData(dictionary: docs[0].data())
                        }
                    }
                })
            }
            else {
                print("no user signed in.  Transitioning to sign in")
                self.user = nil
                self.userData = nil
                self.tabController?.customTabBar.switchTab(from: self.currentTab, to: 5)
            }
        }
        
        
        self.isUserInteractionEnabled = false
        let superView = self.superview!
        //let thisFrame = self.frame
        let superFrame = superView.frame
        superView.addSubview(menuButton)
        superView.addSubview(newPostButton)
        superView.addSubview(friendsButton)
        superView.addSubview(notificationsButton)
        superView.addSubview(dmButton)
        superView.addSubview(homeProfileButton)
        
        let buttonWidth = CGFloat(60)
        let halfButtonWidth = CGFloat(30)
        
        //self.backgroundColor = .white
        
//        print("superFrame \(superFrame)")
        
        menuButton.frame = CGRect(x: superFrame.width/2-40, y: superFrame.height-112, width: 80, height: 80)
        // round ava
        menuButton.layer.cornerRadius = menuButton.frame.size.width / 2
        menuButton.clipsToBounds = true
//        print ("menuButton frame \(menuButton.frame)")
        
        //newPostButton.frame = CGRect(x: superFrame.width/5 - halfButtonWidth, y: menuButton.frame.minY, width: buttonWidth, height: buttonWidth)
    
        notificationsButton.frame = CGRect(x: menuButton.center.x - 130.2829 - halfButtonWidth, y: menuButton.frame.minY + 10, width: buttonWidth, height: buttonWidth)

        //  newPostButton.imageView?.setupHexagonMask(lineWidth: 10.0, color: .black, cornerRadius: 10.0)
        // round ava
       // newPostButton.layer.cornerRadius = newPostButton.frame.size.width / 2
        newPostButton.clipsToBounds = true
//        print ("newpost frame \(newPostButton.frame)")
        
//        friendsButton.frame = CGRect(x: superFrame.width/2 - halfButtonWidth, y: superFrame.height - 223, width: buttonWidth, height: buttonWidth)
//
        homeProfileButton.frame = CGRect(x: superFrame.width/2 - halfButtonWidth, y: superFrame.height - 223, width: buttonWidth, height: buttonWidth)
        
     
        
        friendsButton.frame = CGRect(x: menuButton.center.x + 64.2 - 5, y: superFrame.height - 192 + 10, width: buttonWidth, height: buttonWidth)
    
        friendsButton.clipsToBounds = true

        newPostButton.frame = CGRect(x: menuButton.center.x + 130.2829 - halfButtonWidth, y: superFrame.height - 112 + 10, width: buttonWidth, height: buttonWidth)
      
        notificationsButton.clipsToBounds = true
//        print ("settings frame \(settingsButton.frame)")
        
        
        dmButton.frame = CGRect(x: superFrame.width/5 + 5, y: friendsButton.frame.minY, width: buttonWidth, height: buttonWidth)
        dmButton.clipsToBounds = true
        homeProfileButton.clipsToBounds = true
//        print("home frame \(homeProfileButton.frame)")
        
        var xDistanceFromHomeToMenuCenter = menuButton.center.x - homeProfileButton.frame.maxX

        
        let menuTapped = UITapGestureRecognizer(target: self, action: #selector(tappedMenuButton))
        let menuDragged = UIPanGestureRecognizer(target: self, action: #selector(draggedMenuButton))
        let menuLongPressed = UILongPressGestureRecognizer(target: self, action: #selector(longPressMenuButton))

        menuButton.addGestureRecognizer(menuTapped)
        menuButton.addGestureRecognizer(menuDragged)
        menuButton.addGestureRecognizer(menuLongPressed)

        
        dmButton.addTarget(self, action: #selector(dmsButtonClicked), for: .touchUpInside)
        friendsButton.addTarget(self, action: #selector(friendsButtonClicked), for: .touchUpInside)
        homeProfileButton.addTarget(self, action: #selector(homeButtonClicked), for: .touchUpInside)
        newPostButton.addTarget(self, action: #selector(newPostButtonClicked), for: .touchUpInside)
          notificationsButton.addTarget(self, action: #selector(notificationsButtonClicked), for: .touchUpInside)
        
        
        //hide buttons
        newPostButton.isHidden = true
        notificationsButton.isHidden = true
        friendsButton.isHidden = true
        dmButton.isHidden = true
        homeProfileButton.isHidden = true
        
        newPostButton.setImage(UIImage(named: "addCircle"), for: .normal)
        notificationsButton.setImage(UIImage(named: "bell1"), for: .normal)
        friendsButton.setImage(UIImage(named: "twoFriendsFlipped"), for: .normal)
        dmButton.setImage(UIImage(named: "email1"), for: .normal)
        homeProfileButton.setImage(UIImage(named: "clearHouse"), for: .normal)
        menuButton.imageView!.image = nil
        
        newPostButton.tintColor = .black
        notificationsButton.tintColor = .white
        friendsButton.tintColor = .black
        dmButton.tintColor = .black
        homeProfileButton.tintColor = .black
        menuButton.tintColor = .clear
        menuButton.layer.borderColor = white.cgColor
        menuButton.layer.borderWidth = menuButton.frame.width/10
        
        newPostButton.backgroundColor = .clear
        notificationsButton.backgroundColor = .clear
        friendsButton.backgroundColor = .clear
        dmButton.backgroundColor = .clear
        homeProfileButton.backgroundColor = .clear
        menuButton.backgroundColor = .clear
        newPostButton.imageView!.image = UIImage(named: "addCircle")
        notificationsButton.imageView!.image = UIImage(named: "bell1")
        friendsButton.imageView!.image = UIImage(named: "twoFriendsFlipped")
        dmButton.imageView!.image = UIImage(named: "email1")
        homeProfileButton.imageView!.image = UIImage(named: "clearHouse")
        // show add Post button
        menuButton.isHidden = false
        //menuButton.imageView?.image = UIImage(named: "k23")
        menuButton.layer.zPosition = 2
    }

    @objc func dmsButtonClicked(_ sender: UIButton) {
        let alert = UIAlertController(title: "Coming Soon!", message: "DM's and Messenging Will Be Available in the Next Update", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: {_ in
    })
        alert.addAction(ok)
   //     self.present(alert, animated: true, completion: nil)
    }
    
    @objc func friendsButtonClicked(_ sender: UIButton) {
        let viewControllers = tabController!.customizableViewControllers!
        let profileGrid = (viewControllers[3] as! DiscoverGrid)
        profileGrid.menuView.dmButton.isHidden = true
        profileGrid.menuView.newPostButton.isHidden = true
        profileGrid.menuView.friendsButton.isHidden = true
        profileGrid.menuView.notificationsButton.isHidden = true
        profileGrid.menuView.homeProfileButton.isHidden = true
        
        profileGrid.userData = userData
        tabController!.viewControllers![3] = profileGrid
       // tabController!.viewControllers![currentTab]
        tabController!.customTabBar.switchTab(from: currentTab, to: 3)
    }
    
    @objc func newPostButtonClicked(_ sender: UIButton) {
        let viewControllers = tabController!.customizableViewControllers!
        let newPostVC = (viewControllers[4] as! NewPostColorfulVC)
        newPostVC.menuView.dmButton.isHidden = true
        newPostVC.menuView.newPostButton.isHidden = true
        newPostVC.menuView.friendsButton.isHidden = true
        newPostVC.menuView.notificationsButton.isHidden = true
        newPostVC.menuView.homeProfileButton.isHidden = true
        newPostVC.userData = userData
        tabController!.viewControllers![4] = newPostVC
        tabController!.customTabBar.switchTab(from: currentTab, to: 4)
    }
    
    @objc func notificationsButtonClicked(_ sender: UIButton) {
        let viewControllers = tabController!.customizableViewControllers!
        let notificationsVC = (viewControllers[0] as! NotificationsVC)
        notificationsVC.userData = userData
        notificationsVC.menuView.dmButton.isHidden = true
        notificationsVC.menuView.newPostButton.isHidden = true
        notificationsVC.menuView.friendsButton.isHidden = true
        notificationsVC.menuView.notificationsButton.isHidden = true
        notificationsVC.menuView.homeProfileButton.isHidden = true
        tabController!.viewControllers![0] = notificationsVC
        tabController!.customTabBar.switchTab(from: currentTab, to: 0)
    }
    
    @objc func homeButtonClicked(_ sender: Any) {
        let viewControllers = tabController!.customizableViewControllers!
        let homeVC = (viewControllers[2] as! HomeHexagonGrid)
        homeVC.userData = userData
        homeVC.menuView.dmButton.isHidden = true
        homeVC.menuView.newPostButton.isHidden = true
        homeVC.menuView.friendsButton.isHidden = true
        homeVC.menuView.notificationsButton.isHidden = true
        homeVC.menuView.homeProfileButton.isHidden = true
        tabController!.viewControllers![2] = homeVC
        tabController!.customTabBar.switchTab(from: currentTab, to: 2)
    }
    
    @objc func tappedMenuButton(sender: UITapGestureRecognizer) {
        if (dmButton.isHidden == true) {
            //makeAllMenuButtonsBlack()
            makeAllMenuButtonsClear()
            showMenuOptions()
        }
            //sleep(3000)
        else {
            hideMenuOptions()
        }
    }
    
    // TODO: TO DO Redo this for circular border
    func makeAllMenuButtonsBlack() {
        newPostButton.imageView?.makeRoundedBlack()
        homeProfileButton.imageView?.makeRoundedBlack()
        dmButton.imageView?.makeRoundedBlack()
        notificationsButton.imageView?.makeRoundedBlack()
        friendsButton.imageView?.makeRoundedBlack()
        menuButton.imageView?.makeRoundedBlack()
    }
    
    func makeAllMenuButtonsClear() {
        newPostButton.imageView?.makeSquareClear()
        homeProfileButton.imageView?.makeSquareClear()
        dmButton.imageView?.makeSquareClear()
        notificationsButton.imageView?.makeSquareClear()
        friendsButton.imageView?.makeSquareClear()
        menuButton.imageView?.makeSquareClear()
    }
    
    @objc func draggedMenuButton(sender: UIPanGestureRecognizer) {
        var point : CGPoint = sender.translation(in: self)
        point.x += sender.view!.frame.midX
        point.y += sender.view!.frame.midY
        //        print(point)
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        if (sender.state == .began) {
           // makeAllMenuButtonsBlack()
            makeAllMenuButtonsClear()
            
            //blur the screen
         
           // blurEffectView.frame = (tabController?.customizableViewControllers![currentTab].view.bounds)!
          //  blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            //if currentTab == 2 {
                //let homeVCBlur = tabController?.customizableViewControllers![currentTab] as! HomeHexagonGrid
                //blurEffectView.frame = homeVCBlur.contentView.frame
                //blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                //homeVCBlur.contentView.addSubview(blurEffectView)
            //}
            blurEffectViewArray.append(blurEffectView)
            superview!.addSubview(blurEffectView)
            blurEffectView.frame = superview!.frame
            superview!.bringSubviewToFront(homeProfileButton)
            superview!.bringSubviewToFront(notificationsButton)
            superview!.bringSubviewToFront(dmButton)
            superview!.bringSubviewToFront(friendsButton)
            superview!.bringSubviewToFront(newPostButton)
            superview!.bringSubviewToFront(menuButton)
            
            
            
            
            
            showMenuOptions()
            
    
        }
        if (sender.state == .changed) {
            //showMenuOptions()
            //            print("changing")
            //makeAllMenuButtonsBlack()
            changeBackToWhiteIcons()
            let button = findMenuHexagonButton(hexCenter: point)
            //            print("buttin \(button?.titleLabel)")
            // button?.imageView?.setupHexagonMask(lineWidth: 10.0, color: red, cornerRadius: 10)
            //button?.imageView?.makeRoundedMyCoolBlue()
            if button != nil {
            makeTheIconTeal(iconButton: button!)
            }
        }
        if (sender.state == .ended) {
            //find button
            let button = findMenuHexagonButton(hexCenter: point)
            hideMenuOptions()
            for blurview in blurEffectViewArray {
            blurview.removeFromSuperview()
            }
            button?.sendActions(for: .touchUpInside)
            //print("button triggered: \(button?.titleLabel)")
           
            
            
            //change VC
        }
    }
    
    func changeBackToWhiteIcons() {
        homeProfileButton.imageView?.image = UIImage(named: "clearHouse")
        dmButton.imageView?.image = UIImage(named: "email1")
        friendsButton.imageView?.image = UIImage(named: "twoFriendsFlipped")
        newPostButton.imageView?.image = UIImage(named: "addCircle")
        notificationsButton.imageView?.image = UIImage(named: "bell1")
    }
    
    func makeTheIconTeal(iconButton: UIButton) {
        if iconButton == newPostButton {
          //  changeBackToWhiteIcons()
            newPostButton.imageView?.image = UIImage(named: "newPostTeal100")
        }
        else if iconButton == friendsButton {
          //  changeBackToWhiteIcons()
            friendsButton.imageView?.image = UIImage(named: "friendsTeal100")
        }
        else if iconButton == homeProfileButton {
         //   changeBackToWhiteIcons()
            homeProfileButton.imageView?.image = UIImage(named: "houseTeal100")
        }
        else if iconButton == dmButton {
      //      changeBackToWhiteIcons()
            dmButton.imageView?.image = UIImage(named: "dmTeal100")
        }
        else if iconButton == notificationsButton {
        //    changeBackToWhiteIcons()
            notificationsButton.imageView?.image = UIImage(named: "bellTeal100")
        }
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
        if (distance(hexCenter, notificationsButton.center) < 70) {
            return notificationsButton
        }
        if (distance(hexCenter, friendsButton.center) < 70) {
            return friendsButton
        }
        return nil
    }
    
    @objc func longPressMenuButton(sender: UILongPressGestureRecognizer) {
        if (sender.state == .began) {
           // makeAllMenuButtonsBlack()
            makeAllMenuButtonsClear()
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
        notificationsButton.isHidden = false
        friendsButton.isHidden = false
        //curvedLayer.isHidden = false
    }
    
    func hideMenuOptions() {
        newPostButton.isHidden = true
        homeProfileButton.isHidden = true
        dmButton.isHidden = true
        notificationsButton.isHidden = true
        friendsButton.isHidden = true
        //curvedLayer.isHidden = true
    }
    
    func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt(xDist * xDist + yDist * yDist))
    }
}
