import("orange-api/orange_api_util.nut")

class OSignal extends OObject {
	connections = null

	constructor() {
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
