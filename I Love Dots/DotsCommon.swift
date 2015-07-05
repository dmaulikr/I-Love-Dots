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

class DotsCommon {
    static let font = "ArmagedaWide"
    static let userDefaults = NSUserDefaults.standardUserDefaults()
    
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
    
}