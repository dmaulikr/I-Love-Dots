//
//  GameOver.swift
//  Dots!
//
//  Created by Chris Gilardi on 5/20/15.
//  Copyright (c) 2015 Chris Gilardi. All rights reserved.
//

import Foundation
import SpriteKit
import GameKit
import Darwin

class GameOver : SKScene{
    private let restartLabel: SKLabelNode = SKLabelNode()
    private let thisScore: SKLabelNode = SKLabelNode()
    private let highScore: SKLabelNode = SKLabelNode()
    private let userDefaults = DotsCommon.userDefaults
    private var score = 0
    private var newHigh: Bool = false
    private let message = SKLabelNode()
    var gameMode: Int = 0
    var sizeOfView: CGRect = CGRect()
    let restartButton = SKSpriteNode(imageNamed: "restartbutton")
    let mainMenuButton = SKSpriteNode(imageNamed: "mainmenubutton")
    let showads: Bool = false
    var length: Double = 20
    
    override func didMoveToView(view: SKView) {
        if !DotsCommon.getAdStatus() {
            DotsCommon.showAds()
        }
        
        //Background Color
        self.backgroundColor = UIColor(red: 0.94, green: 1.0, blue: 1.0, alpha: 1.0)
        
        //Restart Label (You lost! etc.)
        restartLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame)/2)
        restartLabel.fontName = DotsCommon.font
        restartLabel.text = String(score)
        restartLabel.fontSize = 100
        restartLabel.name = "rslabel"
        restartLabel.fontColor = SKColor.blackColor()
        self.addChild(restartLabel)
        
        
        //Add the loss message
        message.position = CGPointMake(CGRectGetMidX(self.frame), 3*CGRectGetHeight(self.frame)/4)
        message.fontColor = SKColor.blackColor()
        message.fontName = DotsCommon.font
        message.fontSize = 50
        self.addChild(message)
        
        //Add the new score and display it
        saveScore()
        highScore.text = getHighScore()
        highScore.position = CGPointMake(CGRectGetMidX(self.frame), message.position.y - 30)
        highScore.fontColor = SKColor.blackColor()
        highScore.fontName = DotsCommon.font
        self.addChild(highScore)
        
        //Restart Button Attributes
        restartButton.position = CGPointMake(CGRectGetMidX(self.frame), 3*CGRectGetMaxY(self.frame)/8)
        restartButton.name = "rsbutton"
        self.addChild(restartButton)
        
        //Main Menu Button Attributes
        mainMenuButton.position = CGPointMake(restartButton.position.x, restartButton.position.y - 90)
        mainMenuButton.name = "mmbutton"
        self.addChild(mainMenuButton)
        
        //Load AdMob Interstitials
        var numberOfPlays: Int? = userDefaults.integerForKey("playnum")
        println(numberOfPlays)
        
        if !DotsCommon.getAdStatus() {
            if numberOfPlays! % 15 == 0 {
                //TODO: App List
            } else if numberOfPlays! % 10 == 0 {
                DotsCommon.VShowAds()
            } else if numberOfPlays! % 5 == 0 {
                DotsCommon.AMShowAds()
            }
        }
        userDefaults.setInteger(numberOfPlays! + 1, forKey: "playnum")
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch:UITouch = touches.first! as! UITouch
        let positionInScene = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(positionInScene)
        
        if let name = touchedNode.name {
            //Restarts the game from the current gamemode
            if name == "rsbutton" {
                restartButton.texture = SKTexture(imageNamed: "restartbutton-pushed")
            } else if name == "mmbutton" {
                mainMenuButton.texture = SKTexture(imageNamed: "mainmenubutton-pushed")
            }
            if name == "rslabel" {
                restartLabel.runAction(DotsCommon.wiggle())
                if !DotsCommon.userDefaults.boolForKey("ach_wiggles_finalscore") {
                    DotsCommon.userDefaults.setBool(true, forKey: "ach_wiggles_finalscore")
                    if DotsCommon.checkWiggles_Ach() {
                        DotsCommon.achieveWiggles()
                    }
            }
            
        }

        }
    }

    //We use touchesEnded to make a more natural-feeling button press.
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch:UITouch = touches.first! as! UITouch
        let positionInScene = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(positionInScene)
        
        restartButton.texture = SKTexture(imageNamed: "restartbutton")
        mainMenuButton.texture = SKTexture(imageNamed: "mainmenubutton")
        
        if let name = touchedNode.name {
            //Restarts the game from the current gamemode
            if name == "rsbutton" {
                if self.view != nil{
                    var scene = SKScene()
                    if gameMode == 0 {
                        scene =  TimeTrial(size: self.size) 
                        if length <= 11 {
                           (scene as! TimeTrial).setGameLength(10)
                        } else if length <= 21 {
                            (scene as! TimeTrial).setGameLength(20)
                        } else if length <= 31 {
                            (scene as! TimeTrial).setGameLength(30)
                        }

                    } else if gameMode == 1 {
                        scene = Infinite(size: self.size)
                    } else {
                        scene = MainMenu(size: self.size)
                    }
                    let skView = self.view! as SKView
                    skView.ignoresSiblingOrder = true
                    scene.scaleMode = .ResizeFill
                    scene.size = skView.bounds.size
                    let fade: SKTransition = SKTransition.crossFadeWithDuration(0.5)
                    //let slide: SKTransition = SKTransition.flipVerticalWithDuration(0.5)
                    scene.scaleMode = .Fill
                    skView.presentScene(scene, transition: fade)
                    
                }
            }else if name == "mmbutton" {
                //Bring the user back to the main menu
                if self.view != nil {
                    let scene = MainMenu(size: self.size)
                    let skView = self.view! as SKView
                    skView.ignoresSiblingOrder = true
                    scene.scaleMode = .ResizeFill
                    scene.size = skView.bounds.size
                    let fade: SKTransition = SKTransition.crossFadeWithDuration(0.5)
                    scene.scaleMode = .Fill
                    skView.presentScene(scene, transition: fade)
                }
            }
            
        }
    }
    
    func setMyScore(score: Int){
        self.score = score
    }
    
    func saveScore(){
        var key: String
        /*gameMode Codes //
        0 - Time Trial
        1 - Infinite
                            */
        if gameMode == 0 {
            key = "tt_highscore"
            if length <= 11 {
                key += "_10"
            } else if length <= 21 {
                key += "_20"
            } else if length <= 31 {
                key += "_30"
            }
        } else if gameMode == 1 {
            key = "i_highscore"
        } else {
            key = "extraneous"
        }
        println("reporting to \(key)")
        if let highscore: AnyObject = userDefaults.valueForKey(key) {
            if Int((highscore as! Int)) < score {
                userDefaults.setValue(score, forKey: key)
                userDefaults.synchronize() // don't forget this!!!!
                newHigh = true
            }
        }
        else {
            userDefaults.setValue(score, forKey: key)
            userDefaults.synchronize() // don't forget this!!!!
        }
        
        if (GKLocalPlayer.localPlayer().authenticated) {
            let gkScore = GKScore()
            var leaderboard = ""
            if gameMode == 0 {
                leaderboard += "timetrial"
                if length <= 11 {
                    leaderboard += "_10"
                } else if length <= 21 {
                    leaderboard += "_20"
                } else if length <= 31 {
                    leaderboard += "_30"
                }
            } else {
                leaderboard = "timetrial_20"
            }
            gkScore.leaderboardIdentifier = leaderboard
            
            gkScore.value = Int64(score)
            GKScore.reportScores([gkScore], withCompletionHandler: ( { (error: NSError!) -> Void in
                if (error != nil) {
                    // handle error
                    println("Error: " + error.localizedDescription);
                } else {
                    println("Score reported: \(gkScore.value)")
                }
            }))
            if DotsCommon.userDefaults.integerForKey("playnum") >= 100 && !DotsCommon.userDefaults.boolForKey("ach_professional") {
                let thisachievement = GKAchievement(identifier: "professional_100")
                thisachievement.percentComplete = 100
                thisachievement.showsCompletionBanner = true
                GKAchievement.reportAchievements([thisachievement], withCompletionHandler: ( { (error: NSError!) -> Void in
                    if error != nil {
                        println("Error: " + error.localizedDescription)
                    } else {
                        println("Achievement reported: \(thisachievement.identifier)")
                    }
                }))
                DotsCommon.userDefaults.setBool(true, forKey: "ach_professional")
                }
            
            if DotsCommon.userDefaults.integerForKey("playnum") >= 200 && !DotsCommon.userDefaults.boolForKey("ach_fanatic") {
                let thisachievement = GKAchievement(identifier: "co.bluetruck.fanatic_ach")
                thisachievement.percentComplete = 100
                thisachievement.showsCompletionBanner = true
                GKAchievement.reportAchievements([thisachievement], withCompletionHandler: ( { (error: NSError!) -> Void in
                    if error != nil {
                        println("Error: " + error.localizedDescription)
                    } else {
                        println("Achievement reported: \(thisachievement.identifier)")
                    }
                }))
                DotsCommon.userDefaults.setBool(true, forKey: "ach_fanatic")
            }
            
            if DotsCommon.userDefaults.integerForKey("playnum") >= 500 && !DotsCommon.userDefaults.boolForKey("ach_supportive") {
                let thisachievement = GKAchievement(identifier: "co.bluetruck.supportive_ach")
                thisachievement.percentComplete = 100
                thisachievement.showsCompletionBanner = true
                GKAchievement.reportAchievements([thisachievement], withCompletionHandler: ( { (error: NSError!) -> Void in
                    if error != nil {
                        println("Error: " + error.localizedDescription)
                    } else {
                        println("Achievement reported: \(thisachievement.identifier)")
                    }
                }))
                DotsCommon.userDefaults.setBool(true, forKey: "ach_supportive")
            }
            
            if DotsCommon.userDefaults.integerForKey("playnum") >= 1000 && !DotsCommon.userDefaults.boolForKey("ach_unstable") {
                let thisachievement = GKAchievement(identifier: "co.bluetruck.unstable_ach")
                thisachievement.percentComplete = 100
                thisachievement.showsCompletionBanner = true
                GKAchievement.reportAchievements([thisachievement], withCompletionHandler: ( { (error: NSError!) -> Void in
                    if error != nil {
                        println("Error: " + error.localizedDescription)
                    } else {
                        println("Achievement reported: \(thisachievement.identifier)")
                    }
                }))
                DotsCommon.userDefaults.setBool(true, forKey: "ach_unstable")
            }
            }
        }
            
    
    func getHighScore() -> String{
        var key: String
        if gameMode == 0 {
            key = "tt_highscore"
            if length <= 11 {
                key += "_10"
            } else if length <= 21 {
                key += "_20"
            } else if length <= 31 {
                key += "_30"
            }
        } else if gameMode == 1 {
            key = "i_highscore"
        } else {
            key = "extraneous"
        }
        if let highscore: AnyObject = userDefaults.valueForKey(key) {
            if(newHigh){
                newHigh = false
                return "New High Score! \(highscore)"

            }
            return "High Score: \(highscore)"
        }
        else {
            return "No High Score!"
        }
    }
    
    func setMessage(message: String){
        self.message.text = message
    }
    func setEndGameMode(mode: Int){
        gameMode = mode
    }
    
    func sizeOfView(size: CGRect){
        sizeOfView = size
    }
    
    func setGameLength(length: Double) {
        self.length = length
    }
}