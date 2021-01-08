//
//  TabItem.swift
//  Bio
//
//  Created by Ann McDonough on 8/12/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import Firebase

enum TabItem: String, CaseIterable {
    case home = "Home"
    case friends = "Friends"
    case addPost = "Add Post"
    case notifications = "Notifications"
    case dms = "DMs"
    var viewController: UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch self {
        case .home:
            let homeVC = storyboard.instantiateViewController(identifier: "homeHexGrid420") as! HomeHexagonGrid
            homeVC.loadView()
            homeVC.viewDidLoad()
            return homeVC
            
        case .friends:
            let friendsVC = storyboard.instantiateViewController(identifier: "friendsAndFeaturedVC") as! FriendsAndFeaturedVC
            friendsVC.loadView()
            friendsVC.viewDidLoad()
            return friendsVC
        case .addPost:
            let newPostVC = storyboard.instantiateViewController(identifier: "newPost5OptionsVC") as! NewPost5OptionsVC
            newPostVC.loadView()
            newPostVC.viewDidLoad()
            return newPostVC
        case .notifications:
            let notifications = storyboard.instantiateViewController(identifier: "newsVC") as! NotificationsVC
            notifications.loadView()
            notifications.viewDidLoad()
            return notifications
        case .dms:
            let homeVC = storyboard.instantiateViewController(identifier: "newPost5OptionsVC") as! NewPost5OptionsVC
            homeVC.loadView()
            homeVC.viewDidLoad()
            return homeVC
        }
    }
    // these can be your icons
    var icon: UIImage {
        switch self {
        case .home:
            return UIImage(named: "pinterestLogo")!
            
        case .friends:
            return UIImage(named: "poshmarkLogo")!
        case .addPost:
            return UIImage(named: "snapchatlogo")!
        case .notifications:
            return UIImage(named: "spotifylogo")!
        case .dms:
            return UIImage(named: "twitterlogo")!
        }
        
    }
    var displayTitle: String {
        return self.rawValue.capitalized(with: nil)
    }
}
