class OTimer extends OSignal {
	time = 0
	vars = []

	function call(_time, ...) {
		time = _time
		vars = vargv
		local a = newthread(function(the_stuff) {
			wait(time)
			base.call.acall([this].extend(vars))
		}.bindenv(this))
		api_table().thread_fix(a)
		a.call(vargv)
	}
}

class OCallbackTimer extends OCallback {
	time = OTimer.time
	vars = OTimer.vars

	call = OTimer.call
}

::OSignalTimer <- OTimer // consistency

api_table().Timer <- OTimer
api_table().SignalTimer <- OSignalTimer
api_table().CallbackTimer <- OCallBackTimer
