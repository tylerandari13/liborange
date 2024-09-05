/**
 * @file Houses the multiplayer related signals.
 * @requires signal
 */
require("signal")

local multiplayer = add_module("multiplayer")

/**
 * @function get_players
 * @return {array}
 * @description Returns an array with all the players in the current sector.
 */
multiplayer.get_players <- function() {
	local retval = []
	foreach(player in get_sector())
		if("get_name" in player && startswith(player.get_name(), "Tux"))
			retval.push(player)
	return retval
}

/**
 * @function get_nearest_player
 * @param {OVector} pos
 * @return {instance|null}
 * @description Returns the player closest to the given position.
 */
/**
 * @function get_nearest_player
 * @param {float} x
 * @param {float} y
 * @return {instance|null}
 * @description Returns the player closest to the given position.
 */
multiplayer.get_nearest_player <- function(...) {
	local x
	local y
	switch(vargv.len()) {
		case 1: // get_nearest_player(pos)
			x = vargv[0].x
			y = vargv[0].y
		break
		case 2: // get_nearest_player(x, y)
			x = vargv[0]
			y = vargv[1]
		break
	}

	local closest_pos = -1
	local closest_object
	foreach(i, v in get_players()) {
		local new_pos = liborange.math.distance(x, y, v.get_x(), v.get_y())
		if(new_pos < closest_pos || closest_pos < 0) {
			closest_object = v
			closest_pos = new_pos
		}
	}
	return closest_object
}

/**
 * @signal player_added
 * @param {string} player The player that was added.
 * @description Called whenever a player is added via the multiplayer menu.
 */
/**
 * @signal player_removed
 * @param {string} player The player that was removed.
 * @description Called whenever a player is removed via the multiplayer menu.
 */
local current_players = []
liborange.signal.process.connect(function() {
	local players = liborange.multiplayer.get_players()
	if(players.len() > current_players.len()) {
		foreach(player in players) {
			if(current_players.find(player) == null)
				liborange.signal.get_signal("player_added").call(player)
		}
		current_players = clone players
	} else if(players.len() < current_players.len()) {
		foreach(player in current_players)
			if(players.find(player) == null)
				liborange.signal.get_signal("player_removed").call(player)
		current_players = clone players
	}
})
