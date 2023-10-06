function get_sector() {
	try {
		return sector
	} 	catch(e) {
		try {
			return worldmap
		} catch(e) {
			return {}
		}
	}
}

if(!("orange_api" in get_sector())) get_sector().orange_api <- {}

function get_api_table() return get_sector().orange_api

function help() {
	display_text_file("orange-api/help.stxt")
}

function print(...) {
	local stronk = ""
	foreach(v in vargv) stronk += v.tostring()
	::print("[ORANGE API]" + stronk)
}

class OObject {
	object = null
	odata = null

	constructor(obj) {
		odata = {} // we dont want all odatas to point to the same table
		object = get_sector()[obj]
		delete get_sector()[obj]
		get_sector()[obj] <- this
	}

	function _get(key) {
		if(key in object) {
			return object[key]
		} else if(key in odata) {
			return odata[key]
		}
		throw null
	}

	function _set(key, value) {
		if(key in odata) return odata[key] = value
		throw null
	}

	function _newslot(key, value) {
		return odata[key] <- value
	}
	
	function _delslot(key) {
		return delete odata[key]
    }
}