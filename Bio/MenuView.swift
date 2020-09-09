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
    
    var menuButton: UIButton = UIButton()
    var newPostButton: UIButton = UIButton()
    var friendsButton: UIButton = UIButton()
    var notificationsButton: UIButton = UIButton()
    var dmButton: UIButton = UIButton()
    var homeProfileButton: UIButton =  UIButton()
    var tabController: NavigationMenuBaseController?
    var userData: UserData?
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
            db.collection("UserData1").whereField("email", isEqualTo: user!.email!).addSnapshotListener({ objects, error in
                if error == nil {
                    guard let docs = objects?.documents
                        else{
                            print("bad docs")
                            return
                    }
                    
                    if docs.count == 0 {
                        print("no userdata found.... fix this")
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
        
        
        //self.backgroundColor = .white
        
//        print("superFrame \(superFrame)")
        
        menuButton.frame = CGRect(x: superFrame.width/2-40, y: superFrame.height-112, width: 80, height: 80)
        // round ava
        menuButton.layer.cornerRadius = menuButton.frame.size.width / 2
        menuButton.clipsToBounds = true
//        print ("menuButton frame \(menuButton.frame)")
        
        newPostButton.frame = CGRect(x: superFrame.width/5 - 40, y: menuButton.frame.minY, width: 80, height: 80)
        //  newPostButton.imageView?.setupHexagonMask(lineWidth: 10.0, color: .black, cornerRadius: 10.0)
        // round ava
        newPostButton.layer.cornerRadius = newPostButton.frame.size.width / 2
        newPostButton.clipsToBounds = true
//        print ("newpost frame \(newPostButton.frame)")
        
        friendsButton.frame = CGRect(x: superFrame.width/2 - 40, y: superFrame.height - 223, width: 80, height: 80)
        // friendsButton.imageView?.setupHexagonMask(lineWidth: 10.0, color: .black, cornerRadius: 10.0)
        // round ava
        friendsButton.layer.cornerRadius = friendsButton.frame.size.width / 2
        friendsButton.clipsToBounds = true
//        print ("friends frame \(friendsButton.frame)")
        
        
        
        dmButton.frame = CGRect(x: superFrame.width*3/5 + 5, y: superFrame.height - 192, width: 80, height: 80)
        //  dmButton.imageView?.setupHexagonMask(lineWidth: 10.0, color: .black, cornerRadius: 10.0)
        // round ava
        dmButton.layer.cornerRadius = dmButton.frame.size.width / 2
        dmButton.clipsToBounds = true
//        print ("dm frame \(dmButton.frame)")
        
        
        notificationsButton.frame = CGRect(x: superFrame.width*4/5 - 40, y: superFrame.height - 112, width: 80, height: 80)
        // settingsButton.imageView?.setupHexagonMask(lineWidth: 10.0, color: .black, cornerRadius: 10.0)
        // round ava
        notificationsButton.layer.cornerRadius = notificationsButton.frame.size.width / 2
        notificationsButton.clipsToBounds = true
//        print ("settings frame \(settingsButton.frame)")
        
        
        homeProfileButton.frame = CGRect(x: superFrame.width/5 - 10, y: dmButton.frame.minY, width: 80, height: 80)
        // homeProfileButton.imageView?.setupHexagonMask(lineWidth: 10.0, color: .black, cornerRadius: 10.0)
        // round ava
        homeProfileButton.layer.cornerRadius = homeProfileButton.frame.size.width / 2
        homeProfileButton.clipsToBounds = true
//        print("home frame \(homeProfileButton.frame)")
        
        
        let menuTapped = UITapGestureRecognizer(target: self, action: #selector(tappedMenuButton))
        let menuDragged = UIPanGestureRecognizer(target: self, action: #selector(draggedMenuButton))
        let menuLongPressed = UILongPressGestureRecognizer(target: self, action: #selector(longPressMenuButton))
//        let friendsPressed = UITapGestureRecognizer(target: self, action: #selector(friendsButtonClicked))
//        let homePressed = UITapGestureRecognizer(target: self, action: #selector(homeButtonClicked))
//        let newPostPressed = UITapGestureRecognizer(target: self, action: #selector(newPostButtonClicked))

        menuButton.addGestureRecognizer(menuTapped)
        menuButton.addGestureRecognizer(menuDragged)
        menuButton.addGestureRecognizer(menuLongPressed)
        
//        friendsButton.addGestureRecognizer(friendsPressed)
//        homeProfileButton.addGestureRecognizer(homePressed)
//        newPostButton.addGestureRecognizer(newPostPressed)
        
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
        
        newPostButton.setImage(UIImage(named: "plusImage"), for: .normal)
        notificationsButton.setImage(UIImage(named: "settingsGear"), for: .normal)
        friendsButton.setImage(UIImage(named: "boyprofile"), for: .normal)
        dmButton.setImage(UIImage(named: "mailcircle"), for: .normal)
        homeProfileButton.setImage(UIImage(named: "stickFigure"), for: .normal)
        menuButton.setImage(UIImage(named: "plusImage"), for: .normal)
        
        newPostButton.tintColor = .black
        notificationsButton.tintColor = .black
        friendsButton.tintColor = .black
        dmButton.tintColor = .black
        homeProfileButton.tintColor = .white
        menuButton.tintColor = .black
        
        newPostButton.backgroundColor = .black
        notificationsButton.backgroundColor = .black
        friendsButton.backgroundColor = .white
        dmButton.backgroundColor = .black
        homeProfileButton.backgroundColor = .black
        menuButton.backgroundColor = .black
        newPostButton.imageView!.image = UIImage(named: "plus")
        notificationsButton.imageView!.image = UIImage(named: "gear")
        friendsButton.imageView!.image = UIImage(named: "community2")
        dmButton.imageView!.image = UIImage(named: "plus")
        homeProfileButton.imageView!.image = UIImage(named: "home2")

        
        // show add Post button
        menuButton.isHidden = false
        menuButton.imageView?.image = UIImage(named: "k23")
        menuButton.layer.zPosition = 2
    }
    
    @objc func friendsButtonClicked(_ sender: UIButton) {
        let viewControllers = tabController!.customizableViewControllers!
        let profileGrid = (viewControllers[3] as! BioProfileHexagonGrid2)
        profileGrid.userData = userData
        tabController!.viewControllers![3] = profileGrid
        tabController!.customTabBar.switchTab(from: currentTab, to: 3)
    }
    
    @objc func newPostButtonClicked(_ sender: UIButton) {
        let viewControllers = tabController!.customizableViewControllers!
        let newPostVC = (viewControllers[4] as! NewPostOptionsVC)
        newPostVC.userData = userData
        tabController!.viewControllers![4] = newPostVC
        tabController!.customTabBar.switchTab(from: currentTab, to: 4)
    }
    
    @objc func notificationsButtonClicked(_ sender: UIButton) {
        let viewControllers = tabController!.customizableViewControllers!
        let notificationsVC = (viewControllers[0] as! NotificationsVC)
        notificationsVC.userData = userData
        tabController!.viewControllers![0] = notificationsVC
        tabController!.customTabBar.switchTab(from: currentTab, to: 0)
    }
    
    @objc func homeButtonClicked(_ sender: Any) {
        let viewControllers = tabController!.customizableViewControllers!
        let homeVC = (viewControllers[2] as! HomeHexagonGrid)
        homeVC.userData = userData
        tabController!.viewControllers![2] = homeVC
        tabController!.customTabBar.switchTab(from: currentTab, to: 2)
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
        notificationsButton.imageView?.makeRounded()
        friendsButton.imageView?.makeRounded()
        menuButton.imageView?.makeRounded()
    }
    
    @objc func draggedMenuButton(sender: UIPanGestureRecognizer) {
        var point : CGPoint = sender.translation(in: self)
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
