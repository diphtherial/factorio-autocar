local default_enabled = true

data:extend({
    -- item definition
  {
    type = "item",
    name = "autocar",
    icon = "__base__/graphics/icons/car.png",
    flags = {"goes-to-quickbar"},
    subgroup = "transport",
    order = "b[personal-transport]-a[car]",
    place_result = "autocar",
    stack_size = 1
  },

  -- recipe definition
  {
    type = "recipe",
    name = "autocar",
    enabled = default_enabled,
    ingredients =
    {
      {"iron-plate", 20},
      {"electronic-circuit", 10},
      {"steel-plate", 5},
    },
    result = "autocar"
  },

  -- entity definition
  {
    type = "car",
    name = "autocar",
    icon = "__base__/graphics/icons/car.png",
    flags = {"pushable", "placeable-neutral", "player-creation"},
    minable = {mining_time = 1, result = "autocar"},
    max_health = 50,
    corpse = "medium-remnants",
    dying_explosion = "medium-explosion",
    energy_per_hit_point = 1,
    crash_trigger = crash_trigger(),

    resistances =
    {
      {
        type = "fire",
        percent = 50
      },
      {
        type = "impact",
        percent = 30,
        decrease = 30
      }
    },

    collision_box = {{-0.5, -0.5}, {0.5, 0.5}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    effectivity = 0.0,
    braking_power = "0kW",
    rotation_speed = 0.0,
    weight = 700,
    -- guns = { "vehicle-machine-gun" },
    inventory_size = 40,
    consumption = "150kW",  
    friction = 2e-2,

    burner =
    {
      effectivity = 1.0,
      fuel_inventory_size = 1,
      smoke =
      {
        {
          name = "car-smoke",
          deviation = {0.25, 0.25},
          frequency = 200,
          position = {0, 1.5},
          starting_frame = 0,
          starting_frame_deviation = 60
        }
      }
    },

    light =
    {
      {
        type = "oriented",
        minimum_darkness = 0.3,
        picture =
        {
          filename = "__core__/graphics/light-cone.png",
          priority = "medium",
          scale = 2,
          width = 200,
          height = 200
        },
        shift = {0, -14},
        size = 2,
        intensity = 0.8
      }
    },

    animation =
    {
      layers =
      {
        {
          width = 102,
          height = 86,
          frame_count = 2,
          direction_count = 64,
          shift = {0, -0.1875},
          animation_speed = 8,
          max_advance = 0.2,
          stripes =
          {
            {
             filename = "__base__/graphics/entity/car/car-1.png",
             width_in_frames = 2,
             height_in_frames = 22,
            },
            {
             filename = "__base__/graphics/entity/car/car-2.png",
             width_in_frames = 2,
             height_in_frames = 22,
            },
            {
             filename = "__base__/graphics/entity/car/car-3.png",
             width_in_frames = 2,
             height_in_frames = 20,
            },
          }
        },
        {
          width = 100,
          height = 75,
          frame_count = 2,
          apply_runtime_tint = true,
          direction_count = 64,
          max_advance = 0.2,
          line_length = 2,
          shift = {0, -0.171875},
          stripes = util.multiplystripes(2,
          {
            {
              filename = "__base__/graphics/entity/car/car-mask-1.png",
              width_in_frames = 1,
              height_in_frames = 22,
            },
            {
              filename = "__base__/graphics/entity/car/car-mask-2.png",
              width_in_frames = 1,
              height_in_frames = 22,
            },
            {
              filename = "__base__/graphics/entity/car/car-mask-3.png",
              width_in_frames = 1,
              height_in_frames = 20,
            },
          })
        },
        {
          width = 114,
          height = 76,
          frame_count = 2,
          draw_as_shadow = true,
          direction_count = 64,
          shift = {0.28125, 0.25},
          max_advance = 0.2,
          stripes = util.multiplystripes(2,
          {
           {
            filename = "__base__/graphics/entity/car/car-shadow-1.png",
            width_in_frames = 1,
            height_in_frames = 22,
           },
           {
            filename = "__base__/graphics/entity/car/car-shadow-2.png",
            width_in_frames = 1,
            height_in_frames = 22,
           },
           {
            filename = "__base__/graphics/entity/car/car-shadow-3.png",
            width_in_frames = 1,
            height_in_frames = 20,
           },
          })
        }
      }
    },

    -- turret_animation =
    -- {
    --   layers =
    --   {
    --     {
    --       filename = "__base__/graphics/entity/car/car-turret.png",
    --       line_length = 8,
    --       width = 36,
    --       height = 29,
    --       frame_count = 1,
    --       direction_count = 64,
    --       shift = {0.03125, -0.890625},
    --       animation_speed = 8,
    --     },
    --     {
    --       filename = "__base__/graphics/entity/car/car-turret-shadow.png",
    --       line_length = 8,
    --       width = 46,
    --       height = 31,
    --       frame_count = 1,
    --       draw_as_shadow = true,
    --       direction_count = 64,
    --       shift = {0.875, 0.359375},
    --     }
    --   }
    -- },
    -- turret_rotation_speed = 0.35 / 60,

    sound_no_fuel =
    {
      {
        filename = "__base__/sound/fight/car-no-fuel-1.ogg",
        volume = 0.6
      },
    },

    stop_trigger_speed = 0.2,
    stop_trigger =
    {
      {
        type = "play-sound",
        sound =
        {
          {
            filename = "__base__/sound/car-breaks.ogg",
            volume = 0.6
          },
        }
      },
    },

    sound_minimum_speed = 0.2;
    vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    working_sound =
    {
      sound =
      {
        filename = "__base__/sound/car-engine.ogg",
        volume = 0.6
      },
      activate_sound =
      {
        filename = "__base__/sound/car-engine-start.ogg",
        volume = 0.6
      },
      deactivate_sound =
      {
        filename = "__base__/sound/car-engine-stop.ogg",
        volume = 0.6
      },
      match_speed_to_activity = true,
    },
    open_sound = { filename = "__base__/sound/car-door-open.ogg", volume=0.7 },
    close_sound = { filename = "__base__/sound/car-door-close.ogg", volume = 0.7 }
  }
})

-- slightly modify the autocar to make a variety with a turret included
local ac_entity = util.table.deepcopy(data.raw["car"]["autocar"])
local ac_item = util.table.deepcopy(data.raw["item"]["autocar"])
local ac_recipe = util.table.deepcopy(data.raw["recipe"]["autocar"])

ac_entity.name = "autocar-turreted"
ac_entity.minable.result = "autocar-turreted"
ac_item.name = "autocar-turreted"
ac_item.place_result = "autocar-turreted"
ac_recipe.name = "autocar-turreted"
ac_recipe.result = "autocar-turreted"

data.raw[ac_entity.type][ac_entity.name] = ac_entity
data.raw[ac_item.type][ac_item.name] = ac_item
data.raw[ac_recipe.type][ac_recipe.name] = ac_recipe

-- also clone the turret so we can stick it on the car?
local ac_turret_entity = util.table.deepcopy(data.raw["ammo-turret"]["gun-turret"])
ac_turret_entity.name = "fixed-turret"
ac_turret_entity.flags = {"player-creation", "placeable-off-grid", "not-repairable"}
ac_turret_entity.selection_box = {{-0.1, -0.1}, {0.1, 0.1}}
ac_turret_entity.collision_box = {{0,0}, {0,0}}
ac_turret_entity.collision_mask = {}

data.raw[ac_turret_entity.type][ac_turret_entity.name] = ac_turret_entity