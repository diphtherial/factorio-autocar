require "defines"
require "config"

-- =============================================================
-- === tile action and metadata definitions
-- === (note: prototypes/tile-prototypes.lua reads this table to construct the items/recipes/entities)
-- =============================================================

STATE_RUNNING = 0
STATE_TURNING = 1

tiletypes = {
  -- rotators/reversers
	rotleft = {
    effect=function(car, meta)
  		car.orientation = car.orientation - 0.25
      return true
  	end,
    subgroup="ac-rotations"
  },
	rotright = {
    effect=function(car, meta)
  		car.orientation = car.orientation + 0.25
      return true
  	end,
    subgroup="ac-rotations"
  },
  reverse = {
    effect=function(car, meta)
      car.orientation = car.orientation + 0.5
      return true
    end,
    subgroup="ac-rotations"
  },

  -- orientation changers
  orientup = {
    effect=function(car, meta)
      car.orientation = 0
      return true
    end,
    subgroup="ac-directions"
  },
  orientright = {
    effect=function(car, meta)
      car.orientation = 0.25
      return true
    end,
    subgroup="ac-directions"
  },
  orientdown = {
    effect=function(car, meta)
      car.orientation = 0.5
      return true
    end,
    subgroup="ac-directions"
  },
  orientleft = {
    effect=function(car, meta)
      car.orientation = 0.75
      return true
    end,
    subgroup="ac-directions"
  },

  -- entry/exit tiles
  eject = {
    effect=function(car, meta)
      if car.passenger then
        car.passenger = nil
      end
    end,
    subgroup="ac-specials",
    snap=false
  },
  board = {
    effect=function(car, meta)
      -- scan the area around the car for a player and board them
      local ents_in_area = car.surface.find_entities_filtered({
        area={{car.position.x-2, car.position.y-2}, {car.position.x+2, car.position.y+2}},
        name="player",
        force=car.force
      })

      if #ents_in_area > 0 then
        car.passenger = ents_in_area[1]
      end
    end,
    subgroup="ac-specials",
    snap=false
  },

  -- specials
	stall = {
    effect=function(car, meta)
  		meta.stall_till = game.tick + STALL_TIME
      return true
  	end, subgroup="ac-specials"
  },
	slowdown = {
    effect=function(car, meta)
  		meta.velocity = (meta.velocity > MIN_SPEED and (meta.velocity - 0.02) or MIN_SPEED)
      return true
  	end,
    subgroup="ac-specials",
    snap=false
  },
	speedup = {
    effect=function(car, meta)
  		meta.velocity = (meta.velocity < MAX_SPEED and (meta.velocity + 0.02) or MAX_SPEED)
      return true
  	end,
    subgroup="ac-specials",
    snap=false
  },
  idle = {
    effect=function(car, meta)
      return true
    end,
    subgroup="ac-specials",
    snap=false
  }
}

-- =============================================================
-- === autocar tile-directive and general logic
-- =============================================================

function runCars()
  for i,v in ipairs(global.autocars) do
    local car = v.car

    if car.valid then
      execCar(car, v)
    else
      debug("Autocar "..i.." removed!")
      if v.turret ~= nil and v.turret.valid then
        v.turret.destroy()
      end
      table.remove(global.autocars, i)
    end
  end
end

