//
//  GameViewController.swift
//  CookieCrunch
//
//  Created by Desireé Bryant on 5/25/17.
//  Copyright © 2017 Desireé Bryant. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class GameViewController: UIViewController {

  var scene: GameScene!
  var level: Level!
  var currentLevelNum = 1
  
  var movesLeft = 0
  var score = 0
  
  var tapGestureRecognizer: UITapGestureRecognizer!
  
  lazy var backgroundMusic: AVAudioPlayer? = {
    guard let url = Bundle.main.url(forResource: "Mining by Moonlight", withExtension: "mp3") else {
      return nil
    }
    do {
      let player = try AVAudioPlayer(contentsOf: url)
      player.numberOfLoops = -1
      return player
    } catch {
      return nil
    }
  }()
  
  @IBOutlet weak var targetLabel: UILabel!
  @IBOutlet weak var movesLabel: UILabel!
  @IBOutlet weak var scoreLabel: UILabel!
  @IBOutlet weak var gameOverPanel: UIImageView!
  @IBOutlet weak var shuffleButton: UIButton!
  
  @IBAction func shuffleButtonPressed(_: AnyObject) {
    shuffle()
    decrementMoves()
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  override var shouldAutorotate: Bool {
    return true
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return [.portrait, .portraitUpsideDown]
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupLevel(levelNum: currentLevelNum)

    backgroundMusic?.play()
    
  }
  
  func setupLevel(levelNum: Int) {
    let skView = view as! SKView
    skView.isMultipleTouchEnabled = false
    
    scene = GameScene(size: skView.bounds.size)
    scene.scaleMode = .aspectFill

    level = Level(filename: "Level_\(levelNum)")
    scene.level = level
    
    scene.addTiles()
    scene.swipeHandler = handleSwipe
    
    gameOverPanel.isHidden = true
    shuffleButton.isHidden = true

    skView.presentScene(scene)

    beginGame()
  }
  
  func beginGame() {
    movesLeft = level.maximumMoves
    score = 0
    updateLabels()
    level.resetComboMultiplier()
    scene.animateBeginGame() {
      self.shuffleButton.isHidden = false
    }
    shuffle()
  }
  
  func shuffle() {
    scene.removeAllCookieSprites()
    let newCookies = level.shuffle()
    scene.addSprites(for: newCookies)
  }

  func handleSwipe(_ swap: Swap) {
    view.isUserInteractionEnabled = false
    
    if level.isPossibleSwap(swap) {
      level.performSwap(swap)
      scene.animate(swap: swap, completion: handleMatches)
    } else {
      scene.animateInvalidSwap(swap) {
        self.view.isUserInteractionEnabled = true
      }
    }
  }
  
  func beginNextTurn() {
    level.resetComboMultiplier()
    level.detectPossibleSwaps()
    decrementMoves()
    view.isUserInteractionEnabled = true
  }
  
  func handleMatches() {
    let chains = level.removeMatches()
    
    if chains.count == 0 {
      beginNextTurn()
      return
    }
    
    scene.animateMatchedCookies(for: chains) {
    
      for chain in chains {
        self.score += chain.score
      }
      self.updateLabels()
    
      let columns = self.level.fillHoles()
      
      self.scene.animateFallingCookies(columns: columns) {
        let columns = self.level.topUpCookies()
        
        self.scene.animateNewCookies(columns) {
          self.handleMatches()
        }
      }
    }
  }
  
  func updateLabels() {
    targetLabel.text = String(format: "%ld", level.targetScore)
    movesLabel.text = String(format: "%ld", movesLeft)
    scoreLabel.text = String(format: "%ld", score)
  }
  
  func decrementMoves() {
    movesLeft -= 1
    updateLabels()
    
    if score >= level.targetScore {
      gameOverPanel.image = UIImage(named: "LevelComplete")
      currentLevelNum = currentLevelNum < NumLevels ?
      currentLevelNum + 1 : 1
      showGameOver()
    } else if movesLeft == 0 {
      gameOverPanel.image = UIImage(named: "GameOver")
      showGameOver()
    }
  }
  
  func showGameOver() {
    gameOverPanel.isHidden = false
    shuffleButton.isHidden = true
    scene.isUserInteractionEnabled = false
    
    scene.animateGameOver {
      self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideGameOver))
      self.view.addGestureRecognizer(self.tapGestureRecognizer)
    }
  }
  
  func hideGameOver() {
    view.removeGestureRecognizer(tapGestureRecognizer)
    tapGestureRecognizer = nil
    
    gameOverPanel.isHidden = true
    scene.isUserInteractionEnabled = true
    
    // beginGame()
    setupLevel(levelNum: currentLevelNum)
  }
 
} // # END OF GAMEVIEWCONTROLER
