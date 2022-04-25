//
//  StartScreenScene.swift
//  Mr Puniverse Inspired Game
//
//  Created by Andy Guttridge on 04/01/2022.
//

import Foundation
import SpriteKit

class StartScreenScene: SKScene {
    //Load the StartScreen .sks file and pass it to the GameViewController
    class func newGameScene() -> StartScreenScene {
        // Load 'StartScreen.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "StartScreen") as? StartScreenScene else {
            print("Failed to load StartScreen.sks")
            abort()
        }
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        return scene
    }
}

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension StartScreenScene {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Start the game if the player touches the screen.
        
        //Get a reference to the scene's UIViewController case as GameViewController
        guard let controller = self.view?.window?.rootViewController as? GameViewController
        else {return}
        
        controller.playerDidStartGame() //Call the method on the GameViewController to deal with the state change to a live game.
    }
}

#endif

#if os(OSX)
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
