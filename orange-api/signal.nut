import("orange-api/orange_api_util.nut")

class OSignal extends OObject {
	connections = null

	constructor() {
		base.constructor(class{}())
		connections = []
	}

	function connect(func) {
		if(type(func) == "string") {
			connections.push(compilestring(func))
		} else connections.push(func)
	}

	function disconnect(func) {
		connections.remove(connections.find(func))
	}

	function call(envobj, ...) foreach(connection in connections) connection.acall([envobj].extend(vargv))
	function fire(envobj, ...) foreach(connection in connections) connection.acall([envobj].extend(vargv))
}

api_table().signal <- OSignal

api_table().init_signals <- function() {
	api_table().OSignal_thread <- newthread(function() {
		local added_players = {}
		while(true) {
			foreach(i, v in get_players())
				if(!(i in added_players)) {
					added_players[i] <- v
					api_table().get_signal("player_added").call(this, v)
				} else if(added_players.len() > get_players().len()) {
					foreach(i, v in added_players)
						if(!(i in get_players())) {
							api_table().get_signal("player_removed").call(this, v)
							delete added_players[i]
						}
				}
			wait(0.01)
		}
	})
	api_table().OSignal_thread.call()
}

api_table().add_signal <- function(name) {
	if(!("OSignals" in api_table())) api_table().OSignals <- {}
	api_table().OSignals[name.tolower()] <- OSignal()
}

api_table().get_signal <- function(name) {
	if(!("OSignals" in api_table())) api_table().add_signal(name)
	if(!(name in api_table().OSignals)) api_table().add_signal(name)
	return api_table().OSignals[name.tolower()]
}

api_table().remove_signal <- function(name) {
	if(!("OSignals" in api_table())) api_table().OSignals <- {}
	delete api_table().OSignals[name.tolower()]
}