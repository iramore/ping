//
//  Obstacle.swift
//  Ping
//
//  Created by infuntis on 02.11.16.
//  Copyright © 2016 gala. All rights reserved.
//

import Foundation
import SpriteKit

enum RotationType: Int{
    case positive = 0, reverse
    
    static func random() -> RotationType {
        return RotationType(rawValue: Int(arc4random_uniform(2)))!
    }
    
    var angle: CGFloat{
        let angles = [CGFloat.pi/4,-CGFloat.pi/4]
        return angles[rawValue]
    }
}


class Obstacle {
    var column: Int
    var row: Int
    var sprite: SKSpriteNode?
    let rotation: RotationType
    
    init(column: Int, row: Int, rotation: RotationType) {
        self.column = column
        self.row = row
        self.rotation = rotation
    }
    
    

}
