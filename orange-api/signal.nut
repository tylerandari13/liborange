class OSignal extends OCallback {
	function connect(func) {
		if(type(func) == "string") {
			func = compilestring(func)
        }
        connections.push(func)
	}

	function call(...) foreach(connection in connections) {
		local a = ::newthread(connection)
		api_table().thread_fix(a)
		a.call.acall([a].extend(vargv))
	}
}

api_table().Signal <- OSignal
api_table().signal <- OSignal // compatibility

api_table().init_signals <- function() if(!("signals_innitted" in api_storage())) {
	api_storage().signals_innitted <- true
	local OSignal_thread = newthread(function() {
		local added_players = {}
		while(wait(0) == null) {
			foreach(i, v in get_players()) {
				if(!(i in added_players)) {
					added_players[i] <- v
					api_table().get_signal("player-added").call(v, i)
				} else if(added_players.len() > get_players().len()) {
					foreach(i, v in added_players)
						if(!(i in get_players())) {
							api_table().get_signal("player-removed").call(v, i)
							delete added_players[i]
						}
				}
				foreach(v in added_players) foreach(w in controls) {
					if(v.get_input_pressed(w)) api_table().get_signal("input-pressed").call(w, v)
				//	if(v.get_input_held(w)) api_table().get_signal("input-held").call(w, v)
					if(v.get_input_released(w)) api_table().get_signal("input-released").call(w, v)
				}
			}
			api_table().get_callback("process").call()
		}
	})
	api_table().thread_fix(OSignal_thread)
	OSignal_thread.call()
}

api_table().add_signal <- function(name) {
	if(!("OSignals" in api_sector_storage())) api_sector_storage().OSignals <- {}
	api_sector_storage().OSignals[name.tolower()] <- OSignal()
}

api_table().get_signal <- function(name) {
	if(name == "process") throw getstackinfos(2).src + " line " + getstackinfos(2).line + ". If this is not your doing, report this to Orange immediately."
	if(!("OSignals" in api_sector_storage())) api_table().add_signal(name)
	if(!(name in api_sector_storage().OSignals)) api_table().add_signal(name)
	return api_sector_storage().OSignals[name.tolower()]
}

api_table().remove_signal <- function(name) {
	if(!("OSignals" in api_sector_storage())) api_sector_storage().OSignals <- {}
	delete api_sector_storage().OSignals[name.tolower()]
}


// consistency
api_table().init_callbacks <- api_table().init_signals
