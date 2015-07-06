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
import Darwin
//import AdColony

class MainMenu: SKScene, UIAlertViewDelegate {
    var thisGameMode: Int = Int()
    private let userDefaults = DotsCommon.userDefaults
    var lastGM: Int = 0
    var sizeOfView: CGRect = CGRect()
    let slideIn = SKTransition.moveInWithDirection(SKTransitionDirection.Right, duration: 1)
    let slideOut = SKTransition.moveInWithDirection(SKTransitionDirection.Left, duration: 1)
    var gm_startButton = SKSpriteNode(imageNamed: "startbutton")
    var gc_button = SKSpriteNode(imageNamed: "gamecenter")
    var gm_selector = SKSpriteNode(imageNamed: "gamemode")
    let settings = SKSpriteNode(imageNamed: "settingsbutton")
    let bouncingBall = SKShapeNode(circleOfRadius: 40)
    let leftBall = SKShapeNode(circleOfRadius: 40)
    let rightBall = SKShapeNode(circleOfRadius: 40)
    var theta: Double = 0.0
    var colorPicker = 0
    let gear = SKSpriteNode(imageNamed: "gear")
    var decisiveTimer = NSTimer()
    var dots_logo: SKSpriteNode!
    var touchcount = 0
    
    //Time Selectors
    let timeSelectBackground = SKSpriteNode(imageNamed: "timeselect-background")
    let timeSelect10s = SKSpriteNode(imageNamed: "timeselect-10s")
    let timeSelect20s = SKSpriteNode(imageNamed: "timeselect-20s")
    let timeSelect30s = SKSpriteNode(imageNamed: "timeselect-30s")
    let spacing: CGFloat = 80
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    
    
    override func didMoveToView(view: SKView) {
        
        let node = SKNode()
        node.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        self.addChild(node)
        
        decisiveTimer = NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: "achIndecisive", userInfo: nil, repeats: false)
        
        //Add the three pulsating dots
        //1
        bouncingBall.fillColor = SKColor(red: 0, green: 0.749, blue: 1.0, alpha: 1)
        bouncingBall.name = "middleball"

        
        //2
        leftBall.fillColor = SKColor(red: 0, green: 0, blue: 1.0, alpha: 1)
        leftBall.strokeColor = leftBall.fillColor
        leftBall.name = "leftball"
        
        //3
        rightBall.fillColor = leftBall.fillColor
        rightBall.strokeColor = rightBall.fillColor
        rightBall.name = "rightball"

        if DotsCommon.isiPad() {
            bouncingBall.position = CGPointMake(node.position.x, node.position.y - 71)
            leftBall.position = CGPointMake(node.position.x - 50, bouncingBall.position.y)
            rightBall.position = CGPointMake(node.position.x + 50, leftBall.position.y)
            gm_startButton.position = CGPointMake(node.position.x - 60, node.position.y - 180)
            gc_button.position = CGPointMake(gm_startButton.position.x + 120, gm_startButton.position.y)
            
        } else{
            if DotsCommon.getDevice() == "iPhone 4S" || DotsCommon.getDevice() == "Simulator" {
                gm_startButton.position = CGPointMake(CGRectGetMidX(self.frame) - 60, CGRectGetMidY(self.frame)-150)
                gc_button.position = CGPointMake(CGRectGetMidX(self.frame) + 60, gm_startButton.position.y)
            } else {
                gm_startButton.position = CGPointMake(CGRectGetMidX(self.frame) - 60, CGRectGetMidY(self.frame)-180)
                gc_button.position = CGPointMake(CGRectGetMidX(self.frame) + 60, gm_startButton.position.y)
            }
            bouncingBall.position = CGPointMake(CGRectGetMidX(self.frame), 3*CGRectGetMaxY(self.frame)/8)
            println("Difference: \(node.position.y - bouncingBall.position.y)")
            leftBall.position = CGPointMake(CGRectGetMidX(self.frame) - 50, bouncingBall.position.y)
            rightBall.position = CGPointMake(CGRectGetMidX(self.frame) + 50, leftBall.position.y)

        }
        
        self.addChild(bouncingBall)
        self.addChild(leftBall)
        self.addChild(rightBall)
        
        
        self.backgroundColor = UIColor.whiteColor()
        /*
        let welcomelabel = SKLabelNode(text: "Dots!")
        welcomelabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)/2)
        welcomelabel.fontColor = SKColor.blueColor()
        self.addChild(welcomelabel)
        */
        
        
        dots_logo = SKSpriteNode(imageNamed: "Loading")
        if DotsCommon.isiPad() {
            dots_logo.size = CGSize(width: 240, height: 240)
            dots_logo.position = CGPointMake(node.position.x, node.position.y + 142)
            println("iPad")
        } else {
            dots_logo.size = CGSize(width: 3*CGRectGetMaxX(self.frame)/4, height: 3*CGRectGetMaxX(self.frame)/4)
            println("(WIDTH: \(dots_logo.size.width)" + ", HEIGHT: \(dots_logo.size.height))")
            println("iPhone")
            dots_logo.position = CGPointMake(CGRectGetMidX(self.frame), 3*CGRectGetMaxY(self.frame)/4)
            println("Difference: \(node.position.y - dots_logo.position.y)")
        }


