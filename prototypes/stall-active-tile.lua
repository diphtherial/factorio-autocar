data:extend(
{ 
	{
		type = "item",
		name = "stall-active-tile",
		icon = "__autocar__/graphics/directives/stall-active.png",
		flags = {"goes-to-quickbar"},
		subgroup = "ac-specials",
		order = "a",
		place_result = "stall-active-tile",
		stack_size = 50
	},

	{
		type = "recipe",
		name = "stall-active-tile",
		enabled = true,
		ingredients = {
			{"iron-plate", 2},
			{"electronic-circuit", 3}
		},
		result = "stall-active-tile"
	},

	{
		type = "simple-entity",
		name = "stall-active-tile",
		icon = "__autocar__/graphics/directives/stall-active.png",
		flags = {"placeable-neutral", "player-creation"},
		minable = {hardness = 0.2, mining_time = 0.3, result = "stall-active-tile"},
		max_health = 50,
		corpse = "small-remnants",

		resistances =
		{
		  {
			type = "fire",
			percent = 50
		  }
		},

		collision_box = {{-0.4, -0.4}, {0.4, 0.4}},
		collision_mask = { "floor-layer"},
		selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
		render_layer = "tile",

		pictures =
		{
		  filename = "__autocar__/graphics/directives/stall-active.png",
		  width = 32,
		  height = 32,
		}
	}
})