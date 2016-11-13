//
//  Basket.swift
//  Ping
//
//  Created by infuntis on 12.11.16.
//  Copyright © 2016 gala. All rights reserved.
//

import Foundation
import SpriteKit

func ==(lhs: Basket, rhs: Basket) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row
}

class Basket: Hashable{
    var sprite: SKSpriteNode?
    var column: Int?
    var row: Int?
    init(column: Int, row: Int) {
        self.column = column
        self.row = row
    }
    var hashValue: Int {
        return row!*10 + column!
    }
}
