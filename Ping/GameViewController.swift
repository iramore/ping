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

class GameViewController: UIViewController, winLoseDelegate, themeChangedDelegate {
   
    @IBOutlet weak var shopBtn: UIButton!

    var scene: GameScene!
    var level: Level!
    var timer = Timer()
    let timeToRemember = 3
    var counter : Int?
    var currentLevelNum = 1
    var score = 0
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    @IBOutlet weak var scoreLbl: UILabel!
    @IBOutlet weak var levelLbl: UILabel!
    
    @IBOutlet weak var winLoseLabel: UILabel!
    @IBOutlet weak var winLoseImageBack: UIImageView!
    override var prefersStatusBarHidden: Bool {
        return true
    }

    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait]
    }
    
    
    func themeChanged(){
        setupLevel(currentLevelNum)
    }
    internal func gameActionCompleted(result: Bool) {
        updateLabels()
        if result {
            winLoseLabel.text = "Win"
            currentLevelNum = currentLevelNum < NumLevels ? currentLevelNum+1 : 1
            showGameOver()
        } else  {
            winLoseLabel.text = "Lose"
            showGameOver()
        }

    }

    func beginGame() {
        let obstacles = level.createInitialObstacles()
        updateLabels()
        scene.addSprites(for: obstacles)
        let baskets = level.createInitialBaskets()
        scene.addBasckets(for: baskets)
        timer.invalidate()
        counter = timeToRemember
        timer  = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.timerAction), userInfo: nil, repeats: true)
        let theme = ThemeManager.currentTheme().string
        if let image = UIImage(named: "\(theme)_face_for_shop") {
            shopBtn.setImage(image, for: .normal)
        }
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
    
    func updateLabels() {
        levelLbl.text = "Level: \(currentLevelNum)"
        scoreLbl.text = "Score: \(score)"
    }
    
    func setupLevel(_ levelNum: Int) {
        
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsPhysics = true
        let maxVariant = LevelsNumberOfVariants[levelNum-1]
        let randomNum:UInt32 = arc4random_uniform(UInt32(maxVariant))
        //level = Level(filename: "Level_13")
        let filename = "Level_\(levelNum)\(randomNum+1)"
        //print(filename)
        level = Level(filename: filename)
        scene = GameScene(size: skView.bounds.size)
        scene.initSizes()
        
        scene.delegateWinLose = self
        scene.level = level
        scene.addTilesAndObstacles()
        scene.updateImpulse()
        scene.scaleMode = .aspectFill
        scene.addTiles()
        skView.presentScene(scene)
        winLoseImageBack.isHidden = true
        winLoseLabel.isHidden = true
        beginGame()
        
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLevel(currentLevelNum)
    }
    
    func showGameOver() {
        winLoseImageBack.isHidden = false
        winLoseLabel.isHidden = false
        scene.isUserInteractionEnabled = false
        
        scene.animateGameOver() {
            self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideGameOver))
            self.view.addGestureRecognizer(self.tapGestureRecognizer)
        }
    }
    
    func hideGameOver() {
        view.removeGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = nil
        winLoseImageBack.isHidden = true
        winLoseLabel.isHidden = true
        scene.isUserInteractionEnabled = true
        setupLevel(currentLevelNum)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationNavigationController = segue.destination as! UINavigationController
        let targetController = destinationNavigationController.topViewController as! ShopCollectionViewController
       targetController.themeChanged = self
    }
}
