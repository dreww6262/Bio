//
//  AppDelegate.swift
//  Bio
//
//  Created by Ann McDonough on 6/14/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//
import UIKit
//import FBSDKCoreKit
import Parse
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

 
    //copying from facebook instructions
    func application(
           _ application: UIApplication,
           didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
       ) -> Bool {
        
             //confiugratoin of using Parce code in Heroku
                let parseConfig = ParseClientConfiguration {(ParseClientConfiguration) in
                    print("had to comment out the mutable client configuration")
                    //accessing heroku app via id and keys
        //            ParseMutableClientConfiguration.applicationID = "dartVisualsPatrick"
        //            ParseMutableClientConfiguration.clientKey = "dartVisualsKeyPatrick123456789"
        //            ParseMutableClientConfiguration.server = "http://dartvisuals.herokuapp.com/parse"
                    //accessing heroku app via id and keys
           ParseClientConfiguration.applicationId = "biosocialmedia1234567890987654321"
                    ParseClientConfiguration.clientKey = "bioSocialMediaKey12345654321"
                    ParseClientConfiguration.server = "https://biosocialmedia.herokuapp.com/parse"

                }
                

                Parse.initialize(with: parseConfig)
             
           ApplicationDelegate.shared.application(
               application,
               didFinishLaunchingWithOptions: launchOptions
           )

           return true
       }
             
       func application(
           _ app: UIApplication,
           open url: URL,
           options: [UIApplication.OpenURLOptionsKey : Any] = [:]
       ) -> Bool {

           ApplicationDelegate.shared.application(
               app,
               open: url,
               sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
               annotation: options[UIApplication.OpenURLOptionsKey.annotation]
           )

       }
    
    
    
    
    
    
    
    
    
    
    var window: UIWindow?
    
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        // Override point for customization after application launch.
//
//        //confiugratoin of using Parce code in Heroku
//        let parseConfig = ParseClientConfiguration {(ParseClientConfiguration) in
//            print("had to comment out the mutable client configuration")
//            //accessing heroku app via id and keys
////            ParseMutableClientConfiguration.applicationID = "dartVisualsPatrick"
////            ParseMutableClientConfiguration.clientKey = "dartVisualsKeyPatrick123456789"
////            ParseMutableClientConfiguration.server = "http://dartvisuals.herokuapp.com/parse"
//            //accessing heroku app via id and keys
//   ParseClientConfiguration.applicationId = "biosocialmedia1234567890987654321"
//            ParseClientConfiguration.clientKey = "bioSocialMediaKey12345654321"
//            ParseClientConfiguration.server = "https://biosocialmedia.herokuapp.com/parse"
//
//        }
//
//
//        Parse.initialize(with: parseConfig)
//
//
//        return true
//}

    // MARK: UISceneSession Lifecycle
//@available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
//@available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func login() {

        // remember user's login
        let username : String? = UserDefaults.standard.string(forKey: "username")

        // if loged in
        if username != nil {
            print("This is the username were dealing with \(username!)")
            print("1")
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            print("2")
            let myTabBar = storyboard.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
            print("3")
              myTabBar.selectedIndex = 1   // or whatever you want
            print("4")
            window?.rootViewController = myTabBar
            print("5")
        }

    }


}

