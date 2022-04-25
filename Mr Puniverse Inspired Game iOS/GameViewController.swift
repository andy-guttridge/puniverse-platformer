//
//  GameViewController.swift
//  Mr Puniverse Inspired Game iOS
//
//  Created by Andy Guttridge on 30/10/2021.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    //Define these properties as optionals, as we are not ready to initialise them until after super.init has been called
    var startScreenState: StartScreenState?
    var playingState: PlayingState?
    var gameOverState: GameOverState?
    var stateMachine: GKStateMachine?
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        //Create instances of the various states our game will use for use with the state machine
        
        startScreenState = StartScreenState (viewController: self)
        playingState = PlayingState (viewController: self)
        gameOverState = GameOverState (viewController: self)
        stateMachine = GKStateMachine.init(states: [startScreenState!, playingState!, gameOverState!]) //Create an instance of a GKStateMachine using the states created above. Note these are force unwrapped, as we have just created them within this method, so we know they exist.
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = StartScreenScene.newGameScene() //Create an instance of the StartScreenScene, which is the first scene in our game
       
        // Present the scene
        let skView = self.view as! SKView
        skView.presentScene(scene)
        
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
        
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .landscapeLeft
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    // Make the Home Indicator greyed out and require two upward swipes to dismiss the game
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return [.bottom]
    }
    
    func playerDidStartGame() {
        //The player has touched the start screen, signalling they wish to start a new game. This method is called from an instance of StartScreenScene
        
        if let theStateMachine = stateMachine {
            //Tell theStateMachine that we are now entering the PlayingState.
            theStateMachine.enter(PlayingState.self)
        }
        
        //Create a SKTransition to move from the start screen to the level, create a new LevelScene instance, pass it a reference to theStateMachine, and present the LevelScene instance, using the transition
        let aTransition = SKTransition.doorsOpenHorizontal (withDuration: 2)
        let levelScene = LevelScene.newLevelScene()
        let skView = self.view as! SKView
        levelScene.theStateMachine = stateMachine //Give the scene a reference to the state machine
        skView.presentScene(levelScene, transition: aTransition)
    }
    
    func returnToStartScreen () {
        //This method is called by an instance of StartScreenState, when we have just entered this state after the player has died, so we create an instance of StartScreenScene and present it. 
        let startScreenScene = StartScreenScene.newGameScene()
        let skView = self.view as! SKView
        skView.presentScene(startScreenScene)
    }
}
