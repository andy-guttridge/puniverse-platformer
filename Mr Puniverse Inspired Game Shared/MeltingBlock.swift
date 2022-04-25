//
//  MeltingBlock.swift
//  Mr Puniverse Inspired Game iOS
//
//  Created by Andy Guttridge on 16/11/2021.
//

import Foundation
import SpriteKit

class MeltingBlockSKSpriteNode: SKSpriteNode {
    
    var hasStartedMelting = false //A flag to track if this block has started its melting action
       
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super .init(texture: texture, color: color, size: size)
    }
    
    func blockDidCollideWithPlayer () {
        //The player collided with this melting block.
        //If the block has not already started melting, we retrieve the relevant animation textures, and create a chain of actions to animate the block melting, and then remove it from the scene,
        
        guard let textureAtlas = (scene as? LevelScene)?.textureAtlas else {
            return
        } //Get a reference to the textureAtlas of the parent scene.
        
        if hasStartedMelting == false {
            let meltingBlockf1 = textureAtlas.textureNamed("Melting_Block_f1")
            let meltingBlockf2 = textureAtlas.textureNamed("Melting_Block_f2")
            let meltingBlockf3 = textureAtlas.textureNamed("Melting_Block_f3")
            let meltingBlockf4 = textureAtlas.textureNamed("Melting_Block_f4")
            let meltingBlockTextures = [meltingBlockf1, meltingBlockf2, meltingBlockf3, meltingBlockf4]
            
            let meltingBlockAnimationAction = SKAction.animate(with: meltingBlockTextures, timePerFrame: 0.4)
            let removeMeltingBlockFromSceneAction = SKAction.removeFromParent()
            let meltingBlockChainAction = SKAction.sequence([meltingBlockAnimationAction, removeMeltingBlockFromSceneAction])
            self.run(meltingBlockChainAction)
            hasStartedMelting = true //Set the flag to indicate this block has now started melting
        } else {
            //If the block has already entered the melting state, then we unpause any actions running on this node, in order to resume the melting actions that may have been paused.
            isPaused = false
        }
    }
    
    func blockStoppedCollidingWithPlayer () {
            //If the player has stopped colliding with the block, then we pause any actions running on this node, to pause the melting sequence.
                isPaused = true
    }
}