        dots_logo.name = "dots_logo"
        self.addChild(dots_logo)
        
        gm_startButton.name = "gm_startbutton"
        self.addChild(gm_startButton)
        
        gc_button.name = "gc_button"
        self.addChild(gc_button)
        
        gear.size = CGSize(width: 35, height: 35)
        gear.position = CGPointMake(CGRectGetMaxX(self.frame) - 20, CGRectGetMaxY(self.frame)-20)
        gear.name = "gear"
        self.addChild(gear)
        
        if let lastGamemode: AnyObject = userDefaults.valueForKey("last_gamemode") as? Int{
            lastGM = Int(lastGamemode as! NSNumber)
        }
        thisGameMode = lastGM
        
        
        if !DotsCommon.getAdStatus() {
            DotsCommon.showAds()
        }
        
        timeSelectBackground.position = CGPointMake(CGRectGetMinX(self.frame) - timeSelectBackground.size.width, CGRectGetMidY(self.frame))
        self.addChild(timeSelectBackground)
        
        
        timeSelect10s.position = CGPointMake(timeSelectBackground.position.x, timeSelectBackground.position.y)
        timeSelect10s.name = "10s"
        self.addChild(timeSelect10s)
        
        timeSelect20s.position = CGPointMake(timeSelectBackground.position.x, timeSelectBackground.position.y)
        timeSelect20s.name = "20s"
        self.addChild(timeSelect20s)
        
