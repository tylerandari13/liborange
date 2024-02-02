class OCallback {
	connections = null

	fire = null
	emit = null

	constructor() {
		connections = []

		fire = call
		emit = call
	}

	function connect(env, func) {
		if(type(func) == "string") {
			func = compilestring(func)
		}
		connections.push({
			env = env
			func = func
		})
	}

	function disconnect(func) {
		connections.remove(connections.find(func))
	}

	function call(...) foreach(connection in connections) {
		connection.func.acall([connection.env].extend(vargv))
	}
}

api_table().Callback <- OCallback

api_table().add_callback <- function(name) {
	if(!("OCallbacks" in api_storage())) api_storage().OCallbacks <- {}
	api_storage().OCallbacks[name.tolower()] <- OCallback()
}

api_table().get_callback <- function(name) {
	if(!("OCallbacks" in api_storage())) api_table().add_callback(name)
	if(!(name in api_storage().OCallbacks)) api_table().add_callback(name)
	return api_storage().OCallbacks[name.tolower()]
}

api_table().remove_callback <- function(name) {
	if(!("OCallbacks" in api_storage())) api_storage().OCallbacks <- {}
	delete api_storage().OCallbacks[name.tolower()]
}
