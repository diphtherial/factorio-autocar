data:extend({
	{
		type = "technology",
		name = "autocar-unit",
		icon = "__autocar__/graphics/technology/orient-directives.png",
		icon_size=128,
		effects =
		{
		  { type = "unlock-recipe", recipe = "autocar"},
		  { type = "unlock-recipe", recipe = "autocar-turreted"},
		  { type = "unlock-recipe", recipe = "autocar-rotleft" },
		  { type = "unlock-recipe", recipe = "autocar-rotright" },
		  { type = "unlock-recipe", recipe = "autocar-reverse" },
		  { type = "unlock-recipe", recipe = "autocar-orientup" },
		  { type = "unlock-recipe", recipe = "autocar-orientright" },
		  { type = "unlock-recipe", recipe = "autocar-orientdown" },
		  { type = "unlock-recipe", recipe = "autocar-orientleft" },
		},
		prerequisites = {"automobilism"},
		unit =
		{
		  count = 10,
		  ingredients = {
		    {"science-pack-1", 1},
		    {"science-pack-2", 1},
		  },
		  time = 10
		},
		upgrade = true,
		order = "i-c-a"
	},
	{
		type = "technology",
		name = "autocar-speed",
		icon = "__autocar__/graphics/technology/speed-directives.png",
		icon_size=128,
		effects =
		{
		  { type = "unlock-recipe", recipe = "autocar-speedup" },
		  { type = "unlock-recipe", recipe = "autocar-slowdown" },
		  { type = "unlock-recipe", recipe = "autocar-stall" },
		  { type = "unlock-recipe", recipe = "autocar-board" },
		  { type = "unlock-recipe", recipe = "autocar-eject" },
		},
		prerequisites = {"autocar-unit"},
		unit =
		{
		  count = 20,
		  ingredients = {
		    {"science-pack-1", 1},
		    {"science-pack-2", 1},
		  },
		  time = 20
		},
		upgrade = true,
		order = "i-c-b"
	},
	{
		type = "technology",
		name = "autocar-special",
		icon_size=128,
		icon = "__autocar__/graphics/technology/special-directives.png",
		effects =
		{
		  { type = "unlock-recipe", recipe = "stall-active-tile" }
		},
		prerequisites = {"autocar-unit", "circuit-network"},
		unit =
		{
		  count = 50,
		  ingredients = {
		    {"science-pack-1", 1},
		    {"science-pack-2", 1},
		  },
		  time = 30
		},
		upgrade = true,
		order = "i-c-c"
	}
})