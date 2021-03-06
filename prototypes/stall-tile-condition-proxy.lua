data:extend(
{
	{
		type = "item",
		name = "stall-tile-condition-proxy",
		icon = "__base__/graphics/icons/smart-chest.png",
		flags = {"goes-to-quickbar"},
		subgroup = "storage",
		order = "a[items]-d[smart-chest]",
		place_result = "stall-tile-condition-proxy",
		stack_size = 50
	},

	{
		type = "lamp",
		name = "stall-tile-condition-proxy",
		icon = "__autocar__/graphics/directives/stall-active.png",
		flags = {"placeable-neutral", "player-creation", "placeable-off-grid"},
		minable = {hardness = 0.2, mining_time = 0.3, result = "stall-tile-condition-proxy"},
		max_health = 50,
		corpse = "small-remnants",

		resistances =
		{
		  {
			type = "fire",
			percent = 50
		  }
		},

		collision_box = {{-0.1, -0.2}, {0.1, 0.2}},
		collision_mask = { "floor-layer"},
		selection_box = {{-0.1, -0.2}, {0.1, 0.2}},
		render_layer = "decorative",
		final_render_layer = "ground_patch_higher2",

		-- pictures =
		-- {
		--   filename = "__autocar__/graphics/directives/stall-active.png",
		--   width = 32,
		--   height = 32,
		-- }

	    energy_source =
	    {
	      type = "electric",
	      usage_priority = "secondary-input"
	    },

	    energy_usage_per_tick = "5KW",
	    light = {intensity = 0.0, size = 1},

	    picture_off =
	    {
	      filename = "__autocar__/graphics/conditionlamp/light-off.png",
	      width = 14,
	      height = 19,
	      frame_count = 1,
	      axially_symmetrical = false,
	      direction_count = 1
	    },
	    picture_on =
	    {
	      filename = "__autocar__/graphics/conditionlamp/light-on.png",
	      width = 14,
	      height = 19,
	      frame_count = 1,
	      axially_symmetrical = false,
	      direction_count = 1
	    },

	    circuit_wire_connection_point =
	    {
	      shadow =
	      {
	        red = {0.0, -0.2},
	        green = {0.0, -0.2},
	      },
	      wire =
	      {
	        red = {0.0, -0.2},
	        green = {0.0, -0.2},
	      }
	    },

	    circuit_wire_max_distance = 7.5
	}
})

