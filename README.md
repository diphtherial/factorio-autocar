# Factorio Autocar Mod
Adds an automatable car to Factorio that can be controlled via tiles directives.

As the version number (0.0.2 at time of writing) indicates, this is a super-rough version of the idea, but it more or less works. Note that it's not balanced at all (more on that later).

## Getting Started

The main research is the "Tile Directives" research, available after Automobolism. That unlocks the following items:

- The **Autocar**, a car-like entity that currently looks just like the car sans a turret. The player can ride it, but not control it at all. When fuel is inserted, it'll move forward at the default (slow) speed and consume fuel items until it runs out or hits something. The car will cease to respond to tile directives once it runs out of fuel, so plan accordingly.
- **Tile Directives**, concrete-like tiles with instructions on them that the car will follow when it runs over one. The car will snap to the position of the center of the tile on contact to keep it on the grid. The tile commands are described below. (Since they're like concrete, they'll by default start with a 2x2 brush size; you should probably reduce this to 1x1 by pressing the '-' key.)

## Tile Directive Types:

1. **Rotate CW/CCW:** rotate the car clockwise or counter-clockwise.
2. **Orient N/S/E/W:** align the car to a compass direction.
3. **Reverse:** rotate the car 180 degrees.
4. **Pause:** stops the car for a few seconds, then allows it to resume.
5. **Speed Up/Down:** increases or decreases the car's speed, respectively, which also changes fuel consumption. There is a maximum and minimum speed, configurable in the config.lua file.
6. **Stall:** hold the car until the circuit condition on the attached lamp is satisfied. Must be powered and the lamp must be connected to a circuit network to function. The smart-chest part can also be connected to a circuit network, and will publish the car's inventory to the attached network.

There is also an **Idle Tile** (still in development) that can be used to have the car place a tile automatically after some time elapses. When a stack of idle tiles are placed in the trunk, the car will remove one item from the first stack of idle tiles it finds (scanning left-to-right, bottom-to-top). When the last idle tile is removed, and a tile directive is in the immediately next inventory slot, that tile directive will be placed in front of the car. This allows you to do things like dispatch a car with a stack of idle tiles and a reverse tile immediately after it to set up a loop to a far-off destination quickly. You can set up sequences of tiles to place by interspersing idle tiles and tile directives in the inventory (e.g. to construct a circular loop).

## Role/Balance:

Generally, I see the autocar as being useful for long-distance transportation of goods, or in-base transportation where it'd be tedious to run belts. The autocar is slightly more flexible than the train in that it can publish its inventory to a circuit network and respond to circuit conditions, although its top speed is of course much slower. It's more feasible to use an autocar to connect far-flung bases than place a logistics network, and its power requirements are more modest.

I envision the player starting with an autocar and a few tile directives (to assist in the usual run-around of tending to furnaces, miners, etc.), then having to perform the required research after automobilism to create more.

## Ideas/Notes/Future Work:

- Lamp graphic borrowed from the [Logic Belts](http://www.factorioforums.com/forum/viewtopic.php?f=91&t=14007) mod without permission. Sorry!
- I intend to implement "pallets" that increase the loading/unloading bandwidth by allowing it to load an adjacent chest immediately (like a shipping pallet) into its inventory and then unload it either onto an adjacent autocar or into a chest. Not sure how well that balances, but I think it'd provide an argument to continue using the car.
- Using batteries and the electric network would be cool, but I'm having trouble hacking the car prototype to support it.
- Custom graphics for the autocar would be really nice. I'd eventually like it to be a cube, kind of like a sleeker version of [one of these](https://upload.wikimedia.org/wikipedia/commons/f/fe/Forklift_AGV_with_Stabilizer_Pad%2C_Egemin_Automation_Inc.jpg).
- More ways to report status from the cars to a circuit network. Examples: exposing its fuel inventory instead of the trunk, having a circuit network signal that just indicates the presence of a car.
- Requiring a "speed limit" to stop on certain tiles, so that the car doesn't come to an unrealistically abrupt stop on a pause/stall tile. This is easy to implement, just need to get around to it...
- Figure out a way to have the autocar check its environment for suitable conditions before, say, deploying a blueprint or a tile. This could be used to scout for bases and then to set up an initial structure, perhaps. It'd be nice if the car could be programmed to lay down belts or other structures behind it as it moves to automate that tedious activity...
