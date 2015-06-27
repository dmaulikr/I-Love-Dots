//
//  SettingsPane.swift
//  I Love Dots
//
//  Created by Chris Gilardi on 6/26/15.
//  Copyright (c) 2015 Chris Gilardi. All rights reserved.
//

import Foundation
import SpriteKit

class SettingsPane: SKScene {
    
    
    let muteButton = SKLabelNode()
    
    private let userDefaults = NSUserDefaults.standardUserDefaults()
    
    override func didMoveToView(view: SKView) {
        //TODO: Add the Buttons and shit
        
        let implementMessage = SKLabelNode(text: "Not Yet Implemented")
        implementMessage.color = SKColor.whiteColor()
        implementMessage.name = "imp_message"
        implementMessage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 60)
        self.addChild(implementMessage)
        
        let backButton = SKLabelNode(text: "Back")
        backButton.color = SKColor.whiteColor()
        backButton.name = "back"
        backButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        self.addChild(backButton)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        //Touch variables
        let touch:UITouch = touches.first! as! UITouch
        let positionInScene = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(positionInScene)
        
        if let name = touchedNode.name {
            if name == "back" {
                let scene = MainMenu(size: self.size)
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                scene.scaleMode = .ResizeFill
                scene.size = skView.bounds.size
                let fade: SKTransition = SKTransition.crossFadeWithDuration(0.5)
                //let slide: SKTransition = SKTransition.flipVerticalWithDuration(0.5)
                scene.scaleMode = .Fill
                skView.presentScene(scene, transition: fade)
            }
        }
    }
    
    func muteSound(){

    }
    
    func unmuteSound(){

    }
    
    func goAdless(){
        //TODO: Adless Version
    }
}