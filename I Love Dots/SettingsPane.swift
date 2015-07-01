//
//  SettingsPane.swift
//  I Love Dots
//
//  Created by Chris Gilardi on 6/26/15.
//  Copyright (c) 2015 Chris Gilardi. All rights reserved.
//

import Foundation
import SpriteKit

class SettingsPane: SKScene {
    
    
    let muteButton = SKLabelNode()
    let backButton = SKLabelNode(text: "Back")
    let adlessButton = SKLabelNode(text: "Go Adless")
    let rateButton = SKLabelNode(text: "Rate!")
    let moreGames = SKLabelNode(text: "More")
    
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
        
        adlessButton.position = CGPointMake(muteButton.position.x, muteButton.position.y - 60)
        adlessButton.fontSize = 30
        adlessButton.fontName = DotsCommon.font
        adlessButton.name = "adless"
        self.addChild(adlessButton)
        
        rateButton.position = CGPointMake(adlessButton.position.x, adlessButton.position.y - 60)
        rateButton.fontSize = 30
        rateButton.fontName = DotsCommon.font
        rateButton.name = "rate"
        self.addChild(rateButton)
        
        moreGames.position = CGPointMake(rateButton.position.x, rateButton.position.y - 60)
        moreGames.fontSize = 30
        moreGames.fontName = DotsCommon.font
        moreGames.name = "more"
        self.addChild(moreGames)
        
        
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
            } else if name == "more" {
                moreGames.alpha = 0.7
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
        moreGames.alpha = 1.0
        rateButton.alpha = 1.0
        
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
                //let iTunesLink = "itms://itunes.apple.com/us/app/polarr-photo-editor/id988173374?mt=8"
                //UIApplication.sharedApplication().openURL(NSURL(string: iTunesLink)!)
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
}