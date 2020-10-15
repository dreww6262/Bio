//
//  TabItem.swift
//  Bio
//
//  Created by Ann McDonough on 8/12/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
enum TabItem: String, CaseIterable {
    case home = "Home"
    case friends = "Friends"
    case addPost = "Add Post"
    case notifications = "Notifications"
    case dms = "DMs"
    case signIn
var viewController: UIViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
        switch self {
        case .home:
            let homeVC = storyboard.instantiateViewController(identifier: "homeHexGrid420") as! HomeHexagonGrid
            homeVC.loadView()
            homeVC.viewDidLoad()
            return homeVC
    
        case .friends:
            let friendsVC = storyboard.instantiateViewController(identifier: "ProfileHexGrid") as! BioProfileHexagonGrid2
            friendsVC.loadView()
            friendsVC.viewDidLoad()
            return friendsVC
        case .addPost:
            let newPostVC = storyboard.instantiateViewController(identifier: "newPostVC") as! NewPostColorfulVC
            newPostVC.loadView()
            newPostVC.viewDidLoad()
            return newPostVC
        case .notifications:
            let notifications = storyboard.instantiateViewController(identifier: "newsVC") as! NotificationsVC
            notifications.loadView()
            notifications.viewDidLoad()
            return notifications
        case .dms:
            let homeVC = storyboard.instantiateViewController(identifier: "newPostVC") as! NewPostColorfulVC
            homeVC.loadView()
            homeVC.viewDidLoad()
            return homeVC
        case .signIn:
            let signInVC = storyboard.instantiateViewController(identifier:"phoneSignIn") as! PhoneSignInVC
            signInVC.loadView()
            signInVC.viewDidLoad()
            return signInVC
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
        case .signIn:
            return UIImage(named: "twitterlogo")!
        }
        
    }
var displayTitle: String {
        return self.rawValue.capitalized(with: nil)
    }
}