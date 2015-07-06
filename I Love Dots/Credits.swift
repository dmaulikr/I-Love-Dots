//
//  Credits.swift
//  I Love Dots
//
//  Created by Chris Gilardi on 7/6/15.
//  Copyright (c) 2015 Chris Gilardi. All rights reserved.
//

import Foundation
import SpriteKit

class Credits: SKScene {
    
    let backButton: SKLabelNode = SKLabelNode(text: "Back")
    let chrisTitles = SKLabelNode(text: "Programmer/Graphic Designer")
    let pushNotificaationsTitle = SKLabelNode(text: "Push Notifications By")
    
    override func didMoveToView(view: SKView) {
        backButton.fontColor = SKColor.blackColor()
        backButton.fontName = DotsCommon.font
        backButton.name = "back"
        backButton.fontSize = 30
        backButton.position = CGPointMake(CGRectGetMinX(self.frame) + 35, CGRectGetMaxY(self.frame) - 30)
        self.addChild(backButton)
        
        
    }
}
