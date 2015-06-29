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

class GameOver : SKScene{
    private let restartLabel: SKLabelNode = SKLabelNode()
    private let thisScore: SKLabelNode = SKLabelNode()
    private let highScore: SKLabelNode = SKLabelNode()
    private let userDefaults = NSUserDefaults.standardUserDefaults()
    private var score = 0
    private var newHigh: Bool = false
    private let message = SKLabelNode()
    var gameMode: Int = 0
    var sizeOfView: CGRect = CGRect()
    let font = "ArmagedaWide"       //Change this font to change all the fonts (except the buttons)
    let restartButton = SKSpriteNode(imageNamed: "restartbutton")
    let mainMenuButton = SKSpriteNode(imageNamed: "mainmenubutton")
    
    override func didMoveToView(view: SKView) {
        

        
        //Background Color
        self.backgroundColor = UIColor(red: 0.94, green: 1.0, blue: 1.0, alpha: 1.0)
        
        //Restart Label (You lost! etc.)
        restartLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame)/2)
        restartLabel.fontName = font
        restartLabel.text = String(score)
        restartLabel.fontSize = 100
        restartLabel.name = "rslabel"
        restartLabel.fontColor = SKColor.blackColor()
        self.addChild(restartLabel)
        
        //Add the new score and display it
        saveScore()
        highScore.text = getHighScore()
        highScore.position = CGPointMake(CGRectGetMidX(self.frame), 55)
        self.addChild(highScore)
        
        //Add the loss message
        message.position = CGPointMake(CGRectGetMidX(self.frame), 3*CGRectGetHeight(self.frame)/4)
        message.fontColor = SKColor.blackColor()
        message.fontName = font
        message.fontSize = 50
        self.addChild(message)
        NSNotificationCenter.defaultCenter().postNotificationName("showiAdBanner", object: nil)
        
        //Restart Button Attributes
        restartButton.position = CGPointMake(CGRectGetMidX(self.frame), 3*CGRectGetMaxY(self.frame)/8)
        restartButton.name = "rsbutton"
        self.addChild(restartButton)
        
        //Main Menu Button Attributes
        mainMenuButton.position = CGPointMake(restartButton.position.x, restartButton.position.y - 90)
        mainMenuButton.name = "mmbutton"
        self.addChild(mainMenuButton)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch:UITouch = touches.first! as! UITouch
        let positionInScene = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(positionInScene)
        
        if let name = touchedNode.name {
            //Restarts the game from the current gamemode
            if name == "rsbutton" || name == "rslabel" {
                restartButton.texture = SKTexture(imageNamed: "restartbutton-pushed")
            } else if name == "mmbutton" {
                mainMenuButton.texture = SKTexture(imageNamed: "mainmenubutton-pushed")
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
            if name == "rsbutton" || name == "rslabel" {
                if self.view != nil{
                    var scene = SKScene()
                    if gameMode == 0 {
                        scene =  TimeTrial(size: self.size)
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
        } else if gameMode == 1 {
            key = "i_highscore"
        } else {
            key = "extraneous"
        }
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
            let gkScore = GKScore(leaderboardIdentifier: "Dots_infinite")
            gkScore.value = Int64(score)
            GKScore.reportScores([gkScore], withCompletionHandler: ( { (error: NSError!) -> Void in
                if (error != nil) {
                    // handle error
                    println("Error: " + error.localizedDescription);
                } else {
                    println("Score reported: \(gkScore.value)")
                }
            }))
        }}
            
    
    func getHighScore() -> String{
        var key: String
        if gameMode == 0 {
            key = "tt_highscore"
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
    }