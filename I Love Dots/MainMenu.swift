//
//  MainMenu.swift
//  Dots!
//
//  Created by Chris Gilardi on 6/1/15.
//  Copyright (c) 2015 Chris Gilardi. All rights reserved.
//

import Foundation
import iAd
import UIKit
import SpriteKit
import GameKit
//import AdColony

class MainMenu: SKScene {
    var thisGameMode: Int = Int()
    private let userDefaults = NSUserDefaults.standardUserDefaults()
    var lastGM: Int = 0
    var sizeOfView: CGRect = CGRect()
    let slideIn = SKTransition.moveInWithDirection(SKTransitionDirection.Right, duration: 1)
    let slideOut = SKTransition.moveInWithDirection(SKTransitionDirection.Left, duration: 1)
    var gm_startButton = SKSpriteNode(imageNamed: "startbutton")
    var gc_button = SKSpriteNode(imageNamed: "gamecenter")
    var gm_selector = SKSpriteNode(imageNamed: "gamemode")
    let settings = SKSpriteNode(imageNamed: "settingsbutton")
    
    override func didMoveToView(view: SKView) {
        
        print(CGRectGetMidY(self.frame), appendNewline: false)
        
        //TODO: Add Background Animation
        self.backgroundColor = UIColor(red: 0.94, green: 1.0, blue: 1.0, alpha: 1.0)
        /*
        let welcomelabel = SKLabelNode(text: "Dots!")
        welcomelabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)/2)
        welcomelabel.fontColor = SKColor.blueColor()
        self.addChild(welcomelabel)
        */
        
        gm_startButton.name = "gm_startbutton"
        //gm_startButton.fillColor = SKColor.redColor()
        gm_startButton.position = CGPointMake(CGRectGetMidX(self.frame) - 60, CGRectGetMidY(self.frame))
        self.addChild(gm_startButton)
        
        
        gc_button.name = "gc_button"
        gc_button.position = CGPointMake(CGRectGetMidX(self.frame) + 60, CGRectGetMidY(self.frame))
        self.addChild(gc_button)
        
        
        
        gm_selector.name = "gm_selector"
        //gm_selector.fillColor = SKColor.greenColor()
        gm_selector.position = CGPointMake(CGRectGetMidX(self.frame), gc_button.position.y - 90)
        self.addChild(gm_selector)
        
        settings.name = "settings_button"
        settings.position = CGPointMake(CGRectGetMidX(self.frame), gm_selector.position.y - 90)
        self.addChild(settings)
        
        if let lastGamemode: AnyObject = userDefaults.valueForKey("last_gamemode") as? Int{
            lastGM = Int(lastGamemode as! NSNumber)
        }
        thisGameMode = lastGM
        
        NSNotificationCenter.defaultCenter().postNotificationName("showiAdBanner", object: nil)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch:UITouch = touches.first! as! UITouch
        let positionInScene = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(positionInScene)
        
        if let name = touchedNode.name{
            if name == "gm_startbutton"{
                gm_startButton.texture = SKTexture(imageNamed: "startbutton-pushed")
            }
            if name == "gc_button" {
                gc_button.texture = SKTexture(imageNamed: "gamecenter-pushed")
            }
            if name == "gm_selector" {
                gm_selector.texture = SKTexture(imageNamed: "gamemode-pushed")
            }
            if name == "settings_button" {
                settings.texture = SKTexture(imageNamed: "settingsbutton-pushed")
            }
        }
        
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch:UITouch = touches.first! as! UITouch
        let positionInScene = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(positionInScene)
        gm_startButton.texture = SKTexture(imageNamed: "startbutton")
        gc_button.texture = SKTexture(imageNamed: "gamecenter")
        gm_selector.texture = SKTexture(imageNamed: "gamemode")
        settings.texture = SKTexture(imageNamed: "settingsbutton")
        if let name = touchedNode.name{
            if name == "gm_startbutton"{
                if thisGameMode == 0 {
                    let scene = TimeTrial(size: self.size)
                    let skView = self.view! as SKView
                    skView.ignoresSiblingOrder = true
                    scene.scaleMode = .ResizeFill
                    scene.size = skView.bounds.size
                    NSNotificationCenter.defaultCenter().postNotificationName("hideiAdBanner", object: nil)
                    skView.presentScene(scene, transition: SKTransition.crossFadeWithDuration(0.5))
                    
                } else if thisGameMode == 1 {
                    let scene = Infinite(size: self.size)
                    let skView = self.view! as SKView
                    skView.ignoresSiblingOrder = true
                    scene.scaleMode = .ResizeFill
                    scene.size = skView.bounds.size
                    NSNotificationCenter.defaultCenter().postNotificationName("hideiAdBanner", object: nil)
                    skView.presentScene(scene, transition: SKTransition.crossFadeWithDuration(0.5))
                } else {
                    let scene = TimeTrial(size: self.size)
                    let skView = self.view! as SKView
                    skView.ignoresSiblingOrder = true
                    scene.scaleMode = .ResizeFill
                    scene.size = skView.bounds.size
                    NSNotificationCenter.defaultCenter().postNotificationName("hideiAdBanner", object: nil)
                    skView.presentScene(scene, transition: SKTransition.crossFadeWithDuration(0.5))
                }
                //var scene =  TimeTrial(size: self.size)
            }
            if name == "gm_selector" {
                let scene =  GameModeSelector(size: self.size)
                let skView = self.view! as SKView
                scene.setThisCurrentGM(lastGM)
                skView.ignoresSiblingOrder = true
                scene.scaleMode = .ResizeFill
                scene.size = skView.bounds.size
                //NSNotificationCenter.defaultCenter().postNotificationName("hideiAdBanner", object: nil)
                skView.presentScene(scene, transition: SKTransition.moveInWithDirection(SKTransitionDirection.Right, duration: 0.2))
            }
            if name == "gc_button" {
                NSNotificationCenter.defaultCenter().postNotificationName("showLeaderboard", object: nil)
            }
            if name == "settings_button" {
                let scene =  SettingsPane(size: self.size)
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                scene.scaleMode = .ResizeFill
                scene.size = skView.bounds.size
                skView.presentScene(scene, transition: SKTransition.moveInWithDirection(SKTransitionDirection.Right, duration: 0.2))
            }
        }
        
    }
    
    func setMainGameMode(gamemode: Int){
        thisGameMode = gamemode
    }
    
    func sizeOfView(size: CGRect){
        sizeOfView = size
    }
    
}