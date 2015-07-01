//
//  TimeSelector.swift
//  I Love Dots
//
//  Created by Chris Gilardi on 7/1/15.
//  Copyright (c) 2015 Chris Gilardi. All rights reserved.
//

import Foundation
import SpriteKit

class TimeSelector : SKScene {
    
    let font = "ArmagedaWide"
    
    override func didMoveToView(view: SKView) {
        let selectTen = SKLabelNode(text: "10")
        selectTen.name = "select10"
        selectTen.fontColor = SKColor.blackColor()
        selectTen.fontName = DotsCommon.font
        let selectTwenty = SKLabelNode(text: "20")
        let selectThirty = SKLabelNode(text: "30")
    }
    
}