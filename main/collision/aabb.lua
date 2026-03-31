--- @class AabbBox
--- @field center vector3
--- @field half_extents vector3

--- @alias AabbId hash|string

local M = {}

--- @type table<AabbId, AabbBox>
local registry = {}

--- @param v vector3
--- @return vector3
local function copy_v3(v)
	return vmath.vector3(v.x, v.y, v.z)
end

--- @param start_point vector3
--- @param end_point vector3
--- @param color vector4
local function draw_line(start_point, end_point, color)
	msg.post("@render:", "draw_line", {
		start_point = start_point,
		end_point = end_point,
		color = color,
	})
end

--- @param id AabbId
--- @param center vector3
--- @param half_extents vector3
function M.register(id, center, half_extents)
	registry[id] = {
		center = copy_v3(center),
		half_extents = copy_v3(half_extents),
	}
end

--- @param id AabbId
--- @param center vector3
--- @param half_extents vector3
function M.update(id, center, half_extents)
	if not registry[id] then
		M.register(id, center, half_extents)
		return
	end

	registry[id].center = copy_v3(center)
	registry[id].half_extents = copy_v3(half_extents)
end

--- @param id AabbId
function M.unregister(id)
	registry[id] = nil
end

--- @return table<AabbId, AabbBox>
function M.get_boxes()
	return registry
end

--- @param center_a vector3
--- @param half_a vector3
--- @param center_b vector3
--- @param half_b vector3
--- @return boolean
function M.intersects(center_a, half_a, center_b, half_b)
	return math.abs(center_a.x - center_b.x) < (half_a.x + half_b.x)
		and math.abs(center_a.y - center_b.y) < (half_a.y + half_b.y)
end

--- @param center vector3
--- @param half_extents vector3
--- @param color vector4
function M.draw_box(center, half_extents, color)
	local left = center.x - half_extents.x
	local right = center.x + half_extents.x
	local bottom = center.y - half_extents.y
	local top = center.y + half_extents.y
	local z = center.z

	local bottom_left = vmath.vector3(left, bottom, z)
	local bottom_right = vmath.vector3(right, bottom, z)
	local top_left = vmath.vector3(left, top, z)
	local top_right = vmath.vector3(right, top, z)

	draw_line(bottom_left, bottom_right, color)
	draw_line(bottom_right, top_right, color)
	draw_line(top_right, top_left, color)
	draw_line(top_left, bottom_left, color)

	draw_line(bottom_left, top_right, color)
	draw_line(top_left, bottom_right, color)
end

return M
