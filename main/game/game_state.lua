local M = {}

M.MAX_HP = 5

--- @class GameEnemyState
--- @field url url
--- @field center vector3
--- @field half_extents vector3
--- @field hp number

--- @class GameStateModule
--- @field MAX_HP integer
--- @field hp integer
--- @field game_over boolean
--- @field game_over_reason string|nil
--- @field menu_delay number|nil
--- @field player_url url|nil
--- @field player_center vector3|nil
--- @field player_half_extents vector3|nil
--- @field player_invincible boolean
--- @field player_dead boolean
--- @field enemies table<string, GameEnemyState>

--- @type GameStateModule
M = M

--- @param value vector3|nil
--- @return vector3|nil
local function copy_v3(value)
	if not value then
		return nil
	end

	return vmath.vector3(value.x, value.y, value.z)
end

--- @return nil
function M.reset_session()
	M.hp = M.MAX_HP
	M.game_over = false
	M.game_over_reason = nil
	M.menu_delay = nil
	M.player_url = nil
	M.player_center = nil
	M.player_half_extents = nil
	M.player_invincible = false
	M.player_dead = false
	M.enemies = {}
end

--- @param url url
--- @param center vector3
--- @param half_extents vector3
--- @param invincible boolean|nil
--- @param dead boolean|nil
function M.set_player(url, center, half_extents, invincible, dead)
	M.player_url = url
	M.player_center = copy_v3(center)
	M.player_half_extents = copy_v3(half_extents)
	M.player_invincible = invincible or false
	M.player_dead = dead or false
end

--- @return nil
function M.clear_player()
	M.player_url = nil
	M.player_center = nil
	M.player_half_extents = nil
	M.player_invincible = false
	M.player_dead = false
end

--- @param id string
--- @param url url
--- @param center vector3
--- @param half_extents vector3
--- @param hp number
function M.register_enemy(id, url, center, half_extents, hp)
	M.enemies[id] = {
		url = url,
		center = copy_v3(center),
		half_extents = copy_v3(half_extents),
		hp = hp,
	}
end

--- @param id string
--- @param center vector3
--- @param half_extents vector3
--- @param hp number
function M.update_enemy(id, center, half_extents, hp)
	local enemy = M.enemies[id]
	if not enemy then
		return
	end

	enemy.center = copy_v3(center)
	enemy.half_extents = copy_v3(half_extents)
	enemy.hp = hp
end

--- @param id string
function M.remove_enemy(id)
	M.enemies[id] = nil
end

--- @param amount number|nil
--- @return boolean true if player is dead (hp <= 0)
function M.take_hit(amount)
	amount = amount or 1
	M.hp = math.max(0, M.hp - amount)
	return M.hp <= 0
end

--- @param amount number|nil
function M.heal(amount)
	amount = amount or 1
	M.hp = math.min(M.MAX_HP, M.hp + amount)
end

--- @param delay number|nil
function M.queue_return_to_menu(delay)
	delay = delay or 0
	if M.menu_delay == nil or delay < M.menu_delay then
		M.menu_delay = delay
	end
end

--- @param reason string
--- @param delay number|nil
function M.set_game_over(reason, delay)
	if not M.game_over then
		M.game_over = true
		M.game_over_reason = reason
	end

	if delay ~= nil then
		M.queue_return_to_menu(delay)
	end
end

--- @param dt number
--- @return boolean
function M.tick(dt)
	if M.menu_delay ~= nil then
		M.menu_delay = math.max(0, M.menu_delay - dt)
		if M.menu_delay == 0 then
			M.menu_delay = nil
			return true
		end
	end

	return false
end

M.reset_session()

return M
