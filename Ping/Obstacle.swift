//
//  Obstacle.swift
//  Ping
//
//  Created by infuntis on 02.11.16.
//  Copyright © 2016 gala. All rights reserved.
//

import Foundation
import SpriteKit

enum ObstacleType: Int, CustomStringConvertible {
    case unknown = 0, usual, reverse, gorizontal
    
    static func random() -> ObstacleType {
        return ObstacleType(rawValue: Int(arc4random_uniform(2)) + 1)!
    }
    
    
    var spriteName: String {
        let spriteNames = [
            "obstacle","obstacle_reverse", "gorizontal"]
        
        return spriteNames[rawValue - 1]
    }
    
    var highlightedSpriteName: String {
        return spriteName + "-highlighted"
    }
    var description: String {
        return spriteName
    }
}

class Obstacle: CustomStringConvertible, Hashable {
    var column: Int
    var row: Int
    var sprite: SKSpriteNode?
    let obstacleType: ObstacleType
    
    init(column: Int, row: Int, obstacleType: ObstacleType) {
        self.column = column
        self.row = row
        self.obstacleType = obstacleType
    }
    
    var description: String {
        return "type:\(obstacleType) square:(\(column),\(row))"
    }
    
    var hashValue: Int {
        return row*10 + column
    }
    
    static func ==(lhs: Obstacle, rhs: Obstacle) -> Bool {
        return lhs.column == rhs.column && lhs.row == rhs.row
    }
}
