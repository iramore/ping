//
//  GameScene.swift
//  Ping
//
//  Created by infuntis on 02.11.16.
//  Copyright © 2016 gala. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var level: Level!
    
    let TileWidth: CGFloat = 60.0
    let TileHeight: CGFloat = 60.0
    
    let gameLayer = SKNode()
    let obstaclesLayer = SKNode()
    let tilesLayer = SKNode()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let background = SKSpriteNode(imageNamed: "background")
        background.size = size
        addChild(background)
        addChild(gameLayer)
        
    }
    func addTilesAndObstacles(){
        
        let layerPosition = CGPoint(
            x: -TileWidth * CGFloat(level.numColumns!) / 2,
            y: -TileHeight * CGFloat(level.numRows!) / 2)
        tilesLayer.position = layerPosition
        gameLayer.addChild(tilesLayer)
        
        obstaclesLayer.position = layerPosition
        gameLayer.addChild(obstaclesLayer)
        
    }
    
    func addSprites(for obstacles: Set<Obstacle>) {
        for obstacle in obstacles {
            let sprite = SKSpriteNode(imageNamed: obstacle.obstacleType.spriteName)
            sprite.size = CGSize(width: TileWidth, height: TileHeight)
            sprite.position = pointFor(column: obstacle.column, row: obstacle.row)
            obstaclesLayer.addChild(sprite)
            obstacle.sprite = sprite
        }
    }
    
    func addTiles() {
        for row in 0..<level.numRows! {
            for column in 0..<level.numColumns! {
                
                                    let tileNode = SKSpriteNode(imageNamed: "tile")
                    tileNode.size = CGSize(width: TileWidth, height: TileHeight)
                    tileNode.position = pointFor(column: column, row: row)
                    tilesLayer.addChild(tileNode)
                
            }
        }
    }
    
    func pointFor(column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column)*TileWidth + TileWidth/2,
            y: CGFloat(row)*TileHeight + TileHeight/2)
    }
}
