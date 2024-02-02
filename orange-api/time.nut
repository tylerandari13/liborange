class OTimer extends OSignal {
	time = 0
	vars = []

	function call(_time, ...) {
		time = _time
		vars = vargv
		local a = newthread(thread_func.bindenv(this))
		api_table().thread_fix(a)
		a.call()
	}

	function thread_func() {
		wait(time)
		OSignal.call.acall([this, time].extend(vars))
	}
}

class OCallbackTimer extends OCallback {
	time = OTimer.time
	vars = OTimer.vars

	call = OTimer.call

	function thread_func() {
		wait(time)
		OCallback.call.acall([this, time].extend(vars))
	}
}

::OSignalTimer <- OTimer // consistency

api_table().Timer <- OTimer
api_table().SignalTimer <- OSignalTimer
api_table().CallbackTimer <- OCallbackTimer
