//
//  TimeTrial.swift
//  Dots!
//
//  Created by Chris Gilardi on 5/21/15.
//  Copyright (c) 2015 Chris Gilardi. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation
class TimeTrial : DBasicLevel{
    let TIME_INCREMENT = 20.0
    //gameTimer: NSTimer = NSTimer()
    var firstTouch = true
    var timeLeft: Int = 19
    let timeLeftLabel = SKLabelNode(text: "20")
    let getSmaller = SKAction.fadeOutWithDuration(1.0)
    var welcomeMessage = SKLabelNode()

    
    override func didMoveToView(view: SKView) {
        NSNotificationCenter.defaultCenter().postNotificationName("hideiAdBanner", object: nil)
        ballSize = Int(CGRectGetMaxX(self.frame)/4)
        
        //Setup Audio Files/Player
        audioPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("blop", ofType: "wav")!), error: nil)
        audioPlayer.prepareToPlay()
        print(audioPlayer.prepareToPlay())
        print(blopSound)
        
        //Color the Background
        self.backgroundColor = UIColor(red: 0.94, green: 1.0, blue: 1.0, alpha: 1.0)
        
        //Add the first ball to the scene, uses SKShapeNode, r= 1/4 of the screen size)
        addBall(ballSize)
        
        //Add the welcome message: "Press the Ball"
        welcomeMessage = SKLabelNode(text: "Press the Ball")
        welcomeMessage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        welcomeMessage.fontColor = SKColor.blackColor()
        welcomeMessage.fontSize = 30
        welcomeMessage.name = "welcome"
        self.addChild(welcomeMessage)
        
        //Setup the score counter
        score.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        score.fontSize = 150
        score.fontName = "Avenir Next"
        score.fontColor = SKColor.blackColor()
        
        //Timer visible to User
        timeLeftLabel.position = CGPointMake(self.score.position.x, self.score.position.y - 40)
        timeLeftLabel.fontColor = SKColor.blackColor()
        timeLeftLabel.fontSize = 30
        timeLeftLabel.name = "timer"
        timeLeftLabel.userInteractionEnabled = false

    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        //Touch variables
        let touch:UITouch = touches.first! as! UITouch
        let positionInScene = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(positionInScene)
        
        if let name = touchedNode.name
        {
            //The first ball that shows up, startball
            if name == "startball"
            {
                print("Touched", appendNewline: false)
                addBall(ballSize)
                self.addChild(score)
            }//Any ball created after the first will use this statement
            else if name == "ball"{
                //print("Touched") -- For testing purposes
                scoreCount++
                addBall(ballSize)
                //print(ballSize)
                if DotsCommon.userDefaults.boolForKey("mutestatus") as Bool? == false {
                    audioPlayer.play()
                }

               // self.addChild(timeLeftLabel)
                //self.addChild(score)
            }
        }
        else{
            //Change background to red if the player touches outside the ball
            //self.backgroundColor = SKColor.redColor()
            let scene =  GameOver(size: self.size)
            scene.setMyScore(scoreCount)
            let skView = self.view! as SKView
            skView.ignoresSiblingOrder = true
            scene.scaleMode = .ResizeFill
            scene.size = skView.bounds.size
            scene.setMessage("You Lost!")
            scene.setEndGameMode(gm)
            gameTimer.invalidate()
            shownTimer.invalidate()
            print(" timers invalidated ", appendNewline: false)
            ran = true
            skView.presentScene(scene, transition: SKTransition.crossFadeWithDuration(0.25))
        }
        tapCount++

        if firstTouch {
            NSNotificationCenter.defaultCenter().postNotificationName("hideiAdBanner", object: nil)
            shownTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("decTimer"), userInfo: nil, repeats: true)
            gameTimer = NSTimer.scheduledTimerWithTimeInterval(TIME_INCREMENT, target:self, selector: Selector("endGame"), userInfo: nil, repeats: false)
            firstTouch = false
        }


    }
    
    override func update(currentTime: CFTimeInterval) {
        super.update(currentTime)
        
    }
    
    func endGame(){
        shownTimer.invalidate()
        gameTimer.invalidate()
        let scene =  GameOver(size: self.size)
        scene.setMyScore(scoreCount)
        if self.view != nil {
            let skView = self.view!
            skView.ignoresSiblingOrder = true
            scene.scaleMode = .ResizeFill
            scene.size = skView.bounds.size
            scene.setMessage("Time's Up!")
            
            skView.presentScene(scene, transition: SKTransition.crossFadeWithDuration(0.25))
        }

    }

    override func addBall(size: Int) {
        
        //Find and set bounds of the view
        let viewMidX = view!.bounds.midX
        let viewMidY = view!.bounds.midY
        _ = view?.scene!.frame.height
        _ = view?.scene!.frame.width
        
        //Setup of the ball constant
        let currentBall = SKShapeNode(circleOfRadius: CGFloat(size))
        currentBall.fillColor = pickColor()
        
        //Finding the random position of the ball
        //TODO: Make it so balls spawn close enough to the middle of the screen that player can touch.
        let xPosition = view!.scene!.frame.midX - viewMidX + CGFloat(arc4random_uniform(UInt32(viewMidX*2)))
        let yPosition = view!.scene!.frame.midY - viewMidY + CGFloat(arc4random_uniform(UInt32(viewMidY*2)))
        
        //Set the ball's random position
        currentBall.position = CGPointMake(xPosition, yPosition)
        
        //Set the ball's name
        
        //Remove other balls and add the new one

        if scoreCount != 0{
            if scoreCount == 1{
            self.addChild(score)
            self.addChild(timeLeftLabel)
            self.childNodeWithName("welcome")?.removeFromParent()
            }
            self.childNodeWithName("ball")?.runAction(getSmaller)
            self.childNodeWithName("ball")?.removeFromParent()
            //self.addChild(childNodeWithName("timer")!)
        }
        currentBall.name = "ball"

        self.addChild(currentBall)
    }

    
    func decTimer(){
        //timeLeftLabel.removeFromParent()
        timeLeftLabel.text = "\(timeLeft)"
        timeLeft--
        //self.addChild(timeLeftLabel)
    }
}