function execCar(car, v)
  local fuelInventory = car.get_inventory(defines.inventory.fuel)

  -- if we're a turreted car, sync the turret to our position at all times
  if v.turret ~= nil and v.turret.valid then
    v.turret.teleport(car.position)
  end

  -- can't do anything if we don't have fuel!
  if fuelInventory.is_empty() then
    return false
  end

  -- check if we're supposed to defuel, and if so remove a stack
  if v.defuel_next ~= nil and v.defuel_next < game.tick then
    fuelInventory[1].count = ((fuelInventory[1].count > 0) and fuelInventory[1].count-1 or 0)
    v.defuel_next = nil
  end

  -- compute the tile coordinate we're on
  local tile_loc = {math.floor(car.position.x), math.floor(car.position.y)}
  local closeToCenter = (math.abs(car.position.x - (tile_loc[1]*1.0) - 0.5) <= OFFSET_TOLERANCE) and (math.abs(car.position.y - (tile_loc[2]*1.0) - 0.5) <= OFFSET_TOLERANCE)

  -- check if we're over a marker and follow its command (if we haven't already)
  if closeToCenter and v.last_command + COMMAND_DELAY < game.tick and not samePos(tile_loc, v.last_command_pos) then
    local tilebelow = car.surface.get_tile(car.position.x, car.position.y)
    local accepted_cmd = nil

    -- scan the dictionary for our thing
    for name,val in pairs(tiletypes) do
      if endswith(tilebelow.name, name) then
        accepted_cmd = val
        goto found_cmd
      end
    end

    if accepted_cmd == nil then
      -- check also if there's a stall-active tile entity below us
      local stall_below = car.surface.find_entities_filtered({
          area = {car.position, car.position},
          type = "simple-entity", name = "stall-active-tile" })

      if #stall_below > 0 then
        -- locate the dock in the global list of stall tiles
        for q,s in pairs(global.stall_tiles) do
          -- only stop at this active stall if its condition lamp has energy
          if s.stall_tile == stall_below[1] and s.condition.energy > 0 then
            -- we found it! set up the docking association
            v.dock = s
            s.docked_car = car

            -- set the lamp as our 'stall checker' for this car; if it's satisfied we're good
            v.stall_checker = s.condition

            -- create a dummy accept command to indicate that we handled the event
            accepted_cmd = {effect=nil, snap=true}

            -- sync the chest; if the circuit condition is fulfilled, don't snap
            syncProxyChest(v.dock)
            if stallCheckerFulfilled(v.stall_checker) then
              accepted_cmd.snap = false
            end

            goto found_cmd
          end
        end
      end
    end

    ::found_cmd::

    if accepted_cmd ~= nil then
      -- execute the action
      if accepted_cmd.effect ~= nil then
        accepted_cmd.effect(car, v)
      end

      -- snap the car to the tile's position
      if accepted_cmd.snap == nil or accepted_cmd.snap then
        car.teleport({tile_loc[1] + 0.5, tile_loc[2] + 0.5})
      end
      v.last_command = game.tick
      v.last_command_pos = tile_loc
    end
  end

  -- evaluate movement conditions 
  -- (i.e. whether we're stalling for a fixed amount of time or on a circuit condition)
  local stuck = false

  if v.stall_till > game.tick then
    car.speed = 0
    stuck = true
  elseif v.stall_checker ~= nil and v.stall_checker.valid then
    -- check if it has energy and if the condition is clear
    if stallCheckerFulfilled(v.stall_checker) then
      -- we're clear to move on the next frame
      detachFromDock(v)
      stuck = false
    else
      -- hold us here until we can move
      car.speed = 0
      stuck = true
    end
  end

  if not stuck then
    -- set to cruising velocity
    car.speed = v.velocity

    -- decrement energy?
    if car.energy > 0 then
      car.energy = car.energy - 1
    end
    
    -- determine the next time to remove fuel
    if v.defuel_next == nil and v.velocity > 0.0 and not fuelInventory.is_empty() then
      v.defuel_next = game.tick + ((fuel_values[fuelInventory[1].name] / v.velocity) / CONSUMPTION_RATE)
    end
  end

  -- also, "execute" the inventory if there are blank tiles present
  if game.tick % 60 == 0 then
    local trunkInventory = car.get_inventory(2) -- #2 is apparently the vehicle inventory...

    if not trunkInventory.is_empty() then
      
      -- firstly, if we have a turret try to put ammo into it
      if v.turret ~= nil and v.turret.valid then
        -- check if the trunk contains any bullets (priority given to piercing bullets)
        local piercingBullets = trunkInventory.get_item_count("piercing-bullet-magazine")
        local basicBullets = trunkInventory.get_item_count("basic-bullet-magazine")

        if piercingBullets > 0 and v.turret.can_insert({name="piercing-bullet-magazine", count=piercingBullets}) then
          trunkInventory.remove({
            name="piercing-bullet-magazine",
            count=v.turret.insert({name="piercing-bullet-magazine", count=piercingBullets})
          })
        elseif basicBullets > 0 and v.turret.can_insert({name="basic-bullet-magazine", count=basicBullets}) then
          trunkInventory.remove({
            name="basic-bullet-magazine",
            count=v.turret.insert({name="basic-bullet-magazine", count=basicBullets})
          })
        end
      end

      for i=1,#trunkInventory-1 do
        local item = trunkInventory[i]
        local nextElem = trunkInventory[i+1]

        if item.valid_for_read and item.name == "autocar-idle" and nextElem.valid_for_read and startswith(nextElem.name, "autocar-") then
          if item.count > 0 then
            -- just reduce the items in this stack until we're at 0
            local lastCount = item.count
            item.count = item.count - 1

            if lastCount == 1 then
              -- place the next item in the series since we know it's there
              local nextElem = trunkInventory[i+1]
              local dest = getCarAheadTilePos(car)

              car.surface.set_tiles({ {name=nextElem.name, position=dest} })

              -- and remove one of those items since we placed it
              nextElem.count = nextElem.count - 1
            end
          else

          end

          -- since we executed a command, we can bail now
          goto completed_cmd

          -- game.player.print(i..": "..table.tostring({item.name, item.type, item.count}))
        end
      end

      ::completed_cmd::
    end
  end
end

function getCarAheadTilePos(car)
  local dir = car.orientation
  local tile_loc = {math.floor(car.position.x), math.floor(car.position.y)}

  if dir == 0 then
    return {tile_loc[1], tile_loc[2]-1}
  elseif dir == 0.25 then
    return {tile_loc[1]+1, tile_loc[2]}
  elseif dir == 0.5 then
    return {tile_loc[1], tile_loc[2]+1}
  else
    return {tile_loc[1]-1, tile_loc[2]}
  end
end

-- =============================================================
-- === active stall tile management
-- =============================================================

function runStallTiles()
  for i,v in ipairs(global.stall_tiles) do
    local stallTile = v.stall_tile

    if stallTile.valid then
      -- sync the docked car, if there is one
      if v.docked_car ~= nil and v.docked_car.valid then
        syncProxyChest(v)
      else
        v.proxy.clear_items_inside()
      end
    else
      v.proxy.destroy()
      v.condition.destroy()
      debug("Stall tile "..i.." removed!")
      table.remove(global.stall_tiles, i)
    end
  end
end

function syncProxyChest(stall_meta)
  -- local chestInv = v.proxy.get_inventory(defines.inventory.chest)
  local carFuelInv = stall_meta.docked_car.get_inventory(1)
  local carChestInv = stall_meta.docked_car.get_inventory(stall_meta.checked_inventory)

  stall_meta.proxy.clear_items_inside()
  for name,count in pairs(carChestInv.get_contents()) do
    stall_meta.proxy.insert({name=name,count=count})
  end
end

function stallCheckerFulfilled(stall_checker)
  -- allow us to go if the stall checker is out of energy or satisfied, or if the stall checker disappeared
  return stall_checker == nil or not stall_checker.valid or (stall_checker.valid and (stall_checker.energy < 0 or stall_checker.get_circuit_condition(1).fulfilled))
end

function detachFromDock(v)
  v.dock.proxy.clear_items_inside()
  v.dock.docked_car = nil
  v.dock = nil
  v.stall_checker = nil
end