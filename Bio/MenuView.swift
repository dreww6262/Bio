//
//  MenuView.swift
//  Bio
//
//  Created by Ann McDonough on 8/14/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit

class MenuView: UIView {
    
    var menuButton: UIButton = UIButton()
    var newPostButton: UIButton = UIButton()
    var friendsButton: UIButton = UIButton()
    var settingsButton: UIButton = UIButton()
    var dmButton: UIButton = UIButton()
    var homeProfileButton: UIButton =  UIButton()
    var tabController: NavigationMenuBaseController? = nil
    var userData: UserData? = nil
    
    var currentTab: Int = 0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addBehavior()
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
        self.superview!.addSubview(menuButton)
        self.superview!.addSubview(newPostButton)
        self.superview!.addSubview(friendsButton)
        self.superview!.addSubview(settingsButton)
        self.superview!.addSubview(dmButton)
        self.superview!.addSubview(homeProfileButton)
        
        
        self.backgroundColor = .white
        
        print("menuFrame \(self.frame)")
        
        menuButton.frame = CGRect(x: self.frame.width/2-40, y: self.superview!.frame.height-120, width: 80, height: 80)
        // round ava
        menuButton.layer.cornerRadius = menuButton.frame.size.width / 2
        menuButton.clipsToBounds = true
        print ("menuButton frame \(menuButton.frame)")
        
        newPostButton.frame = CGRect(x: self.frame.width/5 - 40, y: menuButton.frame.minY, width: 80, height: 80)
        //  newPostButton.imageView?.setupHexagonMask(lineWidth: 10.0, color: .black, cornerRadius: 10.0)
        // round ava
        newPostButton.layer.cornerRadius = newPostButton.frame.size.width / 2
        newPostButton.clipsToBounds = true
        print ("newpost frame \(newPostButton.frame)")
        
        friendsButton.frame = CGRect(x: self.frame.width/2 - 40, y: self.superview!.frame.height - 203, width: 80, height: 80)
        // friendsButton.imageView?.setupHexagonMask(lineWidth: 10.0, color: .black, cornerRadius: 10.0)
        // round ava
        friendsButton.layer.cornerRadius = friendsButton.frame.size.width / 2
        friendsButton.clipsToBounds = true
        print ("friends frame \(friendsButton.frame)")
        
        
        
        dmButton.frame = CGRect(x: self.frame.width*3/5 + 20, y: self.superview!.frame.height - 166, width: 80, height: 80)
        //  dmButton.imageView?.setupHexagonMask(lineWidth: 10.0, color: .black, cornerRadius: 10.0)
        // round ava
        dmButton.layer.cornerRadius = dmButton.frame.size.width / 2
        dmButton.clipsToBounds = true
        print ("dm frame \(dmButton.frame)")
        
        
        settingsButton.frame = CGRect(x: self.frame.width*4/5 - 40, y: self.superview!.frame.height - 83, width: 80, height: 80)
        // settingsButton.imageView?.setupHexagonMask(lineWidth: 10.0, color: .black, cornerRadius: 10.0)
        // round ava
        settingsButton.layer.cornerRadius = settingsButton.frame.size.width / 2
        settingsButton.clipsToBounds = true
        print ("settings frame \(settingsButton.frame)")
        
        
        homeProfileButton.frame = CGRect(x: self.frame.width/5 - 20, y: dmButton.frame.minY, width: 80, height: 80)
        // homeProfileButton.imageView?.setupHexagonMask(lineWidth: 10.0, color: .black, cornerRadius: 10.0)
        // round ava
        homeProfileButton.layer.cornerRadius = homeProfileButton.frame.size.width / 2
        homeProfileButton.clipsToBounds = true
        print("home frame \(homeProfileButton.frame)")
        
        
        let menuTapped = UITapGestureRecognizer(target: self, action: #selector(tappedMenuButton))
        let menuDragged = UIPanGestureRecognizer(target: self, action: #selector(draggedMenuButton))
        let menuLongPressed = UILongPressGestureRecognizer(target: self, action: #selector(longPressMenuButton))
        let friendsPressed = UITapGestureRecognizer(target: self, action: #selector(friendsButtonClicked))
        let homePressed = UITapGestureRecognizer(target: self, action: #selector(homeButtonClicked))
        let newPostPressed = UITapGestureRecognizer(target: self, action: #selector(newPostButtonClicked))

        menuButton.addGestureRecognizer(menuTapped)
        menuButton.addGestureRecognizer(menuDragged)
        menuButton.addGestureRecognizer(menuLongPressed)
        
        friendsButton.addGestureRecognizer(friendsPressed)
        homeProfileButton.addGestureRecognizer(homePressed)
        newPostButton.addGestureRecognizer(newPostPressed)
        
        //hide buttons
        newPostButton.isHidden = true
        settingsButton.isHidden = true
        friendsButton.isHidden = true
        dmButton.isHidden = true
        homeProfileButton.isHidden = true
        
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
        settingsButton.imageView?.makeRounded()
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
        //curvedLayer.isHidden = true
    }
    
    func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt(xDist * xDist + yDist * yDist))
    }
}
