//
//  Level.swift
//  Ping
//
//  Created by infuntis on 02.11.16.
//  Copyright © 2016 gala. All rights reserved.
//

import Foundation


class Level {
    var obstacles: Array2D<Obstacle>?// = Array2D<Obstacle>(columns: NumColumns, rows: NumRows)
    var tiles: Array2D<Tile>?// = Array2D<Tile>(columns: NumColumns, rows: NumRows)
    var numRows: Int?
    var numColumns: Int?
    
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
    
    func shuffle() -> Set<Obstacle> {
        return createInitialObstacles()
    }
    
    init(filename: String) {
        guard let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle(filename: filename) else { return }
        guard let tilesArray = dictionary["tiles"] as? [[Int]] else { return }
        numRows  = tilesArray.count
        numColumns  = tilesArray[1].count
        tiles = Array2D<Tile>(columns: numColumns!, rows: numRows!)
        obstacles = Array2D<Obstacle>(columns: numColumns!, rows: numRows!)
        
        for (row, rowArray) in tilesArray.enumerated() {
            let tileRow = numRows! - row - 1
            for (column, value) in rowArray.enumerated() {
                if value == 1 {
                    tiles?[column, tileRow] = Tile()
                }
            }
        }
    }

    
    private func createInitialObstacles() -> Set<Obstacle> {
        var set = Set<Obstacle>()
        
        
        
        for row in 0..<numRows! {
            for column in 0..<numColumns! {
                
                if tiles?[column, row] != nil {
                let obstacleType = ObstacleType.random()
                
                let obstacle = Obstacle(column: column, row: row, obstacleType: obstacleType)
                obstacles?[column, row] = obstacle
                set.insert(obstacle)
                }
            }
        }
        return set
    }
}