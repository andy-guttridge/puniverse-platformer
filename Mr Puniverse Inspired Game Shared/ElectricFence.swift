//
//  ElectricFence.swift
//  Mr Puniverse Inspired Game
//
//  Created by Andy Guttridge on 23/01/2022.
//


import Foundation
import SpriteKit

class ElectricFenceSKSpriteNode: SKSpriteNode {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super .init(texture: texture, color: color, size: size)
    }
    
    func parentSceneDidLoad () {
        guard let textureAtlas = (scene as? LevelScene)?.textureAtlas else {
            print ("Did not find texture atlas in ElectricFenceSKSpriteNode.parentSceneDidLoad")
            return
        }
        
        //Create a repeating SKAction to animate the ElectricFenceSKSpriteNode instance.
        let electricFenceOnLeftTexture = textureAtlas.textureNamed("Electric_Fence_On_L")
        let electricFenceOnRightTexture = textureAtlas.textureNamed("Electric_Fence_On_R")
        let animateFenceAction = SKAction.animate(with: [electricFenceOnLeftTexture, electricFenceOnRightTexture], timePerFrame: 0.05)
        let repeatAnimateFenceAction = SKAction.repeatForever(animateFenceAction)
        self.run(repeatAnimateFenceAction)
    }
    
    func changeElectricFenceState (switchDidTurnOn: Bool) {
        //This method is called by the LevelScene if the player changes the state of a switch associated with this ElectricFenceSKSpriteNode instance
        
        guard let textureAtlas = (scene as? LevelScene)?.textureAtlas else {
            return
        } //Get a reference to the textureAtlas of the parent scene.
        
        switch switchDidTurnOn {
            //Did the switches state turn to 'on'?
        case false:
            //If the switch was turned off, turn the fence instance off. We update the fence's .name property to reflect the 'off' state, remove all actions from the node, and change the texture to the Electric_Fence_Off texture.
            self.name = "electric_fence_off"
            self.removeAllActions()
            let electricFenceOffTexture = textureAtlas.textureNamed("Electric_Fence_Off")
            self.texture = electricFenceOffTexture
        default:
            //The switch was turned on, so turn the fence instance on. We update the fence's .name property to reflect the 'on' state,  create a SKAction to animate the fence, add the action to the ElectricFenceSKSpriteNode, and run the action.
            
            //This could perhaps be refactored so that the SKAction is only created once when the node is first instantiated, and stored for later reuse rather than recreating it here
            self.name = "electric_fence_on"
            let electricFenceOnLeftTexture = textureAtlas.textureNamed("Electric_Fence_On_L")
            let electricFenceOnRightTexture = textureAtlas.textureNamed("Electric_Fence_On_R")
            let animateFenceAction = SKAction.animate(with: [electricFenceOnLeftTexture, electricFenceOnRightTexture], timePerFrame: 0.05)
            let repeatAnimateFenceAction = SKAction.repeatForever(animateFenceAction)
            self.run(repeatAnimateFenceAction)
        }
    }
}

