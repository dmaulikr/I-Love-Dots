//
//  AppDelegate.swift
//  Dots!
//
//  Created by Chris Gilardi on 5/17/15.
//  Copyright (c) 2015 Chris Gilardi. All rights reserved.
//

import UIKit
import SpriteKit
import iAd
import GameKit
import Parse
import StoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ADBannerViewDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        println(DotsCommon.getDevice())
        
        //Setup Vungle
        var appID = "co.bluetruck.I-Love-Dots"
        var sdk = VungleSDK.sharedSDK()
        // start vungle publisher library
        sdk.startWithAppId(appID)
        
        var type = UIUserNotificationType.Badge | UIUserNotificationType.Alert | UIUserNotificationType.Sound
        var setting = UIUserNotificationSettings(forTypes: type, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(setting)
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        //Hook into Parse
        Parse.setApplicationId("f9a9d73IpJMa9vyYw142YZLxw7INZVJBIvkbXLRp",
            clientKey: "2Ao88WddOz3KFjlXHriHdJWLbSlkNOxQq66Fxo8u")
        
        // Register for Push Notitications
        if application.applicationState != UIApplicationState.Background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.
            
            let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
            let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
            var pushPayload = false
            if let options = launchOptions {
                pushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil
            }
            if (preBackgroundPush || oldPushHandlerOnly || pushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            }
        }
        if application.respondsToSelector("registerUserNotificationSettings:") {
            let userNotificationTypes = UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound
            let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
            let types = UIRemoteNotificationType.Badge | UIRemoteNotificationType.Alert | UIRemoteNotificationType.Sound
            application.registerForRemoteNotificationTypes(types)
        }
        
        if DotsCommon.userDefaults.objectForKey("adless") == nil {
            DotsCommon.userDefaults.setBool(false, forKey: "adless")
        }
        if DotsCommon.userDefaults.objectForKey("ach_professional") == nil {
            DotsCommon.userDefaults.setBool(false, forKey: "ach_professional")
        }
        if DotsCommon.userDefaults.objectForKey("ach_nerd") == nil {
            DotsCommon.userDefaults.setBool(false, forKey: "ach_nerd")
        }
        if DotsCommon.userDefaults.objectForKey("ach_fanatic") == nil {
            DotsCommon.userDefaults.setBool(false, forKey: "ach_fanatic")
        }
        if DotsCommon.userDefaults.objectForKey("ach_supportive") == nil {
            DotsCommon.userDefaults.setBool(false, forKey: "ach_supportive")
        }
        if DotsCommon.userDefaults.objectForKey("ach_unstable") == nil {
            DotsCommon.userDefaults.setBool(false, forKey: "ach_unstable")
        }
        if DotsCommon.userDefaults.objectForKey("ach_wiggles_logo") == nil {
            DotsCommon.userDefaults.setBool(false, forKey: "ach_wiggles_logo")
        }
        if DotsCommon.userDefaults.objectForKey("ach_wiggles_finalscore") == nil {
            DotsCommon.userDefaults.setBool(false, forKey: "ach_wiggles_finalscore")
        }
        if DotsCommon.userDefaults.objectForKey("ach_wiggles_playnum") == nil {
            DotsCommon.userDefaults.setBool(false, forKey: "ach_wiggles_playnum")
        }
        if DotsCommon.userDefaults.objectForKey("ach_wiggles") == nil {
            DotsCommon.userDefaults.setBool(DotsCommon.userDefaults.boolForKey("ach_wiggles_finalscore") && DotsCommon.userDefaults.boolForKey("ach_wiggles_logo") && DotsCommon.userDefaults.boolForKey("ach_wiggles_playnum"), forKey: "ach_wiggles")
        } else {
            DotsCommon.userDefaults.setBool(DotsCommon.userDefaults.boolForKey("ach_wiggles_finalscore") && DotsCommon.userDefaults.boolForKey("ach_wiggles_logo") && DotsCommon.userDefaults.boolForKey("ach_wiggles_playnum"), forKey: "ach_wiggles")
        }
        if DotsCommon.userDefaults.objectForKey("ach_indecisive") == nil {
            DotsCommon.userDefaults.setBool(false, forKey: "ach_indecisive")
        }
    
        println(DotsCommon.userDefaults.boolForKey("ach_wiggles").description + " " + DotsCommon.userDefaults.boolForKey("ach_wiggles_finalscore").description + " " + DotsCommon.userDefaults.boolForKey("ach_wiggles_logo").description + " " + DotsCommon.userDefaults.boolForKey("ach_wiggles_playnum").description)
        
        
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            println("Push notifications are not supported in the iOS Simulator.")
        } else {
            println("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
        if application.applicationState == UIApplicationState.Inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
        }
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

