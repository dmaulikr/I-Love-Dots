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

class MainMenu: SKScene {
    var thisGameMode: Int = Int()
    private let userDefaults = DotsCommon.userDefaults
    var lastGM: Int = 0
    var sizeOfView: CGRect = CGRect()
    let slideIn = SKTransition.moveInWithDirection(SKTransitionDirection.Right, duration: 1)
    let slideOut = SKTransition.moveInWithDirection(SKTransitionDirection.Left, duration: 1)
    var gm_startButton = SKSpriteNode(imageNamed: "startbutton")
    var gc_button = SKSpriteNode(imageNamed: "gamecenter-disabled")
    var gm_selector = SKSpriteNode(imageNamed: "gamemode")
    let settings = SKSpriteNode(imageNamed: "settingsbutton")
    let bouncingBall = SKShapeNode(circleOfRadius: 40)
    let leftBall = SKShapeNode(circleOfRadius: 40)
    let rightBall = SKShapeNode(circleOfRadius: 40)
    var theta: Double = 0.0
    var colorPicker = 0
    let gear = SKSpriteNode(imageNamed: "gear")
    
    override func didMoveToView(view: SKView) {
        
        //Add the three pulsating dots
        //1
        bouncingBall.position = CGPointMake(CGRectGetMidX(self.frame), 3*CGRectGetMaxY(self.frame)/8)
        bouncingBall.fillColor = SKColor(red: 0, green: 0.749, blue: 1.0, alpha: 1)
        bouncingBall.name = "middleball"
        self.addChild(bouncingBall)
        
        //2
        leftBall.position = CGPointMake(CGRectGetMidX(self.frame) - 50, 3*CGRectGetMaxY(self.frame)/8)
        leftBall.fillColor = SKColor(red: 0, green: 0, blue: 1.0, alpha: 1)
        leftBall.strokeColor = leftBall.fillColor
        leftBall.name = "leftball"
        self.addChild(leftBall)
        
        //3
        rightBall.position = CGPointMake(CGRectGetMidX(self.frame) + 50, 3*CGRectGetMaxY(self.frame)/8)
        rightBall.fillColor = leftBall.fillColor
        rightBall.strokeColor = rightBall.fillColor
        rightBall.name = "rightball"
        self.addChild(rightBall)
        
        
        
        
        print(CGRectGetMidY(self.frame), appendNewline: false)
        
        //TODO: Add Background Animation
        self.backgroundColor = UIColor(red: 0.94, green: 1.0, blue: 1.0, alpha: 1.0)
        /*
        let welcomelabel = SKLabelNode(text: "Dots!")
        welcomelabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)/2)
        welcomelabel.fontColor = SKColor.blueColor()
        self.addChild(welcomelabel)
        */
        
        
        let dots_logo = SKSpriteNode(imageNamed: "Loading")
        dots_logo.position = CGPointMake(CGRectGetMidX(self.frame), 3*CGRectGetMaxY(self.frame)/4)
        dots_logo.size = CGSize(width: 3*CGRectGetMaxX(self.frame)/4, height: 3*CGRectGetMaxX(self.frame)/4)
        dots_logo.name = "dots_logo"
        self.addChild(dots_logo)
        
        gm_startButton.name = "gm_startbutton"
        //gm_startButton.fillColor = SKColor.redColor()
        gm_startButton.position = CGPointMake(CGRectGetMidX(self.frame) - 60, CGRectGetMidY(self.frame)-180)
        self.addChild(gm_startButton)
        
        
        gc_button.name = "gc_button"
        gc_button.position = CGPointMake(CGRectGetMidX(self.frame) + 60, CGRectGetMidY(self.frame)-180)
        self.addChild(gc_button)
        
        gear.size = CGSize(width: 35, height: 35)
        gear.position = CGPointMake(CGRectGetMaxX(self.frame) - 20, CGRectGetMaxY(self.frame)-20)
        gear.name = "gear"
        self.addChild(gear)
        
        if let lastGamemode: AnyObject = userDefaults.valueForKey("last_gamemode") as? Int{
            lastGM = Int(lastGamemode as! NSNumber)
        }
        thisGameMode = lastGM
        
        DotsCommon.showAds()
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
                //gc_button.texture = SKTexture(imageNamed: "gamecenter-pushed")
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
                (touchedNode as SKNode).runAction(DotsCommon.wiggle())
            }
        }
        
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch:UITouch = touches.first! as! UITouch
        let positionInScene = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(positionInScene)
        gm_startButton.texture = SKTexture(imageNamed: "startbutton")
        //gc_button.texture = SKTexture(imageNamed: "gamecenter")
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
                skView.presentScene(scene, transition: SKTransition.moveInWithDirection(SKTransitionDirection.Right, duration: 0.2))
            }
            if name == "gc_button" {
                //NSNotificationCenter.defaultCenter().postNotificationName("showLeaderboard", object: nil)
            }
            if name == "gear" {
                let scene =  SettingsPane(size: self.size)
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                scene.scaleMode = .ResizeFill
                scene.size = skView.bounds.size
                skView.presentScene(scene, transition: SKTransition.moveInWithDirection(SKTransitionDirection.Right, duration: 0.2))
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

    }
    
    func setMainGameMode(gamemode: Int){
        thisGameMode = gamemode
    }
    
    func sizeOfView(size: CGRect){
        sizeOfView = size
    }
    
}