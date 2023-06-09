//
//  NavigationMenuBaseController.swift
//  Bio
//
//  Created by Ann McDonough on 8/12/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import FirebaseAuth
class NavigationMenuBaseController: UITabBarController, UINavigationControllerDelegate {
    var customTabBar: TabNavigationMenu!
    var tabBarHeight: CGFloat = 0.0 //67.0
    var userDataVM: UserDataVM? {
        didSet {
            if viewControllers != nil {
                for vc in viewControllers! {
                    switch vc {
                    case (is HomeHexagonGrid):
                        (vc as! HomeHexagonGrid).userDataVM = userDataVM
                    case (is NotificationsVC):
                        (vc as! NotificationsVC).userDataVM = userDataVM
                    case (is FriendsAndFeaturedVC):
                        (vc as! FriendsAndFeaturedVC).userDataVM = userDataVM
                    case (is NewPost5OptionsVC):
                        (vc as! NewPost5OptionsVC).userDataVM = userDataVM
                    default:
                        print("bad vc")
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadTabBar()
        self.moreNavigationController.delegate = self
        if (userDataVM?.userData.value == nil) {
            self.dismiss(animated: false, completion: nil)
        }
        else {
            if viewControllers != nil {
                for vc in viewControllers! {
                    switch vc {
                    case (is HomeHexagonGrid):
                        (vc as! HomeHexagonGrid).userDataVM = userDataVM
                    case (is NotificationsVC):
                        (vc as! NotificationsVC).userDataVM = userDataVM
                    case (is FriendsAndFeaturedVC):
                        (vc as! FriendsAndFeaturedVC).userDataVM = userDataVM
                    case (is NewPost5OptionsVC):
                        (vc as! NewPost5OptionsVC).userDataVM = userDataVM
                    default:
                        print("bad vc")
                    }
                }
            }
        }
    }
    
    @IBAction func unvindSegueFromAddToHome(segue:UIStoryboardSegue) {
        //let homeHexGrid = (tabBar.viewControllers![2] as! HomeHexagonGrid)
        //homeHexGrid.userData = userData
        //tabBar.viewControllers![2] = homeHexGrid
        customTabBar.switchTab(from: 4, to: 2) // to home controller
    }
    
    //override func viewWillAppear(_ animated: Bool) {}
    
    func loadTabBar() {
        let tabItems: [TabItem] = [.notifications, .dms, .home, .friends, .addPost]
        
        self.setupCustomTabMenu(tabItems) { (controllers) in
            self.viewControllers = controllers
        }
        if (Auth.auth().currentUser == nil) {
            self.dismiss(animated: false, completion: nil)// default our selected index to the first item
        }
        selectedIndex = 2
        
    }
    func setupCustomTabMenu(_ menuItems: [TabItem], completion: @escaping ([UIViewController]) -> Void) {
        // handle creation of the tab bar and attach touch event listeners
        
        let frame = tabBar.frame
        var controllers = [UIViewController]()
        // hide the tab bar
        tabBar.isHidden = true
        self.customTabBar = TabNavigationMenu(menuItems: menuItems, frame: frame)
        self.customTabBar.translatesAutoresizingMaskIntoConstraints = false
        self.customTabBar.clipsToBounds = true
        self.customTabBar.itemTapped = self.changeTab
        // Add it to the view
        self.view.addSubview(customTabBar)
        // Add positioning constraints to place the nav menu right where the tab bar should be
        NSLayoutConstraint.activate([
            self.customTabBar.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            self.customTabBar.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            self.customTabBar.widthAnchor.constraint(equalToConstant: tabBar.frame.width),
            self.customTabBar.heightAnchor.constraint(equalToConstant: tabBarHeight), // Fixed height for nav menu
            self.customTabBar.bottomAnchor.constraint(equalTo: tabBar.bottomAnchor)
        ])
        for i in 0 ..< menuItems.count {
            controllers.append(menuItems[i].viewController) // we fetch the matching view controller and append here
    }
        self.view.layoutIfNeeded() // important step
        completion(controllers) // setup complete. handoff here
    }
    func changeTab(tab: Int) {
        //self.customTabBar.switchTab(from: selectedIndex, to: tab)
        self.selectedIndex = tab
//        print("selectedIndex: \(selectedIndex)")
        
    }
}
