//
//  MainMenu.swift
//  Dots!
//
//  Created by Chris Gilardi on 5/19/15.
//  Copyright (c) 2015 Chris Gilardi. All rights reserved.
//

import Foundation
import AVFoundation
import SpriteKit
import iAd

class DBasicLevel : SKScene{
    var score = SKLabelNode(text: "0")
    var timer = SKLabelNode()
    var scoreCount: Int = 0
    var Colors = [SKColor]()
    var colorIndex: UInt32 = 0
    var startingColor: UInt32 = 0
    var viewMidX: Int = 0
    var viewMidY: Int = 0
    var tapCount = 0
    var blopSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("blop", ofType: "wav")!)
    var audioPlayer = AVAudioPlayer()
    var gameTimer: NSTimer = NSTimer()
    var hasTimer: Bool = false
    var ran: Bool = false
    var shownTimer = NSTimer()
    var ballSize: Int = 75
    var gm = 0
    var sizeOfView: CGRect = CGRect()
    
    override func didMoveToView(view: SKView) {
        /*SET UP THE SCENE*/
        NSNotificationCenter.defaultCenter().postNotificationName("hideiAdBanner", object: nil)

            //Setup Audio Files/Player
        audioPlayer = AVAudioPlayer(contentsOfURL: blopSound, error: nil)
        audioPlayer.prepareToPlay()
        
        //Color the Background
        self.backgroundColor = SKColor.whiteColor()
        
        //Add preset colors to an array of colors (Predefine them, "pseudorandom")
        Colors.append(SKColor.redColor())
        Colors.append(SKColor.greenColor())
        Colors.append(SKColor.blueColor())
        Colors.append(SKColor.blackColor())
        Colors.append(SKColor.purpleColor())
        Colors.append(SKColor.yellowColor())
        Colors.append(SKColor.orangeColor())
        //Colors.append(SKColor(red: 255, green: 153, blue: 204, alpha: 1))
        
        //Get length of array of colors and find a random start index
        colorIndex = UInt32(Colors.count)
        startingColor = arc4random_uniform(colorIndex)
        print(startingColor)
        
        //Add the first ball to the scene, uses SKShapeNode, r=75, color is "random")
        addBall(ballSize)
        
        //Add the welcome message: "Press the Ball"
        let welcomeMessage = SKLabelNode(text: "Press the Ball")
        welcomeMessage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        welcomeMessage.fontColor = SKColor.blackColor()
        welcomeMessage.fontSize = 30
        welcomeMessage.name = "wm"
        self.addChild(welcomeMessage)
        
        //Setup the score counter
        score.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        score.fontSize = 150
        score.fontName = "Avenir Next"
        score.fontColor = SKColor.blackColor()
        
        
        //self.addChild(score) -- We don't want to add the score until the user has tapped the first ball
        

    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        //Touch variables
        let touch:UITouch = touches.first! as! UITouch
        let positionInScene = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(positionInScene)
        
        if let name = touchedNode.name
        {
            //The first ball that shows up, startball
            if name == "startball" || name == "wm"
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
                audioPlayer.play()
                //self.addChild(score)
            }
        }
        else{
            //Change background to red if the player touches outside the ball
            //self.backgroundColor = SKColor.redColor()
            let scene =  GameOver(size: self.size)
            scene.setMyScore(0)
            let skView = self.view! as SKView
            skView.ignoresSiblingOrder = true
            scene.scaleMode = .ResizeFill
            scene.size = skView.bounds.size
            scene.setMessage("You Lost!")
            scene.setEndGameMode(gm)
            gameTimer.invalidate()
            shownTimer.invalidate()
            ran = true
            skView.presentScene(scene, transition: SKTransition.crossFadeWithDuration(0.25))
        }
        tapCount++
        
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        //Update the score
        score.text = "\(scoreCount)"
        
    }
    
    //Adds a new ball in a random spot
    func addBall(size: Int) {
        
        //Find and set bounds of the view
        let viewMidX = view!.bounds.midX
        let viewMidY = view!.bounds.midY
        let sceneHeight = view?.scene!.frame.height
        let sceneWidth = view?.scene!.frame.width
        
        //Setup of the ball constant
        let currentBall = SKShapeNode(circleOfRadius: CGFloat(size))
        currentBall.fillColor = pickColor()
        
        //Finding the random position of the ball
        //TODO: Make it so balls spawn close enough to the middle of the screen that player can touch.
        let xPosition = view!.scene!.frame.midX - viewMidX + CGFloat(arc4random_uniform(UInt32(viewMidX*2)))
        let yPosition = view!.scene!.frame.midY - viewMidY + CGFloat(arc4random_uniform(UInt32(viewMidY*2)))
        
        //Set the ball's random position
        currentBall.position = CGPointMake(xPosition,yPosition)
        
        //Set the ball's name
        currentBall.name = "ball"
        
        //Remove other balls and add the new one
        self.removeAllChildren()
        if scoreCount != 0{
            self.addChild(score)
            //self.addChild(childNodeWithName("timer")!)
        }
        self.addChild(currentBall)
    }
    
    func pickColor() -> SKColor{
        var temp = colorIndex
        let newColor: SKColor = Colors[Int(arc4random_uniform(UInt32(colorIndex)))]
        colorIndex++
        if(Int(colorIndex) > Colors.count){
            colorIndex = 0
        }
        return newColor
    }
    
    func setGameMode(mode: Int){
        gm = mode
    }
    
    func sizeOfView(size: CGRect){
        sizeOfView = size
    }
}
