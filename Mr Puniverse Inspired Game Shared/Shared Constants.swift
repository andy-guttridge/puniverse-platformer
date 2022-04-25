//
//  Share Constants.swift
//  Mr Puniverse Inspired Game
//
//  Created by Andy Guttridge on 19/11/2021.
//

import Foundation
import SpriteKit

//CollisionCategoryPlayer must always be defined as the lowest collision category value
//CollisionCategoryPlunger must always be defined as the the highest collision category value for the plunger head collision detection to work correctly
//'Background' nodes (i.e. items that do not threaten the player such as static blocks, melting blocks) should have a lower collision category value than bullets and any other item that does threaten the player.

let CollisionCategoryPlayer : UInt32 = 0x1 << 1 //Define the collision category for the player node
let CollisionCategoryStaticBlock : UInt32 = 0x1 << 2 //Define the collison category for the static block nodes
let CollisionCategoryAirDrainArea : UInt32 = 0x1 << 3 //Define the collision category for air drain area nodes
let CollisionCategoryMeltingBlock : UInt32 = 0x1 << 4 //Define the collision category for melting block nodes
let CollisionCategoryBullet : UInt32 = 0x1 << 5 // Define the collision category for bullet nodes
let CollisionCategoryElectricFence : UInt32 = 0x1 << 6 //Define collision category for electric fence nodes
let CollisionCategorySwitch : UInt32 = 0x1 << 7 //Define collision category for switches that control the electric fence nodes
let CollisionCategoryPlunger : UInt32 = 0x1 << 8 //Define the collision category for plunger head nodes

let startingNumberOfLives = 5 //Number of lives at start of the game
let airUpdateRate : TimeInterval = 0.5 //A constant representing the frequency with which the player's air supply is updated in seconds
let airReplenishAmount : Float = 0.0003 // The default value for how much the player's air supply replenishes with each update

let jumpImpulse = CGFloat (1700) //The vertical impulse applied to the player when the player touches the screen

