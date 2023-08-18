//
//  AppDelegate.swift
//  FrontLinkSDKTestApp
//
//  Created by Alexander on 3/13/23.
//

import UIKit
import FrontLinkSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let customNavBarAppearance = UINavigationBarAppearance()
        customNavBarAppearance.configureWithOpaqueBackground()
        customNavBarAppearance.backgroundColor = UIColor.white
        customNavBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        let appearance = UINavigationBar.appearance()
        appearance.scrollEdgeAppearance = customNavBarAppearance
        appearance.compactAppearance = customNavBarAppearance
        appearance.standardAppearance = customNavBarAppearance
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
