-- room_manager.lua
-- Spawns all room content (walls, enemies) at world coordinates.
-- Rooms are placed at (col*480, row*320) in world space so the camera's
-- screen-section logic handles transitions automatically.

local M = {}
local world_data = require "main.world.world_data"

local SCREEN_W = 480
local SCREEN_H = 320

M.factories = nil
M.spawned_ids = {}

local function hash_props(props)
	local result = {}
	for k, v in pairs(props) do
		result[hash(k)] = v
	end
	return result
end

function M.init(factories)
	M.factories = factories
	M.spawned_ids = {}
end

function M.spawn_wall(x, y, sx, sy)
	local pos = vmath.vector3(x, y, 0)
	local scale = vmath.vector3(sx, sy, 1)
	local id = factory.create(M.factories.wall, pos, nil, nil, scale)
	table.insert(M.spawned_ids, id)
end

function M.spawn_all()
	for room_id, room in pairs(world_data.rooms) do
		local ox = room.col * SCREEN_W
		local oy = room.row * SCREEN_H

		-- Walls on edges without exits
		if not room.exits.south then
			M.spawn_wall(ox + 240, oy - 8, 15, 0.5)
		end
		if not room.exits.north then
			M.spawn_wall(ox + 240, oy + SCREEN_H + 8, 15, 0.5)
		end
		if not room.exits.west then
			M.spawn_wall(ox - 8, oy + 160, 0.5, 10)
		end
		if not room.exits.east then
			M.spawn_wall(ox + SCREEN_W + 8, oy + 160, 0.5, 10)
		end

		-- Enemies
		for _, e in ipairs(room.enemies or {}) do
			local pos = vmath.vector3(ox + e.x, oy + e.y, 0)
			local props = e.props and hash_props(e.props) or nil
			local id = factory.create(M.factories.enemy, pos, nil, props)
			table.insert(M.spawned_ids, id)
		end
	end
end

function M.get_start_pos()
	local room = world_data.rooms[world_data.start_room]
	local ox = room.col * SCREEN_W
	local oy = room.row * SCREEN_H
	return vmath.vector3(ox + world_data.start_pos.x, oy + world_data.start_pos.y, 0)
end

return M
