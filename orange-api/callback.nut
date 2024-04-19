class OCallback {
	connections = null

	fire = null
	emit = null

	constructor() {
		connections = []

		fire = call
		emit = call
	}

	function connect(...) {
		if(type(vargv[0]) == "string") {
			vargv[0] = compilestring(vargv[0])
		}
		switch(vargv.len()) {
			case 1: // connect(func)
				connections.push(vargv[0])
			break
			case 2: // connect(env, func)
				print("[liborange] The function `OCallback.connect(env, func)` is deprecated. Please use `OCallback.connect(func)` or `OCallback.connect(func.bindenv(env))` instead.")
				connections.push(vargv[1].bindenv(vargv[0]))
			break
			default:
				throw "wrong number of parameters"
			break
		}
	}

	function disconnect(func) {
		connections.remove(connections.find(func))
	}

	function call(...) foreach(connection in connections) {
		connection.acall([this].extend(vargv))
	}
}

api_table().Callback <- OCallback

api_table().add_callback <- function(name) {
	if(!("OCallbacks" in api_sector_storage())) api_sector_storage().OCallbacks <- {}
	api_sector_storage().OCallbacks[name.tolower()] <- OCallback()
}

api_table().get_callback <- function(name) {
	if(!("OCallbacks" in api_sector_storage())) api_table().add_callback(name)
	if(!(name in api_sector_storage().OCallbacks)) api_table().add_callback(name)
	return api_sector_storage().OCallbacks[name.tolower()]
}

api_table().remove_callback <- function(name) {
	if(!("OCallbacks" in api_sector_storage())) api_sector_storage().OCallbacks <- {}
	delete api_sector_storage().OCallbacks[name.tolower()]
}
