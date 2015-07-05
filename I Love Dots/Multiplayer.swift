//
//  Multiplayer.swift
//  I Love Dots
//
//  Created by Chris Gilardi on 7/3/15.
//  Copyright (c) 2015 Chris Gilardi. All rights reserved.
//

import Foundation
import GameKit
import SpriteKit

class Multiplayer : TimeTrial {
    
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = SKColor.whiteColor()
    }
    
    
    
    func sendPosition() {
        var error: NSError
        var msg: PositionPacket = PositionPacket()
        msg.kind = "position"
        //msg.x = self.childNodeWithName("ball")?.position.x!
    }
    
    
}