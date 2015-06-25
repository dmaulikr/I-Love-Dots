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
    private let scoreBox: SKShapeNode = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 100, height: 100))
    private let restartLabel: SKLabelNode = SKLabelNode()
    private let thisScore: SKLabelNode = SKLabelNode()
    private let highScore: SKLabelNode = SKLabelNode()
    private let userDefaults = NSUserDefaults.standardUserDefaults()
    private var score = 0
    private var newHigh: Bool = false
    private let message = SKLabelNode()
    var gameMode: Int = 0
    var sizeOfView: CGRect = CGRect()
    
    override func didMoveToView(view: SKView) {
        

        
        //Background Color
        self.backgroundColor = SKColor.redColor()
        
        //Change the button color based on score
        if(score <= 0){
            scoreBox.fillColor = SKColor.redColor()
        }
        else if(score < 6){
            scoreBox.fillColor = SKColor.yellowColor()
            restartLabel.fontColor = SKColor.blackColor()
        }
        else if(score >= 6 && score < 25){
            scoreBox.fillColor = SKColor.orangeColor()
            restartLabel.fontColor = SKColor.whiteColor()
        }
        else if(score >= 25){
            scoreBox.fillColor = SKColor.greenColor()
            restartLabel.fontColor = SKColor.blackColor()
        }
        scoreBox.position = CGPointMake(CGRectGetMidX(self.frame) - 50, CGRectGetMidY(self.frame) - 50)
        //restartButton.name = "rsbutton"
        self.addChild(scoreBox)
        
        restartLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 20)
        restartLabel.text = String(score)
        restartLabel.fontSize = 40
        restartLabel.name = "rslabel"
        //restartLabel.fontColor = SKColor.whiteColor()
        self.addChild(restartLabel)
        
        //Add the new score and display it
        saveScore()
        highScore.text = getHighScore()
        highScore.position = CGPointMake(CGRectGetMidX(self.frame), 55)
        self.addChild(highScore)
        
        //Add the loss message
        message.position = CGPointMake(CGRectGetMidX(self.frame), 3*CGRectGetHeight(self.frame)/4)
        message.fontColor = SKColor.whiteColor()
        message.fontSize = 30
        self.addChild(message)
        NSNotificationCenter.defaultCenter().postNotificationName("showiAdBanner", object: nil)
        
        let restartButton = SKSpriteNode(imageNamed: "restartbutton")
        restartButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)/2)
        restartButton.name = "rsbutton"
        self.addChild(restartButton)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch:UITouch = touches.first! as! UITouch
        let positionInScene = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(positionInScene)
        
        if let name = touchedNode.name {
            //The first ball that shows up, startball
            if name == "rsbutton" || name == "rslabel" {
                //NSNotificationCenter.defaultCenter().postNotificationName("hideiAdBanner", object: nil)
                //var bounds: CGRect = UIScreen.mainScreen().bounds
                NSNotificationCenter.defaultCenter().postNotificationName("showVungleAds", object: nil)
                let scene =  MainMenu(size: self.size)
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                scene.scaleMode = .ResizeFill
                scene.size = skView.bounds.size
                let fade: SKTransition = SKTransition.crossFadeWithDuration(0.25)
                //let slide: SKTransition = SKTransition.flipVerticalWithDuration(0.5)
                scene.scaleMode = .Fill
                skView.presentScene(scene, transition: fade)
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
            /*
            do{
                try GKScore.reportScores([gkScore], withCompletionHandler: )
            }*/
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