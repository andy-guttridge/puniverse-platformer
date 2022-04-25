//
//  GameScene.swift
//  Mr Puniverse Inspired Game Shared
//
//  Created by Andy Guttridge on 30/10/2021.
//

import SpriteKit
import CoreMotion
import GameplayKit

class LevelScene: SKScene {
            
    let coreMotionManager = CMMotionManager() //Invoke CMMotionManager.
    let textureAtlas = SKTextureAtlas(named:"Sprites.atlas") //Get a reference to the sprite texture atlas
    var theCamera : SKCameraNode? //This will be a reference to the camera for the scene.
    var player : PlayerSKSpriteNode? //This will be a reference to the node representing our player.
    var velocityLabel : SKLabelNode? //This will be a reference to a label showing our player's velocity for testing purposes.
    var airLabel : SKLabelNode? //This will be a reference to a label showing the amount of air the player has left.
    unowned var theStateMachine : GKStateMachine? //This will be a reference to the GKStateMachine which is owned by the GameViewController.
        
    class func newLevelScene() -> LevelScene {
        // Load 'GameScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "TestLevel") as? LevelScene else {
            print("Failed to load TestLevel.sks")
            abort()
        }
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        return scene
    }
    
    func setUpLevelScene() {
        
        physicsWorld.contactDelegate = self //Identify this scene as the physics world contact delegate
        theCamera = childNode(withName: "camera") as? SKCameraNode //Get a reference to the scene's SKCameraNode
        player = childNode(withName: "player") as? PlayerSKSpriteNode //Get a reference to our player sprite
        velocityLabel = theCamera?.childNode(withName: "velocity_label") as? SKLabelNode //Get a reference to our velocity label
        airLabel = theCamera?.childNode(withName: "air_value_label") as? SKLabelNode //Get a reference to our air label
        
        player?.physicsBody?.categoryBitMask = CollisionCategoryPlayer // Set the collision category for the player node
        player?.physicsBody?.contactTestBitMask = CollisionCategoryMeltingBlock | CollisionCategoryAirDrainArea //Set the contact test bitmask for all the objects the player can contact with and that we need to test for
        player?.physicsBody?.collisionBitMask = CollisionCategoryMeltingBlock | CollisionCategoryStaticBlock //Enable collisions for the player with some categories
       
                //Next, iterate through nodes, setting an appropriate categoryBitMask and contactTestBitMask for each type of node
        enumerateChildNodes(withName: "//*") {
            (node, stop) in
            
            if node.name == "static_block" {
                node.physicsBody?.categoryBitMask = CollisionCategoryStaticBlock
                node.physicsBody?.contactTestBitMask = CollisionCategoryBullet
                node.physicsBody?.collisionBitMask = 0
            }
            
            if node.name == "melting_block" {
                node.physicsBody?.categoryBitMask = CollisionCategoryMeltingBlock
                node.physicsBody?.contactTestBitMask = CollisionCategoryPlayer | CollisionCategoryBullet
                node.physicsBody?.collisionBitMask = CollisionCategoryPlayer
            }
            
            if node.name == "air_drain_area" {
                node.physicsBody?.categoryBitMask = CollisionCategoryAirDrainArea
                node.physicsBody?.contactTestBitMask = CollisionCategoryPlayer
                node.physicsBody?.collisionBitMask = 0
            }
            
            if node.name?.contains("switch") == true {
                node.physicsBody?.categoryBitMask = CollisionCategorySwitch
                node.physicsBody?.contactTestBitMask = CollisionCategoryPlayer
                node.physicsBody?.collisionBitMask = 0
            }
            
            if node.name == "plunger_head" {
                node.physicsBody?.categoryBitMask = CollisionCategoryPlunger
                node.physicsBody?.contactTestBitMask = CollisionCategoryPlayer | CollisionCategoryStaticBlock | CollisionCategoryMeltingBlock
                node.physicsBody?.collisionBitMask = 0
            }
            
        }
        
        player?.playerStartingLocation = childNode(withName: "player")?.position ?? CGPoint (x: 0, y: 0) // Retrieve the player's starting point from the SKScene and store for later use. Here we use a nil-coalescing operator to provide a default value for this optional.
        
        if let width = scene?.view?.frame.size.width {
            print ("The view is \(width) px wide")
        }
        
        if let height = scene?.view?.frame.size.height
        {
            print ("The view is \(height) px high")
            
        }
         
    }
    

    override func didMove(to view: SKView) {
                
        self.setUpLevelScene()
        //Set up the accelerometer now the scene has loaded
        coreMotionManager.accelerometerUpdateInterval = 0.3
        coreMotionManager.startAccelerometerUpdates()
        
        //Set the text of the label to display the starting number of lives for the player
        if let livesLabel = (theCamera?.childNode(withName: "lives_value_label")as? SKLabelNode),
        let numberOfLives = player?.playerLives {
            let textForLabel = String(numberOfLives)
            livesLabel.text = textForLabel
            } else {
                print ("Could not set lives_value_label")
            }
        
        //Let any plunger_head nodes in the scene know the scene has been displayed, so they can set themselves up and start moving
        
        enumerateChildNodes(withName: "plunger_head") {
            (node, stop) in
            (node as? PlungerSKSpriteNode)?.parentSceneDidLoad()
        }
        
        /*Let any gun nodes in the scene know the seen has been displayed, so they can set themselves up and start firing bullets. Note we use a
         wildcard as we have both gun_left and gun_right nodes*/
        
        enumerateChildNodes(withName: "*gun*") {
            (node, stop) in
            (node as? GunSKSpriteNode)?.parentSceneDidLoad()
        }
        
        //Let any electric fence nodes in the scene know the scene has been displayed, so they can set themselves up.
        enumerateChildNodes(withName: "electric_fence_on") {
            (node, stop) in
            (node as? ElectricFenceSKSpriteNode)?.parentSceneDidLoad()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // The next section of code deals with repositioning the camera if the player move out of the currently visible part of the scene
        guard let playerPosition = player?.position else { //Get the player's position
            return
        }
        
        guard let cameraPostition = theCamera?.position else { //Get the camera position
            return
        }
        
        
      
        let  playerPositionOnView = convertPoint(toView: playerPosition)   //Get the player's current position on the scene. Convert to iOS view coordinate system
            
        if let viewFrameHeight = view?.frame.height {
            //If the player has disappeared off the top or bottom of the visible portion of the scene, move the camera up by a full frameheight, so the player reappears at the bottom of the view
            if playerPositionOnView.y < 0 {
                theCamera?.position.y = cameraPostition.y  + viewFrameHeight
            }
            if playerPositionOnView.y > viewFrameHeight {
                theCamera?.position.y = cameraPostition.y - viewFrameHeight
            }
        }
        
        if let viewFrameWidth = view?.frame.width {
            //If the player has disappeared off the left or right of the visible portion of the scene, move the camera by a full framewidth, so the player reappears at the left or right of the scene
            if playerPositionOnView.x > viewFrameWidth {
                theCamera?.position.x = cameraPostition.x + viewFrameWidth
            }
            
            if playerPositionOnView.x < 0 {
                theCamera?.position.x = cameraPostition.x - viewFrameWidth
            }
        }
        
        //Get the camera position again, as it may already have changed according to the player's position
        guard let cameraPostition = theCamera?.position else {
            return
        }
        
        if let heightOfPlayer = (player?.size.height), let heightOfFrame = (view?.frame.height) {
            //If the player has come to rest and part of the player has disappeared off the bottom of the view, readjust the camera position to bring the whole player back into view. Remember the view coordinates start in the top left, and the player's anchor point is in the middle of the SKSpriteNode, so if the player's y coordinate plus half the height of the player is greater than the height of the frame, part of the player must be out of the view
            if ((playerPositionOnView.y + (heightOfPlayer / 2) > heightOfFrame) && (player?.physicsBody?.velocity.dy == 0)) {
                theCamera?.position.y = cameraPostition.y - (heightOfPlayer / 2)
            }
        } else {
            print ("Could not determine player location on view in GameScene.update (_ currentTime:)")
        }
        
        //Update the label that diplays the player's current velocity
        let roundedxVelocity = player?.physicsBody?.velocity.dx.rounded()
        velocityLabel?.text = roundedxVelocity?.description
        
        //Call the updateAirAmount function on the player, which takes care of the player's air supply draining or replenishing
        if theStateMachine?.currentState is PlayingState {
            player?.updateAirSupply()
        }
        
        //Update the label that displays the current amount of air the player has left
        if let playerAirRemaining = player?.airRemaining
        {
            let roundedAirRemaining = Int.init((round (playerAirRemaining * 100)))
            airLabel?.text = roundedAirRemaining.description            
        }
    }
    
    func switchDidChangeState (switchID: Int, switchIsOn: Bool) {
        //This method is called by a SwitchSKSpriteNode instance when its state changes. We use this method to talk to the corresponding ElectricFenceSKSpriteNode to ask it to change its state
        enumerateChildNodes(withName: "*electric_fence*") {
            //Iterate through any ElectricFenceSKSpriteNode instances in our scene
            (node, stop) in
                if let electricFenceDictionary = node.userData {
                    //The switch has passed us the ID number stored in its user data dictionary, so check this against each ElectricFenceSKSpriteNode. If we find match, we call the .changeElectricFenceState (switchDidTurnOn: ) method, passing through the state of the switch. The ElectricFenceSKSpriteNode will then deal with changing its own state to correspond with that of the switch
                    let electricFenceID = electricFenceDictionary.value(forKey: "id") as? Int ?? 0
                    if electricFenceID == switchID {
                        (node as? ElectricFenceSKSpriteNode)?.changeElectricFenceState(switchDidTurnOn: switchIsOn)
                }
            }
        }
    }
    
    func playerDidLoseALife() {
        player?.playerLives -= 1 //Decrement the number of lives
        //Move the player back to the start location, using an SKAction (can't set an SKSpriteNode position property directly when there is a SKPhysicsBody attached to the node).
        let movePlayerToStartPointSKAction = SKAction.move(to: player?.playerStartingLocation ?? CGPoint (x: 0, y: 0), duration: 0)
        player?.run(movePlayerToStartPointSKAction)
        
        //Update the livesLabel to reflect the new number of lives
        if let livesLabel = (theCamera?.childNode(withName: "lives_value_label")as? SKLabelNode),
        let numberOfLives = player?.playerLives {
            let textForLabel = String(numberOfLives)
            livesLabel.text = textForLabel
            } else {
                print ("Could not set lives_value_label")
            }
        
        //If the number of lives reaches 0, the player has died and we change the state of theStateMachine
        if player?.playerLives == 0 {
            theStateMachine?.enter(GameOverState.self)
            }
        else {
            player?.airRemaining = 1 //Or, if the player hasn't died, then reset the amount of air remaining to the maximum...
            player?.airUpdateUnit = airReplenishAmount //...and reset the airUpdateUnit to the default postitive value
        }
    }
    
}


