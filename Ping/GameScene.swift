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
protocol winLoseDelegate: class {
    func gameActionCompleted(result: Bool)
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var delegateWinLose:winLoseDelegate?
    
    var level: Level!
    
    var TileWidth: CGFloat = 40.0
    var TileHeight: CGFloat = 40.0
    var BasketSize: CGFloat = 40.0
    var ObstacleWidth: CGFloat = 35.0
    var ObstacleHeight: CGFloat = 8.0
    var BallSize: CGFloat = 18.0
    var PhysicBodyBasketOffset: CGFloat = -32.0
    var DeskOffset: CGFloat = -20.0
    var TilesOffset: CGFloat = -25.0
    var BallPhBodyOffset: CGFloat = -2.0
    var BallImpulseDx: CGFloat = 1.2
    var BallImpulseDy: CGFloat = 1.2
    
    let gameLayer = SKNode()
    let obstaclesLayer = SKNode()
    let tilesLayer = SKNode()
    let basketsLayer = SKNode()
    let obstaclesLayerUpper = SKNode()
    let basketsLayerUpper = SKNode()
    var ball : SKSpriteNode
    var selected = false
    var selectedBasket: Basket?
    var testBall = SKSpriteNode(imageNamed: "ball")
    var ballAnimation: SKAction
    var touchable = false
    var theme: String
    var startImageName = "start-left"
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
   
        
    override init(size: CGSize) {
        theme = ThemeManager.currentTheme().string
        var textures:[SKTexture] = []
        for i in 1...4 {
            textures.append(SKTexture(imageNamed: "\(theme)_face\(i)"))
        }
        ballAnimation = SKAction.animate(with: textures,
                                         timePerFrame: 0.1)
        ball = SKSpriteNode(color: UIColor.blue, size: CGSize(width: BallSize,height:  BallSize))
        let ballTexture = SKTexture(imageNamed: "ball")
        //let ballTexture = SKTexture(imageNamed: "\(theme)_face1")
        ball.texture = ballTexture
        
        super.init(size: size)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        let background = SKSpriteNode(imageNamed: "back")
        background.size = size
        addChild(background)
        let desk = SKSpriteNode(imageNamed: "desk")
        desk.position = CGPoint(x: 0, y: DeskOffset)
        desk.size = size
        //addChild(desk)
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
            y: -TileHeight * CGFloat(level.numRows!) / 2 + TilesOffset)
        let basketsPosition = CGPoint(x: -TileWidth*CGFloat(level.numColumns!)/2 - TileWidth,
                                      y: -TileHeight * CGFloat(level.numRows!) / 2 + TilesOffset - TileWidth)
        let basketsPositionUpper = CGPoint(x: TileWidth*CGFloat(level.numColumns!)/2 + TileWidth,
                                           y: TileHeight * CGFloat(level.numRows!) / 2 + TilesOffset + TileWidth)
        let layerPositionUpper = CGPoint(
            x: TileWidth * CGFloat(level.numColumns!) / 2,
            y: TileHeight * CGFloat(level.numRows!) / 2 + TilesOffset)
        basketsLayer.position = basketsPosition
        basketsLayerUpper.position = basketsPositionUpper
        obstaclesLayerUpper.position = layerPositionUpper
        tilesLayer.position = layerPosition
        gameLayer.addChild(basketsLayer)
        gameLayer.addChild(tilesLayer)
        obstaclesLayer.position = layerPosition
        gameLayer.addChild(obstaclesLayer)
        gameLayer.addChild(basketsLayerUpper)
        gameLayer.addChild(obstaclesLayerUpper)
    }
    
    func addSprites(for obstacles: [Obstacle]) {
        for obstacle in obstacles {
            let texture = SKTexture(imageNamed: "obs")
            let sprite = SKSpriteNode(color: UIColor.blue, size: CGSize(width: ObstacleWidth,height:  ObstacleHeight))
            sprite.texture = texture
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
    
    func hideObstacles(){
        for row in 0..<level.numRows! {
            for column in 0..<level.numColumns! {
                if let obstacle = level.obstacleAt(column: column, row: row){
                    obstacle.sprite?.run(SKAction.hide())
                }
            }
        }
    }
    func unhideObstacles(){
        for row in 0..<level.numRows! {
            for column in 0..<level.numColumns! {
                if let obstacle = level.obstacleAt(column: column, row: row){
                    obstacle.sprite?.run(SKAction.unhide())
                }
            }
        }
    }
    
    func addBasckets(for baskets: [Basket]){
        
        for basket in baskets{
                let point = pointForBasket(column: basket.column!, row: basket.row!)
                let texture = SKTexture(imageNamed: "bascket")
                let backetNode = SKSpriteNode(color: UIColor.blue, size: CGSize(width: BasketSize,height:  BasketSize))
                backetNode.texture = texture
                backetNode.position = point
                setPhysicBodyForBasketNode(node: backetNode)
                basketsLayer.addChild(backetNode)
                basket.sprite = backetNode
        }
        
        
    }
    
    func addStart(){
        let basket = level.basketAt(column: level.startColumn!, row: level.startRow!)
        basket?.sprite?.removeFromParent()
       let point = pointForBasket(column: level.startColumn!, row: level.startRow!)
        let texture = SKTexture(imageNamed: startImageName)
        let startNode = SKSpriteNode(color: UIColor.blue, size: CGSize(width: BasketSize,height:  BasketSize))
        startNode.texture = texture
        startNode.position = point
        basketsLayer.addChild(startNode)
    }
    
    func startBallAnimation() {
        if ball.action(forKey: "animation") == nil {
            ball.run(
                SKAction.repeatForever(ballAnimation),
                withKey: "animation")
        }
    }
    
    func stopBallAnimation() {
        ball.removeAction(forKey: "animation")
    }
    
    func setPhysicBodyForBasketNode(node: SKSpriteNode){
        let size = CGSize(width: node.size.width+PhysicBodyBasketOffset, height: node.size.height+PhysicBodyBasketOffset)
        node.physicsBody = SKPhysicsBody(rectangleOf: size)
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
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2 + BallPhBodyOffset)
        ball.physicsBody?.restitution = 1
        ball.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        ball.physicsBody?.friction = 0
        ball.physicsBody?.categoryBitMask = PhysicsCatagory.Ball
        ball.physicsBody?.collisionBitMask = PhysicsCatagory.Obstacle
        ball.physicsBody?.contactTestBitMask = PhysicsCatagory.Basket
        ball.physicsBody?.fieldBitMask = 0
        ball.physicsBody?.angularDamping = 0
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.pinned = false
        ball.position = pointFor(column: level.startColumn!-1, row: level.startRow!-1)
        ball.position = CGPoint(x: ball.position.x, y: ball.position.y)
        ball.physicsBody?.affectedByGravity=false
        obstaclesLayer.addChild(ball)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if firstBody.categoryBitMask == PhysicsCatagory.Ball && secondBody.categoryBitMask == PhysicsCatagory.Basket &&  firstBody.node?.parent != nil {
            let pointBall = CGPoint(x: ball.position.x, y: ball.position.y)
            let pointBallBsk = obstaclesLayer.convert(pointBall, to: basketsLayer)
            let result = convertPointForBasket(point: pointBallBsk)
            if result.success {
                print("row \(result.row) column \(result.column)")
                if let basket = level.basketAt(column: result.column, row: result.row) {
                    let texture = SKTexture(imageNamed: "basket_with_ball")
                    //basket.sprite.size = CGSize(width: TileWidth, height: TileHeight)
                    basket.sprite!.run(SKAction.setTexture(texture))
                    if basket == selectedBasket {
                        print("WIN1")
                        delegateWinLose?.gameActionCompleted(result: true)
                    } else{
                        print("LOSE")
                        delegateWinLose?.gameActionCompleted(result: false)
                    }
                }
                firstBody.node?.removeFromParent()
            }
            
            
            
        }
        else if firstBody.categoryBitMask == PhysicsCatagory.Basket && secondBody.categoryBitMask == PhysicsCatagory.Ball &&  secondBody.node?.parent != nil {
            let pointBall = CGPoint(x: ball.position.x, y: ball.position.y)
            let pointBallBsk = obstaclesLayer.convert(pointBall, to: basketsLayer)
            let result = convertPointForBasket(point: pointBallBsk)
            if result.success {
                print("row \(result.row) column \(result.column)")
                if let basket = level.basketAt(column: result.column, row: result.row) {
                    let texture = SKTexture(imageNamed: "basket_with_ball")
                    //basket.sprite.size = CGSize(width: TileWidth, height: TileHeight)
                    basket.sprite!.run(SKAction.setTexture(texture))
                    if basket == selectedBasket {
                         print("WIN2")
                        delegateWinLose?.gameActionCompleted(result: true)
                        
                    } else{
                        print("LOSE")
                        delegateWinLose?.gameActionCompleted(result: false)
                    }
                }
                secondBody.node?.removeFromParent()
            }
            
        }
    }
    
    func animateGameOver(_ completion: @escaping () -> ()) {
        let action = SKAction.move(by: CGVector(dx: 0, dy: -size.height), duration: 0.3)
        action.timingMode = .easeIn
        gameLayer.run(action, completion: completion)
    }
    
    func animateBeginGame(_ completion: @escaping () -> ()) {
        gameLayer.isHidden = false
        gameLayer.position = CGPoint(x: 0, y: size.height)
        let action = SKAction.move(by: CGVector(dx: 0, dy: -size.height), duration: 0.3)
        action.timingMode = .easeOut
        gameLayer.run(action, completion: completion)
    }

    
    func convertPointForBasket(point: CGPoint) -> (success: Bool, column: Int, row: Int) {
        print()
        print(point)
        let pointObsLayer = basketsLayer.convert(point, to: obstaclesLayer)
        print(pointObsLayer)
        let pointObsLayerU = basketsLayer.convert(point, to: obstaclesLayerUpper)
        print(pointObsLayerU)
        let pointBskLayerU = basketsLayer.convert(point, to: basketsLayerUpper)
         print(pointBskLayerU)
        if point.x >= 0 && point.y >= 0 && pointBskLayerU.x <= 0 && pointBskLayerU.y <= 0 && (((pointObsLayer.y <= 0 && pointObsLayer.x >= 0) || (pointObsLayer.x <= 0 && pointObsLayer.y >= 0)) || ((pointObsLayerU.x >= 0 && pointBskLayerU.y <= 0) || (pointObsLayerU.y >= 0 && pointBskLayerU.x <= 0))) {
            return (true, Int(point.x / TileWidth), Int(point.y / TileHeight))
        } else {
            return (false, 0, 0)
        }
    }
    
    func pointFor(column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column)*TileWidth + TileWidth/2,
            y: CGFloat(row)*TileHeight + TileHeight/2)
    }
    
    func pointForBasket(column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column)*TileWidth + TileWidth/2,
            y: CGFloat(row)*TileHeight + TileHeight/2)    }
    
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
                    if((ball.physicsBody?.velocity.dx)! > CGFloat(5) || (ball.physicsBody?.velocity.dx)! < CGFloat(-5)){
                        ball.position.y = point.y+TileHeight/2
                    }
                    if((ball.physicsBody?.velocity.dy)!>CGFloat(5) || (ball.physicsBody?.velocity.dy)!<CGFloat(-5)){
                        ball.position.x = point.x+TileWidth/2
                    }
                }
                
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touchable {
            if selectedBasket == nil {
                guard let touch = touches.first else { return }
                let locationBs = touch.location(in: basketsLayer)
                let result = convertPointForBasket(point: locationBs)
                if result.success {
                    if let basket = level.basketAt(column: result.column, row: result.row) {
                        let texture = SKTexture(imageNamed: "selected_basket")
                        basket.sprite!.run(SKAction.setTexture(texture))
                        ball.physicsBody?.applyImpulse(CGVector(dx: BallImpulseDx, dy: BallImpulseDy))
                        selectedBasket = Basket(column: result.column,row: result.row)
                        startBallAnimation()
                        unhideObstacles()
                    }
                }
                
            }
        }
    }
    
    func updateImpulse(){
        if level.startRow! == 0 {
            BallImpulseDx *= 0
            startImageName = "start_up"
        }
        if level.startRow! == level.numRows!+1 {
            BallImpulseDy *= -1
            BallImpulseDx *= 0
            startImageName = "start_down"
        }
        if level.startColumn! == 0{
            BallImpulseDy *= 0
            startImageName = "start_right"
        }
        if level.startColumn! == level.numColumns! + 1{
            BallImpulseDy *= 0
            BallImpulseDx *= -1
            startImageName = "start_left"
        }
    }
    
    
    func initSizes(){
        let screenSize = UIScreen.main.bounds
       
        switch screenSize.height {
        case 480.0:
            print("iPhone 3,4")
            TileWidth = 35.0
            TileHeight  = 35.0
            BasketSize  = 35.0
            ObstacleWidth = 35.0
            ObstacleHeight = 6.0
            BallSize = 16.0
            PhysicBodyBasketOffset = -30.0
            DeskOffset = -20.0
            TilesOffset = -25.0
            BallPhBodyOffset = -2.0
            BallImpulseDx = 1.0
            BallImpulseDy = 1.0
        case 568.0:
            print("iPhone 5")
            TileWidth = 40.0
            TileHeight  = 40.0
            BasketSize  = 40.0
            ObstacleWidth = 35.0
            ObstacleHeight = 8.0
            BallSize = 18.0
            PhysicBodyBasketOffset = -32.0
            DeskOffset = -20.0
            TilesOffset = -25.0
            BallPhBodyOffset = -2.0
            BallImpulseDx = 1.2
            BallImpulseDy = 1.2
        case 667.0:
            print("iPhone 6")
            TileWidth = 45.0
            TileHeight  = 45.0
            BasketSize  = 45.0
            ObstacleWidth = 40.0
            ObstacleHeight = 9.0
            BallSize = 21.0
            PhysicBodyBasketOffset = -40.0
            DeskOffset = -20.0
            TilesOffset = -25.0
            BallPhBodyOffset = -3.0
            BallImpulseDx = 1.2
            BallImpulseDy = 1.2
        case 736.0:
            print("iPhone 6+")
            TileWidth = 55.0
            TileHeight  = 55.0
            BasketSize  = 55.0
            ObstacleWidth = 50.0
            ObstacleHeight = 10.0
            BallSize = 22.0
            PhysicBodyBasketOffset = -50.0
            DeskOffset = -20.0
            TilesOffset = -25.0
            BallPhBodyOffset = -4.0
            BallImpulseDx = 1.3
            BallImpulseDy = 1.3
        default:
            TileWidth = 55.0
            TileHeight  = 55.0
            BasketSize  = 55.0
            ObstacleWidth = 50.0
            ObstacleHeight = 10.0
            BallSize = 22.0
            PhysicBodyBasketOffset = -50.0
            DeskOffset = -20.0
            TilesOffset = -25.0
            BallPhBodyOffset = -4.0
            BallImpulseDx = 1.3
            BallImpulseDy = 1.3
            print("not an iPhone")
            
        }
    }
}





