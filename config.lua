require 'defines'

debug_mode = true -- Set to true to receive tasty debugging information ingame

COMMAND_DELAY = 0 -- debounce before a car can execute another command (this is mostly handled otherwise by the car remembering the last tile that issued it a command)
STALL_TIME = 100 -- time to stop at a basic stall tile
DEFAULT_SPEED = 0.03 -- initial speed of the autocar
MIN_SPEED = 0.01 -- minimum speed reachable via slowdown tiles
MAX_SPEED = 0.35 -- maximum speed reachable via speedup tiles

OFFSET_TOLERANCE = 0.25 -- degree to which the car can be offset from the tile midpoint and still accept the command
						-- decreases the "jerkiness" of snapping to a tile's position, but also requires the car to be better-aligned to the tilegrid

-- FIXME: implement these eventually
STALL_VELOCITY_LIMIT = 0.08 -- max speed to stop at a stall tile (otherwise it overshoots)
DIRCHANGE_VELOCITY_LIMIT = 0.1 -- max speed to change direction (otherwise it overshoots)

-- the formula for fuel consumption is the following:
-- ticks_till_next_consume = (fuel_value/velocity)/consumption_rate
fuel_values = {
  ["raw-wood"]				= 4.0/8.0,
  ["wood"]					= 2.0/8.0,
  ["wooden-chest"]			= 4.0/8.0,
  ["coal"]					= 8.0/8.0,
  ["small-electric-pole"]	= 4.0/8.0,
  ["solid-fuel"]			= 25.0/8.0,
}

CONSUMPTION_RATE = 0.015