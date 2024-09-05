/**
 * @file Houses the OTimer and functions related to time and waiting.
 */
require("signal")

local timer = add_module("time")
local internal = add_module("_time")

/**
 * @class OTimer
 * @description Allows you to call functions after a set time. Intended as a soloution to the "Can't suspend through native calle/metamethods" error.
 */
class OTimer {
	/**
	 * @member {float} time
	 * @description The time to wait when `start` is called.
	 */
	time = 0
	/**
	 * @member {OSignal} timeout
	 * @description The OSignal that will call when the time reaces 0.
	 */
	timeout = null
	/**
	 * @member {bool} stopped
	 * @description Whether the timer is stopped or not. If `start` is called then stopped will be false.
	 */
	stopped = true

	/**
	 * @member {bool} continuous
	 * @description If true the OTimer will start again once it stops.
	 */
	continuous = false

	/**
	 * @constructor Constructs an OTimer with the time specified.
	 * @param {float} time_seconds The amount of time to wait.
	 * @param {bool} _continuous If true the OTimer will start again once it stops.
	 * @default _continuous false
	 */
	constructor(time_seconds, _continuous = false) {
		time = time_seconds
		continuous = _continuous
		timeout = OSignal()
	}

	/**
	 * @function start
	 * @param {float} time_seconds The amount of time to wait. If less than 0 `time` will be used instead.
	 * @default time_seconds -1
	 * @return {OTimer} Returns itself so you can type `OTimer().start()` to start it instantly.
	 * @description Starts the OTimer. Sets `stopped` to false and waits the amount of time specified before calling the `timeout` signal.
	 */
	function start(time_seconds = -1) {
		if(time_seconds < 0) time_seconds = time
		stopped = false
		liborange.thread.sector_thread(function[this]() {
			local once = true
			while(continuous || once) {
				once = false
				wait(time_seconds)
				if(!stopped) {
					timeout.call()
					if(!continuous) stopped = true
				}
			}
		}).wakeup()
		return this
	}

	/**
	 * @function stop
	 * @description Stops the OTimer.
	 */
	function stop() {
		stopped = true
	}
}

/**
 * @classend
 */

/**
 * @function waitf
 * @param {float} frames The amount of frames to wait.
 * @default frames 1
 * @description Waits for the specified amount of frames, regardless of the games current speed.
 */
timer.waitf <- function(frames = 1) {
	local i = 0
	while(i < frames) {
		wait(0)
		i++
	}
	return true
}

/**
 * @function await
 * @param {function} _for
 * @description Calls the passed function every frame and waits until the passed function returns true.
 */
/**
 * @function await
 * @param {OSignal} _for
 * @description Waits until the passed signal is called before continuing.
 */
timer.await <- function(_for) {
	switch(typeof _for) {
		case "function":
			while(!_for()) wait(0)
		break
		case "instance":
			local called = false
			_for.connect(function[this](...) {
				called = true
				_for.disconnect(callee())
			})
			while(!called) wait(0)
		break
	}
}

local fps = 60 // rough estimate
local fps_delta = 0

/**
 * @function init_fps_counter
 * @description Starts the FPS counter. Keep in mind it is an estimate, but is generally close enough.
 */
timer.init_fps_counter <- function() {
	if(!("fps_timer" in internal)) {
		internal.fps_timer <- OTimer(1, true)
		internal.fps_timer.timeout.connect(function[this]() {
			fps = fps_delta - 1 // `wait()` always waits a frame too long, so remove a frame for accuracy
			fps_delta = 0
		})
		internal.fps_timer.start()
		::liborange.signal.process.connect(function[this]() {
			fps_delta++
		})
	}
}
/**
 * @function is_fps_counter_initted
 * @description Returns true if `liborange.timer.init_fps_counter` has been called, else returns false.
 */

timer.is_fps_counter_initted <- @() "fps_timer" in internal

/**
 * @function get_fps
 * @description Gets the estimated frames per second. Will always return 60 if `liborange.timer.init_fps_counter` has not been called.
 */
timer.get_fps <- @() fps
