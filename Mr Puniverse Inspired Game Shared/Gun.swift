//
//  Gun.swift
//  Mr Puniverse Inspired Game
//
//  Created by Andy Guttridge on 28/12/2021.
//

import Foundation
import SpriteKit

class GunSKSpriteNode: SKSpriteNode {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super .init(texture: texture, color: color, size: size)
    }
    
    func parentSceneDidLoad () {
        let shootBulletAction: SKAction = SKAction.run (self.fireBullet) //Create an SKAction to run the bullet firing function
        let waitAction: SKAction = SKAction.wait(forDuration: 5) //Create an SKAction to wait for a period
        let chainedShootingActions: SKAction = SKAction.sequence ([shootBulletAction, waitAction]) //Create an action to fire the bullet and then wait a number of seconds
        let repeatingChainedShootingActions: SKAction = SKAction.repeatForever(chainedShootingActions) //Create an action to keep firing bullets forever
        self.run (repeatingChainedShootingActions) //Run the repeating shooting action
    }
     
    func fireBullet() {
        let aBullet = SKSpriteNode.init(imageNamed: "Bullet") //Create a bullet SKSpriteNode
        aBullet.anchorPoint = CGPoint.init(x: 0.5, y: 0.5) //Set anchor point to centre of SKSpriteNode
        aBullet.name = "bullet" //Set the SKSpriteNode's name to bullet
        
        //Create a physics body for the bullet and set properties
        aBullet.physicsBody = SKPhysicsBody.init(rectangleOf: aBullet.size)
        aBullet.physicsBody?.isDynamic = true
        aBullet.physicsBody?.affectedByGravity = false
        aBullet.physicsBody?.allowsRotation = false
        aBullet.physicsBody?.pinned = false
        aBullet.physicsBody?.mass = 0.25
        aBullet.physicsBody?.friction = 0
        aBullet.physicsBody?.restitution = 0
        aBullet.physicsBody?.linearDamping = 0
        aBullet.physicsBody?.angularDamping = 0
        aBullet.physicsBody?.categoryBitMask = CollisionCategoryBullet
        aBullet.physicsBody?.contactTestBitMask = CollisionCategoryPlayer | CollisionCategoryStaticBlock | CollisionCategoryMeltingBlock
        aBullet.physicsBody?.collisionBitMask = 0
        
        //Position the bullet relative to the gun's anchor points - this will differ depending on whether the gun is pointing left or right
        
        let gunType = self.name //Retrieve the name value of our gun to find out which direction it is facing
        
        //Declare empty variables for use in Switch statment below
                var bulletStartX : CGFloat = 0
        var bulletStartY : CGFloat = 0
        var bulletStartVelocity = CGVector.init()
        
        //Set up the bullet's start position and velocity relative to the gun, with a different case for gun_left and gun_right nodes
        switch gunType {
        case "gun_left":
            bulletStartX = self.position.x - 16
            bulletStartY = self.position.y
            bulletStartVelocity = CGVector.init(dx: -200, dy: 0)
        case "gun_right":
            bulletStartX = self.position.x + 16
            bulletStartY = self.position.y
            bulletStartVelocity = CGVector.init(dx: 200, dy: 0)
        default:
            print ("Something went wrong with firing a bullet. Check 'name' parameter of gun in scene builder.")
        }
        
        //Add the bullet to the scene, set its position and velocity
        self.scene?.addChild(aBullet)
        print ("Bullet added")
        aBullet.position = CGPoint.init(x: bulletStartX, y: bulletStartY)
        aBullet.physicsBody?.velocity = bulletStartVelocity
        
        
         
    }
}



