/**
 * @file Houses the OSignal and process signal.
 * @requires thread
 */
require("thread")

local signal = add_module("signal")
local internal = add_module("_signal" {
	signals = {}
	processes = {}
})

/**
 * @class OSignal
 * @description Allows you to attach functions and call them all at once.
 */
class OSignal {
	/**
	 * @member {array} connections
	 * @description An array of all the connected functions. Prefer using the functions provided by the class to add functions.
	 */
	connections = null

	/**
	 * @constructor Constructs an OSignal.
	 */
	constructor() {
		connections = []
	}

	/**
	 * @function connect
	 * @param {function} func The function to connect.
	 * @description Connects a function to the OSignal.
	 */
	function connect(func) {
		if(typeof func != "function") throw "Cannot connect type \"" + typeof func + "\" to an OSignal. Please only connect functions to OSignals."
		connections.push(func)
	}

	/**
	 * @function has_connected
	 * @param {function} func The function to check.
	 * @return {bool}
	 * @description Returns whether the given function has been connected.
	 */
	function has_connected(func) {
		return typeof func == "function" && idx != null
	}

	/**
	 * @function disconnect
	 * @param {function} func The function to disconnect.
	 * @description Disconnects a function to the OSignal.
	 */
	function disconnect(func) {
		local idx = connections.find(func)
		if(idx == null) throw "Attempted to remove function that has not yet been connected."
		connections.remove(idx)
	}

	/**
	 * @function call
	 * @param ... The arguments to pass into each function.
	 * @description Calls all functions connected to the OSignal
	 */
	function call(...) {
		foreach(func in connections) {
			func.acall([::get_sector()].extend(vargv))
		}
	}
}

/**
 * @classend
 */


/**
 * @function get_signal
 * @param {string} name The name of the signal youre trying to get.
 * @return {OSignal}
 * @description Returns a global signal under this name, and creates one if it doesnt currently exist.
 * Prefer using the metamethod for getting signals instead.
 */
signal.get_signal <- function(name) {
	if(!(name in internal.signals)) internal.signals[name] <- ::OSignal()
	return internal.signals[name]
}

local frame = 0
local signal_function = function() {
	while(wait(0) == null) {
		::liborange.signal.get_signal("process").call()
		frame++
	}
}

/**
 * @function init_process
 * @description Starts calling the process signal every frame. You can get the process signal using `liborange.signal.process`.
 */
signal.init_process <- function() {
	if("process_thread" in internal) return
	internal.process_thread <- ::liborange.thread.sector_thread(signal_function)
	internal.process_thread.wakeup()
}

/**
 * @function is_proces_initted
 * @return {bool}
 * @description Returns true if `liborange.signal.process` has been called, else returns false.
 */
signal.is_proces_initted <- @() "process_thread" in internal

/**
 * @function get_frame
 * @return {integer}
 * @description Returns amount of times the process signal has been called. Will always return 0 if `liborange.signal.init_process` has not been called.
 */
signal.get_frame <- @() frame

signal.setdelegate({
	_get = function(key) {
		return signal.get_signal(key)
	}
})
