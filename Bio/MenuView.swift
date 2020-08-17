//
//  MenuView.swift
//  Bio
//
//  Created by Ann McDonough on 8/14/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit

class MenuView: UIView {
    
    var addPostButton: UIButton = UIButton()
    var newPostButton: UIButton = UIButton()
    var friendsButton: UIButton = UIButton()
    var settingsButton: UIButton = UIButton()
    var dmButton: UIButton = UIButton()
    var homeProfileButton: UIButton =  UIButton()
    var tabController: NavigationMenuBaseController? = nil
    
    
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
        self.addSubview(addPostButton)
        self.addSubview(newPostButton)
        self.addSubview(friendsButton)
        self.addSubview(settingsButton)
        self.addSubview(dmButton)
        self.addSubview(homeProfileButton)
        addPostButton.frame = CGRect(x: self.frame.width/2-40, y: self.frame.height - 83, width: 80, height: 80)
        //  addPostButton.imageView?.setupHexagonMask(lineWidth: 10.0, color: .black, cornerRadius: 10.0)
        // round ava
        addPostButton.layer.cornerRadius = addPostButton.frame.size.width / 2
        addPostButton.clipsToBounds = true
        
        
        newPostButton.frame = CGRect(x: 13, y: addPostButton.frame.minY, width: 80, height: 80)
        //  newPostButton.imageView?.setupHexagonMask(lineWidth: 10.0, color: .black, cornerRadius: 10.0)
        // round ava
        newPostButton.layer.cornerRadius = newPostButton.frame.size.width / 2
        newPostButton.clipsToBounds = true
        
        
        friendsButton.frame = CGRect(x: self.frame.width/2 - 40, y: self.frame.height - 203, width: 80, height: 80)
        // friendsButton.imageView?.setupHexagonMask(lineWidth: 10.0, color: .black, cornerRadius: 10.0)
        // round ava
        friendsButton.layer.cornerRadius = friendsButton.frame.size.width / 2
        friendsButton.clipsToBounds = true
        
        
        
        
        dmButton.frame = CGRect(x: self.frame.width*3/5 + 20, y: self.frame.height - 166, width: 80, height: 80)
        //  dmButton.imageView?.setupHexagonMask(lineWidth: 10.0, color: .black, cornerRadius: 10.0)
        // round ava
        dmButton.layer.cornerRadius = dmButton.frame.size.width / 2
        dmButton.clipsToBounds = true
        
        
        
        settingsButton.frame = CGRect(x: self.frame.width - 93, y: self.frame.height - 83, width: 80, height: 80)
        // settingsButton.imageView?.setupHexagonMask(lineWidth: 10.0, color: .black, cornerRadius: 10.0)
        // round ava
        settingsButton.layer.cornerRadius = settingsButton.frame.size.width / 2
        settingsButton.clipsToBounds = true
        
        
        
        homeProfileButton.frame = CGRect(x: self.frame.width/5 - 20, y: dmButton.frame.minY, width: 80, height: 80)
        // homeProfileButton.imageView?.setupHexagonMask(lineWidth: 10.0, color: .black, cornerRadius: 10.0)
        // round ava
        homeProfileButton.layer.cornerRadius = homeProfileButton.frame.size.width / 2
        homeProfileButton.clipsToBounds = true
        //        let curvedHeight = friendsButton.frame.minY - 10
        //        curvedRect = CGRect(x: 0.0, y: curvedHeight, width: self.frame.width, height: self.frame.height )
        //        var curvedRect = CGRect(x: 0.0, y: curvedHeight, width: scrollView.frame.width, height: scrollView.frame.height)
        //        curvedLayer = UIImageView(frame: curvedRect)
        //        curvedLayer.backgroundColor = gold
        //
        //        //round layer
        //        curvedLayer.layer.cornerRadius = curvedLayer.frame.size.width / 2
        //        curvedLayer.clipsToBounds = true
        
        let menuTapped = UITapGestureRecognizer(target: self, action: #selector(tappedMenuButton))
        let menuDragged = UIPanGestureRecognizer(target: self, action: #selector(draggedMenuButton))
        let menuLongPressed = UILongPressGestureRecognizer(target: self, action: #selector(longPressMenuButton))
        
        let friendsButtonPressed = UITapGestureRecognizer(target: self, action: #selector(friendsButtonClicked))
        let newPostButtonPressed = UITapGestureRecognizer(target: self, action: #selector(newPostButtonClicked))
//        let friendsButtonPressed = UITapGestureRecognizer(target: self, action: #selector(friendsButtonClicked))
        
        friendsButton.addGestureRecognizer(friendsButtonPressed)
        newPostButton.addGestureRecognizer(newPostButtonPressed)
        
        addPostButton.addGestureRecognizer(menuTapped)
        addPostButton.addGestureRecognizer(menuDragged)
        addPostButton.addGestureRecognizer(menuLongPressed)
        
        newPostButton.isHidden = true
        settingsButton.isHidden = true
        friendsButton.isHidden = true
        dmButton.isHidden = true
        homeProfileButton.isHidden = true
        //  curvedLayer.isHidden = true
        
        
        // show add Post button
        addPostButton.isHidden = false
        addPostButton.imageView?.image = UIImage(named: "k23")
        addPostButton.layer.zPosition = 2
    }
    
    @objc func friendsButtonClicked(_ sender: UIButton) {
        //      let profileHexGrid =   storyboard?.instantiateViewController(identifier: "ProfileHexGrid") as! BioProfileHexagonGrid2
        //        profileHexGrid.userData = userData
        //        self.dismiss(animated: false, completion: nil)
        //        present(profileHexGrid, animated: false)
        //self.dismiss(animated: false, completion: nil)
        let viewControllers = tabController!.customizableViewControllers!
        let profileGrid = (viewControllers[3] as! BioProfileHexagonGrid2)
        //profileGrid.userData = userData
        tabController!.viewControllers![3] = profileGrid
        tabController!.customTabBar.switchTab(from: 2, to: 3)
    }
    
    @objc func newPostButtonClicked(_ sender: UIButton) {
        //        let newPostVC =   storyboard?.instantiateViewController(identifier: "newPostVC") as! NewPostOptionsVC
        //        newPostVC.userData = userData
        //        self.dismiss(animated: false, completion: nil)
        //        present(newPostVC, animated: false)
        //        //self.dismiss(animated: false, completion: nil)
        let viewControllers = tabController!.customizableViewControllers!
        let newPostVC = (viewControllers[4] as! NewPostOptionsVC)
        //newPostVC.userData = userData
        tabController!.viewControllers![4] = newPostVC
        tabController!.customTabBar.switchTab(from: 2, to: 4)
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
