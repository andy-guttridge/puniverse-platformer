//
//  GameOverState.swift
//  Mr Puniverse Inspired Game
//
//  Created by Andy Guttridge on 04/01/2022.
//

import Foundation
import SpriteKit
import GameplayKit

class GameOverState : GKState {
    
    unowned let viewController: GameViewController
    
    init(viewController: GameViewController) {
        self.viewController = viewController
    }
    
    override func didEnter(from previousState: GKState?) {
        print ("Entered Game Over state")
        if let levelScene = (viewController.view as? SKView)?.scene as? LevelScene,
           let camera = levelScene.theCamera
            {
                let gameOverLabel = SKLabelNode (text: "Game Over!")
                gameOverLabel.position = CGPoint (x: 0, y: 0)
                gameOverLabel.fontName = "ChalkboardSE-Bold"
                gameOverLabel.zPosition = 1 //Make sure the label appears on top of the scene
                camera.addChild(gameOverLabel)
            }
        else {
            return
        }
    }
    
    override func willExit(to nextState: GKState) {
        
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        //The only valid next state is StartScreenState
        if stateClass == StartScreenState.self {
            return true
        }
        return false
    }
}
