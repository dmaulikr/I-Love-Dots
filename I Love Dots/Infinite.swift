//
//  Infinite.swift
//  Dots!
//
//  Created by Chris Gilardi on 5/22/15.
//  Copyright (c) 2015 Chris Gilardi. All rights reserved.
//

import Foundation
import SpriteKit

class Infinite : DBasicLevel{
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        setGameMode(1)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        if ballSize < 51 {
            ballSize = 51
        }
        ballSize--
    }
}