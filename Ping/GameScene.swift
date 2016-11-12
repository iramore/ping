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
    var ball = SKSpriteNode(imageNamed: "ball")
    
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
        
        let border  = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        border.friction = 0
        border.restitution = 1
        
        self.physicsBody = border
        
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
            let texture = SKTexture(imageNamed: "gorizontal")
            let sprite = SKSpriteNode(texture: texture)
            sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: sprite.size.width,                                                                   height: sprite.size.height))
            sprite.zRotation = CGFloat.pi / 4
            sprite.physicsBody?.isDynamic=false
            sprite.physicsBody?.affectedByGravity=false
            sprite.physicsBody?.friction = 0
            sprite.physicsBody?.restitution = 0
            sprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            sprite.position = pointFor(column: obstacle.column, row: obstacle.row)
            print("obstacles \(pointFor(column: obstacle.column, row: obstacle.row))")
            sprite.physicsBody?.linearDamping=0.1
            sprite.physicsBody?.categoryBitMask = 1
            sprite.physicsBody?.collisionBitMask = 2
            sprite.physicsBody?.contactTestBitMask = 2
            sprite.physicsBody?.fieldBitMask = 0
            
            sprite.physicsBody?.angularDamping=0.1
            sprite.physicsBody?.velocity = CGVector(dx:0,dy:0)
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
    
    func addBall(){
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        ball.physicsBody?.restitution = 1
        ball.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        ball.physicsBody?.friction = 0
        ball.physicsBody?.categoryBitMask = 2
        ball.physicsBody?.collisionBitMask = 1
        ball.physicsBody?.contactTestBitMask = 1
        ball.physicsBody?.fieldBitMask = 0
        ball.physicsBody?.angularDamping=0
        ball.physicsBody?.linearDamping=0
        ball.physicsBody?.velocity = CGVector(dx: 0
            , dy: 0
        )
        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.pinned = false
        ball.position = pointFor(column: level.numColumns!, row: level.numRows!-1)
        ball.physicsBody?.affectedByGravity=false
        print("ball \(pointFor(column: level.numColumns!, row: level.numRows!-1))")
        obstaclesLayer.addChild(ball)
        
        
    }
    
    func pointFor(column: Int, row: Int) -> CGPoint {
            return CGPoint(
            x: CGFloat(column)*TileWidth + TileWidth/2,
            y: CGFloat(row)*TileHeight + TileHeight/2)
    }
}
