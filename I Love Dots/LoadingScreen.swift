//
//  LoadingScreen.swift
//  Dots!
//
//  Created by Chris Gilardi on 5/26/15.
//  Copyright (c) 2015 Chris Gilardi. All rights reserved.
//

import Foundation
import SpriteKit

class LoadingScreen : SKScene{
    override func didMoveToView(view: SKView) {
        let loadLabel = SKSpriteNode(imageNamed: "Loading")
        loadLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        //loadLabel.text = "Loading..."
        //loadLabel.fontColor = SKColor.blackColor()
        //loadLabel.fontSize = 40
        self.addChild(loadLabel)
    }
}
