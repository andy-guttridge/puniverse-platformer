# Puniverse Platformer
This is a proof of concept demo of simple iOS platform game written in Swift and using the SpriteKit framework. It is inspired by a simple but great 80s platform game called [Mr Puniverse](https://www.youtube.com/watch?v=3JxU1qmFdf4) for the Commodore 16/Plus-4, which I spent hours playing as a kid.

This is currently very much a work-in-progress. Most of the desired game elements from the original game are now implemented and fully functioning, with the exception of the 'ladders' that let let you climb up (but not down) on certain levels. 

However the art assests are very rudimentary at present, levels need to be designed, and functionality enabling loading of multiple levels and saving game progress needs to be implemented. The game will also need a proper title when a theme has been decided.

Game objects currently implemented are as follows (and you can see some in the screenshots below):

- Player controlled using the accelerometer to move left and right, and touching the screen to jump. The player is currently deplicted by the light yellow triangle. I need to think of a cool character for this.
- Guns shooting bullets that kill the player on contact. The guns are the military grey coloured objects with the muzzle sticking out of one side.
- 'Plungers' that move up and down, killing the player on contact - these are the pink objects. These currently move at a fixed velocity, but this needs to be changed as it is impossible to get past the shorter ones.
- 'Electric fences' that kill the play on contact, and a switch associated with each fence that activates/decativates the current in the fence. The player can disable each electric fence by finding the corresponding switch, and jumping down on it from above. Repeating this action turns the electric fence back on. The electric fences are the objects with the yellow 'teeth' (these are animated and depict the electrical current), and the switches are the grey objects the same colour as the guns but with a leaver with a red knob extending from the top.
- 'Melting blocks' - these are the lilac coloured blocks. They gradually melt away when the player is standing on them, and once they're gone there's no way to get them back - so be careful!
- 'Air depletion zones' are areas in which the player's air supply is depleted, much as though they are in a cave with limited air supply. These are currently visible as transculcent red areas for testing purposes, but will likely be invisible in the finished game (or indicated in some other way via an appropriate background design). When the player is not in an air depletion zone, the air supply is recharged until it reaches a maximum level.


