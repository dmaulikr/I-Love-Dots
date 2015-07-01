//
//  GameScene.swift
//  Dots!
//
//  Created by Chris Gilardi on 5/17/15.
//  Copyright (c) 2015 Chris Gilardi. All rights reserved.
//

import SpriteKit
import Foundation
import iAd

class GameScene: SKScene {

    override func didMoveToView(view: SKView) {
        self.backgroundColor = SKColor.whiteColor()
        _ = NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: "presentMenu", userInfo: nil, repeats: false)
        
        //TODO: Make "Dots!" Logo
        
        let loadingLabel = SKSpriteNode(imageNamed: "Loading")
        loadingLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        //loadingLabel.fontColor = SKColor.blackColor()
        //loadingLabel.fontSize = 60
        loadingLabel.alpha = 0
        self.addChild(loadingLabel)
        let fadeIn = SKAction.fadeInWithDuration(1)
        let wait = SKAction.waitForDuration(2)
        let fadeOut = SKAction.fadeOutWithDuration(1)
        let sequence = SKAction.sequence([fadeIn, wait, fadeOut])
        loadingLabel.runAction(sequence)
        
        DotsCommon.getMuteStatus()
        DotsCommon.resetPlaysIfNeeded()
        
        //TODO: Add Loading Animation (After I have the logo)
    }
    
    func presentMenu(){
        let scene = MainMenu(size: self.size)
        let skView = self.view! as SKView
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .ResizeFill
        scene.size = skView.bounds.size
        //NSNotificationCenter.defaultCenter().postNotificationName("hideiAdBanner", object: nil)
        skView.presentScene(scene, transition: SKTransition.fadeWithColor(UIColor.whiteColor(), duration: 1))
    }
}