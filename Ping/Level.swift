//
//  Level.swift
//  Ping
//
//  Created by infuntis on 02.11.16.
//  Copyright © 2016 gala. All rights reserved.
//

import Foundation

let NumLevels = 4


class Level {
    
    let overSizeConst = 89
    
    
    
    
    var obstacles: Array2D<Obstacle>?// = Array2D<Obstacle>(columns: NumColumns, rows: NumRows)
    var tiles: Array2D<Tile>?
    var baskets: Array2D<Basket>?// = Array2D<Tile>(columns: NumColumns, rows: NumRows)
    var numRows: Int?
    var numColumns: Int?
    var startRow: Int?
    var startColumn: Int?
    
    
    func tileAt(column: Int, row: Int) -> Tile? {
        assert(column >= 0 && column < numColumns!)
        assert(row >= 0 && row < numRows!)
        return tiles?[column, row]
    }
    
    
    func obstacleAt(column: Int, row: Int) -> Obstacle? {
        assert(column >= 0 && column < numColumns!)
        assert(row >= 0 && row < numRows!)
        return obstacles?[column, row]
    }
    
    func basketAt(column: Int, row: Int) -> Basket? {
        assert(column >= 0 && column <= numColumns!+1)
        assert(row >= 0 && row <= numRows!+1)
        return baskets?[column, row]
    }
    
    
    init(filename: String) {
        guard let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle(filename: filename) else { return }
        guard let tilesArray = dictionary["tiles"] as? [[Int]] else { return }
        guard let start = dictionary["start"] as? [Int] else { return }
        numRows  = tilesArray.count
        numColumns  = tilesArray[1].count
        tiles = Array2D<Tile>(columns: numColumns!, rows: numRows!)
        obstacles = Array2D<Obstacle>(columns: numColumns!, rows: numRows!)
        baskets = Array2D<Basket>(columns: numColumns!+2, rows: numRows!+2)
        
        for (index,strPoint) in start.enumerated(){
            if index == 0 {
                if(strPoint == overSizeConst){
                    startRow = numRows!
                } else{
                    startRow = strPoint
                }
            }
            if index == 1{
                if(strPoint == overSizeConst){
                    startColumn = numColumns!
                } else{
                    startColumn = strPoint
                }
            }
        }
        
        print("start row \(startRow) start column \(startColumn)" )
        
        for (row, rowArray) in tilesArray.enumerated() {
            let tileRow = numRows! - row - 1
            for (column, value) in rowArray.enumerated() {
                if value == 1 {
                    tiles?[column, tileRow] = Tile(type: 1)
                }
                if value == 2{
                    tiles?[column, tileRow] = Tile(type:2)
                }
                if value == 3{
                    tiles?[column, tileRow] = Tile(type: 3)
                }
            }
        }
    }
    
    
    func createInitialObstacles() -> [Obstacle] {
        var list = [Obstacle]()
        
        for row in 0..<numRows! {
            for column in 0..<numColumns! {
                
                if tiles?[column, row] != nil {
                    if(tiles?[column, row]?.type == 1){
                        let obstacle = Obstacle(column: column, row: row, rotation: RotationType.positive)
                        obstacles?[column, row] = obstacle
                        list.append(obstacle)
                        
                    }
                    if(tiles?[column, row]?.type == 2){
                        let obstacle = Obstacle(column: column, row: row, rotation: RotationType.reverse)
                        obstacles?[column, row] = obstacle
                        list.append(obstacle)
                        
                    }
                    if(tiles?[column, row]?.type == 3){
                        let rotationType = RotationType.random()
                        
                        let obstacle = Obstacle(column: column, row: row, rotation: rotationType)
                        obstacles?[column, row] = obstacle
                        list.append(obstacle)
                    }
                    
                }
            }
        }
        return list
    }
    
    func createInitialBaskets() -> [Basket]{
        var list = [Basket]()
        for row in 0..<numRows!+2 {
            for column in 0..<numColumns!+2 {
                if row == 0 && column != 0 && column != numColumns!+1 {
                    let basket = Basket(column: column, row: row)
                    baskets?[column, row] = basket
                    list.append(basket)
                }
                if row == numRows!+1 && column != 0 && column != numColumns!+1 {
                    let basket = Basket(column: column, row: row)
                    baskets?[column, row] = basket
                    list.append(basket)
                }
                if row == 0 && column != 0 && column != numColumns!+1 {
                    let basket = Basket(column: column, row: row)
                    baskets?[column, row] = basket
                    list.append(basket)
                }
                if column == 0 && row != 0 && row != numRows!+1 {
                    let basket = Basket(column: column, row: row)
                    baskets?[column, row] = basket
                    list.append(basket)
                }
                if column == numColumns!+1 && row != 0 && row != numRows!+1 {
                    let basket = Basket(column: column, row: row)
                    baskets?[column, row] = basket
                    list.append(basket)
                }

            }
        }
        return list
    }
}
