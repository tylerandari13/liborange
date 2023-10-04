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

class ObjectOverride {
	object = null

	constructor(obj) {
		object = get_sector()[obj]
		delete get_sector()[obj]
		get_sector()[obj] <- this
	}
}