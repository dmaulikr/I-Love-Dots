//
//  PositionPacket.swift
//  I Love Dots
//
//  Created by Chris Gilardi on 7/4/15.
//  Copyright (c) 2015 Chris Gilardi. All rights reserved.
//

import Foundation
import GameKit
import SpriteKit

class PositionPacket {
    
    var kind: String
    var x: CGFloat
    var y: CGFloat

    init(){
        kind = "position"
        x = 0
        y = 0
    }
    
    init(x: CGFloat, y: CGFloat) {
        kind = "position"
        self.x = x
        self.y = y
    }
    
    init(x: CGFloat, y: CGFloat, kind: String) {
        self.kind = kind
        self.x = x
        self.y = y
    }
    
}