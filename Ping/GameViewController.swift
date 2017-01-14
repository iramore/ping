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
    var timer = Timer()
    let timeToRemember = 5
    var counter : Int?
    
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
        scene.addBasckets(for: baskets)
        timer.invalidate()
        counter = timeToRemember
        timer  = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.timerAction), userInfo: nil, repeats: true)
        
    }
    
    func timerAction(){
        counter! -= 1
        if counter! < 0{
            timer.invalidate()
            scene.addStart()
            scene.addBall()
            counter = timeToRemember
            scene.touchable = true
            scene.hideObstacles()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsPhysics = true
        level = Level(filename: "Level_2")
        scene = GameScene(size: skView.bounds.size)
        scene.level = level
        scene.addTilesAndObstacles()
        scene.scaleMode = .aspectFill
        scene.addTiles()
        skView.presentScene(scene)
        beginGame()
    }
}
