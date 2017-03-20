//
//  AppDelegate.swift
//  MADemo
//
//  Created by Yancen Li on 3/16/17.
//  Copyright © 2017 Yancen Li. All rights reserved.
//

import UIKit
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: HomeController())
        window?.makeKeyAndVisible()
        
        GADMobileAds.configure(withApplicationID: "ca-app-pub-3818139859760841~7873427813")
        
        return true
    }

}

