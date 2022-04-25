//
//  Player.swift
//  Mr Puniverse Inspired Game iOS
//
//  Created by Andy Guttridge on 16/11/2021.
//

import Foundation
import SpriteKit

class PlayerSKSpriteNode: SKSpriteNode {
        
    var playerLives = startingNumberOfLives //Define a property that holds the current number of player lives, and initialise with a starting value.
    var playerStartingLocation = CGPoint (x: 0, y: 0) //Define a property to store the player's starting point within the level. The default value is overwritten before the property is used.
    var airRemaining: Float = 1 //Instance variable to store the amount of air the player has left. 1 is the maximum
    var airUpdateUnit: Float = airReplenishAmount //Instance variable to store a value by which the player's air supply drains or replenishes with each frame update. A positive value results in air replenishing, a negative value results in air draining
    private var lastAirUpdateTime = Date.init() //This stores the time at which the last update to the player's air supply was made. Set an initial value of the current date.
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super .init(texture: texture, color: color, size: size)
    }
    
    func updateAirSupply () {
        let timeNow = Date.init ()
        if (lastAirUpdateTime + airUpdateRate >= timeNow) {
            airRemaining += airUpdateUnit
            if airRemaining > 1 {
                airRemaining = 1
            }
            if airRemaining <= 0 {
                (scene as! LevelScene).playerDidLoseALife()
            }
        }
        lastAirUpdateTime = timeNow //Update the time when the last air supply was last updated
    }
    
    func airDrainStatusDidChange (airDrainUnit: Float = airReplenishAmount) {
        airUpdateUnit = airDrainUnit
    }
    
}
