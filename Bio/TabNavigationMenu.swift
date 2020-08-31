//
//  TabNavigationMenu.swift
//  Bio
//
//  Created by Ann McDonough on 8/12/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import FirebaseAuth

class TabNavigationMenu: UIView {
    var itemTapped: ((_ tab: Int) -> Void)?
    var activeItem: Int = 0
    var tabItems: [TabItem]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    convenience init(menuItems: [TabItem], frame: CGRect) {
        self.init(frame: frame)
        // Convenience init body
        tabItems = menuItems
        self.layer.backgroundColor = UIColor.white.cgColor
        for i in 0 ..< menuItems.count {
            let itemWidth = self.frame.width / CGFloat(menuItems.count)
            let leadingAnchor = itemWidth * CGFloat(i)
            
            let itemView = self.createTabItem(item: menuItems[i])
            itemView.translatesAutoresizingMaskIntoConstraints = false
            itemView.clipsToBounds = true
            itemView.tag = i
            self.addSubview(itemView)
            NSLayoutConstraint.activate([
                itemView.heightAnchor.constraint(equalTo: self.heightAnchor),
                itemView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leadingAnchor),
                itemView.topAnchor.constraint(equalTo: self.topAnchor),
            ])
        }
        self.setNeedsLayout()
        self.layoutIfNeeded()

        if (Auth.auth().currentUser == nil){
            self.activateTab(tab: 5) // activate the first tab
        }
        else {
            self.activateTab(tab: 2)
        }
    }
    
    func createTabItem(item: TabItem) -> UIView {
        let tabBarItem = UIView(frame: CGRect.zero)
        let itemTitleLabel = UILabel(frame: CGRect.zero)
        let itemIconView = UIImageView(frame: CGRect.zero)
        itemTitleLabel.text = item.displayTitle
        itemTitleLabel.textAlignment = .center
        itemTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        itemTitleLabel.clipsToBounds = true
        
        itemIconView.image = item.icon.withRenderingMode(.automatic)
        itemIconView.translatesAutoresizingMaskIntoConstraints = false
        itemIconView.clipsToBounds = true
        tabBarItem.layer.backgroundColor = UIColor.white.cgColor
        tabBarItem.addSubview(itemIconView)
        tabBarItem.addSubview(itemTitleLabel)
        tabBarItem.translatesAutoresizingMaskIntoConstraints = false
        tabBarItem.clipsToBounds = true
        NSLayoutConstraint.activate([
            itemIconView.heightAnchor.constraint(equalToConstant: 25), // Fixed height for our tab item(25pts)
            itemIconView.widthAnchor.constraint(equalToConstant: 25), // Fixed width for our tab item icon
            itemIconView.centerXAnchor.constraint(equalTo: tabBarItem.centerXAnchor),
            itemIconView.topAnchor.constraint(equalTo: tabBarItem.topAnchor, constant: 8), // Position menu item icon 8pts from the top of it's parent view
            itemIconView.leadingAnchor.constraint(equalTo: tabBarItem.leadingAnchor, constant: 35),
            itemTitleLabel.heightAnchor.constraint(equalToConstant: 13), // Fixed height for title label
            itemTitleLabel.widthAnchor.constraint(equalTo: tabBarItem.widthAnchor), // Position label full width across tab bar item
            itemTitleLabel.topAnchor.constraint(equalTo: itemIconView.bottomAnchor, constant: 4), // Position title label 4pts below item icon
        ])
        tabBarItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap))) // Each item should be able to trigger and action on tap
        return tabBarItem
        
    }
    @objc func handleTap(_ sender: UIGestureRecognizer) {
        self.switchTab(from: self.activeItem, to: sender.view!.tag)
    }
    func switchTab(from: Int, to: Int) {
        self.deactivateTab(tab: from)
        self.activateTab(tab: to)
    }
    func activateTab(tab: Int) {
        
        let tabToActivate = self.subviews[tab]
        let borderWidth = tabToActivate.frame.size.width - 20
        let borderLayer = CALayer()
        borderLayer.backgroundColor = UIColor.green.cgColor
        borderLayer.name = "active border"
        borderLayer.frame = CGRect(x: 10, y: 0, width: borderWidth, height: 2)
        prepareForeSwitch(tab: tab)
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.8, delay: 0.0, options: [.curveEaseIn, .allowUserInteraction], animations: {
                tabToActivate.layer.addSublayer(borderLayer)
                tabToActivate.setNeedsLayout()
                tabToActivate.layoutIfNeeded()
            })
            self.itemTapped?(tab)
        }
        self.activeItem = tab
    }
    
    func prepareForeSwitch(tab: Int) {
        switch tab {
                //case 0:
                    // settings does not need to refresh
        //            (tabItems![tab].viewController as! HomeHexagonGrid).refresh()
                case 1:
                    print("dm tab")
                    // change to valid DM View Controller
                    //(tabItems![tab].viewController as! dms).refresh()
                case 2:
                    print("home tab")
                    let homeGrid = (tabItems![tab].viewController as! HomeHexagonGrid)
                    //homeGrid.loadView()
                    //homeGrid.refresh()
                case 3:
                    print("friends tab")
                    let friendsGrid = (tabItems![tab].viewController as! BioProfileHexagonGrid2)
                    //friendsGrid.loadView()
                    //friendsGrid.refresh()
                case 4:
                    print("add Post tab")
                    let newPostVC = (tabItems![tab].viewController as! NewPostOptionsVC)
                    //newPostVC.loadView()
                    //newPostVC.refresh()
                    // add post does not need to refresh
        //            .refresh()
                case 5:
                    print("signin tab")
                    // sign in does not need to refresh
                    let phoneVC = (tabItems![tab].viewController as! PhoneSignInVC)
//                              print("settings tab")
//                              // sign in does not need to refresh
//                              let settingsVC = (tabItems![tab].viewController as! SettingsVCGradient)
                    //phoneVC.loadView()
        //            (tabItems![tab].viewController as! HomeHexagonGrid).refresh()
                default:
                    print("not possible... not a valid tab")
                }
    }
    
    func deactivateTab(tab: Int) {
        let inactiveTab = self.subviews[tab]
        let layersToRemove = inactiveTab.layer.sublayers!.filter({ $0.name == "active border" })
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, delay: 0.0, options: [.curveEaseIn, .allowUserInteraction], animations: {
                layersToRemove.forEach({ $0.removeFromSuperlayer() })
                inactiveTab.setNeedsLayout()
                inactiveTab.layoutIfNeeded()
            })
        }
    }
}


//Put in other VC viewdidload
//
//self.view.backgroundColor = UIColor.white
//let label = UILabel(frame: CGRect.zero)
//label.text = "[CONTROLLER_NAME] View Controller"
//label.font = UIFont.systemFont(ofSize: 16)
//label.translatesAutoresizingMaskIntoConstraints = false
//label.clipsToBounds = true
//label.sizeToFit()
//self.view.addSubview(label)
//NSLayoutConstraint.activate([
//    label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//    label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
//])
