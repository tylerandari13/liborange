/**
 * @file Houses the sector thread.
 */

require("game_object")

local thread = add_module("thread")

local internal = add_module("_thread")

local trigger = OGameObject("scripttrigger")
trigger.oneshot = true

internal.thread_func <- function(key) {
	local container = internal[key]
	container.object.set_pos(-64, -64)
	container.thread <- get_current_thread()
	if(container.param) {
		container.func(::suspend())
	} else {
		::suspend()
		container.func()
	}
}

/**
 * @function sector_thread
 * @param {function} func The function that the thread will run.
 * @param {bool} param Whether the function accepts a parameter. A function using a sector thread can only have one parameter.
 * @returns {thread}
 * @description Returns a special thread thats tied to the sector to prevent thread unsafe code.
 * Use `thread.wakeup()` to start the thread. If `param` is true you can pass one parameter into `wakeup` that will go to the function.
 */
thread.sector_thread <- function(func, param = false) {
	local key = rand() + "" + rand()
	trigger.script = "liborange[\"_thread\"].thread_func(\"" + key + "\")"
	internal[key] <- {
		object = trigger.initialize({x = sector.Tux.get_x(), y = sector.Tux.get_y()}),
		param = param
		func = func
	}
	while(!("thread" in internal[key])) {
		internal[key].object.set_pos(sector.Tux.get_x(), sector.Tux.get_y())
		wait(0.01)
	}
	local thread = internal[key].thread
	delete internal[key]
	return thread
}
