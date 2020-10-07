//
//  AppDelegate.swift
//  Bio
//
//  Created by Ann McDonough on 6/14/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//
import UIKit
//import FBSDKCoreKit
//import Parse
//import FBSDKCoreKit
import Firebase
import FirebaseCore
import FirebaseFirestore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //This stuff is from firebase for phoneNumber
    var window: UIWindow?
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        //For testing purposes only*****
        Firestore.firestore().clearPersistence(completion: { error in
            if error != nil {
                print("Could not enable persistence: \(error?.localizedDescription)")
            }
        })
        // clears persistence data for firesetore
        return true
    }
    
    
    
    
    
    //~~~~~~~~private ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // Parse things
    
    
    //    //copying from facebook instructions
    //    private func application(
    //           _ application: UIApplication,
    //           didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    //       ) -> Bool {
    //
    //             //confiugratoin of using Parce code in Heroku
    //                let parseConfig = ParseClientConfiguration {(ParseClientConfiguration) in
    //                    print("had to comment out the mutable client configuration")
    //
    //                    //accessing heroku app via id and keys
    //           ParseClientConfiguration.applicationId = "biosocialmedia1234567890987654321"
    //                    ParseClientConfiguration.clientKey = "bioSocialMediaKey12345654321"
    //                    ParseClientConfiguration.server = "https://biosocialmedia.herokuapp.com/parse"
    //
    //                }
    //
    //
    //                Parse.initialize(with: parseConfig)
    //
    //           ApplicationDelegate.shared.application(
    //               application,
    //               didFinishLaunchingWithOptions: launchOptions
    //           )
    //
    //           return true
    //       }
//    
//    func application(
//        _ app: UIApplication,
//        open url: URL,
//        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
//    ) -> Bool {
//        
//        ApplicationDelegate.shared.application(
//            app,
//            open: url,
//            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
//            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
//        )
//        
//    }
//    
    
    
    
    
    
    
    
    
    
    
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
    
    
}

