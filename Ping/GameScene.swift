//
//  GameScene.swift
//  Ping
//
//  Created by infuntis on 02.11.16.
//  Copyright © 2016 gala. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCatagory {
    static let Obstacle : UInt32 = 0x1 << 1
    static let Basket : UInt32 = 0x1 << 3
    static let Ball : UInt32 = 0x1 << 2
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var level: Level!
    
    let TileWidth: CGFloat = 60.0
    let TileHeight: CGFloat = 60.0
    let BasketSize: CGFloat = 42.0
    
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
        self.physicsWorld.contactDelegate = self
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
    
    func addSprites(for obstacles: [Obstacle]) {
        for obstacle in obstacles {
            let texture = SKTexture(imageNamed: "gorizontal")
            let sprite = SKSpriteNode(texture: texture)
            sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: sprite.size.width,                                                                   height: sprite.size.height))
            sprite.zRotation = obstacle.rotation.angle
            sprite.physicsBody?.isDynamic=false
            sprite.physicsBody?.affectedByGravity=false
            sprite.physicsBody?.friction = 0
            sprite.physicsBody?.restitution = 0
            sprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            sprite.position = pointFor(column: obstacle.column, row: obstacle.row)
            sprite.physicsBody?.linearDamping=0.1
            sprite.physicsBody?.categoryBitMask = PhysicsCatagory.Obstacle
            sprite.physicsBody?.collisionBitMask = PhysicsCatagory.Ball
            sprite.physicsBody?.contactTestBitMask = PhysicsCatagory.Ball
            sprite.physicsBody?.angularDamping=0.1
            sprite.physicsBody?.velocity = CGVector(dx:0,dy:0)
            obstaclesLayer.addChild(sprite)
            obstacle.sprite = sprite
        }
    }
    func addBascketsAndStart(for baskets: [Basket]){
        
        for basket in baskets{
            if basket.column! != level.startColumn! || basket.row! != level.startRow! {
                let point = pointForBasket(column: basket.column!, row: basket.row!)
                let texture = SKTexture(imageNamed: "bascket")
                let backetNode = SKSpriteNode(texture: texture)
                backetNode.position = point
                setPhysicBodyForBasketNode(node: backetNode)
                obstaclesLayer.addChild(backetNode)
                basket.sprite = backetNode
            }
        }
        let point = pointForBasket(column: level.startColumn!, row: level.startRow!)
        let texture = SKTexture(imageNamed: "start")
        let startNode = SKSpriteNode(texture: texture)
        startNode.position = point
        obstaclesLayer.addChild(startNode)
        
    }
    
    func setPhysicBodyForBasketNode(node: SKSpriteNode){
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = PhysicsCatagory.Basket
        node.physicsBody?.collisionBitMask = 0
        node.physicsBody?.contactTestBitMask = PhysicsCatagory.Ball
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
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2-2)
        ball.physicsBody?.restitution = 1
        ball.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        ball.physicsBody?.friction = 0
        ball.physicsBody?.categoryBitMask = PhysicsCatagory.Ball
        ball.physicsBody?.collisionBitMask = PhysicsCatagory.Obstacle
        ball.physicsBody?.contactTestBitMask = PhysicsCatagory.Basket
        ball.physicsBody?.fieldBitMask = 0
        ball.physicsBody?.angularDamping=0
        ball.physicsBody?.linearDamping=0
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.pinned = false
        ball.position = pointFor(column: level.numColumns!, row: level.numRows!-1)
        ball.position = CGPoint(x: ball.position.x, y: ball.position.y)
        ball.physicsBody?.affectedByGravity=false
        obstaclesLayer.addChild(ball)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if firstBody.categoryBitMask == PhysicsCatagory.Ball && secondBody.categoryBitMask == PhysicsCatagory.Basket{
            let result = convertPointForBasket(point: CGPoint(x: ball.position.x, y: ball.position.y))
            if result.success {
                print("row \(result.row) column \(result.column)")
                if let basket = level.basketAt(column: result.column, row: result.row) {
                    let texture = SKTexture(imageNamed: "basket_with_ball")
                    //basket.sprite.size = CGSize(width: TileWidth, height: TileHeight)
                    basket.sprite!.run(SKAction.setTexture(texture))
                    
                }
                
            }
            firstBody.node?.removeFromParent()
            
            
        }
        else if firstBody.categoryBitMask == PhysicsCatagory.Basket && secondBody.categoryBitMask == PhysicsCatagory.Ball {
            let result = convertPointForBasket(point: CGPoint(x: ball.position.x, y: ball.position.y))
            if result.success {
                print("row \(result.row) column \(result.column)")
                if let basket = level.basketAt(column: result.column, row: result.row) {
                    let texture = SKTexture(imageNamed: "basket_with_ball")
                    //basket.sprite.size = CGSize(width: TileWidth, height: TileHeight)
                    basket.sprite!.run(SKAction.setTexture(texture))
                    
                }
            }
            secondBody.node?.removeFromParent()
        }
    }
    
    func convertPointForBasket(point: CGPoint) -> (success: Bool, column: Int, row: Int) {
        if point.x >= 0 && point.x < CGFloat(level.numColumns!)*TileWidth &&
            point.y >= 0 && point.y < CGFloat(level.numRows!)*TileHeight {
            return (true, Int(point.x / TileWidth), Int(point.y / TileHeight))
        } else {
            return (false, 0, 0)  // invalid location
        }
    }
    
    func pointFor(column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column)*TileWidth + TileWidth/2,
            y: CGFloat(row)*TileHeight + TileHeight/2)
    }
    func pointForBasket(column: Int, row: Int) -> CGPoint {
        if column == -1 {
            return CGPoint(
                x: CGFloat(column)*TileWidth + TileWidth - BasketSize/2,
                y: CGFloat(row)*TileHeight + TileHeight/2)
        } else if column == level.numColumns! {
            return CGPoint(
                x: CGFloat(column)*TileWidth + BasketSize/2,
                y: CGFloat(row)*TileHeight + TileHeight/2)
        } else if row == -1 {
            return CGPoint(
                x: CGFloat(column)*TileWidth + TileHeight/2,
                y: CGFloat(row)*TileHeight + TileWidth - BasketSize/2)
        }else {
            return CGPoint(
                x: CGFloat(column)*TileWidth + TileWidth/2,
                y: CGFloat(row)*TileHeight + BasketSize/2)
        }
    }
    
    func pointForStart(column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column)*TileWidth,
            y: CGFloat(row)*TileHeight )
    }
    override func update(_ currentTime: TimeInterval) {
        updateBallPosition()
    }
    
    func updateBallPosition(){
        for row in 0..<level.numRows! {
            for column in 0..<level.numColumns! {
                let point = pointForStart(column: column, row: row)
                if(ball.position.x > point.x && ball.position.y > point.y && ball.position.x < point.x+TileWidth && ball.position.y < point.y + TileHeight){
                    if((ball.physicsBody?.velocity.dx)!>CGFloat(5) || (ball.physicsBody?.velocity.dx)!<CGFloat(-5)){
                        ball.position.y = point.y+TileHeight/2
                    }
                    if((ball.physicsBody?.velocity.dy)!>CGFloat(5) || (ball.physicsBody?.velocity.dy)!<CGFloat(-5)){
                        ball.position.x = point.x+TileWidth/2
                    }
                }
                
            }
        }
    }
    
    
    
    
}