        timeSelect30s.position = CGPointMake(timeSelectBackground.position.x, timeSelectBackground.position.y)
        timeSelect30s.name = "30s"
        self.addChild(timeSelect30s)
    }
    
    override func willMoveFromView(view: SKView) {
        decisiveTimer.invalidate()
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
                //DotsCommon.restorePurchase()
            }
            if name == "gm_selector" {
                gm_selector.texture = SKTexture(imageNamed: "gamemode-pushed")
            }
            if name == "settings_button" {
                settings.texture = SKTexture(imageNamed: "settingsbutton-pushed")
            }
            if name == "middleball" || name == "leftball" || name == "rightball" {
                (touchedNode as! SKShapeNode).fillColor = DotsCommon.getColor(colorPicker)
                colorPicker++
            }
            if name == "dots_logo" {
                if !DotsCommon.userDefaults.boolForKey("ach_wiggles_logo") {
                    DotsCommon.userDefaults.setBool(true, forKey: "ach_wiggles_logo")
                    if DotsCommon.checkWiggles_Ach() {
                        DotsCommon.achieveWiggles()
                    }
                }
                touchcount++
                if touchcount % 20 == 0 {
                    let alert = UIAlertView(title: "Stop Tapping Me!", message: "It really hurts!", delegate: self, cancelButtonTitle: "I'm Sorry")
                    alert.show()
                }
                (touchedNode as SKNode).runAction(DotsCommon.wiggle())
                //DotsCommon.hostMP()
            }
            
            if name == "10s" {
                timeSelect10s.texture = SKTexture(imageNamed: "timeselect-10s-pushed")
            } else if name == "20s" {
                timeSelect20s.texture = SKTexture(imageNamed: "timeselect-20s-pushed")
            } else if name == "30s" {
                timeSelect30s.texture = SKTexture(imageNamed: "timeselect-30s-pushed")
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
        timeSelect10s.texture = SKTexture(imageNamed: "timeselect-10s")
        timeSelect20s.texture = SKTexture(imageNamed: "timeselect-20s")
        timeSelect30s.texture = SKTexture(imageNamed: "timeselect-30s")
        if let name = touchedNode.name{
            if name != "gm_startbutton" {
                timeSelectBackground.runAction(DotsCommon.slideOutLeft(self.frame, width: timeSelectBackground.size.width))
            }
            if name == "gm_startbutton"{
                
                timeSelectBackground.runAction(DotsCommon.slideInFromSide(self.frame))
                
                
                
                /*
                if thisGameMode == 0 {
                    let scene = TimeTrial(size: self.size)
                    let skView = self.view! as SKView
                    skView.ignoresSiblingOrder = true
                    scene.scaleMode = .ResizeFill
                    scene.size = skView.bounds.size
                    DotsCommon.hideAds()
                    skView.presentScene(scene, transition: SKTransition.crossFadeWithDuration(0.5))
                    
                } else if thisGameMode == 1 {
                    let scene = Infinite(size: self.size)
                    let skView = self.view! as SKView
                    skView.ignoresSiblingOrder = true
                    scene.scaleMode = .ResizeFill
                    scene.size = skView.bounds.size
                    DotsCommon.hideAds()
                    skView.presentScene(scene, transition: SKTransition.crossFadeWithDuration(0.5))
                } else {
                    let scene = TimeTrial(size: self.size)
                    let skView = self.view! as SKView
                    skView.ignoresSiblingOrder = true
                    scene.scaleMode = .ResizeFill
                    scene.size = skView.bounds.size
                    DotsCommon.hideAds()
                    skView.presentScene(scene, transition: SKTransition.crossFadeWithDuration(0.5))
                }*/
                //var scene =  TimeTrial(size: self.size)
            }
            if name == "gm_selector" {
                let scene =  GameModeSelector(size: self.size)
                let skView = self.view! as SKView
                scene.setThisCurrentGM(lastGM)
                skView.ignoresSiblingOrder = true
                scene.scaleMode = .ResizeFill
                scene.size = skView.bounds.size
                skView.presentScene(scene, transition: SKTransition.moveInWithDirection(SKTransitionDirection.Right, duration: 0.2))
            }
            if name == "gc_button" {
                DotsCommon.showLeaderboard()
                //DotsCommon.showBetaAlert()
                decisiveTimer.invalidate()
                //DotsCommon.VShowAds()
            }
            if name == "gear" {
                let scene =  SettingsPane(size: self.size)
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                scene.scaleMode = .ResizeFill
                scene.size = skView.bounds.size
                decisiveTimer.invalidate()
                skView.presentScene(scene, transition: SKTransition.moveInWithDirection(SKTransitionDirection.Right, duration: 0.2))
            }
            if name == "10s" {
                let gameTime: Double = 10.0
                let scene = TimeTrial(size: self.size)
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                scene.scaleMode = .ResizeFill
                scene.size = skView.bounds.size
                scene.setGameLength(gameTime)
                DotsCommon.hideAds()
                decisiveTimer.invalidate()
                skView.presentScene(scene, transition: SKTransition.crossFadeWithDuration(0.5))
            } else if name == "20s"{
                let gameTime: Double = 20.0
                let scene = TimeTrial(size: self.size)
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                scene.scaleMode = .ResizeFill
                scene.size = skView.bounds.size
                scene.setGameLength(gameTime)
                DotsCommon.hideAds()
                decisiveTimer.invalidate()
                skView.presentScene(scene, transition: SKTransition.crossFadeWithDuration(0.5))
            } else if name == "30s" {
                let gameTime: Double = 30.0
                let scene = TimeTrial(size: self.size)
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                scene.scaleMode = .ResizeFill
                scene.size = skView.bounds.size
                scene.setGameLength(gameTime)
                DotsCommon.hideAds()
                decisiveTimer.invalidate()
                skView.presentScene(scene, transition: SKTransition.crossFadeWithDuration(0.5))
            }
            
        }
        
    }
    
    override func update(currentTime: NSTimeInterval) {
        
        let pi = M_PI
        
        if theta > 2*pi {
            theta = 0.0
        }
        
        leftBall.xScale = CGFloat(cos(theta + pi/2))
        rightBall.xScale = CGFloat(cos(theta + pi/2))
        leftBall.yScale = CGFloat(cos(theta + pi/2))
        rightBall.yScale = CGFloat(cos(theta + pi/2))
        
        bouncingBall.xScale = CGFloat(cos(theta))
        bouncingBall.yScale = CGFloat(cos(theta))
        theta += 0.01
        


        timeSelect10s.position = CGPointMake(timeSelectBackground.position.x, timeSelectBackground.position.y + self.spacing)
        timeSelect20s.position = timeSelectBackground.position
        timeSelect30s.position = CGPointMake(timeSelectBackground.position.x, timeSelectBackground.position.y - self.spacing)
        
    }
    
    func setMainGameMode(gamemode: Int){
        thisGameMode = gamemode
    }
    
    func sizeOfView(size: CGRect){
        sizeOfView = size
    }
    
    func achIndecisive() {
        println("Starting")
        if !DotsCommon.userDefaults.boolForKey("ach_indecisive") {
            println("Passed")
            if GKLocalPlayer.localPlayer().authenticated {
                println("Passed")
                let thisachievement = GKAchievement(identifier: "co.bluetruck.indecisive_ach")
                thisachievement.percentComplete = 100
                thisachievement.showsCompletionBanner = true
                GKAchievement.reportAchievements([thisachievement], withCompletionHandler: ( { (error: NSError!) -> Void in
                    if error != nil {
                        println("Error: " + error.localizedDescription)
                    } else {
                        println("Achievement reported: \(thisachievement.identifier)")
                    }
                }))
                DotsCommon.userDefaults.setBool(true, forKey: "ach_indecisive")
            }

        }
    }
    
}