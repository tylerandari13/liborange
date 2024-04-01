function OThread(func) {
	::print("[liborange] The class \"liborange.Thread()\" is deprecated. Use \"newthread()\" in combination with \"liborange.thread_fix()\" instead.")
	::print(getstackinfos(2).src + " : line " + getstackinfos(2).line)
	::print(startswith(getstackinfos(2).src, "liborange") || startswith(getstackinfos(2).src, "orange-api") ? "Please report to Orange with the above info." : "...")
	local object = ::newthread(::type(func) == "string" ? compilestring(func) : func)
	if(!("OThreads" in ::api_storage())) ::api_storage().OThreads <- []
	::api_storage().OThreads.push(object)
	return object
}

api_table().Thread <- OThread
api_table().thread <- OThread

api_table().thread_fix <- function(thread) {
	if(!("OThreads" in ::api_storage())) ::api_storage().OThreads <- []
	::api_storage().OThreads.push(thread)
}

if(WORLDMAP_GUARD) {
	local thread_object = OGameObject("scripttrigger")
	thread_object.width = 1
	thread_object.height = 1
	thread_object.oneshot = true
	thread_object.button = false

	api_table().sector_thread <- function(func, wakeup_param = false) {
		local id = rand()
		if(type(func) == "string") func = compilestring(func)

		if(!("thread_ids" in sector)) sector.thread_ids <- {}
		sector.thread_ids[id] <- {
			func = func
			wakeup_param = wakeup_param
		}

		thread_object.script = @"
			local func = sector.thread_ids[" + id + @"].func
			local wakeup_param = sector.thread_ids[" + id + @"].wakeup_param
			sector.thread_ids[" + id + @"].thread <- get_current_thread()
			if(wakeup_param) {
				func(::suspend())
			} else {
				::suspend()
				func()
			}"
		thread_object.initialize({x = sector.Tux.get_x() + 16, y = sector.Tux.get_y() + 16}, false)

		while(!("thread" in sector.thread_ids[id])) wait(0)
		local thread = sector.thread_ids[id].thread
		delete sector.thread_ids[id]
		return thread
	}
}