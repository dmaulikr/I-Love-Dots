//
//  SettingsPane.swift
//  I Love Dots
//
//  Created by Chris Gilardi on 6/26/15.
//  Copyright (c) 2015 Chris Gilardi. All rights reserved.
//

import Foundation
import SpriteKit
import GameKit

class SettingsPane: SKScene {
    
    
    let muteButton = SKLabelNode()
    let backButton = SKLabelNode(text: "Back")
    let adlessButton = SKLabelNode(text: "Go Adless")
    let rateButton = SKLabelNode(text: "Rate!")
    let shareButton = SKLabelNode(text: "Share!")
    //let restoreButton = SKLabelNode(text: "Restore Purchase")
    let gamesPlayed = SKLabelNode(text: String(DotsCommon.userDefaults.integerForKey("playnum")) + " " + "Games")
    var infoNum: Int = 1
    
    private let userDefaults = DotsCommon.userDefaults
    
    override func didMoveToView(view: SKView) {
        //TODO: Add the Buttons and shit
        
        backButton.fontColor = SKColor.whiteColor()
        backButton.fontName = DotsCommon.font
        backButton.name = "back"
        backButton.fontSize = 30
        backButton.position = CGPointMake(CGRectGetMinX(self.frame) + 35, CGRectGetMaxY(self.frame) - 30)
        self.addChild(backButton)
        
        muteButton.fontColor = SKColor.whiteColor()
        if DotsCommon.userDefaults.boolForKey("mutestatus") as Bool? == false {
            muteButton.text = "Mute"
        } else {
            muteButton.text = "Unmute"
        }
        muteButton.name = "mute"
        muteButton.fontName = DotsCommon.font
        muteButton.fontSize = 30
        muteButton.position = CGPointMake(CGRectGetMidX(self.frame), 3*CGRectGetMaxY(self.frame)/4)
        self.addChild(muteButton)
        
        /*
        adlessButton.position = CGPointMake(muteButton.position.x, muteButton.position.y - 60)
        adlessButton.fontSize = 30
        adlessButton.fontName = DotsCommon.font
        adlessButton.name = "adless"
        self.addChild(adlessButton)
*/
        

        rateButton.position = CGPointMake(muteButton.position.x, muteButton.position.y - 60)
        rateButton.fontSize = 30
        rateButton.fontName = DotsCommon.font
        rateButton.name = "rate"
        self.addChild(rateButton)
        
        
        shareButton.position = CGPointMake(rateButton.position.x, rateButton.position.y - 60)
        shareButton.fontSize = 30
        shareButton.fontName = DotsCommon.font
        shareButton.name = "share"
        self.addChild(shareButton)
        
        if DotsCommon.isiPad() {
            gamesPlayed.position = CGPointMake(shareButton.position.x, CGRectGetMinY(self.frame) + 80)
        } else {
            gamesPlayed.position = CGPointMake(shareButton.position.x, CGRectGetMinY(self.frame) + 60)
        }

        gamesPlayed.fontName = DotsCommon.font
        gamesPlayed.fontSize = 30
        gamesPlayed.name = "gamesplayed"
        self.addChild(gamesPlayed)
        
        //restoreButton.position = CGPointMake(moreGames.position.x, moreGames.position.y - 60)
        //restoreButton.fontName = DotsCommon.font
        //restoreButton.fontSize = 30
        //restoreButton.name = "restorebutton"
        //self.addChild(restoreButton)
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        //Touch variables
        let touch:UITouch = touches.first! as! UITouch
        let positionInScene = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(positionInScene)
        
        if let name = touchedNode.name {
            if name == "back" {
                backButton.alpha = 0.7
            } else if name == "mute" {
                muteButton.alpha = 0.7
            } else if name == "rate" {
                rateButton.alpha = 0.7
            } else if name == "share" {
                shareButton.alpha = 0.7
            } else if name == "adless" {
                adlessButton.alpha = 0.7
            } else if name == "restorebutton" {
                //restoreButton.alpha = 0.7
            }
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        //Touch variables
        let touch:UITouch = touches.first! as! UITouch
        let positionInScene = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(positionInScene)
        
        backButton.alpha = 1.0
        muteButton.alpha = 1.0
        shareButton.alpha = 1.0
        rateButton.alpha = 1.0
        adlessButton.alpha = 1.0
        //restoreButton.alpha = 1.0
        
        if let name = touchedNode.name {
            if name == "back" {
                let scene = MainMenu(size: self.size)
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                scene.scaleMode = .ResizeFill
                scene.size = skView.bounds.size
                let fade: SKTransition = SKTransition.crossFadeWithDuration(0.5)
                //let slide: SKTransition = SKTransition.flipVerticalWithDuration(0.5)
                scene.scaleMode = .Fill
                skView.presentScene(scene, transition: fade)
            } else if name == "mute" {
                if userDefaults.boolForKey("mutestatus") as Bool? == false {
                    muteSound()
                    muteButton.text = "Unmute"
                } else if userDefaults.boolForKey("mutestatus") as Bool? == true {
                    unmuteSound()
                    muteButton.text = "Mute"
                }
            } else if name == "rate" {
                let iTunesLink = "http://bluetruck.co/"
                UIApplication.sharedApplication().openURL(NSURL(string: iTunesLink)!)
            } else if name == "gamesplayed" {
                gamesPlayed.runAction(DotsCommon.wiggle())
                let timer = NSTimer.scheduledTimerWithTimeInterval(0.625, target: self, selector: "changeInfoText", userInfo: nil, repeats: false)
                if GKLocalPlayer.localPlayer().authenticated {
                    if !DotsCommon.userDefaults.boolForKey("ach_nerd") {
                        let thisachievement = GKAchievement(identifier: "co.bluetruck.nerd_ach")
                        thisachievement.percentComplete = 100
                        thisachievement.showsCompletionBanner = true
                        GKAchievement.reportAchievements([thisachievement], withCompletionHandler: ( { (error: NSError!) -> Void in
                            if error != nil {
                                println("Error: " + error.localizedDescription)
                            } else {
                                println("Achievement reported: \(thisachievement.identifier)")
                            }
                        }))
                        DotsCommon.userDefaults.setBool(true, forKey: "ach_nerd")
                    }
                }
                if !DotsCommon.userDefaults.boolForKey("ach_wiggles_playnum") {
                    DotsCommon.userDefaults.setBool(true, forKey: "ach_wiggles_playnum")
                    if DotsCommon.checkWiggles_Ach() {
                        DotsCommon.achieveWiggles()
                    }

                }}
             else if name == "share" {
                    println("Trying")
                NSNotificationCenter.defaultCenter().postNotificationName("showSharingView", object: nil)
            } else if name == "adless" {
                //DotsCommon.buyAdless()
            } else if name == "restorebutton" {
                //DotsCommon.restorePurchase()
            }
            }
        }
    
    func muteSound(){
        userDefaults.setBool(true, forKey: "mutestatus")
        println("muted!")

    }
    
    func unmuteSound(){
        userDefaults.setBool(false, forKey: "mutestatus")
        println("unmuted!")
    }
    
    func goAdless(){
        //TODO: Adless Version
    }
    
    func changeInfoText(){
        if infoNum == 0 {
            var gameCount = DotsCommon.userDefaults.integerForKey("playnum")
            var gameSig = String()
            if gameCount == 1 {
                gameSig = "Game"
            } else {
                gameSig = "Games"
            }
            gamesPlayed.text = "\(gameCount) \(gameSig)!"
            self.infoNum = 1
        } else if infoNum == 1 {
            let nsObject: AnyObject? = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"]
            let build = NSBundle.mainBundle().infoDictionary!["CFBundleVersion"] as! String
            let version = nsObject as! String
            gamesPlayed.text = version + " (Build " + build + ")"
            self.infoNum = 0
        }
        println(infoNum)
    }
    }