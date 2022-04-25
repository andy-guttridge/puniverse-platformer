//
//  Plunger.swift
//  Mr Puniverse Inspired Game iOS
//
//  Created by Andy Guttridge on 17/11/2021.
//

import Foundation
import SpriteKit

class PlungerSKSpriteNode: SKSpriteNode {
    
    var startPosition: CGPoint = CGPoint.init(x: 0, y: 0) //Stores the plunger head's start position on the scene.
    var lastStalkNodePosition: CGPoint = CGPoint.init(x: 0, y: 0) //Stores the position of the last stalk node on the scene.
    var stalkNodes: [SKSpriteNode] = [] //An array to store the stalk nodes currently added to the scene.
    var isMovingDown = true //Stores the current direction of the plunger head.
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super .init(texture: texture, color: color, size: size)
        }
    
    func parentSceneDidLoad () {
        startPosition = position //Store the start position before the plunger starts moving.
        physicsBody?.velocity = CGVector (dx: 0, dy: -100) //Set the plunher off moving in a downwards direction.
        
        
        addPlungerStalkAt(position, asFirstStalk: true) //Add the first plunger stalk to the scene. The asFirstStalk: true will cause the stalk to be added at the same location as the plungerHead's starting point.
    }
    
    func plungerDidCollideWithBackground () {
        //If the plunger has collided with the background and is currently moving down, get it moving up.
        if isMovingDown == true {
            physicsBody?.velocity = CGVector (dx:0, dy: 200)
            isMovingDown = false
        } else {
            //If the plunger has collided with the background and is currently moving up, get it moving down.
            physicsBody?.velocity = CGVector (dx: 0, dy: -200)
            isMovingDown = true
        }
    }
    
    func doPlungerStalks() {
        //If the current position of the plunger head is further down the screen than the bottom of the last stalkNode, and the plunger head is currently moving down, then we add another StalkNode directly beneath the previous one.
        if position.y <= (lastStalkNodePosition.y - size.height) && isMovingDown == true {
            let newPlungerStalkPosition = CGPoint.init(x: position.x, y: 0) //Create a CGPoint to position the new stalkNode. x can be relied upon to equal the  position of the plunger head, as they never move horizontally. We use a value of 0 for the y position, because the addPlungerStalkAt method will calcuate the y position based on the height of the new stalk.
            addPlungerStalkAt(newPlungerStalkPosition, asFirstStalk: false) //asFirstStalk: false ensures the method calculates the y position based on the height of the new stalkNode.
        }
        
        if position.y >= (lastStalkNodePosition.y) && isMovingDown == false && stalkNodes.count > 1 {
            stalkNodes.last?.removeFromParent()
            if stalkNodes.count > 1 {
                stalkNodes.removeLast()
            }
            if let aPosition = stalkNodes.last?.position {
                lastStalkNodePosition = aPosition
            }
        }
    }
    
    func addPlungerStalkAt (_ position: CGPoint, asFirstStalk: Bool) {
        //We retrieve the plunger stalk texture from the texture atlas, and add a node directly to the scene at the start position of the plunger head. Note that the stalk nodes are added as children of the scene rather than the plunger head, as we do not want them to move along with the plunger head (they are static nodes on the scene background).
        guard let textureAtlas = (scene as? LevelScene)?.textureAtlas else {
            return
        }//Get a reference to the texture atlas from the parent scene.
        
        let PlungerStalkTexture = textureAtlas.textureNamed("Plunger_Stalk")
        let aPlungerStalk = SKSpriteNode(texture: PlungerStalkTexture)
        if !(asFirstStalk) {
            aPlungerStalk.position = CGPoint.init(x: position.x, y: lastStalkNodePosition.y - aPlungerStalk.size.height)
        } else {
            aPlungerStalk.position = position
        }
        
        //Set up physicsBody properties for the new stalkNode
        aPlungerStalk.physicsBody?.isDynamic = false
        aPlungerStalk.physicsBody?.categoryBitMask = CollisionCategoryPlunger
        aPlungerStalk.physicsBody?.contactTestBitMask = CollisionCategoryPlayer
        aPlungerStalk.physicsBody?.collisionBitMask = 0
                
        lastStalkNodePosition = aPlungerStalk.position //Update the lastStalkNodePosition property to maintain a record of the currenty last added stalk node.
        stalkNodes.append(aPlungerStalk) //Add to the array of stalk nodes used to track the current nodes added to the scene.
        parent?.addChild(aPlungerStalk) //Add the stalk node to the scene.
    }
}
