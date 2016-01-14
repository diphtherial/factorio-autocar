require "tiles-effects"

-- ======================================
-- == RIGHT-ROTATION TILE (all other types are variants of this)
-- ======================================

data:extend({
  {
    type = "tile",
    name = "autocar-rotright",
    needs_correction = false,
    minable = {hardness = 0.2, mining_time = 0.5, result = "autocar-rotright"},
    mined_sound = { filename = "__base__/sound/deconstruct-bricks.ogg" },
    collision_mask = {"ground-tile"},
    layer = 61,
    variants =
    {
      main =
      {
        {
          picture = "__autocar__/graphics/directives/rotright.png",
          count = 1,
          size = 1
        }
      },
      inner_corner =
      {
        picture = "__base__/graphics/terrain/concrete/concrete-inner-corner.png",
        count = 8
      },
      outer_corner =
      {
        picture = "__base__/graphics/terrain/concrete/concrete-outer-corner.png",
        count = 8
      },
      side =
      {
        picture = "__base__/graphics/terrain/concrete/concrete-side.png",
        count = 8
      }
    },
    map_color={r=100, g=100, b=100},
    ageing=0
  },

  -- item defn
  {
    type = "item",
    name = "autocar-rotright",
    icon = "__autocar__/graphics/directives/rotright.png",
    flags = {"goes-to-main-inventory"},
    subgroup = "ac-rotations",
    order = "a",
    stack_size = 100,
    place_as_tile =
    {
      result = "autocar-rotright",
      condition_size = 0,
      condition = { "water-tile" }
    }
  },

  -- recipe defn
  {
    type = "recipe",
    name = "autocar-rotright",
    enabled = true,
    ingredients =
    {
      {"electronic-circuit", 1},
      {"iron-plate", 3}
    },
    result = "autocar-rotright"
  }
})

--
-- create all the other types of tiles as variants of rotright
--

for k, v in pairs(tiletypes) do
  if k ~= "rotright" then
    -- define the lefthanded one as a copy of the right-handed one
    local entity = util.table.deepcopy(data.raw["tile"]["autocar-rotright"])
    local item = util.table.deepcopy(data.raw["item"]["autocar-rotright"])
    local recipe = util.table.deepcopy(data.raw["recipe"]["autocar-rotright"])

    -- ...specify entity, item, and recipe differences...
    entity.name = "autocar-"..k
    entity.minable.result = "autocar-"..k
    entity.variants.main[1].picture = "__autocar__/graphics/directives/"..k..".png"
    -- item
    item.name = "autocar-"..k
    item.icon = "__autocar__/graphics/directives/"..k..".png"
    item.subgroup = v.subgroup
    item.place_as_tile.result = "autocar-"..k
    -- recipe
    recipe.name = "autocar-"..k
    recipe.result = "autocar-"..k

    -- ...and insert them all
    data.raw[entity.type][entity.name] = entity
    data.raw[item.type][item.name] = item
    data.raw[recipe.type][recipe.name] = recipe
  end
end
