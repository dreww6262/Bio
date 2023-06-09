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
    var tipLabel = UILabel()
    var blurEffectViewArray: [UIView] = []
    var menuButton: UIButton = UIButton()
    var closeMenuButton: UIButton = UIButton()
    var newPostButton: UIButton = UIButton()
    var friendsButton: UIButton = UIButton()
    var notificationsButton: UIButton = UIButton()
    var dmButton: UIButton = UIButton()
    var homeProfileButton: UIButton =  UIButton()
    var tabController: NavigationMenuBaseController?

    var db = Firestore.firestore()
    var user = Auth.auth().currentUser
    
    var currentTab: Int = 0
    
    var numNotifications = 0
    let notificationLabel = UILabel()
    
    
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
        superView.addSubview(notificationLabel)
        closeMenuButton.isHidden = true
        superView.addSubview(closeMenuButton)
        
        
        let buttonWidth = CGFloat(60)
        let halfButtonWidth = CGFloat(30)
        
        //self.backgroundColor = .white
        
        //        print("superFrame \(superFrame)")
        
        menuButton.frame = CGRect(x: superFrame.width/2-40, y: superFrame.height-112, width: 80, height: 80)
        // round ava
        menuButton.layer.cornerRadius = menuButton.frame.size.width / 2
        menuButton.clipsToBounds = true
        
        closeMenuButton.frame = CGRect(x: superFrame.width/2-40, y: superFrame.height-112, width: 80, height: 80)
        // round ava
        closeMenuButton.layer.cornerRadius = closeMenuButton.frame.size.width / 2
        closeMenuButton.clipsToBounds = true
        
        //        print ("menuButton frame \(menuButton.frame)")
        
        //newPostButton.frame = CGRect(x: superFrame.width/5 - halfButtonWidth, y: menuButton.frame.minY, width: buttonWidth, height: buttonWidth)
        
        notificationsButton.frame = CGRect(x: menuButton.center.x - 130.2829 - halfButtonWidth, y: menuButton.frame.minY + 10, width: buttonWidth, height: buttonWidth)
        
        let notificationSize: CGFloat = 40
        notificationLabel.frame = CGRect(x: notificationsButton.frame.maxX -  notificationSize / 2, y: notificationsButton.frame.minY - notificationSize / 2, width: notificationSize, height: notificationSize)
        notificationLabel.backgroundColor = .red
        setNotificationAlertText()
        notificationLabel.font = UIFont(name: "Poppins-SemiBold", size: 14)
        notificationLabel.textColor = .white
        notificationLabel.textAlignment = .center
        notificationLabel.layer.cornerRadius = notificationSize/2
        notificationLabel.clipsToBounds = true

        newPostButton.clipsToBounds = true

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
        
        
        
        let menuTapped = UITapGestureRecognizer(target: self, action: #selector(tappedMenuButton))
        let closeMenuTapped = UITapGestureRecognizer(target: self, action: #selector(tappedCloseMenuButton))
        let menuDragged = UIPanGestureRecognizer(target: self, action: #selector(draggedMenuButton))
        let menuLongPressed = UILongPressGestureRecognizer(target: self, action: #selector(longPressMenuButton))
        
        menuButton.addGestureRecognizer(menuTapped)
        menuButton.addGestureRecognizer(menuDragged)
        menuButton.addGestureRecognizer(menuLongPressed)
        closeMenuButton.addGestureRecognizer(closeMenuTapped)
        
        
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
        notificationLabel.isHidden = true
        
        newPostButton.setImage(UIImage(named: "addCircle"), for: .normal)
        notificationsButton.setImage(UIImage(named: "bell1"), for: .normal)
        friendsButton.setImage(UIImage(named: "twoFriendsFlipped"), for: .normal)
        dmButton.setImage(UIImage(named: "email1"), for: .normal)
        homeProfileButton.setImage(UIImage(named: "clearHouse"), for: .normal)
        menuButton.imageView!.image = nil
        closeMenuButton.imageView!.image = nil
        
        newPostButton.tintColor = .black
        notificationsButton.tintColor = .white
        friendsButton.tintColor = .black
        dmButton.tintColor = .black
        homeProfileButton.tintColor = .black
        menuButton.tintColor = .clear
        menuButton.layer.borderColor = white.cgColor
        menuButton.layer.borderWidth = menuButton.frame.width/10
        
        closeMenuButton.tintColor = .clear
        closeMenuButton.layer.borderColor = white.cgColor
        closeMenuButton.layer.borderWidth = closeMenuButton.frame.width/10
        closeMenuButton.backgroundColor = .clear
        
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
        for blurview in blurEffectViewArray {
            blurview.removeFromSuperview()
        }
        hideMenuOptions()
        //makeAllMenuButtonsClear()
        changeBackToWhiteIcons()
        let alert = UIAlertController(title: "Coming Soon!", message: "DM's and Messenging Will Be Available in the Next Update.", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: {_ in
        })
        alert.addAction(ok)
        menuButton = closeMenuButton
        let menuTapped = UITapGestureRecognizer(target: self, action: #selector(tappedMenuButton))
        menuButton.addGestureRecognizer(menuTapped)
        hideMenuOptions()
        //makeAllMenuButtonsClear()
        
        //it goes to close menu button here when i want regular menu button!!!
        closeMenuButton.isHidden = true
        menuButton.isHidden = false
        parentContainerViewController()?.present(alert, animated: true, completion: nil)
    }
    
    @objc func friendsButtonClicked(_ sender: UIButton) {
        for blurview in blurEffectViewArray {
            blurview.removeFromSuperview()
        }
        //makeAllMenuButtonsClear()
        changeBackToWhiteIcons()
        let viewControllers = tabController!.customizableViewControllers!
        let profileGrid = (viewControllers[3] as! FriendsAndFeaturedVC)
        profileGrid.menuView.dmButton.isHidden = true
        profileGrid.menuView.newPostButton.isHidden = true
        profileGrid.menuView.friendsButton.isHidden = true
        profileGrid.menuView.notificationsButton.isHidden = true
        profileGrid.menuView.homeProfileButton.isHidden = true
        profileGrid.menuView.notificationLabel.isHidden = true
        
        
        //profileGrid.userData = userData
        tabController!.viewControllers![3] = profileGrid
        // tabController!.viewControllers![currentTab]
        tabController!.customTabBar.switchTab(from: currentTab, to: 3)
    }
    
    @objc func newPostButtonClicked(_ sender: UIButton) {
        for blurview in blurEffectViewArray {
            blurview.removeFromSuperview()
        }
        //  makeAllMenuButtonsClear()
        changeBackToWhiteIcons()
        let viewControllers = tabController!.customizableViewControllers!
        let newPostVC = (viewControllers[4] as! NewPost5OptionsVC)
        newPostVC.menuView.dmButton.isHidden = true
        newPostVC.menuView.newPostButton.isHidden = true
        newPostVC.menuView.friendsButton.isHidden = true
        newPostVC.menuView.notificationsButton.isHidden = true
        newPostVC.menuView.homeProfileButton.isHidden = true
        newPostVC.menuView.notificationLabel.isHidden = true
        //newPostVC.userData = userData
        tabController!.viewControllers![4] = newPostVC
        tabController!.customTabBar.switchTab(from: currentTab, to: 4)
    }
    
    @objc func notificationsButtonClicked(_ sender: UIButton) {
        for blurview in blurEffectViewArray {
            blurview.removeFromSuperview()
        }
        changeBackToWhiteIcons()
        //   makeAllMenuButtonsClear()
        let viewControllers = tabController!.customizableViewControllers!
        let notificationsVC = (viewControllers[0] as! NotificationsVC)
        //notificationsVC.userData = userData
        notificationsVC.menuView.dmButton.isHidden = true
        notificationsVC.menuView.newPostButton.isHidden = true
        notificationsVC.menuView.friendsButton.isHidden = true
        notificationsVC.menuView.notificationsButton.isHidden = true
        notificationsVC.menuView.homeProfileButton.isHidden = true
        notificationsVC.menuView.notificationLabel.isHidden = true
        tabController!.viewControllers![0] = notificationsVC
        tabController!.customTabBar.switchTab(from: currentTab, to: 0)
    }
    
    @objc func homeButtonClicked(_ sender: Any) {
        for blurview in blurEffectViewArray {
            blurview.removeFromSuperview()
        }
        //  makeAllMenuButtonsClear()
        changeBackToWhiteIcons()
        let viewControllers = tabController!.customizableViewControllers!
        let homeVC = (viewControllers[2] as! HomeHexagonGrid)
        //homeVC.userData = userData
        homeVC.menuView.dmButton.isHidden = true
        homeVC.menuView.newPostButton.isHidden = true
        homeVC.menuView.friendsButton.isHidden = true
        homeVC.menuView.notificationsButton.isHidden = true
        homeVC.menuView.homeProfileButton.isHidden = true
        homeVC.menuView.notificationLabel.isHidden = true
        tabController!.viewControllers![2] = homeVC
        tabController!.customTabBar.switchTab(from: currentTab, to: 2)
    }
    
    func showMenuOptions() {
        newPostButton.isHidden = false
        homeProfileButton.isHidden = false
        dmButton.isHidden = false
        notificationsButton.isHidden = false
        friendsButton.isHidden = false
        setNotificationAlertText()
        //notificationLabel.isHidden = false
        
        
        //curvedLayer.isHidden = false
    }
    
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
    
    @objc func tappedMenuButton(sender: UITapGestureRecognizer) {
        print("I tapped menu button")
        makeAllMenuButtonsClear()
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        tipLabel.text = "Tap or Swipe To A Menu Button To Go To That Destination."
        tipLabel.font = UIFont(name: "DINAlternate-Bold", size: 16)
        tipLabel.textColor = .black
        
        blurEffectView.bringSubviewToFront(tipLabel)
        //hide menu button and replace with close button
        closeMenuButton = menuButton
        menuButton.isHidden = true
        closeMenuButton.isHidden = false
        let closeMenuTapped = UITapGestureRecognizer(target: self, action: #selector(tappedCloseMenuButton))
        closeMenuButton.addGestureRecognizer(closeMenuTapped)
        
        
        blurEffectViewArray.append(blurEffectView)
        superview!.addSubview(blurEffectView)
        blurEffectView.frame = superview!.frame
        superview!.bringSubviewToFront(homeProfileButton)
        superview!.bringSubviewToFront(notificationsButton)
        superview!.bringSubviewToFront(dmButton)
        superview!.bringSubviewToFront(friendsButton)
        superview!.bringSubviewToFront(newPostButton)
        superview!.bringSubviewToFront(menuButton)
        superview!.bringSubviewToFront(notificationLabel)
        superview!.addSubview(tipLabel)
        tipLabel.center = superview!.center
        setNotificationAlertText()
        showMenuOptions()
        //makeAllMenuButtonsClear()
        changeBackToWhiteIcons()
        
        
    }
    // TODO: TO DO Redo this for circular border
    @objc func tappedCloseMenuButton(sender: UITapGestureRecognizer) {
        print("I tapped close menu button")
        menuButton = closeMenuButton
        let menuTapped = UITapGestureRecognizer(target: self, action: #selector(tappedMenuButton))
        menuButton.addGestureRecognizer(menuTapped)
        hideMenuOptions()
        makeAllMenuButtonsClear()
        for blurview in blurEffectViewArray {
            blurview.removeFromSuperview()
            tipLabel.isHidden = true
            
        }
        closeMenuButton.isHidden = true
        menuButton.isHidden = false
        
        
    }
    
    @objc func draggedMenuButton(sender: UIPanGestureRecognizer) {
        var point : CGPoint = sender.translation(in: self)
        point.x += sender.view!.frame.midX
        point.y += sender.view!.frame.midY
        //        print(point)
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        if (sender.state == .began) {
            changeBackToWhiteIcons()
            blurEffectViewArray.append(blurEffectView)
            superview!.addSubview(blurEffectView)
            blurEffectView.frame = superview!.frame
            superview!.bringSubviewToFront(homeProfileButton)
            superview!.bringSubviewToFront(notificationsButton)
            superview!.bringSubviewToFront(dmButton)
            superview!.bringSubviewToFront(friendsButton)
            superview!.bringSubviewToFront(newPostButton)
            superview!.bringSubviewToFront(menuButton)
            superview!.bringSubviewToFront(notificationLabel)
            setNotificationAlertText()
            showMenuOptions()
            changeBackToWhiteIcons()
            
            
            
            
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
        let buttonWidth: CGFloat = 60
        let superFrame = self.superview!.frame
        self.dmButton.setImage(UIImage(named: "email1"), for: .normal)
        self.dmButton.frame = CGRect(x: superFrame.width/5 + 5, y: self.friendsButton.frame.minY, width: buttonWidth, height: buttonWidth)
        self.dmButton.imageView?.contentMode = .scaleAspectFill
        friendsButton.imageView?.image = UIImage(named: "twoFriendsFlipped")
        newPostButton.imageView?.image = UIImage(named: "addCircle")
        notificationsButton.imageView?.image = UIImage(named: "bell1")
    }
    
    func makeTheIconTeal(iconButton: UIButton) {
        
        DispatchQueue.main.async {
        
            if iconButton == self.newPostButton {
                //  changeBackToWhiteIcons()
                self.newPostButton.imageView?.image = UIImage(named: "newPostTeal100")
            }
            else if iconButton == self.friendsButton {
                //  changeBackToWhiteIcons()
                self.friendsButton.imageView?.image = UIImage(named: "friendsTeal100")
            }
            else if iconButton == self.homeProfileButton {
                //   changeBackToWhiteIcons()
                self.homeProfileButton.imageView?.image = UIImage(named: "houseTeal100")
            }
            else if iconButton == self.dmButton {
                //      changeBackToWhiteIcons()
                let buttonWidth: CGFloat = 60
                let superFrame = self.superview!.frame
                self.dmButton.setImage(UIImage(named: "dmTeal100"), for: .normal)
                self.dmButton.frame = CGRect(x: superFrame.width/5 + 5, y: self.friendsButton.frame.minY, width: buttonWidth, height: buttonWidth)
                self.dmButton.imageView?.contentMode = .scaleAspectFill
            }
            else if iconButton == self.notificationsButton {
                //    changeBackToWhiteIcons()
                self.notificationsButton.imageView?.image = UIImage(named: "bellTeal100")
            }
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
        //        if (sender.state == .began) {
        //           // makeAllMenuButtonsBlack()
        //            makeAllMenuButtonsClear()
        //            showMenuOptions()
        //        }
        //        if (sender.state == .ended) {
        //            hideMenuOptions()
        //        }
        
        
    }
    
    
    
    func hideMenuOptions() {
        newPostButton.isHidden = true
        homeProfileButton.isHidden = true
        dmButton.isHidden = true
        notificationsButton.isHidden = true
        friendsButton.isHidden = true
        notificationLabel.isHidden = true
        //curvedLayer.isHidden = true
    }
    
    func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt(xDist * xDist + yDist * yDist))
    }
    
    func setNotificationAlertText() {
        let numNotifications: Int = { () -> Int in
            if self.tabController != nil { return(self.tabController!.customizableViewControllers![0] as! NotificationsVC).unreadNotifications
            }
            return 0
        }()
        if (numNotifications != 0) {
            let text = String(numNotifications)
            notificationLabel.text = "\(text)"
            notificationLabel.isHidden = false
        }
        else {
            notificationLabel.isHidden = true
        }
    }
}
