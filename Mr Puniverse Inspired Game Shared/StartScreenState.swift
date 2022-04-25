//
//  StartScreenState.swift
//  Mr Puniverse Inspired Game
//
//  Created by Andy Guttridge on 04/01/2022.
//

import Foundation
import SpriteKit
import GameplayKit

class StartScreenState : GKState {
    
    unowned let viewController: GameViewController
    
    init(viewController: GameViewController) {
        self.viewController = viewController
    }
    
    override func didEnter(from previousState: GKState?) {
        //If we've entered this state after the player has died, then call the returnToStartScreen method on the view controller, which gets rid of the current LevelScene and presents the StartScreenScene. 
        if previousState is GameOverState {
            viewController.returnToStartScreen()
        }
    }
    
    override func willExit(to nextState: GKState) {
        
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        //The only valid next state is PlayingState
        if stateClass == PlayingState.self {
            return true
        }
        return false
    }
}
