//
//  SceneDelegate.swift
//  Bio
//
//  Created by Ann McDonough on 6/14/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
//import Parse
//import FBSDKLoginKit
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

//    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
//        guard let url = URLContexts.first?.url else {
//            return
//        }
//
//        ApplicationDelegate.shared.application(
//            UIApplication.shared,
//            open: url,
//            sourceApplication: nil,
//            annotation: [UIApplication.OpenURLOptionsKey.annotation]
//        )
//    }
    

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

//    func login() {
//        
//        // remember user's login
//        let username : String? = UserDefaults.standard.string(forKey: "username")
//        
//        // if loged in
//        if username != nil {
//            print("This is the username were dealing with \(username!)")
//            print("1")
//            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            print("2")
//            let myTabBar = storyboard.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
//            print("3")
//              myTabBar.selectedIndex = 1   // or whatever you want
//            print("4")
//            window?.rootViewController = myTabBar
//            print("5")
//        }
//        
//    }
    

}

