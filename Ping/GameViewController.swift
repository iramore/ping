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
        let obstacles = level.shuffle()
        scene.addSprites(for: obstacles)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view.
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false
        level = Level(filename: "Level_0")
        // Create and configure the scene.
        scene = GameScene(size: skView.bounds.size)
        scene.level = level
        scene.addTilesAndObstacles()
        scene.scaleMode = .aspectFill
        
        scene.addTiles()
        
        
        // Present the scene.
        skView.presentScene(scene)
        beginGame()
    }
}
