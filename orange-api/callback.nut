class OCallback {
	connections = null

	constructor() {
		connections = []
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
	function fire(...) call.acall([this].extend(vargv))
}

api_table().Callback <- OCallback
