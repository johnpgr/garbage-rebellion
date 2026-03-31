-- world_data.lua
-- Static room definitions for the game world
-- Each room is a 480x320 screen. Positions are room-local (0-480, 0-320).
-- Room IDs follow "col_row" format. World position = (col*480, row*320).

local M = {}

--    (0,1) -- (1,1) -- (2,1)
--      |       |
--    (0,0) -- (1,0) -- (2,0)

M.rooms = {
	["0_0"] = {
		col = 0, row = 0,
		exits = { north = "0_1", east = "1_0" },
		enemies = {},
	},
	["1_0"] = {
		col = 1, row = 0,
		exits = { north = "1_1", west = "0_0", east = "2_0" },
		enemies = {
			{x = 300, y = 200, props = {max_hp = 2, move_speed = 90}},
			{x = 150, y = 120, props = {max_hp = 2, move_speed = 70}},
		},
	},
	["2_0"] = {
		col = 2, row = 0,
		exits = { west = "1_0", north = "2_1" },
		enemies = {
			{x = 240, y = 160, props = {max_hp = 5, move_speed = 60, visual_scale = 0.45}},
		},
	},
	["0_1"] = {
		col = 0, row = 1,
		exits = { south = "0_0", east = "1_1" },
		enemies = {
			{x = 350, y = 200, props = {max_hp = 3}},
		},
	},
	["1_1"] = {
		col = 1, row = 1,
		exits = { south = "1_0", west = "0_1", east = "2_1" },
		enemies = {},
	},
	["2_1"] = {
		col = 2, row = 1,
		exits = { south = "2_0", west = "1_1" },
		enemies = {
			{x = 200, y = 250, props = {max_hp = 3, move_speed = 80}},
			{x = 350, y = 120, props = {max_hp = 3, move_speed = 80}},
		},
	},
}

M.start_room = "0_0"
M.start_pos = {x = 240, y = 160}

return M
