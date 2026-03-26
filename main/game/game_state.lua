local M = {}

local LEVEL_TIME = 120

M.PLAYER_STATE_SMALL = 1
M.PLAYER_STATE_NORMAL = 2
M.PLAYER_STATE_POWERED = 3

local function copy_v3(value)
	if not value then
		return nil
	end

	return vmath.vector3(value.x, value.y, value.z)
end

function M.reset_session()
	M.player_state = M.PLAYER_STATE_NORMAL
	M.score = 0
	M.level_duration = LEVEL_TIME
	M.time_left = LEVEL_TIME
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

function M.set_player(url, center, half_extents, invincible, dead)
	M.player_url = url
	M.player_center = copy_v3(center)
	M.player_half_extents = copy_v3(half_extents)
	M.player_invincible = invincible or false
	M.player_dead = dead or false
end

function M.clear_player()
	M.player_url = nil
	M.player_center = nil
	M.player_half_extents = nil
	M.player_invincible = false
	M.player_dead = false
end

function M.register_enemy(id, url, center, half_extents, hp)
	M.enemies[id] = {
		url = url,
		center = copy_v3(center),
		half_extents = copy_v3(half_extents),
		hp = hp,
	}
end

function M.update_enemy(id, center, half_extents, hp)
	local enemy = M.enemies[id]
	if not enemy then
		return
	end

	enemy.center = copy_v3(center)
	enemy.half_extents = copy_v3(half_extents)
	enemy.hp = hp
end

function M.remove_enemy(id)
	M.enemies[id] = nil
end

function M.add_score(amount)
	M.score = M.score + amount
end

function M.get_player_state_label()
	if M.player_state == M.PLAYER_STATE_POWERED then
		return "* POWERED"
	elseif M.player_state == M.PLAYER_STATE_NORMAL then
		return "o NORMAL"
	end

	return ". SMALL"
end

function M.power_up()
	M.player_state = math.min(M.PLAYER_STATE_POWERED, M.player_state + 1)
end

function M.take_hit(amount)
	amount = amount or 1
	for _ = 1, amount do
		if M.player_state == M.PLAYER_STATE_SMALL then
			M.player_state = 0
			return true
		end

		M.player_state = M.player_state - 1
	end

	return false
end

function M.queue_return_to_menu(delay)
	delay = delay or 0
	if M.menu_delay == nil or delay < M.menu_delay then
		M.menu_delay = delay
	end
end

function M.set_game_over(reason, delay)
	if not M.game_over then
		M.game_over = true
		M.game_over_reason = reason
	end

	if delay ~= nil then
		M.queue_return_to_menu(delay)
	end
end

function M.tick(dt)
	if not M.game_over then
		M.time_left = math.max(0, M.time_left - dt)
		if M.time_left <= 0 then
			M.set_game_over("time", 0)
		end
	end

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
