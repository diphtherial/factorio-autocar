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

  -- if game.tick % 2 == 0 then
      runCars()
  -- end
end

local function onBuilt(event)
  local newEntityName = event.created_entity.name
  local newEntity = event.created_entity

  if newEntityName == "autocar" or newEntityName == "autocar-turreted" then
    debug("Autocar created!")
    local car_meta = {
      car=newEntity,
      state=STATE_RUNNING,
      velocity=DEFAULT_SPEED,
      last_command=game.tick,
      stall_till=game.tick,
      stall_checker=nil,
      defuel_next=nil,
      dock=nil,
      turret=nil
    }

    if newEntityName == "autocar-turreted" then
      local turret_entity = newEntity.surface.create_entity({
          name="fixed-turret",
          position=newEntity.position,
          force=newEntity.force
        })
      turret_entity.destructible = false
      car_meta.turret = turret_entity
    end

    table.insert(global.autocars, car_meta)

    -- for i,v in pairs(global.autocars) do
    --   debug(table.tostring(v))
    -- end
  elseif newEntityName == "stall-active-tile" then
    debug("Stall tile created!")

    -- create a ghost smartchest that pushes the autocar's contents to the circuit network when the car is present
    local chest_proxy = game.surfaces[newEntity.surface.name].create_entity({
      name="stall-tile-chest-proxy",
      position = {newEntity.position.x + 0.25, newEntity.position.y - 0.9},
      force = newEntity.force})

    chest_proxy.minable = false
    chest_proxy.destructible = false
    chest_proxy.operable = false

    -- also create a ghost that monitors the circuit network for an unstuck condition
    local condition_proxy = game.surfaces[newEntity.surface.name].create_entity({
      name="stall-tile-condition-proxy",
      position = {newEntity.position.x - 0.3, newEntity.position.y - 0.8},
      force = newEntity.force})

    condition_proxy.minable = false
    condition_proxy.destructible = false
    condition_proxy.operable = true

    table.insert(global.stall_tiles, {
      stall_tile=newEntity,
      proxy=chest_proxy,
      condition=condition_proxy,
      docked_car=nil,
      checked_inventory=2 -- 1: fuel inventory, 2: chest inventory
    })
  end 
end

local function onRemove(event)
  -- return turret's inventory to the player
  if event.entity.name == "autocar-turreted" then
    for i,v in pairs(global.autocars) do
      if v.car == event.entity and event.player_index ~= nil and v.turret ~= nil and v.turret.valid then
        local removedBasic = v.turret.remove_item({name="basic-bullet-magazine", count=1000})
        local removedPiercing = v.turret.remove_item({name="piercing-bullet-magazine", count=1000})

        if removedBasic > 0 then
          game.players[event.player_index].insert({name="basic-bullet-magazine", count=removedBasic})
        end
        if removedPiercing > 0 then
          game.players[event.player_index].insert({name="piercing-bullet-magazine", count=removedBasic})
        end
        
        goto complete
      end
    end

    ::complete::
  end
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
