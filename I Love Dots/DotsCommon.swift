//
//  DotsCommon.swift
//  I Love Dots
//
//  Created by Chris Gilardi on 7/1/15.
//  Copyright (c) 2015 Chris Gilardi. All rights reserved.
//

import Foundation
import SpriteKit
import GameKit

import UIKit

private let DeviceList = [
    /* iPod 5 */          "iPod5,1": "iPod Touch 5",
    /* iPhone 4 */        "iPhone3,1":  "iPhone 4", "iPhone3,2": "iPhone 4", "iPhone3,3": "iPhone 4",
    /* iPhone 4S */       "iPhone4,1": "iPhone 4S",
    /* iPhone 5 */        "iPhone5,1": "iPhone 5", "iPhone5,2": "iPhone 5",
    /* iPhone 5C */       "iPhone5,3": "iPhone 5C", "iPhone5,4": "iPhone 5C",
    /* iPhone 5S */       "iPhone6,1": "iPhone 5S", "iPhone6,2": "iPhone 5S",
    /* iPhone 6 */        "iPhone7,2": "iPhone 6",
    /* iPhone 6 Plus */   "iPhone7,1": "iPhone 6 Plus",
    /* iPad 2 */          "iPad2,1": "iPad 2", "iPad2,2": "iPad 2", "iPad2,3": "iPad 2", "iPad2,4": "iPad 2",
    /* iPad 3 */          "iPad3,1": "iPad 3", "iPad3,2": "iPad 3", "iPad3,3": "iPad 3",
    /* iPad 4 */          "iPad3,4": "iPad 4", "iPad3,5": "iPad 4", "iPad3,6": "iPad 4",
    /* iPad Air */        "iPad4,1": "iPad Air", "iPad4,2": "iPad Air", "iPad4,3": "iPad Air",
    /* iPad Air 2 */      "iPad5,1": "iPad Air 2", "iPad5,3": "iPad Air 2", "iPad5,4": "iPad Air 2",
    /* iPad Mini */       "iPad2,5": "iPad Mini", "iPad2,6": "iPad Mini", "iPad2,7": "iPad Mini",
    /* iPad Mini 2 */     "iPad4,4": "iPad Mini", "iPad4,5": "iPad Mini", "iPad4,6": "iPad Mini",
    /* iPad Mini 3 */     "iPad4,7": "iPad Mini", "iPad4,8": "iPad Mini", "iPad4,9": "iPad Mini",
    /* Simulator */       "x86_64": "Simulator", "i386": "Simulator"
]

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let machine = systemInfo.machine
        let mirror = reflect(machine)
        var identifier = ""
        
        for i in 0..<mirror.count {
            if let value = mirror[i].1.value as? Int8 where value != 0 {
                identifier.append(UnicodeScalar(UInt8(value)))
            }
        }
        return DeviceList[identifier] ?? identifier
    }
    
}

class DotsCommon {
    static let font = "ArmagedaWide"
    static let userDefaults = NSUserDefaults.standardUserDefaults()
    
    static func getDevice() -> String {
        return UIDevice.currentDevice().modelName
    }
    
    static func getColor(color: Int) -> SKColor {
        let rainbow: [SKColor] = [SKColor.redColor(), SKColor.magentaColor(), SKColor.orangeColor(), SKColor.yellowColor(), SKColor.greenColor(), SKColor.cyanColor(), SKColor.blueColor(), SKColor.purpleColor()]
        return rainbow[color%rainbow.count]
    }
    
    static func showAds() {
        NSNotificationCenter.defaultCenter().postNotificationName("showiAdBanner", object: nil)
    }
    
    static func hideAds() {
        NSNotificationCenter.defaultCenter().postNotificationName("hideiAdBanner", object: nil)
    }
    
    static func AMShowAds() {
        NSNotificationCenter.defaultCenter().postNotificationName("AMShowAds", object: nil)
        println("Showing AdMob Interstitial!")
    }
    
    static func VShowAds() {
        NSNotificationCenter.defaultCenter().postNotificationName("VShowAds", object: nil)
        println("Showing Vungle Ads!")
    }
    
    static func showShareView() {
        NSNotificationCenter.defaultCenter().postNotificationName("showSharingView", object: nil)
    }

    static func showLeaderboard() {
        NSNotificationCenter.defaultCenter().postNotificationName("showLeaderboard", object: nil)
    }
    
    static func getAdStatus() -> Bool {
        return userDefaults.boolForKey("adless")
    }
    
    static func buyAdless() {
        NSNotificationCenter.defaultCenter().postNotificationName("buyAdless", object: nil)
    }
    
    static func restorePurchase() {
        NSNotificationCenter.defaultCenter().postNotificationName("restorePurchase", object: nil)
    }
    
    static func showBetaAlert() {
        NSNotificationCenter.defaultCenter().postNotificationName("showAlertView", object: nil)
    }
    
    static func wiggle() -> SKAction {
        let timeInterval: NSTimeInterval = 0.125
        return SKAction.sequence([SKAction.rotateByAngle(-0.26179938779, duration: timeInterval), SKAction.rotateByAngle(0.52359877559, duration: timeInterval), SKAction.rotateByAngle(-0.52359877559, duration: timeInterval), SKAction.rotateByAngle(0.52359877559, duration: timeInterval), SKAction.rotateByAngle(-0.26179938779, duration: timeInterval)])
    }
    
    static func slideInFromSide(frame: CGRect) -> SKAction {
        return SKAction.moveTo(CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame)), duration: 0.175)
    }
    
    static func slideOutLeft(frame: CGRect, width: CGFloat) -> SKAction {
        return SKAction.moveTo(CGPointMake(CGRectGetMinX(frame) - width, CGRectGetMidY(frame)), duration: 0.175)
    }
    
    static func getMuteStatus() {
        if userDefaults.boolForKey("mutestatus") as Bool? == nil {
            userDefaults.setBool(false, forKey: "mutestatus")
        }
        else {return}
    }
    
    static func resetPlaysIfNeeded() {
        let numberOfPlays: Int? = userDefaults.integerForKey("playnum")
        if numberOfPlays == nil {
            userDefaults.setInteger(0, forKey: "playnum")
        }
    }
    
    static func hostMP(){
        NSNotificationCenter.defaultCenter().postNotificationName("hostMultiplayerGame", object: nil)
    }
    
    static func checkWiggles_Ach() -> Bool{
        userDefaults.setBool(userDefaults.boolForKey("ach_wiggles_logo") && userDefaults.boolForKey("ach_wiggles_finalscore") && userDefaults.boolForKey("ach_wiggles_playnum"), forKey: "ach_wiggles")
        println("Will work: " + userDefaults.boolForKey("ach_wiggles").description)
        return userDefaults.boolForKey("ach_wiggles")
    }
    
    static func achieveWiggles() {
        if userDefaults.boolForKey("ach_wiggles"){
            println("passed 1")
            if GKLocalPlayer.localPlayer().authenticated {
                println("passed 2")
                let thisachievement = GKAchievement(identifier: "co.bluetruck.wiggles_ach")
                thisachievement.percentComplete = 100
                thisachievement.showsCompletionBanner = true
                GKAchievement.reportAchievements([thisachievement], withCompletionHandler: ( { (error: NSError!) -> Void in
                    if error != nil {
                        println("Error: " + error.localizedDescription)
                    } else {
                        println("Achievement reported: \(thisachievement.identifier)")
                    }
                }))
                DotsCommon.userDefaults.setBool(true, forKey: "ach_wiggles")
            }
        }
    }
    
    static func isiPad() -> Bool {
        if(UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad) {
            return true
        } else {return false}
    }
    
}