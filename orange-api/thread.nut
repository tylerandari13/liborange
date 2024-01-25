/*class OThread {
	object = null
	constructor(func) {
		object = ::newthread(::type(func) == "string" ? compilestring(func) : func)
		if(!("OThreads" in ::api_storage())) ::api_storage().OThreads <- []
		::api_storage().OThreads.push(object)
	}
	function _get(key) {
		return object[key].bindenv(object)
	}
}

class OThread extends OObject {
	constructor(func) {
		if(::type(func) == "string") {
			base.constructor(::newthread(compilestring(func)))
		} else base.constructor(::newthread(func))
		if(!("OThreads" in ::api_storage())) ::api_storage().OThreads <- []
		::api_storage().OThreads.push(object)
	}
	function _get(key) {
		try {
			return function(...) {
				return object[key].acall([object].extend(vargv))
			}
		} catch(e) {
			return base._get(key)
		}
		throw null
	}
}*/

function OThread(func) {
	print("[liborange] The class \"liborange.Thread()\" is deprecated. Use \"newthread()\" in combination with \"liborange.thread_fix()\" instead.")
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
