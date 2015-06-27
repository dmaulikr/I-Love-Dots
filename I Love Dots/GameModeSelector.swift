//
//  GameModeSelector.swift
//  Dots!
//
//  Created by Chris Gilardi on 5/26/15.
//  Copyright (c) 2015 Chris Gilardi. All rights reserved.
//

import Foundation
import SpriteKit
import iAd

class GameModeSelector : SKScene {
    
    private let userDefaults = NSUserDefaults.standardUserDefaults()
    
    var timeTrialButton = SKSpriteNode()
    var infiniteButton = SKSpriteNode()
    var gameCenterLink = SKSpriteNode()
    var backButton = SKLabelNode()
    var currentGM: Int = 0
    var chosenMode: Int = 0
    
    
    override func didMoveToView(view: SKView) {
        
        //Background Color
        self.backgroundColor = UIColor(red: 0.74, green: 0.5, blue: 1, alpha: 1)
        
        //Add TimeTrial Selector
        timeTrialButton = SKSpriteNode(imageNamed: "timetrialbutton")
        timeTrialButton.position = CGPointMake(CGRectGetMidX(self.frame), 3*CGRectGetMaxY(self.frame)/4)
        timeTrialButton.name = "timetrial"
        self.addChild(timeTrialButton)
        
        //Add Infinite Selector
        infiniteButton = SKSpriteNode(imageNamed: "infinitebutton")
        infiniteButton.position = CGPointMake(timeTrialButton.position.x, timeTrialButton.position.y - 90)
        infiniteButton.name = "infinite"
        self.addChild(infiniteButton)
        
        //Add Back Button
        backButton.text = "Back"
        backButton.name = "backbutton"
        backButton.position = CGPointMake(CGRectGetMinX(self.frame) + 40, CGRectGetMaxY(self.frame) - 40)
        backButton.fontColor = SKColor.whiteColor()
        backButton.fontSize = 30
        self.addChild(backButton)
        
        //Set Starting Gamemode
        chosenMode = currentGM
        //TODO: Mode Selector Buttons
        //TODO: Show highscore here for each gamemode
        //TODO: Show iAd banner on bottom
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        //Touch variables
        let touch:UITouch = touches.first! as! UITouch
        let positionInScene = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(positionInScene)
        
        if let name = touchedNode.name {
            if name == "backbutton"{
                
            } else if name == "timetrial" {
                timeTrialButton.texture = SKTexture(imageNamed: "timetrialbutton-pushed")
                
            } else if name == "infinite" {
                infiniteButton.texture = SKTexture(imageNamed: "infinitebutton-pushed")
            }
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        //Touch variables
        let touch:UITouch = touches.first! as! UITouch
        let positionInScene = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(positionInScene)
        
        //Set the Textures back to the correct ones.
        timeTrialButton.texture = SKTexture(imageNamed: "timetrialbutton")
        infiniteButton.texture = SKTexture(imageNamed: "infinitebutton-pushed")
        
        if let name = touchedNode.name {
            if name == "backbutton"{
                let scene = MainMenu(size: self.size)
                scene.setMainGameMode(chosenMode)
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                scene.scaleMode = .ResizeFill
                scene.size = skView.bounds.size
                NSNotificationCenter.defaultCenter().postNotificationName("hideiAdBanner", object: nil)
                skView.presentScene(scene, transition: SKTransition.moveInWithDirection(SKTransitionDirection.Left, duration: 0.2))
                
            } else if name == "timetrial" {
                chosenMode = 0
                //self.backgroundColor = SKColor.greenColor()
                if let last_gm: AnyObject = userDefaults.valueForKey("last_gamemode") {
                    userDefaults.setValue(chosenMode, forKey: "last_gamemode")
                    userDefaults.synchronize() // don't forget this!!!!
                } else{
                    userDefaults.setValue(chosenMode, forKey: "last_gamemode")
                    userDefaults.synchronize() // don't forget this!!!!
                }
                
                
            } else if name == "infinite" {
                chosenMode = 1
                //self.backgroundColor = SKColor.blueColor()
                if let last_gm: AnyObject = userDefaults.valueForKey("last_gamemode") {
                    userDefaults.setValue(chosenMode, forKey: "last_gamemode")
                    userDefaults.synchronize() // don't forget this!!!!
                } else{
                    userDefaults.setValue(chosenMode, forKey: "last_gamemode")
                    userDefaults.synchronize() // don't forget this!!!!
                }
            }
        }
    }
    
    func setThisCurrentGM(gamemode: Int){
        if gamemode == 0 {
            //self.backgroundColor = SKColor.greenColor()
        }
        else if gamemode == 1 {
            //self.backgroundColor = SKColor.blueColor()
        }
        currentGM = gamemode
    }
}