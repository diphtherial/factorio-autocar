require "config"
require "utils"
require "tiles-effects"

local mod_version="0.0.1"

-- =============================================================
-- === event definitions
-- =============================================================

local function onLoad(event)
  local reset = false
  if reset then
    global.autocars = {}
    global.stall_tiles = {}
  end

  if global.autocars == nil then
    global.autocars = {}
  end
  if global.stall_tiles == nil then
    global.stall_tiles = {}
  end
end

local function onSave()
end

local function onTick()
  runStallTiles()

  if game.tick % 2 == 0 then
      runCars()
  end
end

local function onBuilt(event)
  local newEntityName = event.created_entity.name
  local newEntity = event.created_entity

  if newEntityName == "autocar" then
    debug("Autocar created!")
    table.insert(global.autocars, {
      car=newEntity,
      velocity=DEFAULT_SPEED,
      last_command=game.tick,
      stall_till=game.tick,
      stall_checker=nil,
      defuel_next=nil,
      dock=nil
    })

    for i,v in pairs(global.autocars) do
      debug(table.tostring(v))
    end
  elseif newEntityName == "stall-active-tile" then
    debug("Stall tile created!")

    -- create a ghost smartchest that pushes the autocar's contents to the circuit network when the car is present
    local chest_proxy = game.surfaces[newEntity.surface.name].create_entity({
      name="stall-tile-chest-proxy",
      position = {newEntity.position.x, newEntity.position.y - 1.0},
      force = newEntity.force})

    chest_proxy.minable = false
    chest_proxy.destructible = false
    chest_proxy.operable = false

    -- -- also create a ghost that monitors the circuit network for an unstuck condition
    -- local condition_proxy = game.surfaces[newEntity.surface.name].create_entity({
    --   name="stall-tile-condition-proxy",
    --   position = {newEntity.position.x, newEntity.position.y - 1.0},
    --   force = newEntity.force})


    table.insert(global.stall_tiles, {
      stall_tile=newEntity,
      proxy=chest_proxy,
      docked_car=nil,
      checked_inventory=2 -- 1: fuel inventory, 2: chest inventory
    })
  end 
end

local function onRemove(event)
end

-- =============================================================
-- === event registration
-- =============================================================

script.on_init(onLoad)
script.on_load(onLoad)

-- script.on_save(onSave)

script.on_event(defines.events.on_tick,onTick)

script.on_event(defines.events.on_built_entity, onBuilt)

script.on_event(defines.events.on_entity_died, onRemove)
script.on_event(defines.events.on_preplayer_mined_item, onRemove)
script.on_event(defines.events.on_robot_pre_mined, onRemove)
