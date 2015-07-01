//
//  DotsCommon.swift
//  I Love Dots
//
//  Created by Chris Gilardi on 7/1/15.
//  Copyright (c) 2015 Chris Gilardi. All rights reserved.
//

import Foundation
import SpriteKit

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
    }
    
    static func wiggle() -> SKAction {
        let timeInterval: NSTimeInterval = 0.125
        return SKAction.sequence([SKAction.rotateByAngle(-0.26179938779, duration: timeInterval), SKAction.rotateByAngle(0.52359877559, duration: timeInterval), SKAction.rotateByAngle(-0.52359877559, duration: timeInterval), SKAction.rotateByAngle(0.52359877559, duration: timeInterval), SKAction.rotateByAngle(-0.26179938779, duration: timeInterval)])
    }
    
    static func getMuteStatus() {
        if userDefaults.boolForKey("mutestatus") as Bool? == nil {
            userDefaults.setBool(false, forKey: "mutestatus")
        }
        else {return}
    }
}