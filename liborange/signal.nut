require("thread")

local signal = add_module("signal")
local internal = {}

class OSignal {
	connections = null

	constructor() {
		connections = []
	}

	function connect(func) {
		if(typeof func != "function") throw "Cannot connect type \"" + typeof func + "\" to an OSignal. Please only connect functions to OSignals."
		connections.push(func)
	}

	function has_connected(func) {
		return typeof func == "function" && idx != null
	}

	function disconnect(func) {
		local idx = connections.find(func)
		if(idx == null) throw "Attempted to remove function that has not yet been connected."
		connections.remove(idx)
	}

	function call(...) {
		foreach(func in connections) {
			func.acall([::get_sector()].extend(vargv))
		}
	}
}

signal.get_signal <- function(name) {
	if(!(name in internal)) internal[name] <- ::OSignal()
	return internal[name]
}

local signal_function = function() {
	while(wait(0) == null)
		::liborange.signal.get_signal("process").call()
}

signal.init_process <- function() {
	local thread = ::get_module("_process_thread")
	if(thread != null) return

	local thrd = ::liborange.thread.sector_thread(signal_function)
	::add_module("_process_thread", {thread = thrd})
	thrd.wakeup()
}

signal.setdelegate({
	_get = function(key) {
		return signal.get_signal(key)
	}
})
