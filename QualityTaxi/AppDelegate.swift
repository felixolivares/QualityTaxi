//
//  AppDelegate.swift
//  QualityTaxi
//
//  Created by Felix Olivares on 11/4/15.
//  Copyright © 2015 Felix Olivares. All rights reserved.
//

import UIKit
import MagicalRecord
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.    
        
        
        MagicalRecord.setupCoreDataStackWithStoreNamed("QualityTaxi")
        
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        navigationBarAppearace.tintColor = UIColor(rgb: 0xffffff)
        navigationBarAppearace.translucent = false
//        navigationBarAppearace.barTintColor = UIColor(rgb: 0x456190)183C58
        navigationBarAppearace.barTintColor = UIColor(rgb: 0x183C58)
        navigationBarAppearace.shadowImage = UIImage()
        navigationBarAppearace.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
//        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)

        
        GMSServices.provideAPIKey("AIzaSyBLkLS7K3MLLJt22Ra7DdmSVao12P2_yTY")                                
        
        IQKeyboardManager.sharedManager().enable = true
        
        QualityUser.MR_truncateAll()
        QualityTrip.MR_truncateAll()
        
        QTUserManager.sharedInstance
        QTFakeUsers().createUsers()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

