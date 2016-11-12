//
//  Tile.swift
//  Ping
//
//  Created by infuntis on 02.11.16.
//  Copyright © 2016 gala. All rights reserved.
//

import Foundation
import SpriteKit


//enum TileType: Int, CustomStringConvertible {
//    case unknown = 0, usual
//    
//    
//    var spriteName: String {
//        let spriteNames = [
//            "tile"]
//        
//        return spriteNames[rawValue - 1]
//    }
//    
//    var highlightedSpriteName: String {
//        return spriteName + "-highlighted"
//    }
//    var description: String {
//        return spriteName
//    }
//}

class Tile
{
    
    var type:Int?
    
    init(type: Int){
        self.type = type
        
    }
}
    
//}: CustomStringConvertible, Hashable {
//    var column: Int
//    var row: Int
//    var sprite: SKSpriteNode?
//    let tileType: TileType
//    
//    init(column: Int, row: Int, tileType: TileType) {
//        self.column = column
//        self.row = row
//        self.tileType = tileType
//    }
//    
//    var description: String {
//        return "type:\(tileType) square:(\(column),\(row))"
//    }
//    
//    var hashValue: Int {
//        return row*10 + column
//    }
//    
//    static func ==(lhs: Tile, rhs: Tile) -> Bool {
//        return lhs.column == rhs.column && lhs.row == rhs.row
//    }
//}
