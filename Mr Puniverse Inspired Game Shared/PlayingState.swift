//
//  PlayingState.swift
//  Mr Puniverse Inspired Game
//
//  Created by Andy Guttridge on 04/01/2022.
//

import Foundation
import SpriteKit
import GameplayKit

class PlayingState : GKState {
    
    unowned let viewController: GameViewController
    
    init(viewController: GameViewController) {
        self.viewController = viewController
    }
    
    override func didEnter(from previousState: GKState?) {
        
    }
    
    override func willExit(to nextState: GKState) {
        
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        //The only valid next state for PlayingState is GameOverState
        if stateClass == GameOverState.self {
            return true
        }
        return false
    }
}
