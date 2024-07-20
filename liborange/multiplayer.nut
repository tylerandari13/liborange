require("signal")

local multiplayer = add_module("multiplayer")

multiplayer.get_players <- function() {
	local retval = []
	foreach(player in get_sector())
		if("get_name" in player && startswith(player.get_name(), "Tux"))
			retval.push(player)
	return retval
}

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
