//
//  GameViewController.swift
//  Ping
//
//  Created by infuntis on 02.11.16.
//  Copyright © 2016 gala. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    var scene: GameScene!
    var level: Level!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.landscape]
    }
    func beginGame() {
        let obstacles = level.createInitialObstacles()
        scene.addSprites(for: obstacles)
        let baskets = level.createInitialBaskets()
        scene.addBascketsAndStart(for: baskets)
        scene.addBall()
        scene.ball.physicsBody?.applyImpulse(CGVector(dx: -1, dy: 0))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false
        level = Level(filename: "Level_3")
        scene = GameScene(size: skView.bounds.size)
        scene.level = level
        scene.addTilesAndObstacles()
        scene.scaleMode = .aspectFill
        scene.addTiles()
        
        skView.presentScene(scene)
        beginGame()
    }
}
