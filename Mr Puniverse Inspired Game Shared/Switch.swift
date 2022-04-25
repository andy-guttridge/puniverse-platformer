//
//  Switch.swift
//  Mr Puniverse Inspired Game
//
//  Created by Andy Guttridge on 30/01/2022.
//

import Foundation
import SpriteKit

class SwitchSKSpriteNode: SKSpriteNode {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super .init(texture: texture, color: color, size: size)
    }
    
    func changeSwitchState() {
        //This method is called by the LevelScene when the player collides with the switch to change its state
        
        guard let textureAtlas = (scene as? LevelScene)?.textureAtlas else {
            return
        } //Get a reference to the textureAtlas of the parent scene.
        
        
        switch name {
            //Is the switch currently on or off? We use the .name property of the SwitchSKSpriteNode instance to store the switch's current state
            case "switch_off":
            //If the switch is currently of, we update the .name property to reflect the new state, and update the texture so the switch appears to be in the 'left' position
                self.name = "switch_on"
                let switchOnTexture = textureAtlas.textureNamed("Switch_L")
                self.texture = switchOnTexture
                if let switchDictionary = self.userData {
                    //Retrieve the ID number for this switch from this SwitchSKSpriteNode's user data dictionary, and then call the LevelScene.switchDidChangeState method, passing through the switch's ID and its current state
                    let switchID: Int = switchDictionary.value(forKey: "id") as? Int ?? 0
                    (scene as? LevelScene)?.switchDidChangeState(switchID: switchID, switchIsOn: true)
                }
            default:
                //Turn switch off
                self.name = "switch_off"
                //If the switch is currently of, we update the .name property to reflect the new state, and update the texture so the switch appears to be in the 'right' position
                let switchOffTexture = textureAtlas.textureNamed("Switch_R")
                self.texture = switchOffTexture
                if let switchDictionary = self.userData {
                    //Retrieve the ID number for this switch from this SwitchSKSpriteNode's user data dictionary, and then call the LevelScene.switchDidChangeState method, passing through the switch's ID and its current state
                    let switchID = switchDictionary.value(forKey: "id") as? Int ?? 0
                    (scene as? LevelScene)?.switchDidChangeState(switchID: switchID, switchIsOn: false)
                }
        }
    }
}