extension LevelScene : SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        //Sort the two bodies involved in the contact according to the value of their categoryBitMask
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        //If the player has contacted with a melting block and the player is moving downwards (so that blocks won't melt when bumped from underneath), call a method on the melting block to start or continue the melting sequence.
        if (firstBody.node?.name == "player") && (secondBody.node?.name == "melting_block") && (contact.contactNormal.dy > 0) {
            print ("Player made contact with melting block")
                (secondBody.node as? MeltingBlockSKSpriteNode)?.blockDidCollideWithPlayer()
        }
        
        //If the player has contacted a switch and the player is moving downwards, call a method on the switch to change its state. This method also indirectly insitiates the change of the corresponding electric fence's state. The switches .name property can be either "switch_on" or "switch_off", so we check if the string contains the substring "switch".
        if (firstBody.node?.name == "player") && ((secondBody.node?.name?.contains("switch")) == true) && (contact.contactNormal.dy > 0) {
            (secondBody.node as? SwitchSKSpriteNode)?.changeSwitchState()
        }
        
        //If a plunger head has collided with a background element, call a method on the plunger to reverse direction.
        if (firstBody.node?.name != "player") && (secondBody.node?.name == "plunger_head") {
            (secondBody.node as? PlungerSKSpriteNode)?.plungerDidCollideWithBackground()
        }
        
        //If a bullet has collided with a background element, remove the bullet from the scene.
        if ((firstBody.node?.name == "static_block") || (firstBody.node?.name == "melting_block")) && (secondBody.node?.name == "bullet") {
            secondBody.node?.removeFromParent()
            print("Removed a bullet from the scene")
        }
        
        //If a plunger head, a bullet or an electric fence has collided with the player, the player loses a life.
        if (firstBody.node?.name == "player") && ((secondBody.node?.name == "plunger_head") || (secondBody.node?.name == "bullet") || (secondBody.node?.name == "electric_fence_on")) {
            playerDidLoseALife() //Call the function that deals with the player losing a life and possibly dying
        }
        
        // If the player has made contact with an air_drain_area...
        if firstBody.node?.name == "player" && secondBody.node?.name == "air_drain_area" {
            if let airDrainAreaDictionary = secondBody.node?.userData {
                let airDrainUnit = airDrainAreaDictionary.value(forKey: "air_drain_rate") //Retrieve the value for airDrainUnit from the air_drain_area's user dictionary...
                player?.airDrainStatusDidChange(airDrainUnit: airDrainUnit as? Float ?? 0) //... and call the airDrainStatusDidChange function on the player, which deals with the change in state
            }
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        //Sort the two bodies involved in the contact according to the value of their categoryBitMask.
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        //If the contact that has ended was with a melting block, call a method on the block to pause the melting action.
        if (firstBody.node?.name == "player") && (secondBody.node?.name == "melting_block") {
            (secondBody.node as? MeltingBlockSKSpriteNode)?.blockStoppedCollidingWithPlayer()
        }
        
        //If the contact that has ended was with an air_drain_area...
        if (firstBody.node?.name == "player") && (secondBody.node?.name == "air_drain_area") {
            player?.airDrainStatusDidChange() //Call the player's airDrainStatusDidChange method, without any paremeters. In this case, the player will use a default postitive value for its airSupplyUnit, which means that the air supply will start replenishing
        }
    }
   
}

    

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension LevelScene {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Apply a vertical impulse if the player touches the screen, if the game is currently in PlayingState. We also apply the current x velocity.
        
        if theStateMachine?.currentState is PlayingState {
            if let playerVelocity = player?.physicsBody?.velocity {
                 if playerVelocity.dy == 0 {
                     player?.physicsBody?.applyImpulse(CGVector (dx: playerVelocity.dx, dy: jumpImpulse))
                }
            }
        }
         //If the player touches the screen while the game is in the GameOverState, then change the state to StartScreenState.
        if theStateMachine?.currentState is GameOverState {
            theStateMachine?.enter(StartScreenState.self)
        }
        
    }
    
    override func didSimulatePhysics() {
        //When physics have been simulated - and if the game is currently in PlayingState - obtain data from the accelerometer's y axis and apply x vector to the player - note y axis data is applied to x axis because we're in landscape mode. Apply a stronger impulse if the player's x velocity is < 20, otherwise its sluggish to get going. Also we don't let the overall x velocity exceed 300.

        if theStateMachine?.currentState is PlayingState {
            if let accelerometerData = coreMotionManager.accelerometerData, let playerVelocity = player?.physicsBody?.velocity {
                switch playerVelocity.dx {
                case 0..<40:
                    player?.physicsBody?.applyImpulse(CGVector (dx: (accelerometerData.acceleration.y * 60), dy:0 ))
                case (-40)..<0:
                    player?.physicsBody?.applyImpulse(CGVector (dx: (accelerometerData.acceleration.y * 60), dy:0 ))
                case 40...150:
                    player?.physicsBody?.applyImpulse(CGVector (dx: (accelerometerData.acceleration.y * 20), dy:0 ))
                case -150..<(-40):
                    player?.physicsBody?.applyImpulse(CGVector (dx: (accelerometerData.acceleration.y * 20), dy:0 ))
                default:
                    if playerVelocity.dx > 170 {
                        player?.physicsBody?.velocity.dx = 170
                    }
                    if playerVelocity.dx < -170 {
                        player?.physicsBody?.velocity.dx = -170
                    }
                }
            }
        }

        
        //Next we call the doPlungerStalks method on each plunger head in the scene. This is where the plunger heads evaluate their current position, and add or remove stalk nodes accordingly.
        
        enumerateChildNodes(withName: "plunger_head") {
            (node, stop) in
            (node as? PlungerSKSpriteNode)?.doPlungerStalks()
        }
        
        //print (player?.physicsBody?.velocity.dx)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
   
}
#endif

#if os(OSX)
//Boiler plate code - Mac not implemented as yet.
// Mouse-based event handling
extension GameScene {

    override func mouseDown(with event: NSEvent) {
        /*
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        self.makeSpinny(at: event.location(in: self), color: SKColor.green)
         */
    }
    
    override func mouseDragged(with event: NSEvent) {
        /*
        self.makeSpinny(at: event.location(in: self), color: SKColor.blue)
         */
    }
    
    override func mouseUp(with event: NSEvent) {
        /*
        self.makeSpinny(at: event.location(in: self), color: SKColor.red)
         */
    }

}
#endif

